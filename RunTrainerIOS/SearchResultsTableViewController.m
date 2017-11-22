//
//  SearchResultsTableViewController.m
//  RunTrainerIOS
//
//  Created by jarek on 15.10.2012.
//
//

#import "SearchResultsTableViewController.h"
#import "runtrainerAppDelegate.h"
#import "Result.h"
#import "Training.h"
#import "ResultDetailsController.h"

@interface SearchResultsTableViewController ()
@property NSString* searchString;
@end

@implementation SearchResultsTableViewController
@synthesize fetchedResultsController= _fetchedResultsController;
@synthesize searchString = _searchString;
NSDateFormatter *dateFormatter;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSLocale* locale = [NSLocale currentLocale];
    [dateFormatter setLocale:locale];
    
    
}

-(void)awakeFromNib
{
    self.title =NSLocalizedString(@"Find result", nil);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Result  *managedObject =
    (Result*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text =[dateFormatter stringFromDate:managedObject.trainingDate];
    NSString *tName= managedObject.trainingName;
    
    if (tName == nil | tName.length ==0)
    {
        tName = managedObject.training.trainingName;
    }
    cell.detailTextLabel.text = tName;
    return cell;
}

-(void)prepareFetchedResultsController
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Result" inManagedObjectContext:DataContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:500];
    [fetchRequest setIncludesPendingChanges:NO];
    
    [fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"training",nil]];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"trainingDate" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:DataContext sectionNameKeyPath: nil cacheName: nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Result *t = [self.fetchedResultsController objectAtIndexPath:indexPath];
                
        [DataContext deleteObject:t];
        [DataContext save:nil];
        
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setResult:)])
    {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        [segue.destinationViewController setResult:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
    }
}

@end
