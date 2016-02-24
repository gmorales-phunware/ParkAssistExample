//
//  ParkingSpaceModel.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/20/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "ParkingSpaceModel.h"

@implementation ParkingSpaceModel

-(NSString *)garage
{
    NSString *garage = @"";
    if (_zone.length > 0) {
        NSArray *stringArray = [_zone componentsSeparatedByString:@" "];
        garage = stringArray[0];
    }
    return garage;
}

-(NSString *)level
{
    NSString *level = @"";
    if (_zone.length > 0) {
        level = [_zone substringFromIndex:[_zone rangeOfString:@" "].location];
    }
    return level;
}

@end
