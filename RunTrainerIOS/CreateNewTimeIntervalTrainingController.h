//
//  CreateNewTimeIntervalTrainingController.h
//  RunTrainerIOS
//
//  Created by jarek on 13.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Training+TrainingDescription.h"
#import "Lap.h"

@interface CreateNewTimeIntervalTrainingController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *trainingName;
- (IBAction)createNewTraining:(id)sender;
@property (atomic, retain) NSMutableArray *laps;
@property (weak, nonatomic) IBOutlet UITextField *runTimeText;
@property (weak, nonatomic) IBOutlet UITextField *restTimeText;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
- (IBAction)AddLap:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *trainingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *runTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *restTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addLapButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
