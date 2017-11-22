//
//  Result.h
//  Ultra runner
//
//  Created by jarek on 13.05.2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ResultLap, Training;

@interface Result : NSManagedObject

@property (nonatomic, retain) NSDate * trainingDate;
@property (nonatomic, retain) NSString * trainingName;
@property (nonatomic, retain) NSSet *laps;
@property (nonatomic, retain) Training *training;
@end

@interface Result (CoreDataGeneratedAccessors)

- (void)addLapsObject:(ResultLap *)value;
- (void)removeLapsObject:(ResultLap *)value;
- (void)addLaps:(NSSet *)values;
- (void)removeLaps:(NSSet *)values;

@end
