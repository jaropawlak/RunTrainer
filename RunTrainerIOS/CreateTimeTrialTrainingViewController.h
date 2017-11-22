//
//  CreateTimeTrialTrainingViewController.h
//  RunTrainerIOS
//
//  Created by jarek on 12.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTimeTrialTrainingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *trainingName;
- (IBAction)createNewTraining:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *timeTrialPicker;
@property (weak, nonatomic) IBOutlet UILabel *trainingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTrialLabel;

@end
