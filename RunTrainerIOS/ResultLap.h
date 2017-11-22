//
//  ResultLap.h
//  Ultra runner
//
//  Created by jarek on 13.05.2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Result, SpeedData;

@interface ResultLap : NSManagedObject

@property (nonatomic, retain) NSNumber * avgSpeed;
@property (nonatomic, retain) NSNumber * lapNumber;
@property (nonatomic, retain) NSNumber * maxSpeed;
@property (nonatomic, retain) NSNumber * restTime;
@property (nonatomic, retain) NSNumber * runDistance;
@property (nonatomic, retain) NSNumber * runTime;
@property (nonatomic, retain) NSNumber * ascend;
@property (nonatomic, retain) NSNumber * descend;
@property (nonatomic, retain) Result *result;
@property (nonatomic, retain) NSSet *speedData;
@end

@interface ResultLap (CoreDataGeneratedAccessors)

- (void)addSpeedDataObject:(SpeedData *)value;
- (void)removeSpeedDataObject:(SpeedData *)value;
- (void)addSpeedData:(NSSet *)values;
- (void)removeSpeedData:(NSSet *)values;

@end
