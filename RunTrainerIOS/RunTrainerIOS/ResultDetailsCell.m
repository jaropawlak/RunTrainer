//
//  ResultDetailsCell.m
//  RunTrainerIOS
//
//  Created by jarek on 05.09.2012.
//
//

#import "ResultDetailsCell.h"

@implementation ResultDetailsCell
@synthesize lapNumber;
@synthesize runTime;
@synthesize restTime;
@synthesize distance;
@synthesize avgSpeed;
@synthesize maxSpeed;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
