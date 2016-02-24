//
//  ParkingSpaceModel.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/20/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LocationModel.h"

@interface ParkingSpaceModel : JSONModel

@property (strong, nonatomic)NSString *bay_group;
@property (strong, nonatomic)NSString *bay_id;
@property (strong, nonatomic)NSString *map;
@property (strong, nonatomic)LocationModel *position;
@property (strong, nonatomic)NSString *uuid;
@property (strong, nonatomic)NSString *zone;
@property (strong, nonatomic)NSString<Ignore>* garage;
@property (strong, nonatomic)NSString<Ignore>* level;

@end
