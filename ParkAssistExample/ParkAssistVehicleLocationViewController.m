//
//  ParkAssistVehicleLocationViewController.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/22/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "ParkAssistVehicleLocationViewController.h"
#import "ParkingSpaceModel.h"
#import "UIStoryboard+ParkAssist.h"
#import <ParkAssist/ParkAssist.h>

@interface ParkAssistVehicleLocationViewController()<UIScrollViewDelegate>
@property (nonatomic, strong) ParkingSpaceModel *parkingSpace;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ParkAssistVehicleLocationViewController {
    __weak IBOutlet UIScrollView *mainScrollView;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
}

+ (instancetype)showLocationDetailWithParkingModel:(ParkingSpaceModel *)parkingSpaceModel {
    ParkAssistVehicleLocationViewController *vc = [[UIStoryboard homeStoryboard] instantiateViewControllerWithIdentifier:@"ParkAssistVehicleLocationViewController"];
    vc.parkingSpace = parkingSpaceModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _parkingSpace.garage;
    [self loadMap];
}

- (void)viewWillAppear:(BOOL)animated {
    [activityIndicator startAnimating];
}

#pragma mark - Helper Methods

- (void)loadMap {
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        [[ParkAssist sharedInstance] getMapImageWithName:_parkingSpace.map andUUID:_parkingSpace.uuid withCompletion:^(BOOL success, UIImage *image, NSError *error) {
            if (weakSelf) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (success && image) {
                    mainScrollView.delegate = strongSelf;
                    mainScrollView.contentSize = image.size;
                    mainScrollView.minimumZoomScale=0.5;
                    mainScrollView.maximumZoomScale=6.0;
                    strongSelf.imageView = [[UIImageView alloc] initWithImage:image];
                    long x = _parkingSpace.position.x / image.scale;
                    long y = _parkingSpace.position.y / image.scale;
                    [[ParkAssist sharedInstance] addSublayerToView:_imageView atX:x Y:y
                                                          andColor:[UIColor colorWithRed:0 green:0.49 blue:0.81 alpha:1]];
                    [mainScrollView addSubview:_imageView];
                    [mainScrollView setZoomScale:1.0];
                    [strongSelf centerToParkingSpace:CGPointMake(x, y)];
                } else if (error) {
                    [strongSelf showAlertWithTitle:@"Alert" andMessage:@"Something went wrong. Please try again later."];
                    strongSelf.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellPlaceholder"]];
                }
            }
        }];
        [activityIndicator stopAnimating];
    });
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)centerToParkingSpace:(CGPoint )point {
    CGRect frame=CGRectMake(point.x - roundf(mainScrollView.frame.size.width/2.0),
                            point.y - roundf(mainScrollView.frame.size.height/2.0),
                            mainScrollView.frame.size.width, mainScrollView.frame.size.height);
    [mainScrollView scrollRectToVisible:frame animated:NO];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
