//
//  runtrainerAppDelegate.h
//  RunTrainerIOS
//
//  Created by jarek on 24.04.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
@interface runtrainerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
