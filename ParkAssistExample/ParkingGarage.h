//
//  ParkingGarage.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/19/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkingGarage : NSObject

@property (nonatomic, readonly) NSNumber *totalSpaces;
@property (nonatomic, readonly) NSNumber *availableSpaces;
@property (nonatomic, readonly) NSNumber *occupiedSpaces;

@property (nonatomic, readonly) NSArray *totalGarages;
@property (nonatomic, readonly) NSString *timeStamp;

-(instancetype)initWithParkingZones:(NSArray *)zones;

@end
