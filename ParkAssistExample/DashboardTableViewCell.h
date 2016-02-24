//
//  DashboardTableViewCell.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/19/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingModel.h"
#import "CircleProgressView.h"

@interface DashboardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountSpaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *garageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet CircleProgressView *circleProgreeView;

-(void)updateAvailableLabel:(int)available;
-(void)updateOccupied:(int)occupied;
-(void)updateTotalSpaceLabel:(int)total;
-(void)updateTimeLabel:(NSString *)timeStamp;

-(void)configureCellWithParkingZoneModel:(ParkingModel *)parkingZoneModel;

-(NSString *)calculateTime:(NSString *)fromDate;

@end
