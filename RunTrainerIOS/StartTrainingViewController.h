//
//  StartTrainingViewController.h
//  RunTrainerIOS
//
//  Created by jarek on 17.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Training.h"
#import "Lap.h"
#import "Result.h"
#import "ResultLap.h"
#import "TrainingManagerDelegate.h"
//#import "MOGlassButton.h"
#import <iAd/iAd.h>

@interface StartTrainingViewController : UIViewController<TrainingManagerDelegate,ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusText;
@property (weak, nonatomic) IBOutlet UILabel *speedText;
@property (weak, nonatomic) IBOutlet UILabel *distanceText;
@property (weak, nonatomic) IBOutlet UIButton *startTrainingButton;
@property (weak, nonatomic) IBOutlet UILabel *yourTraining;
@property (weak, nonatomic) IBOutlet UIButton *selectYourTrainingButton;
@property (weak, nonatomic) IBOutlet UITextView *trainingDescription;
@property (weak, nonatomic) IBOutlet UIImageView *yourTrainingImageView;
- (IBAction)startTraining:(id)sender;
@property (strong, nonatomic) Training* training;

//@property (strong, nonatomic) UIButton* menuButton;

@end
