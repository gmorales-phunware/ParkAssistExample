//
//  ParkAssistVehicleLocationViewController.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/22/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParkingSpaceModel;

@interface ParkAssistVehicleLocationViewController : UIViewController

+ (instancetype)showLocationDetailWithParkingModel:(ParkingSpaceModel *)parkingSpaceModel;

@end
