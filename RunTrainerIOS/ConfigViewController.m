//
//  ConfigViewController.m
//  RunTrainerIOS
//
//  Created by jarek on 18.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import "ConfigViewController.h"
#import "RunTrainerShared.h"


@interface ConfigViewController ()

@end

@implementation ConfigViewController
@synthesize monitorTempoSwitch;
@synthesize requiredTempoText;
@synthesize checkTempoIntervalSlider;
@synthesize checkTempoIntervalLabel;
@synthesize speedUnits;
@synthesize partialSounds;
@synthesize tempoDiffersSlider;
@synthesize tempoDiffersLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.partialSounds setTitle:NSLocalizedString(@"No sounds",nil) forSegmentAtIndex:0];
    [self.partialSounds setTitle:NSLocalizedString(@"Every half",nil) forSegmentAtIndex:1];
     [self.partialSounds setTitle:NSLocalizedString(@"Every quarter",nil) forSegmentAtIndex:2];
    [super viewWillAppear:animated];
 
    RunTrainerShared* shared = [RunTrainerShared instance];
    self.checkTempoIntervalSlider.value = shared.checkTempoIntervalSeconds;
    self.tempoDiffersSlider.value = shared.tempoDiffersThreshold;
    self.monitorTempoSwitch.on = shared.monitorTempo;
    self.requiredTempoText.text =[NSString stringWithFormat:@"%.02f",[shared unitSpeedFromGeneric:shared.requiredTempo ]];
    self.speedUnits.selectedSegmentIndex = shared.speedUnits;
    self.partialSounds.selectedSegmentIndex = shared.partialSounds;
     self.tempoDiffersLabel.text =[NSString stringWithFormat:@"%d", (int)self.tempoDiffersSlider.value];
     self.checkTempoIntervalLabel.text =[NSString stringWithFormat:@"%d",(int) self.checkTempoIntervalSlider.value];
    self.scrollView.contentSize = self.contentView.bounds.size;
    
    
    //metronome
    self.useMetronomeSwitch.on= shared.useMetronome;
    self.stepsPerMinuteSlider.value = shared.stepsPerMinute;
    self.stepsPerMinuteLabel.text = [NSString stringWithFormat:@"%i", shared.stepsPerMinute];
    
    //countdown timer
    self.countdownSlider.value = shared.trainingCountdown;
    self.countdownLabel.text = [NSString stringWithFormat:@"%i s", shared.trainingCountdown];
    
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.monitorTempoLabel.text = NSLocalizedString(@"MonitorTempoLabel",nil);
    self.warnIfTempoDiffersLabel.text = NSLocalizedString(@"warnIfTempoDiffersLabel",nil);
    
    self.checkTempoIntervalTitleLabel.text = NSLocalizedString(@"checkTempoIntervalTitleLabel",nil);
    self.useMetronomeLabel.text = NSLocalizedString(@"useMetronomeLabel",nil);
    self.requestedStepsPerMinuteLabel.text = NSLocalizedString(@"requestedStepsPerMinuteLabel",nil);
    self.requiredTempoLabel.text = NSLocalizedString(@"requiredTempoLabel", nil);
    [self.restorePurchasesButton setTitle:NSLocalizedString(@"Click to restore your purchases", nil) forState:UIControlStateNormal];
	// Do any additional setup after loading the view.
    //_menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self prepareSliding:_menuButton];
    
}


-(void)awakeFromNib
{
     self.title = NSLocalizedString(@"Setup", nil);
   
    
}

- (void)viewDidUnload
{
    [self setSpeedUnits:nil];
    [self setPartialSounds:nil];
    [self setTempoDiffersSlider:nil];
    [self setTempoDiffersLabel:nil];
    [self setCheckTempoIntervalSlider:nil];
    [self setCheckTempoIntervalLabel:nil];
    [self setMonitorTempoSwitch:nil];
    [self setRequiredTempoText:nil];
    [self setUseMetronomeSwitch:nil];
    [self setStepsPerMinuteSlider:nil];
    [self setStepsPerMinuteLabel:nil];
    [self setCountdownSlider:nil];
    [self setCountdownLabel:nil];
   
    [self setRequiredTempoLabel:nil];
    [self setSetupTabBarItem:nil];
    
    [self setMonitorTempoLabel:nil];
    [self setRequiredTempoLabel:nil];
    [self setWarnIfTempoDiffersLabel:nil];
    [self setCheckTempoIntervalLabel:nil];
    [self setCheckTempoIntervalTitleLabel:nil];
    [self setUseMetronomeLabel:nil];
    [self setRequestedStepsPerMinuteLabel:nil];
    [self setRestorePurchasesButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tempoDiffersValueChanged:(id)sender {
    self.tempoDiffersLabel.text =[NSString stringWithFormat:@"%d", (int)self.tempoDiffersSlider.value];
}
- (IBAction)checkTempoIntervalValueChanged:(id)sender {
    self.checkTempoIntervalLabel.text =[NSString stringWithFormat:@"%d",(int) self.checkTempoIntervalSlider.value];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self saveChanges:self];
    [super viewWillDisappear:animated];
}
- (IBAction)saveChanges:(id)sender {
    RunTrainerShared* shared = [RunTrainerShared instance];
    shared.checkTempoIntervalSeconds=    self.checkTempoIntervalSlider.value ;
    shared.tempoDiffersThreshold=    self.tempoDiffersSlider.value  ;
    shared.monitorTempo=   self.monitorTempoSwitch.on  ;
    shared.speedUnits= self.speedUnits.selectedSegmentIndex;
    shared.requiredTempo=  [shared genericSpeedFromUnit:self.requiredTempoText.text.doubleValue];
    shared.partialSounds= self.partialSounds.selectedSegmentIndex;
    
    shared.useMetronome =self.useMetronomeSwitch.on;
    shared.stepsPerMinute =self.stepsPerMinuteSlider.value;  
    shared.trainingCountdown = self.countdownSlider.value;
   
}

- (IBAction)unitsChanged:(UISegmentedControl *)sender {
    RunTrainerShared* shared = [RunTrainerShared instance];
    if (self.requiredTempoText.text.doubleValue != 0.0)
    {
    double genericSpeed =    [shared genericSpeedFromUnit:self.requiredTempoText.text.doubleValue];
    shared.speedUnits = self.speedUnits.selectedSegmentIndex;
    self.requiredTempoText.text = [NSString stringWithFormat:@"%.02f",[shared unitSpeedFromGeneric:genericSpeed ]];
    }
}
- (IBAction)stepsPerMinuteChanged:(id)sender {
    self.stepsPerMinuteLabel.text = [NSString stringWithFormat:@"%.0f",self.stepsPerMinuteSlider.value];
}
- (IBAction)countdownChanged:(UISlider *)sender {
    self.countdownLabel.text =[NSString stringWithFormat:@"%i s", (int)self.countdownSlider.value];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"Units",nil);
            break;
        case 1:
            return NSLocalizedString(@"Tempo",nil);
            break;
        case 2:
            return NSLocalizedString(@"Checkpoints",nil);
            break;
        case 3:
            return NSLocalizedString(@"Metronome",nil);
            break;
        case 4:
            return NSLocalizedString(@"Start countdown",nil);
            break;
        case 5:
            return NSLocalizedString(@"Restore purchases", nil);
        default:
            break;
    }
    return [super tableView:tableView titleForHeaderInSection:section];
};

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 4:
            return NSLocalizedString(@"CountdownFooter",nil);
            break;
        default:
            break;
    }
    return [super tableView:tableView titleForFooterInSection:section];
};
@end
