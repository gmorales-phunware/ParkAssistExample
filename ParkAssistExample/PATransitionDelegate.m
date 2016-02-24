//
//  PATransitionDelegate.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "PATransitionDelegate.h"
#import "PAPresenterAnimator.h"
#import "PADismissalAnimator.h"

#import <objc/runtime.h>

static const void *const PAShadeViewKey = &PAShadeViewKey;

@implementation PATransitionDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    UIView *shadeView;
    if (_shadeViewEnabled) {
        shadeView = [[UIView alloc] initWithFrame:CGRectZero];
        shadeView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        shadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        objc_setAssociatedObject(presented, PAShadeViewKey, shadeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    PAPresenterAnimator *presentationAnimator = [[PAPresenterAnimator alloc] init];
    
    presentationAnimator.openingFrame = self.openingFrame;
    presentationAnimator.shadeView = shadeView;
    
    return presentationAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    PADismissalAnimator *dismissalAnimator = [[PADismissalAnimator alloc] init];
    
    dismissalAnimator.openingFrame = self.openingFrame;
    dismissalAnimator.shadeView = objc_getAssociatedObject(dismissed, PAShadeViewKey);
    
    objc_setAssociatedObject(dismissed, PAShadeViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return dismissalAnimator;
}

@end
