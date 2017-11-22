//
//  SpeedData.h
//  RunTrainerIOS
//
//  Created by jarek on 23.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ResultLap;

@interface SpeedData : NSManagedObject

@property (nonatomic, retain) NSNumber * alt;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) ResultLap *lapResult;

@end
