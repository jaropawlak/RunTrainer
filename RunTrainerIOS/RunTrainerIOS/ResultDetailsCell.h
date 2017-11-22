//
//  ResultDetailsCell.h
//  RunTrainerIOS
//
//  Created by jarek on 05.09.2012.
//
//

#import <UIKit/UIKit.h>

@interface ResultDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lapNumber;
@property (weak, nonatomic) IBOutlet UILabel *runTime;
@property (weak, nonatomic) IBOutlet UILabel *restTime;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *avgSpeed;
@property (weak, nonatomic) IBOutlet UILabel *maxSpeed;
@property (weak, nonatomic) IBOutlet UILabel *ascend;
@property (weak, nonatomic) IBOutlet UILabel *descend;

@property (weak, nonatomic) IBOutlet UILabel *lapNrLabel;
@property (weak, nonatomic) IBOutlet UILabel *runTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *elevationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *restLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *reductionLabel;


@end
