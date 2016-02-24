//
//  DashboardTableViewCell.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/19/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "DashboardTableViewCell.h"
#import "UILabel+Bold.h"

@implementation DashboardTableViewCell

-(void)configureCellWithParkingZoneModel:(ParkingModel *)parkingZoneModel
{
    self.timeLabel.text = [self calculateTime:parkingZoneModel.counts.timestamp];
    self.garageNameLabel.text = parkingZoneModel.name;
    [self updateTotalSpaceLabel:parkingZoneModel.counts.total];
    [self updateAvailableLabel:parkingZoneModel.counts.available];
    [self updateOccupied:parkingZoneModel.counts.occupied];
    int percentage = 0;
    if (parkingZoneModel.counts.total > 0) {
        percentage = parkingZoneModel.counts.occupied * 100 / parkingZoneModel.counts.total;
    }
    self.circleProgreeView.percent = percentage;
    [self.circleProgreeView setNeedsDisplay];
}

-(NSString *)getStringValue:(int)value {
    return [NSString stringWithFormat:@"%d",value];
}

-(void)updateAvailableLabel:(int)available;
{
    self.availableLabel.text = [NSString stringWithFormat:@"%d %@",available,NSLocalizedString(@"Available", @"Available")];
    [self.availableLabel boldSubstring:[NSString stringWithFormat:@"%d",available]];
    
}
-(void)updateOccupied:(int)occupied
{
    self.occupiedLabel.text = [NSString stringWithFormat:@"%d %@",occupied,NSLocalizedString(@"Occupied", @"Occupied")];
    [self.occupiedLabel boldSubstring:[NSString stringWithFormat:@"%d",occupied]];
}
-(void)updateTotalSpaceLabel:(int)total
{
    self.totalAmountSpaceLabel.text = [NSString stringWithFormat:@"%d %@",total,NSLocalizedString(@"Total Spaces",@"Total Spaces")];
    [self.totalAmountSpaceLabel boldSubstring:[NSString stringWithFormat:@"%d",total]];
}

-(void)updateTimeLabel:(NSString *)timeStamp
{
    self.timeLabel.text = [self calculateTime:timeStamp];
}

-(NSString *)calculateTime:(NSString *)fromDate
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZZ"]];
    NSDate *from = [formater dateFromString:fromDate];
    NSString *result = @"";
    if (from) {
        NSTimeInterval timeDiff = [[NSDate date] timeIntervalSinceDate:from];
        result = [self stringFromTimeInterval:timeDiff];
    }
    return  result;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger time = (NSInteger)interval;
    NSInteger seconds = time % 60;
    NSInteger minutes = (time / 60) % 60;
    NSInteger hours = (time / 3600);
    NSMutableString *resultString = [[NSMutableString alloc] init];
    if (hours) {
        [resultString appendString:[NSString stringWithFormat:@"%ldh",(long)hours]];
    }
    else if (minutes)
    {
        [resultString appendString:[NSString stringWithFormat:@"%ldm",(long)minutes]];
    }
    else if (seconds)
    {
        [resultString appendString:[NSString stringWithFormat:@"%lds",(long)seconds]];
    }
    return resultString;
}


@end
