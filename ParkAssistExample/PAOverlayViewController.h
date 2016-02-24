//
//  PAOverlayViewController.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAOverlayViewController : UIViewController
@property (readonly, nonatomic) UIViewController *viewController;
@property (readonly, nonatomic) UIView *overlayView;

// Default YES
@property (assign, nonatomic) BOOL allowsTapToDismiss;

- (instancetype)initWithViewController:(UIViewController *)viewController;

+ (instancetype)new __attribute__((unavailable("+new is unavailable. Use -initWithViewController: instead.")));
- (instancetype)init __attribute__((unavailable("-init is unavailable. Use -initWithViewController: instead.")));
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil __attribute__((unavailable("-initWithNibName:bundle: is unavailable. Use -initWithViewController: instead.")));
@end

NS_ASSUME_NONNULL_END