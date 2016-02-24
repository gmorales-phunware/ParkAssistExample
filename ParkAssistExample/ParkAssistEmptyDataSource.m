//
//  ParkAssistEmptyDataSource.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/20/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "ParkAssistEmptyDataSource.h"

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface ParkAssistEmptyDataSource ()
@property (nonatomic, strong) NSString *emptyTitle;
@property (nonatomic, strong) NSString *emptyDescription;

@end

@implementation ParkAssistEmptyDataSource

+ (instancetype)emptyDataSetSourceWithTitle:(NSString *)title description:(NSString *)description {
    ParkAssistEmptyDataSource *source = [ParkAssistEmptyDataSource new];
    source.emptyTitle = title;
    source.emptyDescription = description;
    return source;
}

- (void)updateTitle:(NSString *)title description:(NSString *)description {
    self.emptyTitle = title;
    self.emptyDescription = description;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:_emptyTitle attributes:attributeDict];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:_emptyDescription attributes:attributeDict];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    if (IS_IPHONE_4) {
        return -120;
    } else if (IS_IPHONE_5) {
        return -150;
    } else {
        return -200;
    }
}

@end
