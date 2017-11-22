//
//  RunTrainerShared.m
//  RunTrainerIOS
//
//  Created by jarek on 11.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import "RunTrainerShared.h"

@interface RunTrainerShared ()

@end

@implementation RunTrainerShared
@synthesize dataContext;

+(RunTrainerShared*) instance
{
    static dispatch_once_t once;
    static RunTrainerShared* sharedInstance;
    dispatch_once(&once, ^{sharedInstance = [[self alloc] init];});
    return sharedInstance;
}
-(NSInteger)trainingCountdown
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"trainingCountdown"];
}
-(void)setTrainingCountdown:(NSInteger)trainingCountdown
{
    [[NSUserDefaults standardUserDefaults] setInteger:trainingCountdown                                             forKey:@"trainingCountdown"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)speedUnits
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"speedUnits"];
}
-(void)setSpeedUnits:(NSInteger)speedUnits
{
    [[NSUserDefaults standardUserDefaults] setInteger:speedUnits                                             forKey:@"speedUnits"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}
-(double)requiredTempo
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"requiredTempo"];
}
-(void)setRequiredTempo:(double)requiredTempo
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:requiredTempo]  forKey:@"requiredTempo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)partialSounds
{
     return [[NSUserDefaults standardUserDefaults] integerForKey:@"partialSounds"];
}
-(void)setPartialSounds:(NSInteger)partialSounds
{
    [[NSUserDefaults standardUserDefaults] setInteger:partialSounds  forKey:@"partialSounds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)tempoDiffersThreshold
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"tempoDiffersThreshold"];
}
-(void)setTempoDiffersThreshold:(NSInteger)tempoDiffersThreshold
{
    [[NSUserDefaults standardUserDefaults] setInteger:tempoDiffersThreshold  forKey:@"tempoDiffersThreshold"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)checkTempoIntervalSeconds
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"checkTempoIntervalSeconds"];
}
-(void)setCheckTempoIntervalSeconds:(NSInteger)checkTempoIntervalSeconds
{
    [[NSUserDefaults standardUserDefaults] setInteger:checkTempoIntervalSeconds  forKey:@"checkTempoIntervalSeconds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)monitorTempo
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"monitorTempo"] ;
}
-(void)setMonitorTempo:(BOOL)monitorTempo
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:monitorTempo]  forKey:@"monitorTempo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)useMetronome
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"useMetronome"];
}
-(void)setUseMetronome:(BOOL)useMetronome
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:useMetronome]  forKey:@"useMetronome"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

-(double) scoreFor:(NSString*)trainingName
{
    NSDictionary* scores = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"scoreDictionary"];
    if (scores == nil || [scores objectForKey:trainingName] == nil)
    {
        return 0;
    }
    return [[scores objectForKey:trainingName] doubleValue];
}
-(void) setScoreFor:(NSString*)trainingName withValue:(double)score
{
    NSDictionary* scores = [[NSUserDefaults standardUserDefaults]  dictionaryForKey:@"scoreDictionary"];
    if (scores == nil)
    {
        scores = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:score] forKey:trainingName];
    }
    else
    {
        NSMutableDictionary* mutableScores = [scores mutableCopy];
        [mutableScores setObject:[NSNumber numberWithDouble:score] forKey:trainingName];
        scores = mutableScores;
    }
    [[NSUserDefaults standardUserDefaults] setObject:scores forKey:@"scoreDictionary"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)useFacebook
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"useFacebook"];
}
-(void)setUseFacebook:(BOOL)useFacebook
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:useFacebook]  forKey:@"useFacebook"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}


-(NSInteger)stepsPerMinute
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"stepsPerMinute"];
}
-(void)setStepsPerMinute:(NSInteger)stepsPerMinute
{
    [[NSUserDefaults standardUserDefaults] setInteger:stepsPerMinute  forKey:@"stepsPerMinute"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

//on input m/s
-(NSString*)formatSpeed: (float)speed
{
    if (speed <0)
    {
        return @"N/A";
    }
    switch (self.speedUnits)
    {
        case 0: //km/h
            return [NSString stringWithFormat:@" %.2f km/h", speed*36.0/10.0];
            break;
        case 1: //km/m
            return [NSString stringWithFormat:@" %.2f m/h", speed*600.0/1609.344];
            break;
        case 2: //m/km
            return [NSString stringWithFormat:@" %.2f m/km", 1.0/(speed*60.0/1000.0)];
            break;
        case 3: //m/m
            return [NSString stringWithFormat:@" %.2f m/mile", 1.0/( speed*60.0/1609.344)];
            break;
    }
    return @"error";
}

-(double) genericSpeedFromUnit:(double)unitSpeed
{
    switch (self.speedUnits)
    {
        case 0: //km/h
            return unitSpeed*10.0/36.0;
        case 1: //km/m
            return unitSpeed*1609.344/3600.0;
        case 2: //m/km
            return 1.0/(unitSpeed*60.0/1000.0);
        case 3: //m/m
            return 1.0/( unitSpeed*60.0/1609.344);
    }
    return 0.0;

}
-(double) unitSpeedFromGeneric:(double) speed
{
    switch (self.speedUnits)
    {
        case 0: //km/h
            return speed*36.0/10.0;
        case 1: //km/m
            return speed*3600.0/1609.344;
        case 2: //m/km
            return 1.0/(speed*60.0/1000.0);
        case 3: //m/m
            return 1.0/( speed*60.0/1609.344);            
    }
    return 0.0;

}




    
@end
