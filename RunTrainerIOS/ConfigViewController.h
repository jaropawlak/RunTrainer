//
//  ConfigViewController.h
//  RunTrainerIOS
//
//  Created by jarek on 18.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UISlider *countdownSlider;
- (IBAction)countdownChanged:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *requiredTempoLabel;
- (IBAction)useMetronomeChanged:(id)sender;
- (IBAction)monitorTempoChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *speedUnits;
@property (weak, nonatomic) IBOutlet UISegmentedControl *partialSounds;
@property (weak, nonatomic) IBOutlet UISlider *tempoDiffersSlider;
@property (weak, nonatomic) IBOutlet UILabel *tempoDiffersLabel;
- (IBAction)tempoDiffersValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *checkTempoIntervalSlider;
@property (weak, nonatomic) IBOutlet UILabel *checkTempoIntervalLabel;
- (IBAction)checkTempoIntervalValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *monitorTempoSwitch;
@property (weak, nonatomic) IBOutlet UITextField *requiredTempoText;
- (IBAction)saveChanges:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)unitsChanged:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UISwitch *useMetronomeSwitch;
@property (weak, nonatomic) IBOutlet UISlider *stepsPerMinuteSlider;
@property (weak, nonatomic) IBOutlet UILabel *stepsPerMinuteLabel;
- (IBAction)stepsPerMinuteChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UITabBarItem *setupTabBarItem;


@property (weak, nonatomic) IBOutlet UILabel *monitorTempoLabel;
@property (weak, nonatomic) IBOutlet UILabel *warnIfTempoDiffersLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkTempoIntervalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *useMetronomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestedStepsPerMinuteLabel;
- (IBAction)restorePurchasesClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *restorePurchasesButton;

//@property (strong, nonatomic) UIButton* menuButton;
@end
