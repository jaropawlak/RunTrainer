//
//  TrainingManager.h
//  RunTrainerIOS
//
//  Created by jarek on 23.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Training.h"
#import "Lap.h"
#import "Result.h"
#import "ResultLap.h"
#import "SpeedData.h"

#import "TrainingManagerDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface TrainingManager : NSObject<CLLocationManagerDelegate>

@property Training *training;
@property (weak) id<TrainingManagerDelegate> delegate;
@property (strong) CLLocationManager *locationManager;
-(void)startTraining;
-(double)stopTraining;

//metody obsługi GPS
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

@property double currentDistance;
@property int currentLapIndex;
-(double)getSpeedFromLastSpeedDataRecords;
-(void)prepareLocationManager;
@property (readonly) NSString* status;

@end
