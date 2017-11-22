//
//  CreateNewDistanceIntervalViewController.m
//  RunTrainerIOS
//
//  Created by jarek on 17.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import "CreateNewDistanceIntervalViewController.h"
#import "StaticLibrary.h"

@interface CreateNewDistanceIntervalViewController ()

@end

@implementation CreateNewDistanceIntervalViewController
@synthesize restTimeLabel;
@synthesize isRestComputedSwitch;
@synthesize trainingName;
@synthesize runDistance;
@synthesize restTime;
@synthesize laps=_laps;
@synthesize descriptionText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.laps = [[NSMutableArray alloc] init];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    while ([self.laps count] >0)
    {
        Lap* lap = [self.laps lastObject];
        [DataContext deleteObject:lap];
        [self.laps removeLastObject];
        
    }
    [super viewWillDisappear:animated];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.trainingNameLabel.text = NSLocalizedString(@"TrainingName", nil);
    [self.addLapButton setTitle:NSLocalizedString(@"AddLap", nil) forState:UIControlStateNormal];
    self.descriptionLabel.text = NSLocalizedString(@"Description", nil);
    self.runDistanceLabel.text = NSLocalizedString(@"RunDistance",nil);
    self.restTimeLabel.text = NSLocalizedString(@"RestTime", nil);
    self.title = NSLocalizedString(@"DistanceIntervalTitle", nil);
    self.restTimeComputedLabel.text = NSLocalizedString(@"Rest time computed", nil);
    [StaticLibrary roundCorners:self.descriptionText];
   

}
- (void)viewDidUnload
{
    [self setTrainingName:nil];
    [self setRunDistance:nil];
    [self setRestTime:nil];
    [self setIsRestComputedSwitch:nil];
    [self setRestTimeLabel:nil];
    [self setTrainingNameLabel:nil];
    [self setRunDistanceLabel:nil];
    [self setRestTimeComputedLabel:nil];
    [self setAddLapButton:nil];
    [self setDescriptionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)AddLap:(id)sender {
    Lap * lap = (Lap*)[NSEntityDescription insertNewObjectForEntityForName:@"Lap"  inManagedObjectContext:DataContext];
    lap.runDistance =[NSNumber numberWithInteger:self.runDistance.text.integerValue];
    lap.containsRest = [NSNumber numberWithBool:(self.restTime.text.integerValue >0)];
    lap.isRestTimeComputed = [NSNumber numberWithBool:self.isRestComputedSwitch.on];
    if (self.isRestComputedSwitch.on)
    {
        lap.restTimeComputeFactor = [NSDecimalNumber decimalNumberWithString:self.restTime.text];

    }
    else {
       lap.restTime = [NSNumber numberWithInteger:self.restTime.text.integerValue];
    }
    
    lap.lapNumber = [NSNumber numberWithInteger:([self.laps count] +1)];
    [self.laps addObject:lap];
    descriptionText.text = [Training  descriptionForLaps:self.laps];

}
- (IBAction)restSwitchSwitched:(id)sender {
    if (self.isRestComputedSwitch.on)
    {
        self.restTimeLabel.text = NSLocalizedString(@"Rest factor",nil);
    }
    else {
        self.restTimeLabel.text = NSLocalizedString(@"RestTime", nil);
    }
}
- (IBAction)createNewTraining:(id)sender {
    Training *training = (Training*)[NSEntityDescription insertNewObjectForEntityForName:@"Training" inManagedObjectContext:DataContext];
    training.trainingName = self.trainingName.text;
    for (int i = 0 ; i < [self.laps count] ; ++i)
    {
        Lap *lap =[self.laps objectAtIndex:i];
        lap.training = training;
        lap.lapNumber = [NSNumber numberWithInt:i];
    }
    self.laps = nil;
    [DataContext save:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] -3] animated:YES];

}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField != self.runDistance && textField != self.restTime)
    {
        return YES;
    }
    return [string isEqualToString:@""] || ([string stringByTrimmingCharactersInSet:
                                              [[NSCharacterSet decimalDigitCharacterSet] invertedSet]].length > 0) || [string isEqualToString:@"."]|| [string isEqualToString:@","];
   
}

@end
