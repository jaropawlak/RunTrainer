//
//  createDistanceTrainingViewController.h
//  RunTrainerIOS
//
//  Created by jarek on 11.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateDistanceTrainingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *trainingName;
@property (weak, nonatomic) IBOutlet UITextField *distance;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *trainingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

- (IBAction)CreateNewTraining:(id)sender;

@end
