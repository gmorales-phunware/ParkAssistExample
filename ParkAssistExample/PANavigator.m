//
//  PANavigator.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "PANavigator.h"
#import "PATransitionDelegate.h"
#import "UIViewController+Utility.h"
#import "PAOverlayViewController.h"
#import "ParkAssistVehicleDetailViewController.h"
#import "ParkAssistVehicleLocationViewController.h"

@interface PANavigator ()
@property (nonatomic, strong, nonnull) PATransitionDelegate *transitionDelegate;

@end

@implementation PANavigator

+ (void)load
{
    @autoreleasepool {
        [self sharedNavigator];
    }
}

+ (instancetype)sharedNavigator
{
    static PANavigator *sharedNavigator;
    static dispatch_once_t onceToken;
    
    
    dispatch_once(&onceToken, ^{
        sharedNavigator = [[PANavigator alloc] initPrivate];
    });
    
    return sharedNavigator;
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _transitionDelegate = [[PATransitionDelegate alloc] init];
    }
    
    return self;
}

- (void)presentVehicleLocationDetailWithParkingSpace:(ParkingSpaceModel *)space {
    ParkAssistVehicleLocationViewController *vc = [ParkAssistVehicleLocationViewController showLocationDetailWithParkingModel:space];
    [[self navigationControllerToPushFrom] pushViewController:vc animated:YES];
}


- (void)showVehicleDetailViewController:(ParkAssistVehicleDetailViewController *)detailViewController {
    PAOverlayViewController *overlay = [[PAOverlayViewController alloc] initWithViewController:detailViewController];
    [self presentViewController:overlay fromView:nil];
}

- (void)presentViewController:(UIViewController *)viewController
                     fromView:(UIView *)view
{
    [self presentViewController:viewController
                       fromView:view
                usingViewAsSize:NO];
}

- (void)presentViewController:(UIViewController *)viewController
                     fromView:(UIView *)view
              usingViewAsSize:(BOOL)isUsingViewAsSize
{
    UIViewController *viewControllerToPresentFrom = [self viewControllerToPresentFrom];
    CGRect frameToOpenFrom;
    CGRect mainScreenRect = [UIScreen mainScreen].bounds;
    frameToOpenFrom = (CGRect){CGPointMake(CGRectGetMidX(mainScreenRect), CGRectGetMidY(mainScreenRect)), CGSizeZero};
    self.transitionDelegate.shadeViewEnabled = YES;
    
    PATransitionDelegate *transitionDelegate = self.transitionDelegate;
    viewController.transitioningDelegate = transitionDelegate;
    viewController.modalPresentationCapturesStatusBarAppearance = YES;
    
    self.transitionDelegate.openingFrame = frameToOpenFrom;
    
    // resign any first responder
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [viewControllerToPresentFrom presentViewController:viewController animated:YES completion:NULL];
}

- (UIViewController *)viewControllerToPresentFrom
{
    return [UIViewController topMostPresentedViewControllerOfKeyWindow];
}

- (UINavigationController *)navigationControllerToPushFrom
{
    return [UIViewController topMostNavigationControllerOfKeyWindow];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *presentedViewController = [self viewControllerToPresentFrom];
    if ([presentedViewController isKindOfClass:[PAOverlayViewController class]]) {
        [presentedViewController dismissViewControllerAnimated:animated completion:^{
            [[self navigationControllerToPushFrom] pushViewController:viewController animated:animated];
        }];
    } else {
        [[self navigationControllerToPushFrom] pushViewController:viewController animated: animated];
    }
}

@end
