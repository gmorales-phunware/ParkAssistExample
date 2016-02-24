//
//  PADismissalAnimator.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "PADismissalAnimator.h"

@implementation PADismissalAnimator

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
    
    toViewController.view.userInteractionEnabled = YES;
    fromViewController.view.userInteractionEnabled = NO;
    
    // Orientation bug fix
    // See: http://stackoverflow.com/a/20061872/351305
    fromViewController.view.frame = containerView.bounds;
    
    // for some unknown reason, iOS 7 is treating UIModalPresentationCurrentContext as UIModalPresentationFullScreen
    if (fromViewController.modalPresentationStyle == UIModalPresentationFullScreen || fromViewController.modalPresentationStyle == UIModalPresentationCurrentContext) {
        [containerView addSubview:toViewController.view];
    }
    
    UIView *snapshotView = [fromViewController.view resizableSnapshotViewFromRect:fromViewController.view.bounds afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    [containerView addSubview:snapshotView];
    
    fromViewController.view.alpha = 0.0f;
    
    if (fromViewController.modalPresentationStyle == UIModalPresentationCustom) {
        [toViewController beginAppearanceTransition:YES animated:YES];
    }
    
    [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseOut animations:^{
        snapshotView.frame = self.openingFrame;
        snapshotView.alpha = 0.0f;
        _shadeView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [snapshotView removeFromSuperview];
        [fromViewController.view removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        if (fromViewController.modalPresentationStyle == UIModalPresentationCustom) {
            [toViewController endAppearanceTransition];
        }
        
        //        toViewController.view.userInteractionEnabled = YES;
        //        fromViewController.view.userInteractionEnabled = YES;
    }];
}

@end
