//
//  ParkAssistPlateSearchViewController.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/19/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "ParkAssistPlateSearchViewController.h"
#import <ParkAssist/ParkAssist.h>
#import "ParkingSpaceModel.h"
#import "PlateResultsTableViewCell.h"
#import "ParkAssistEmptyDataSource.h"
#import "ParkAssistVehicleDetailViewController.h"
#import "PAOverlayViewController.h"
#import "PANavigator.h"
#import "GMDCircleLoader.h"

@interface ParkAssistPlateSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UITextFieldDelegate, DZNEmptyDataSetDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
//@property (weak, nonatomic) IBOutlet UIButton *searchButton;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (weak, nonatomic) IBOutlet UITextField *searchBarTextField;

//@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTableView;
@property (strong, nonatomic) NSArray *searchResultArray;
@property (strong, nonatomic) NSArray *searchHistryArray;
@property (assign, nonatomic) BOOL isSearching;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyTableViewHeightConstraint;
@property (strong, nonatomic) NSArray *filteredHisotry;
@property (strong, nonatomic) ParkingSpaceModel *selectParkingSpaceModel;
@property (assign, nonatomic)BOOL isSearchingProcess;
@property (strong, nonatomic) NSMutableDictionary *allCarThumbnails;
@property (nonatomic, strong) ParkAssist *parkAssist;

@end

@implementation ParkAssistPlateSearchViewController{
    id<DZNEmptyDataSetSource> _emptyDataSource;
    __weak IBOutlet UITableView *searchResultTableView;
    __weak IBOutlet UIButton *searchButton;
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UITextField *searchBarTextField;
    __weak IBOutlet UITableView *searchHistoryTableView;
}

- (void)viewDidLoad {
    self.title = @"Search for license plate";
    [super viewDidLoad];
    
    self.parkAssist = [[ParkAssist alloc] init];
    [self setupViews];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        return _searchResultArray.count;
    }
    else {        
        return _isSearching ? _filteredHisotry.count : _searchHistryArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        static NSString *cellIdentifier = @"PlateSearchCell";
        PlateResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        ParkingSpaceModel *model = self.searchResultArray[indexPath.row];
        [cell configureCellWithParkingSpaceModel:model];
        
        if (self.allCarThumbnails.count > 0 && [[self.allCarThumbnails allKeys] containsObject:@(indexPath.row)]) {
            [cell.carImage setImage:self.allCarThumbnails[@(indexPath.row)]];
        } else {
            tableView.allowsSelection = NO;
            __weak typeof(self) weakSelf = self;
            [[ParkAssist sharedInstance] getVehicleThumbnailWithUUID:model.uuid withCompletion:^(BOOL success, UIImage *image, NSError *error) {
                if (weakSelf) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (success) {
                        cell.carImage.image = image ? image : [UIImage imageNamed:@"cellPlaceholder"];
                        [strongSelf.allCarThumbnails setObject:image forKey:@(indexPath.row)];
                        [cell layoutSubviews];
                    } else {
                        [strongSelf showAlertWithTitle:@"Alert" andMessage:error.localizedDescription];
                    }
                }
                tableView.allowsSelection = YES;
            }];
        }
        return cell;
    }
    else {
        static NSString *cellIdentifier = @"HistoryCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]];
        cell.textLabel.text = _isSearching ? [_filteredHisotry objectAtIndex:indexPath.row] : [_searchHistryArray objectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1000) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        ParkingSpaceModel *parkingSpaceModel = self.searchResultArray[indexPath.row];
        PlateResultsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        ParkAssistVehicleDetailViewController *viewController = [ParkAssistVehicleDetailViewController showVehicleDetailWithParkingSpace:parkingSpaceModel vehicleImage:cell.carImage.image];
        [[PANavigator sharedNavigator] showVehicleDetailViewController:viewController];
    }
    else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *selectedText = cell.textLabel.text;
        searchBarTextField.text = selectedText;
        tableView.hidden = YES;
        [searchBarTextField resignFirstResponder];
        if (selectedText.length >= 3) {
            searchButton.enabled = YES;
        }
    }
}

-(void)viewDidLayoutSubviews {
    if ([searchResultTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [searchResultTableView setSeparatorInset:UIEdgeInsetsZero];
        [searchHistoryTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([searchResultTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [searchResultTableView setLayoutMargins:UIEdgeInsetsZero];
        [searchHistoryTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
    if (textField.text.length > 0) {
        NSString *upper = textField.text.capitalizedString;
        [self textField:textField shouldChangeCharactersInRange:NSRangeFromString(upper) replacementString:upper];
    } else {
        if (self.searchHistryArray.count > 0) {
            _historyTableViewHeightConstraint.constant = 34.0 * _searchHistryArray.count;
            searchHistoryTableView.hidden = NO;
            [searchHistoryTableView reloadData];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseString]];
    searchButton.enabled = textField.text.length >=3 ? YES : NO;
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > 0) {
        self.isSearching = YES;
        searchHistoryTableView.hidden = NO;
        if (textField.text.length >= 3) {
            searchButton.enabled = YES;
        } else {
            searchButton.enabled = NO;
        }
        [self filterHistoryForSearchTerm:textField.text];
        if (_filteredHisotry.count > 0) {
            _historyTableViewHeightConstraint.constant = 34.0 * _filteredHisotry.count;
            searchHistoryTableView.hidden = NO;
        } else {
            searchHistoryTableView.hidden = YES;
        }
    }
    else {
        self.isSearching = NO;
        if (_searchHistryArray.count > 0) {
            _historyTableViewHeightConstraint.constant = 34.0 * _searchHistryArray.count;
            searchHistoryTableView.hidden = NO;
        } else {
            searchHistoryTableView.hidden = YES;
        }
    }
    [searchHistoryTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length <3) {
        [self showAlertWithTitle:@"Alert" andMessage:@"Please enter at least 3 characters."];
        return YES;
    } else {
        searchHistoryTableView.hidden = YES;
        [self insertStringToSavedHistory:textField.text];
        [self searchCarWithPlate:textField.text];
    }
    [textField setText:nil];
    [textField resignFirstResponder];
    searchButton.enabled = NO;
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController {
    presentingController.providesPresentationContextTransitionStyle = YES;
    presentingController.definesPresentationContext = YES;
    [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}

#pragma mark - Helper Methods
- (void)setupViews {
    searchResultTableView.hidden = YES;
    searchHistoryTableView.layer.borderWidth = 0.8;
    searchResultTableView.emptyDataSetDelegate = self;
    
    UIColor *customerGrayColor= [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    searchHistoryTableView.layer.borderColor = customerGrayColor.CGColor;
    searchHistoryTableView.hidden = YES;
    
    self.searchHistryArray = [self fetchSavedHistory];
    
    _isSearching = NO;
    searchButton.enabled = NO;
    searchButton.layer.cornerRadius = 5;
    searchButton.clipsToBounds = YES;
    
    searchResultTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [searchBarTextField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [searchBarTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchButton setTitle:@"SEARCH" forState:UIControlStateNormal];
    searchBarTextField.placeholder = @"Search License Plate #";
}

-(void)searchCarWithPlate:(NSString *)plate {
    if (_isSearchingProcess) {
        return;
    }
    self.allCarThumbnails = nil;
    self.allCarThumbnails = [[NSMutableDictionary alloc] init];
    self.isSearchingProcess = YES;
    searchResultTableView.hidden = YES;
    searchResultTableView.allowsSelection = NO;
    
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    __weak __typeof__(self) weakSelf = self;
    [self.parkAssist searchLicensePlate:plate withCompletion:^(BOOL success, NSArray *results, NSError *error) {
        __typeof__(self) strongSelf = weakSelf;
        NSArray *plateResult = [ParkingSpaceModel arrayOfModelsFromDictionaries:results error:nil];
        strongSelf.searchResultArray = plateResult;
        if (results.count == 0) {
            if (_emptyDataSource == nil) {
                _emptyDataSource = [ParkAssistEmptyDataSource emptyDataSetSourceWithTitle:@"No Results Found"  description:@"Please, check the license plate number entered and try again."];
                searchResultTableView.emptyDataSetSource = _emptyDataSource;
                searchResultTableView.emptyDataSetDelegate = self;
            }
        } else if (error) {
            _emptyDataSource = [ParkAssistEmptyDataSource emptyDataSetSourceWithTitle:@"Error" description:error.localizedDescription];
        }
        [GMDCircleLoader hideFromView:self.view animated:YES];
        searchResultTableView.hidden = NO;
        searchResultTableView.emptyDataSetSource = _emptyDataSource;
        [searchResultTableView reloadData];
        self.isSearchingProcess = NO;
        searchResultTableView.allowsSelection = YES;
    }];
}

-(NSArray *)fetchSavedHistory {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkingSearchHistory"];
}

-(void)insertStringToSavedHistory:(NSString *)searchTerm {
    NSMutableArray *historyArray =[_searchHistryArray mutableCopy];
    if (historyArray == nil) {
        historyArray = [[NSMutableArray alloc] init];
    }
    if ([historyArray containsObject:searchTerm]) {
        [historyArray removeObject:searchTerm];
        [historyArray insertObject:searchTerm atIndex:0];
    }
    else {
        if (historyArray.count < 5) { //only record recent 5
            [historyArray insertObject:searchTerm atIndex:0];
        } else {
            [historyArray removeObjectAtIndex:historyArray.count - 1];
            [historyArray insertObject:searchTerm atIndex:0];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:historyArray forKey:@"ParkingSearchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.searchHistryArray = historyArray;
}

- (void)filterHistoryForSearchTerm:(NSString *)searchTerm
{
    NSArray *filterResult = @[];
    if (searchTerm.length > 0) {
        NSString *filter =@"SELF CONTAINS[c] %@";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:filter,searchTerm];
        filterResult = [_searchHistryArray filteredArrayUsingPredicate:predicate];
    }
    self.filteredHisotry = filterResult;
}

#pragma mark - Actions

- (IBAction)clickSearchButton:(id)sender {
    if (![searchBarTextField.text containsString:@" "]) {
        [self insertStringToSavedHistory:searchBarTextField.text];
        [self searchCarWithPlate:searchBarTextField.text];
    } else {
        //Alert
    }
    [searchBarTextField setText:nil];
    [searchHistoryTableView setHidden:YES];
    [searchBarTextField resignFirstResponder];
    [searchButton setEnabled:NO];
}

#pragma mark - Helper Methods
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
