//
//  ParkAssistEmptyDataSource.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/20/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"

@interface ParkAssistEmptyDataSource : NSObject<DZNEmptyDataSetSource>

+ (instancetype)emptyDataSetSourceWithTitle:(NSString *)title
                                description:(NSString *)description;


- (void)updateTitle:(NSString *)title
        description:(NSString *)description;

@end
