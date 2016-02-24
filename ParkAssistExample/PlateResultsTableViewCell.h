//
//  PlateResultsTableViewCell.h
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/20/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingSpaceModel.h"

@interface PlateResultsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *garageLabel;
@property (weak, nonatomic) IBOutlet UILabel *terminalLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

-(void)configureCellWithParkingSpaceModel:(ParkingSpaceModel *)parkingSpaceModel;

@end
