//
//  SelectNewTrainingTypeViewController.h
//  Ultra runner
//
//  Created by jarek on 23.03.2013.
//
//

#import <UIKit/UIKit.h>

@interface SelectNewTrainingTypeViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *distanceTrainingTitle;
@property (weak, nonatomic) IBOutlet UILabel *distanceTrainingDescription;
@property (weak, nonatomic) IBOutlet UILabel *timeTrialTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeTrialDescription;
@property (weak, nonatomic) IBOutlet UILabel *timeIntervalTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeIntervalDescription;
@property (weak, nonatomic) IBOutlet UILabel *distanceIntervalTitle;
@property (weak, nonatomic) IBOutlet UILabel *distanceIntervalDescription;

@end
