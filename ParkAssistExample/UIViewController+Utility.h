//
//  UIViewController+Utility.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utility)

+ (UIViewController *)topMostPresentedViewControllerOfKeyWindow;
+ (UIViewController *)topMostViewControllerOfKeyWindow;
+ (UINavigationController *)topMostNavigationControllerOfKeyWindow;

- (BOOL)hasRegularSizeClasses;

@end
