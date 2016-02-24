//
//  DashboardViewController.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/19/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "DashboardViewController.h"
#import <ParkAssist/ParkAssist.h>
#import "DashboardTableViewCell.h"
#import "ParkingGarage.h"
#import "GMDCircleLoader.h"

@interface DashboardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic)ParkingGarage *garages;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ParkAssist Example";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    
    self.mainTableView.allowsSelection = YES;
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self loadParkingLotData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews
{
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.garages.totalGarages.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            static NSString *cellIdentifier = @"DashboardSearchCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.textLabel.text = @"Find Your Car";
            return cell;
            break;
        }
        case 1: {
            static NSString *cellIdentifier = @"DashboardTableCell";
            DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            ParkingModel *parkingZoneModel = self.garages.totalGarages[indexPath.row];
            [cell configureCellWithParkingZoneModel:parkingZoneModel];
            return cell;
            break;
        }
            
        default:
            return nil;
            break;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0:{
            [self performSegueWithIdentifier:@"showFindMyCarViewControllerIdentifier" sender:self];
            break;
        }
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
            return 135;
            break;
            
        default:
            return 64;
            break;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Helper Methods

- (void)loadParkingLotData {
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    __weak typeof(self) weakSelf = self;
    [[ParkAssist sharedInstance] getAvailableParkingInfo:^(BOOL success, NSArray *results, NSError *error) {
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (success) {
                NSArray *parkingZones = [ParkingModel arrayOfModelsFromDictionaries:results error:&error];
                strongSelf.garages = [[ParkingGarage alloc] initWithParkingZones:parkingZones];
                [strongSelf.mainTableView reloadData];
            } else {
                [strongSelf showAlertWithTitle:@"Alert" andMessage:error.localizedDescription];
            }
        }
        [GMDCircleLoader hideFromView:self.view animated:YES];
    }];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
