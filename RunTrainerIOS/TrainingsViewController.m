//
//  TrainingsViewController.m
//  RunTrainerIOS
//
//  Created by jarek on 10.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import "TrainingsViewController.h"
#import "runtrainerAppDelegate.h"
#import "Training+TrainingDescription.h"
#import "StartTrainingViewController.h"
#import "Training.h"
#import "Lap.h"

@interface TrainingsViewController ()
@property (strong, nonatomic) Training* training;
@end

@implementation TrainingsViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize training = _training;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkAndGenerateTraining];   
    [self.tableView reloadData];
    
}
-(void)checkAndGenerateTraining
{
      id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    if ([sectionInfo numberOfObjects] >0)
    {
        return;
    }
    //Tabata 
    Training *training = (Training*)[NSEntityDescription insertNewObjectForEntityForName:@"Training" inManagedObjectContext:DataContext];
    training.trainingName = @"Tabata";
    for (int i = 0 ; i < 8 ; ++i)
    {
        Lap *lap =(Lap*)[NSEntityDescription insertNewObjectForEntityForName:@"Lap" inManagedObjectContext:DataContext];
        lap.training = training;
        lap.lapNumber = [NSNumber numberWithInt:i];
        lap.runTime = [NSNumber numberWithInt:20];
        lap.restTime = [NSNumber numberWithInt:10];
        lap.isRestTimeComputed = [NSNumber numberWithBool:NO];
        lap.containsRest =[NSNumber numberWithBool:YES];
    }
    
    //10 x 100 w rest = 2 run
    training = (Training*)[NSEntityDescription insertNewObjectForEntityForName:@"Training" inManagedObjectContext:DataContext];
    training.trainingName = @"10x100m / 2xR";
    for (int i = 0 ; i < 10 ; ++i)
    {
        Lap *lap =(Lap*)[NSEntityDescription insertNewObjectForEntityForName:@"Lap" inManagedObjectContext:DataContext];
        lap.training = training;
        lap.lapNumber = [NSNumber numberWithInt:i];
        lap.runDistance = [NSNumber numberWithInt:100];
        lap.restTimeComputeFactor = [NSNumber numberWithDouble:2.0];
        lap.isRestTimeComputed = [NSNumber numberWithBool:YES];
        lap.containsRest =[NSNumber numberWithBool:YES];
    }
    
    //4x400 2min
    training = (Training*)[NSEntityDescription insertNewObjectForEntityForName:@"Training" inManagedObjectContext:DataContext];
    training.trainingName = @"4x400 / 2min R";
    for (int i = 0 ; i < 4 ; ++i)
    {
        Lap *lap =(Lap*)[NSEntityDescription insertNewObjectForEntityForName:@"Lap" inManagedObjectContext:DataContext];
        lap.training = training;
        lap.lapNumber = [NSNumber numberWithInt:i];
        lap.runDistance = [NSNumber numberWithInt:400];
        lap.restTime = [NSNumber numberWithInt:120];
        lap.isRestTimeComputed = [NSNumber numberWithBool:NO];
        lap.containsRest =[NSNumber numberWithBool:YES];
       
    }

    //12 minute
    training = (Training*)[NSEntityDescription insertNewObjectForEntityForName:@"Training" inManagedObjectContext:DataContext];
    training.trainingName = NSLocalizedString(@"12 minutes",nil);
    Lap *lap =(Lap*)[NSEntityDescription insertNewObjectForEntityForName:@"Lap" inManagedObjectContext:DataContext];
        lap.training = training;
        lap.lapNumber = [NSNumber numberWithInt:0];
        lap.runTime = [NSNumber numberWithInt:12*60];
    
    training = (Training*)[NSEntityDescription insertNewObjectForEntityForName:@"Training" inManagedObjectContext:DataContext];
    training.trainingName = @"5km";
    lap =(Lap*)[NSEntityDescription insertNewObjectForEntityForName:@"Lap" inManagedObjectContext:DataContext];
    lap.training = training;
    lap.lapNumber = [NSNumber numberWithInt:0];
    lap.runDistance = [NSNumber numberWithInt:5000];

    //create trainings only if there is none
    
    [DataContext save:nil];
    [self.tableView reloadData];

}
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
    self.title = NSLocalizedString(@"Trainings",nil);
    [self.createTrainingButton setTitle:NSLocalizedString(@"Create your training",nil) forState:UIControlStateNormal];
   // [self.createTrainingButton setupAsTurquiseButton];
    
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setCreateTrainingButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // jedna sekcja tylko (lista treningów)
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    if (sectionInfo == nil)
    {
        NSLog(@"section info nil");
    }
    if (self.fetchedResultsController == nil)
    {
        NSLog(@"fetched controller nil");
    }
    NSLog(@"sectioninfo zawiera %lu obiektow", (unsigned long)[sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TrainingsTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Training  *managedObject = 
    (Training*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text =managedObject.trainingName;
    cell.detailTextLabel.text = managedObject.description;
    //[NSString stringWithFormat:@"%i",[managedObject.results count]];
//detail coś wymysle
    //    cell.detailTextLabel.text = @"d2";
    return cell;
}
-(void)prepareFetchedResultsController
{
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Training" inManagedObjectContext:DataContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:50];
    
    // Don't display unsaved cases
    [fetchRequest setIncludesPendingChanges:NO];
    
    [fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"laps",nil]];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"trainingName" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:DataContext sectionNameKeyPath: nil cacheName: nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        [self prepareFetchedResultsController];
    }
return _fetchedResultsController;
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
                
        Training *t = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", t.trainingName);
        
       
        
      
      
         [DataContext deleteObject:t];
         [DataContext save:nil];
        
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeDelete) {
        // Delete row from tableView.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    } else if (type == NSFetchedResultsChangeInsert)
    {
        [self.tableView reloadData];
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Training  *managedObject =
    (Training*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString* textToMeasure = managedObject.description;
    float width = self.tableView.bounds.size.width - 30;

    CGSize size = CGSizeMake(width, 999999.0);
   float height =  [textToMeasure sizeWithFont:[UIFont systemFontOfSize:14]   constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping].height + 45;
    return height;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.training = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    StartTrainingViewController* controller= [self.navigationController.viewControllers //lastObject];
                                              objectAtIndex:self.navigationController.viewControllers.count-2];
    if ([controller respondsToSelector:@selector(setTraining:)])
    {
        [controller setTraining:self.training];
    }
    [self.navigationController popViewControllerAnimated:YES];
  //  return indexPath;//

}
- (IBAction)CreateTrainingClicked:(id)sender {
    [self performSegueWithIdentifier:@"CreateTraining" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setTraining:)])
    {
        [segue.destinationViewController setTraining:self.training];

    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}
@end
