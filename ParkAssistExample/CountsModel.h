//
//  CountsModel.h
//  Honeybadger
//
//  Created by John Zhao on 12/7/15.
//  Copyright © 2015 Phunware Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface CountsModel : JSONModel

@property (assign, nonatomic) int available;
@property (assign, nonatomic) int occupied;
@property (assign, nonatomic) int out_of_service;
@property (assign, nonatomic) int reserved;
@property (strong, nonatomic) NSString *timestamp;
@property (assign, nonatomic) int total;
@property (assign, nonatomic) int vacant;

//- (instancetype) initWithDictionary:(NSDictionary *)dict;
@end
