//
//  SearchResultsTableViewController.h
//  RunTrainerIOS
//
//  Created by jarek on 15.10.2012.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SearchResultsTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (strong, nonatomic) UIButton* menuButton;
@end
