//
//  CreateTimeTrialTrainingViewController.m
//  RunTrainerIOS
//
//  Created by jarek on 12.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import "CreateTimeTrialTrainingViewController.h"
#import "Training.h"
#import "Lap.h"

@interface CreateTimeTrialTrainingViewController ()

@end

@implementation CreateTimeTrialTrainingViewController
@synthesize trainingName;
@synthesize timeTrialPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"NewTimeTrialTitle", nil);
    self.trainingNameLabel.text = NSLocalizedString(@"TrainingName", nil);
    self.timeTrialLabel.text = NSLocalizedString(@"TimeTrialLength", nil);

	// Do any additional setup after loading the view.
}
- (void)viewDidUnload
{
    [self setTrainingName:nil];
    [self setTrainingNameLabel:nil];
    [self setTimeTrialLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)createNewTraining:(id)sender {
    NSManagedObjectContext* context= DataContext;
    Training *t = (Training*)[NSEntityDescription insertNewObjectForEntityForName:@"Training"  inManagedObjectContext:context];
    t.trainingName = self.trainingName.text;
    Lap * lap = (Lap*)[NSEntityDescription insertNewObjectForEntityForName:@"Lap"  inManagedObjectContext:context];
    lap.runTime =[self prepareRunTime];
    lap.training = t;
    lap.containsRest = NO;
    __autoreleasing NSError *e = [[NSError alloc] init] ;
    [context save:&e];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] -3] animated:YES];

    
    
}
-(NSNumber*)prepareRunTime
{
    // 0  2  4 - komponent 0 godzin + komponent 2 minut + komponent 4 sekund
    //00:00:00
    int seconds = 0;
    seconds += [self.timeTrialPicker selectedRowInComponent:0];
    seconds *= 60;
    seconds += [self.timeTrialPicker selectedRowInComponent:2];
    seconds *= 60;
    seconds += [self.timeTrialPicker selectedRowInComponent:4];
    return [NSNumber numberWithInt:seconds];
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
#pragma mark Picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5; //00:00:00  = 5
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component ==1 || component == 3)
        return 1; //:
    if (component == 2 || component == 4)
        return 60; // minuty i sekundy 00 - 59 (0-5)
    return 100;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30; // prób i błędów
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component ==1 || component == 3)
        return @":"; //:

    return [NSString stringWithFormat:@"%i", row];
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 50;
}

@end
