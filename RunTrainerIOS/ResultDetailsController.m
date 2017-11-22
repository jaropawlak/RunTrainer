//
//  ResultDetailsController.m
//  RunTrainerIOS
//
//  Created by jarek on 03.09.2012.
//
//

#import "ResultDetailsController.h"
#import "ResultDetailsCell.h"
#import "SpeedChartViewController.h"
@interface ResultDetailsController ()
@property NSMutableArray* resultLaps;
@end

@implementation ResultDetailsController
@synthesize result = _result;
@synthesize resultLaps = _resultLaps;

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
     NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"lapNumber" ascending:YES];
    self.resultLaps = [[[self.result.laps allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
}

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"Training results", nil);
    [super viewDidLoad];

   
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultLaps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultDetailsCell";
    ResultDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    ResultLap* lap = [self.resultLaps objectAtIndex:indexPath.row];
    cell.restTime.text = [NSString stringWithFormat:@"%@ s",lap.restTime];
    cell.lapNumber.text =[NSString stringWithFormat:@"%@",lap.lapNumber];
    cell.runTime.text = [NSString stringWithFormat:@"%.2f s",lap.runTime.doubleValue];
    cell.distance.text = [NSString stringWithFormat:@"%.2f m",lap.runDistance.doubleValue];
    cell.avgSpeed.text = [[RunTrainerShared instance] formatSpeed:lap.avgSpeed.floatValue];
    cell.maxSpeed.text = [[RunTrainerShared instance] formatSpeed:lap.maxSpeed.floatValue];
    if (lap.ascend)
    {
        cell.ascend.text = [NSString stringWithFormat:@"%.2f m",lap.ascend.doubleValue];
    }
    if (lap.descend)
    {
        cell.descend.text = [NSString stringWithFormat:@"%.2f m",lap.descend.doubleValue];
    }
    
    cell.runTimeLabel.text = NSLocalizedString(@"Run",nil);
    cell.distanceLabel.text = NSLocalizedString(@"Distance",nil);
    cell.lapNrLabel.text = NSLocalizedString(@"Lap nr",nil);
    cell.restLabel.text = NSLocalizedString(@"Rest",nil);
    cell.avgSpeedLabel.text = NSLocalizedString(@"avg speed",nil);
    cell.maxSpeedLabel.text = NSLocalizedString(@"max speed",nil);
    cell.elevationLabel.text = NSLocalizedString(@"elevation",nil);
    cell.reductionLabel.text = NSLocalizedString(@"reduction",nil);
    
    return cell;
}


#pragma mark - Table view delegate


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setResultLap:)])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [segue.destinationViewController setResultLap:[self.resultLaps objectAtIndex:indexPath.row]];
    }
}

@end
