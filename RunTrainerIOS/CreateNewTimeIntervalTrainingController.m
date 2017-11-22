//
//  CreateNewTimeIntervalTrainingController.m
//  RunTrainerIOS
//
//  Created by jarek on 13.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//
// Działanie tego kontrolera: przy otwarciu tworzy trening, w tableView jest kolekcja itemów w tym treningu
// przy anulowaniu usuwa trening!!
#import "CreateNewTimeIntervalTrainingController.h"
#import "StaticLibrary.h"

@interface CreateNewTimeIntervalTrainingController ()

@end

@implementation CreateNewTimeIntervalTrainingController

@synthesize trainingName;
@synthesize laps=_laps;
@synthesize runTimeText;
@synthesize restTimeText;
@synthesize descriptionText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"TimeIntervalTitle", nil);
    self.trainingNameLabel.text = NSLocalizedString(@"TrainingName", nil);
    [self.addLapButton setTitle:NSLocalizedString(@"AddLap", nil) forState:UIControlStateNormal];
    self.descriptionLabel.text = NSLocalizedString(@"Description", nil);
    self.runTimeLabel.text = NSLocalizedString(@"RunTime", nil);
    self.restTimeLabel.text = NSLocalizedString(@"RestTime", nil);
    
    [StaticLibrary roundCorners:self.descriptionText];
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
- (void)viewDidUnload
{
    
    [self setTrainingName:nil];
    [self setRunTimeText:nil];
    [self setRestTimeText:nil];
    [self setTrainingNameLabel:nil];
    [self setRunTimeLabel:nil];
    [self setRestTimeLabel:nil];
    [self setAddLapButton:nil];
    [self setDescriptionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [self.navigationController  popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] -3] animated:YES];

}

- (IBAction)AddLap:(id)sender {
    
    Lap * lap = (Lap*)[NSEntityDescription insertNewObjectForEntityForName:@"Lap"  inManagedObjectContext:DataContext];
    lap.runTime =[NSNumber numberWithInt:self.runTimeText.text.integerValue];
    int rest = self.restTimeText.text.integerValue;
    lap.containsRest = [NSNumber numberWithBool:(self.restTimeText.text.integerValue >0)];
    lap.restTime = [NSNumber numberWithInt:rest];
   // lap.containsRest = (rest > 0) ? YES : NO;
    lap.lapNumber = [NSNumber numberWithInt:([self.laps count] +1)];
    [self.laps addObject:lap];
    descriptionText.text = [Training descriptionForLaps:self.laps];
        
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField != self.runTimeText && textField != self.restTimeText)
    {
        return YES;
    }
    return [string isEqualToString:@""] ||
    ([string stringByTrimmingCharactersInSet:
      [[NSCharacterSet decimalDigitCharacterSet] invertedSet]].length > 0);
}
@end
