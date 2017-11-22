//
//  RunTrainerShared.h
//  RunTrainerIOS
//
//  Created by jarek on 11.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>

@interface RunTrainerShared : NSObject

+(RunTrainerShared*) instance;

@property (weak) NSManagedObjectContext* dataContext;
@property NSInteger speedUnits;
//0 nic, 1 w połowie, 2 co ćwiartkę
@property NSInteger partialSounds;
@property NSInteger tempoDiffersThreshold;
@property NSInteger checkTempoIntervalSeconds;
@property BOOL monitorTempo;
@property double requiredTempo;
@property NSInteger trainingCountdown;
-(NSString*)formatSpeed: (float)speed;
-(double) genericSpeedFromUnit:(double)unitSpeed;
-(double) unitSpeedFromGeneric:(double) speed;
@property BOOL useFacebook;
@property NSInteger stepsPerMinute;
@property BOOL useMetronome;

@property (strong, nonatomic) FBSession *session;
-(BOOL) isFacebookLoggedin;
-(BOOL) facebookLogin;
-(double) scoreFor:(NSString*)trainingName;
-(void) setScoreFor:(NSString*)trainingName withValue:(double)score;



@end
