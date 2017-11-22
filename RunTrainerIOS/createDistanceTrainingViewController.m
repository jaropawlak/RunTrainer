//
//  createDistanceTrainingViewController.m
//  RunTrainerIOS
//
//  Created by jarek on 11.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import "createDistanceTrainingViewController.h"
#import "Training.h"
#import "Lap.h"
@interface CreateDistanceTrainingViewController ()

@end

@implementation CreateDistanceTrainingViewController
@synthesize trainingName;
@synthesize distance;
@synthesize picker;

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
    self.title = NSLocalizedString(@"CreateDistanceTrainingTitle", nil);
    self.trainingNameLabel.text = NSLocalizedString(@"TrainingName", nil);
    self.distanceLabel.text = NSLocalizedString(@"Distance", nil);
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTrainingName:nil];
    [self setDistance:nil];
    [self setTrainingNameLabel:nil];
    [self setDistanceLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)CreateNewTraining:(id)sender {
    int value = 0;
    for (int i = 0 ; i < 4 ; ++i)
    {   value *=10;
        value += [picker selectedRowInComponent:i];
    }
    switch ([picker selectedRowInComponent:4])
    {
        case 1: value *= 1000; //km;
            break;
        case 2: value*= 1609.344;
    }
    NSManagedObjectContext* context= [RunTrainerShared instance].dataContext;
    Training *t = (Training*)[NSEntityDescription insertNewObjectForEntityForName:@"Training"  inManagedObjectContext:context];
    t.trainingName = self.trainingName.text;
    Lap * lap = (Lap*)[NSEntityDescription insertNewObjectForEntityForName:@"Lap"  inManagedObjectContext:context];
    lap.runDistance =[NSNumber numberWithInt:value];
    lap.runTime = 0;
    lap.containsRest = NO;
    lap.training = t;
    __autoreleasing NSError *e = [[NSError alloc] init] ;
    [context save:&e];

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] -3] animated:YES];
    
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5; //4 cyfy + jednostka
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component <4)
        return 10; //10 cyfr
    return 3; //km, mile, metry
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30; // prób i błędów
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component < 4)
        return [NSString stringWithFormat:@"%i", row];
    switch (row)
    {
        case 0: return @"m";
        case 1: return @"km";
        case 2: return NSLocalizedString(@"miles", nil);
    }
    return nil;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component < 4) return 50;
    return 80;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([trainingName isFirstResponder])
    {
     [trainingName resignFirstResponder];
    }
}
@end
