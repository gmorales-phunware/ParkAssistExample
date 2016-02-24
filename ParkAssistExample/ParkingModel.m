//
//  ParkingModel.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/19/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "ParkingModel.h"

@implementation ParkingModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"zoneId"}];
}

-(NSString *)garage
{
    NSString *garage = @"";
    if (_name.length > 0) {
        NSArray *stringArray = [_name componentsSeparatedByString:@" "];
        garage = stringArray[0];
    }
    return garage;
}

-(NSString *)level
{
    NSString *level = @"";
    if (_name.length > 0) {
        level = [_name substringFromIndex:[_name rangeOfString:@" "].location];
    }
    return level;
}

@end
