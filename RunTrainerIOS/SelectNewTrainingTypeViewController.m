//
//  SelectNewTrainingTypeViewController.m
//  Ultra runner
//
//  Created by jarek on 23.03.2013.
//
//

#import "SelectNewTrainingTypeViewController.h"

@interface SelectNewTrainingTypeViewController ()

@end

@implementation SelectNewTrainingTypeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"New training",nil);
    self.distanceIntervalDescription.text = NSLocalizedString(@"distanceIntervalDescription",nil);
        self.timeIntervalDescription.text = NSLocalizedString(@"timeIntervalDescription",nil);
        self.timeTrialDescription.text = NSLocalizedString(@"timeTrialDescription",nil);
        self.distanceTrainingDescription.text = NSLocalizedString(@"distanceTrainingDescription",nil);
        self.distanceTrainingTitle.text = NSLocalizedString(@"distanceTrainingTitle",nil);
        self.timeTrialTitle.text = NSLocalizedString(@"timeTrialTitle",nil);
        self.timeIntervalTitle.text = NSLocalizedString(@"timeIntervalTitle",nil);
        self.distanceIntervalTitle.text = NSLocalizedString(@"distanceIntervalTitle",nil);
}
- (void)viewDidUnload {
    [self setDistanceTrainingTitle:nil];
    [self setDistanceTrainingDescription:nil];
    [self setTimeTrialTitle:nil];
    [self setTimeTrialDescription:nil];
    [self setTimeIntervalTitle:nil];
    [self setTimeIntervalDescription:nil];
    [self setDistanceIntervalTitle:nil];
    [self setDistanceIntervalDescription:nil];
    [super viewDidUnload];
}
@end
