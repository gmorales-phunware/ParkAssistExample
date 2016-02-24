//
//  CircleProgressView.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/19/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "CircleProgressView.h"


@interface CircleProgressView()
{
    CGFloat startAngle;
    CGFloat endAngle;
    CGFloat grayStartAngle;
    CGFloat grayEndAngle;
}

@end

@implementation CircleProgressView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        startAngle = 0.0;
        endAngle = (M_PI * 2.0) * ((float)_percent / 100.0);
        grayStartAngle = endAngle;
        grayEndAngle =M_PI * 2.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Display our percentage as a string
    self.backgroundColor = [UIColor whiteColor];
    startAngle = 0.0;
    endAngle = (M_PI * 2.0) * ((float)_percent / 100.0);
    grayStartAngle = endAngle;
    grayEndAngle =M_PI * 2.0;
    
    //Draw content Arc
    NSString* textContent = [NSString stringWithFormat:@"%d%%", self.percent];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0)
                          radius:(rect.size.width / 2.0 - 8.0)
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];
    bezierPath.lineWidth = 6.0;
    
    //Set different color for stroke
    if (_percent < 90) {
        UIColor *green = [UIColor colorWithRed:0 green:0.97 blue:0.64 alpha:1];
        [green setStroke];
    }
    else if (_percent >= 90 && _percent <= 97) {
        UIColor *yellow = [UIColor colorWithRed:1 green:0.92 blue:0.31 alpha:1];
        [yellow setStroke];
    }
    else {
        UIColor *red = [UIColor colorWithRed:0.96 green:0.21 blue:0.18 alpha:1];
        [red setStroke];
    }
    
    [bezierPath stroke];
    
    //Draw Gray Arc
    UIBezierPath* bezierGrayPath = [UIBezierPath bezierPath];
    [bezierGrayPath addArcWithCenter:CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0)
                              radius:(rect.size.width / 2.0 - 8.0)
                          startAngle:grayStartAngle
                            endAngle:grayEndAngle
                           clockwise:YES];
    bezierGrayPath.lineWidth = 4.0;
    UIColor *customGray = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
    [customGray setStroke];
    [bezierGrayPath stroke];
    
    // Draw Text
    CGFloat textWidth = rect.size.width;
    CGFloat textHeight = rect.size.height / 4.0;
    CGRect textRect = CGRectMake((rect.size.width - textWidth)/2.0, (rect.size.height - textHeight )/ 2.0, textWidth, textHeight);
    UIColor *customizeDarkColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0 /255.0 alpha:1.0];
    [customizeDarkColor setFill];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName:font,
                                                      NSParagraphStyleAttributeName:paragraphStyle}];
    
}

@end
