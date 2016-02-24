//
//  PADismissalAnimator.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface PADismissalAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect openingFrame;
@property (nonatomic, strong) UIView *shadeView;

@end
