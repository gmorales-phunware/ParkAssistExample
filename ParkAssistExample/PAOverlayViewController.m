//
//  PAOverlayViewController.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "PAOverlayViewController.h"

@interface PAOverlayViewController ()
@property (nonatomic) UIView *overlayView;
@property (nonatomic, strong) UIButton *dismissButton;
@end

@implementation PAOverlayViewController

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        _viewController = viewController;
        //        _shadeView = [UIView new];
        _overlayView = [UIView new];
        _allowsTapToDismiss = YES;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.dismissButton.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.viewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.viewController.preferredInterfaceOrientationForPresentation;
}

- (BOOL)shouldAutorotate
{
    return self.viewController.shouldAutorotate;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layoutMargins = UIEdgeInsetsMake(8, 8, 8, 8);
    
    [self setupChildViewController];
    [self setupSubviews];
}

- (void)setupSubviews
{
    //    self.shadeView.backgroundColor = [[MVFColor shadowColor] colorWithAlphaComponent:0.6];
    //    self.shadeView.translatesAutoresizingMaskIntoConstraints = NO;
    //    self.shadeView.frame = self.view.bounds;
    
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dismissButton addTarget:self
                           action:@selector(dismissOverlay)
                 forControlEvents:UIControlEventTouchUpInside];
    
    self.overlayView.backgroundColor = [UIColor whiteColor];
    self.overlayView.translatesAutoresizingMaskIntoConstraints = NO;
    self.overlayView.clipsToBounds = YES;
    self.overlayView.layoutMargins = UIEdgeInsetsZero;
    
    //    [self.view addSubview:self.shadeView];
    [self.view addSubview:self.dismissButton];
    [self.view addSubview:self.overlayView];
    
    [self setupSubviewConstraints];
}

- (void)setupChildViewController
{
    [self addChildViewController:self.viewController];
    self.viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewController.view.frame = self.overlayView.bounds;
    [self.overlayView addSubview:self.viewController.view];
    [self setupChildViewControllerConstraints];
    [self.viewController didMoveToParentViewController:self];
}

- (void)setupChildViewControllerConstraints
{
    NSLayoutConstraint *top, *leading, *bottom, *trailing;
    
    top = [NSLayoutConstraint constraintWithItem:self.viewController.view attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.overlayView attribute:NSLayoutAttributeTopMargin
                                      multiplier:1.0 constant:0.0];
    
    leading = [NSLayoutConstraint constraintWithItem:self.viewController.view attribute:NSLayoutAttributeLeading
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self.overlayView attribute:NSLayoutAttributeLeadingMargin
                                          multiplier:1.0 constant:0.0];
    
    bottom = [NSLayoutConstraint constraintWithItem:self.overlayView attribute:NSLayoutAttributeBottomMargin
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.viewController.view attribute:NSLayoutAttributeBottom
                                         multiplier:1.0 constant:0.0];
    
    trailing = [NSLayoutConstraint constraintWithItem:self.overlayView attribute:NSLayoutAttributeTrailingMargin
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:self.viewController.view attribute:NSLayoutAttributeTrailing
                                           multiplier:1.0 constant:0.0];
    
    [NSLayoutConstraint activateConstraints:@[top, leading, bottom, trailing]];
}

- (void)setupSubviewConstraints
{
    // Shade view
    
    NSLayoutConstraint *top, *leading, *bottom, *trailing;
    
    //    top = [NSLayoutConstraint constraintWithItem:self.shadeView attribute:NSLayoutAttributeTop
    //                                       relatedBy:NSLayoutRelationEqual
    //                                          toItem:self.view attribute:NSLayoutAttributeTop
    //                                      multiplier:1.0 constant:0.0];
    //
    //    leading = [NSLayoutConstraint constraintWithItem:self.shadeView attribute:NSLayoutAttributeLeading
    //                                           relatedBy:NSLayoutRelationEqual
    //                                              toItem:self.view attribute:NSLayoutAttributeLeading
    //                                          multiplier:1.0 constant:0.0];
    //
    //    bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom
    //                                          relatedBy:NSLayoutRelationEqual
    //                                             toItem:self.shadeView attribute:NSLayoutAttributeBottom
    //                                         multiplier:1.0 constant:0.0];
    //
    //    trailing = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing
    //                                            relatedBy:NSLayoutRelationEqual
    //                                               toItem:self.shadeView attribute:NSLayoutAttributeTrailing
    //                                           multiplier:1.0 constant:0.0];
    //
    //    [NSLayoutConstraint activateConstraints:@[top, leading, bottom, trailing]];
    
    
    // Overlay view
    
    NSLayoutConstraint *width, *height, *centerX, *centerY, *topGuide, *bottomGuide;
    
    CGSize childViewControllerPreferredContentSize = self.viewController.preferredContentSize;
    
    width = [NSLayoutConstraint constraintWithItem:self.overlayView attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:1.0 constant:childViewControllerPreferredContentSize.width];
    width.priority = 900;
    
    height = [NSLayoutConstraint constraintWithItem:self.overlayView attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1.0 constant:childViewControllerPreferredContentSize.height];
    height.priority = 900;
    
    centerX = [NSLayoutConstraint constraintWithItem:self.overlayView attribute:NSLayoutAttributeCenterX
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self.view attribute:NSLayoutAttributeCenterXWithinMargins
                                          multiplier:1.0 constant:0.0];
    
    centerY = [NSLayoutConstraint constraintWithItem:self.overlayView attribute:NSLayoutAttributeCenterY
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self.view attribute:NSLayoutAttributeCenterYWithinMargins
                                          multiplier:1.0 constant:0.0];
    
    top = [NSLayoutConstraint constraintWithItem:self.overlayView attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                          toItem:self.view attribute:NSLayoutAttributeTopMargin
                                      multiplier:1.0 constant:0.0];
    
    topGuide = [NSLayoutConstraint constraintWithItem:self.overlayView attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                               toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom
                                           multiplier:1.0 constant:4.0];
    
    leading = [NSLayoutConstraint constraintWithItem:self.overlayView attribute:NSLayoutAttributeLeading
                                           relatedBy:NSLayoutRelationGreaterThanOrEqual
                                              toItem:self.view attribute:NSLayoutAttributeLeadingMargin
                                          multiplier:1.0 constant:0.0];
    
    bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottomMargin
                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                             toItem:self.overlayView attribute:NSLayoutAttributeBottom
                                         multiplier:1.0 constant:0.0];
    
    bottomGuide = [NSLayoutConstraint constraintWithItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop
                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                  toItem:self.overlayView attribute:NSLayoutAttributeBottom
                                              multiplier:1.0 constant:4.0];
    
    trailing = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailingMargin
                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                               toItem:self.overlayView attribute:NSLayoutAttributeTrailing
                                           multiplier:1.0 constant:0.0];
    
    [NSLayoutConstraint activateConstraints:@[width, height, centerX, centerY, top, topGuide,
                                              leading, bottom, bottomGuide, trailing]];
}

- (void)dismissOverlay
{
    if (_allowsTapToDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        NSLog(@"Tap to dismiss is disabled.");
    }
}

@end
