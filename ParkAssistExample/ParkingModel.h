//
//  ParkingModel.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/19/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CountsModel.h"

@interface ParkingModel : JSONModel

@property (assign, nonatomic) int zoneId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) CountsModel *counts;
@property (strong, nonatomic)NSString<Ignore>* garage;
@property (strong, nonatomic)NSString<Ignore>* level;



@end
