//
//  PATransitionDelegate.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface PATransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) CGRect openingFrame;
@property (nonatomic, assign, getter=isShadeViewEnabled) BOOL shadeViewEnabled;

@end
