//
//  Lap.h
//  RunTrainerIOS
//
//  Created by jarek on 24.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Training;

@interface Lap : NSManagedObject

@property (nonatomic, retain) NSNumber * containsRest;
@property (nonatomic, retain) NSNumber * isRestTimeComputed;
@property (nonatomic, retain) NSNumber * lapNumber;
@property (nonatomic, retain) NSNumber * restTime;
@property (nonatomic, retain) NSNumber * restTimeComputeFactor;
@property (nonatomic, retain) NSNumber * runDistance;
@property (nonatomic, retain) NSNumber * runTime;
@property (nonatomic, retain) Training *training;

@end
