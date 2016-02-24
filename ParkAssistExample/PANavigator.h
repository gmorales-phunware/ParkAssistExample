//
//  PANavigator.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

@import Foundation;
@import UIKit;

@class ParkAssistVehicleDetailViewController;
@class ParkAssistVehicleLocationViewController;
@class ParkingSpaceModel;

@interface PANavigator : NSObject

+ (instancetype)sharedNavigator;

- (void)showVehicleDetailViewController:(ParkAssistVehicleDetailViewController *)detailViewController;
- (void)presentVehicleLocationDetailWithParkingSpace:(ParkingSpaceModel *)space;

@end
