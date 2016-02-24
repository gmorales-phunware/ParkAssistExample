//
//  ParkAssistVehicleDetailViewController.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParkingSpaceModel;

@interface ParkAssistVehicleDetailViewController : UIViewController

+ (instancetype)showVehicleDetailWithParkingSpace:(ParkingSpaceModel *)parkingSpace
                                     vehicleImage:(UIImage *)vehicleImage;

@end
