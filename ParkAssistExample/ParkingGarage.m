//
//  ParkingGarage.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/19/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "ParkingGarage.h"
#import "ParkingModel.h"
#import "CountsModel.h"

@implementation ParkingGarage

-(instancetype)initWithParkingZones:(NSArray *)zones
{
    self = [super init];
    if (self) {
        long int totalSpaces = 0;
        long int availableSpaces = 0;
        long int occupiedSpaces = 0;
        _timeStamp = @"";
        NSMutableArray *parkingLots = [[NSMutableArray alloc] init];
        for (ParkingModel *model in zones) {
            CountsModel *count = model.counts;
            availableSpaces += count.available;
            occupiedSpaces += count.occupied;
            totalSpaces += count.total;
            [parkingLots addObject:model];
            _timeStamp = [count.timestamp copy];
        }
        _availableSpaces = @(availableSpaces);
        _totalSpaces = @(totalSpaces);
        _occupiedSpaces = @(occupiedSpaces);
        _totalGarages = parkingLots;
    }
    return self;
}

@end
