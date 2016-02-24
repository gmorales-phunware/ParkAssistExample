//
//  UIViewController+Utility.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "UIViewController+Utility.h"
#import "PAOverlayViewController.h"

@implementation UIViewController (Utility)

+ (UIViewController *)topMostPresentedViewControllerOfKeyWindow
{
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    return viewController;
}

+ (UIViewController *)topMostViewControllerOfKeyWindow
{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UINavigationController *)topMostNavigationControllerOfKeyWindow
{
    UIViewController *viewController = [UIViewController topMostViewControllerOfKeyWindow];
    UINavigationController *resultNavigationController;
    
    
    if ([viewController isKindOfClass:[PAOverlayViewController class]] && [((PAOverlayViewController *)viewController).viewController isKindOfClass:[UINavigationController class]]) {
        resultNavigationController = (UINavigationController *)((PAOverlayViewController *)viewController).viewController;
    }
    else if ([viewController isKindOfClass:[UINavigationController class]]) {
        resultNavigationController = (UINavigationController *)viewController;
    }
    else if (viewController.navigationController) {
        resultNavigationController = viewController.navigationController;
    }
    else if ([viewController.presentingViewController isKindOfClass:[UINavigationController class]]) {
        resultNavigationController = (UINavigationController *)viewController.presentingViewController;
    }
    
    return resultNavigationController;
}

- (BOOL)hasRegularSizeClasses
{
    // Need to check the trait collection of the root view controller
    // since some view controllers can be presented with a form sheet style
    // which has non-regular size classes.
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return (rootViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
            rootViewController.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular);
}

#pragma mark - Private

+ (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

@end
