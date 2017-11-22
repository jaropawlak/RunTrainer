//
//  Training.h
//  RunTrainerIOS
//
//  Created by jarek on 13.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lap, Result;

@interface Training : NSManagedObject

@property (nonatomic, retain) NSString * trainingName;
@property (nonatomic, retain) NSSet *laps;
@property (nonatomic, retain) NSSet *results;
@end

@interface Training (CoreDataGeneratedAccessors)

- (void)addLapsObject:(Lap *)value;
- (void)removeLapsObject:(Lap *)value;
- (void)addLaps:(NSSet *)values;
- (void)removeLaps:(NSSet *)values;

- (void)addResultsObject:(Result *)value;
- (void)removeResultsObject:(Result *)value;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;

@end
