//
//  PlateResultsTableViewCell.m
//  ParkAssistExample
//
//  Created by Gabriel Morales on 2/20/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "PlateResultsTableViewCell.h"

@implementation PlateResultsTableViewCell

-(void)configureCellWithParkingSpaceModel:(ParkingSpaceModel *)parkingSpaceModel
{
    self.garageLabel.text = parkingSpaceModel.garage;
    self.levelLabel.text = parkingSpaceModel.level;
    
}

@end
