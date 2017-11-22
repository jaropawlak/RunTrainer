//
//  TrainingsViewController.h
//  RunTrainerIOS
//
//  Created by jarek on 10.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import "MOGlassButton.h"
@interface TrainingsViewController : UIViewController<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *createTrainingButton;
- (IBAction)CreateTrainingClicked:(id)sender;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
//- (IBAction)EditMode:(UIBarButtonItem *)sender;

@end
