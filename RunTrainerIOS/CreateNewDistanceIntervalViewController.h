//
//  CreateNewDistanceIntervalViewController.h
//  RunTrainerIOS
//
//  Created by jarek on 17.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Training+TrainingDescription.h"
#import "Lap.h"

@interface CreateNewDistanceIntervalViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *trainingName;
@property (weak, nonatomic) IBOutlet UITextField *runDistance;
@property (weak, nonatomic) IBOutlet UITextField *restTime;
- (IBAction)AddLap:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *isRestComputedSwitch;
- (IBAction)restSwitchSwitched:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *restTimeLabel;
- (IBAction)createNewTraining:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@property (nonatomic, retain) NSMutableArray *laps;
@property (weak, nonatomic) IBOutlet UILabel *trainingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *runDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *restTimeComputedLabel;
@property (weak, nonatomic) IBOutlet UIButton *addLapButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
