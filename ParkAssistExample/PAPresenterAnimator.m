//
//  PAPresenterAnimator.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "PAPresenterAnimator.h"

@implementation PAPresenterAnimator

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
    
    toViewController.view.userInteractionEnabled = YES;
    fromViewController.view.userInteractionEnabled = NO;
    
    // Orientation bug fix
    // See: http://stackoverflow.com/a/20061872/351305
    toViewController.view.frame = containerView.bounds;
    fromViewController.view.frame = containerView.bounds;
    
    if (_shadeView) {
        _shadeView.frame = containerView.bounds;
        _shadeView.alpha = 0.0;
        [containerView addSubview:_shadeView];
    }
    
    // add blurred background to the view
    CGRect fromViewFrame = fromViewController.view.frame;
    
    UIGraphicsBeginImageContext(fromViewFrame.size);
    [fromViewController.view drawViewHierarchyInRect:fromViewFrame afterScreenUpdates:YES];
    UIGraphicsEndImageContext();
    
    UIView *snapshotView = [toViewController.view resizableSnapshotViewFromRect:toViewController.view.frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    snapshotView.frame = self.openingFrame;
    [containerView addSubview:snapshotView];
    
    toViewController.view.alpha = 0.0f;
    [containerView addSubview:toViewController.view];
    
    if (toViewController.modalPresentationStyle == UIModalPresentationCustom) {
        [fromViewController beginAppearanceTransition:NO animated:YES];
    }
    
    [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        snapshotView.frame = fromViewController.view.frame;
        _shadeView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [snapshotView removeFromSuperview];
        toViewController.view.alpha = 1.0f;
        
        [transitionContext completeTransition:finished];
        
        if (toViewController.modalPresentationStyle == UIModalPresentationCustom) {
            [fromViewController endAppearanceTransition];
        }
        
        //        toViewController.view.userInteractionEnabled = YES;
        //        fromViewController.view.userInteractionEnabled = YES;
    }];
}
@end
