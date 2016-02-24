//
//  ParkAssistVehicleDetailViewController.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "ParkAssistVehicleDetailViewController.h"
#import "ParkingSpaceModel.h"
#import "UIStoryboard+ParkAssist.h"
#import "ParkAssistVehicleLocationViewController.h"
#import "PANavigator.h"
#import "GMDCircleLoader.h"

@interface ParkAssistVehicleDetailViewController ()
@property (nonatomic, strong) ParkingSpaceModel *parkingSpace;
@property (nonatomic, strong) UIImage *vehicleImage;
@end

@implementation ParkAssistVehicleDetailViewController {
    
    __weak IBOutlet UILabel *_garageLabel;
    __weak IBOutlet UILabel *_levelLabel;
    __weak IBOutlet UIImageView *_vehicleImaveView;
    __weak IBOutlet UIButton *_seeLocationButton;
}

+ (instancetype)showVehicleDetailWithParkingSpace:(ParkingSpaceModel *)parkingSpace vehicleImage:(UIImage *)vehicleImage {
    ParkAssistVehicleDetailViewController *viewController = [[UIStoryboard homeStoryboard] instantiateViewControllerWithIdentifier:@"ParkAssistVehicleDetailViewController"];
    viewController.parkingSpace = parkingSpace;
    viewController.vehicleImage = vehicleImage;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _garageLabel.textColor = [UIColor colorWithRed:0.01 green:0.53 blue:0.84 alpha:1];
    _levelLabel.textColor = [UIColor colorWithRed:0.01 green:0.53 blue:0.84 alpha:1];
    [_seeLocationButton setTitleColor:[UIColor colorWithRed:0.01 green:0.53 blue:0.84 alpha:1] forState:UIControlStateNormal];
    
    _garageLabel.text = _parkingSpace.garage;
    _levelLabel.text = _parkingSpace.level;
    _vehicleImaveView.image = _vehicleImage;
}

- (IBAction)onDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSeeLocation:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[PANavigator sharedNavigator] presentVehicleLocationDetailWithParkingSpace:_parkingSpace];
}

@end
