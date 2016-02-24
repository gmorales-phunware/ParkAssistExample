//
//  LocationModel.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/20/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LocationModel : JSONModel

@property (assign, nonatomic)long x;
@property (assign, nonatomic)long y;

@end
