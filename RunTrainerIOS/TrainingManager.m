//
//  TrainingManager.m
//  RunTrainerIOS
//
//  Created by jarek on 23.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import "TrainingManager.h"
@interface TrainingManager()
@property (strong) NSMutableArray* laps;
@property (strong) NSMutableArray* results;
@property (strong) Lap*  currentLap;
@property (strong) Result* currentResult;
@property (strong) ResultLap* currentResultLap;

@property float maxSpeed;
@property float avgSpeed;
@property BOOL runningNow;
@property BOOL restingNow;
@property int tempoWarningCount;
@property NSDate *tempoWarningStart;
@property NSDate *startRunningTime;
@property NSDate *startRestingTime;
@property double restTime; // moze byc obliczany lub na sztywno. ustawiany w checkendruncontidions
@property BOOL q1sound;
@property BOOL q2sound;
@property BOOL q3sound;
@property NSTimer *timer;
@property BOOL trainingInProgress;
@property (strong) NSMutableArray *speedDataInfo;

@end
@implementation TrainingManager
@synthesize locationManager=_locationManager;
@synthesize avgSpeed=_avgSpeed;
@synthesize maxSpeed=_maxSpeed;
@synthesize currentLap = _currentLap;
@synthesize currentResult=_currentResult;
@synthesize currentResultLap=_currentResultLap;
@synthesize results=_results;
@synthesize runningNow=_runningNow;
@synthesize restingNow=_restingNow;
@synthesize laps=_laps;
@synthesize currentLapIndex = _currentLapIndex;
@synthesize training=_training;
@synthesize delegate=_delegate;
@synthesize tempoWarningCount=_tempoWarningCount;
@synthesize tempoWarningStart=_tempoWarningStart;
@synthesize currentDistance=_currentDistance;
@synthesize startRestingTime;
@synthesize restTime = _restTime;
@synthesize startRunningTime;
@synthesize q1sound = _q1sound;
@synthesize q2sound = _q2sound;
@synthesize q3sound = _q3sound;
@synthesize speedDataInfo =_speedDataInfo;
@synthesize timer=_timer;
@synthesize trainingInProgress;

double ascend;
double descend;

#define CurrentRunTime [[NSDate date] timeIntervalSinceDate:self.startRestingTime]
#define NumberOfDataObjectsForAvgSpeed 5

//zeruje wartości propertasów przed kolejną turą
-(void)clearProperties
{
    self.avgSpeed = self.maxSpeed = self.currentDistance= 0;
    _speedDataInfo = [[NSMutableArray alloc] initWithCapacity:NumberOfDataObjectsForAvgSpeed];
    _q1sound = _q2sound = _q3sound = NO;
    ascend = descend = 0.0;
}




-(double)stopTraining
{
    CLLocation* location = _locationManager.location;

    [self stopMetronome];
    trainingInProgress = NO;
    double result= [self saveScore];
    [self.delegate notifyTrainingFinished:result];

    if (self.locationManager != nil)
    {
       // [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
    }
    self.runningNow =NO;
    self.restingNow = NO;
    
    [DataContext save:nil];
        
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer =nil;
    }
   
    return result;
}
-(double)saveScore
{
    double score = 0;
    NSArray* laps = [self.currentResult.laps allObjects];
    for (ResultLap* rLap in laps) {
        score += rLap.avgSpeed.doubleValue;
    }
    score /= laps.count;
    
    return score;
}
-(NSString*) status
{
    if (_runningNow)
    {
        if (_currentLap.runDistance.doubleValue > 0)
        {
          return [NSString stringWithFormat:NSLocalizedString(@"RUN %.0f m", nil), (_currentLap.runDistance.doubleValue - _currentDistance)];
        }
        else
        {
            return [NSString stringWithFormat:NSLocalizedString(@"RUN %.0f s",nil), _currentLap.runTime.doubleValue -[[NSDate date] timeIntervalSinceDate:startRunningTime] ];
        }
    }
    else if (_restingNow)
    {
        
       return [NSString stringWithFormat:NSLocalizedString(@"Rest %.0f s",nil),self.restTime -[[NSDate date] timeIntervalSinceDate:self.startRestingTime]
               ];
    }
    return @"";
}
-(void)startNextStep
{
    
    if (!self.runningNow)
    {
            //nie biegnie kiedy zakończył się odpoczynek lub trening dopiero się zaczyna, bierzemy kolejne okrążenie
            if (++self.currentLapIndex < [self.laps count])
            {
                [self clearProperties];
                self.tempoWarningCount = [[RunTrainerShared instance] checkTempoIntervalSeconds];
                self.tempoWarningStart = [NSDate date];
                self.currentLap = [self.laps objectAtIndex:self.currentLapIndex];
                self.currentResultLap = [NSEntityDescription insertNewObjectForEntityForName:@"ResultLap" inManagedObjectContext:DataContext];
                self.currentResultLap.result = self.currentResult;
                self.currentResultLap.lapNumber = [NSNumber numberWithInt:(self.currentLap.lapNumber.intValue + 1)];
                self.startRunningTime = [NSDate date];
                [self.delegate notifyStartRunning];
                self.runningNow = YES;
                self.restingNow = NO;
                [self startMetronome];
            }
            else 
            {
                [self stopTraining];
                //save results
                //stop timer
            }
    }
    else // if running     
    {
        self.runningNow=NO;
        self.restingNow = YES;
        self.currentResultLap.ascend = [NSNumber numberWithDouble:ascend];
        self.currentResultLap.descend = [NSNumber numberWithDouble:descend];
        [self stopMetronome];
        
        if ([self.currentLap.containsRest boolValue])
        {
            self.startRestingTime = [NSDate date];            
            [self.delegate notifyStopRunning];
            
            
        } else {
            [self startNextStep]; // jak nie ma przerwy to idz do kolejnego kroku
        }
    }
    
}
-(void)checkPartialSoundConditions
{
    int psounds = [[RunTrainerShared instance] partialSounds];
    if ( psounds==0)
        return;
    if ([self.currentLap.runTime intValue] >0)
    {
        double currentRunTime = [[NSDate date] timeIntervalSinceDate:self.startRunningTime];
        double totalRunTime = [self.currentLap.runTime doubleValue];
        if (psounds != 1 && !_q1sound && currentRunTime > (totalRunTime/4.0))
        {
            _q1sound = YES;
            [self.delegate notifyPartialSound];
            return;
        }
        if (!_q2sound && currentRunTime > (totalRunTime/2.0))
        {
            _q2sound = YES;
            [self.delegate notifyPartialSound];
            return;
        }
        if (psounds != 1 && !_q3sound && currentRunTime > (totalRunTime*3.0/4.0))
        {
            _q3sound = YES;
            [self.delegate notifyPartialSound];
            return;
        }
        
    }
    else //distance based
    {
        double currentDistance = self.currentDistance;
        double totalDistance = [self.currentLap.runDistance doubleValue];
        if (psounds != 1 && !_q1sound && currentDistance > (totalDistance/4.0))
        {
            _q1sound = YES;
            [self.delegate notifyPartialSound];
            return;
        }
        if (!_q2sound && currentDistance > (totalDistance/2.0))
        {
            _q2sound = YES;
            [self.delegate notifyPartialSound];
            return;
        }
        if (psounds != 1 && !_q3sound && currentDistance > (totalDistance*3.0/4.0))
        {
            _q3sound = YES;
            [self.delegate notifyPartialSound];
            return;
        }
    }
}
-(void)checkEndRestConditions
{
    if ([[NSDate date] timeIntervalSinceDate:self.startRestingTime] >= self.restTime)
    {
        [self startNextStep];
    }
    else
    {
         [self.delegate notifyDataUpdated];
    }
}
-(void)checkEndRunConditions
{
    if ( ([self.currentLap.runTime intValue] > 0 &&  // czasowy lap
            ([[NSDate date] timeIntervalSinceDate:self.startRunningTime] >= [self.currentLap.runTime intValue])) ||
        //lub jesli dystans i juz za dlugo biegniemy
       ( [self.currentLap.runDistance intValue] >0 && self.currentDistance >= [self.currentLap.runDistance doubleValue]))
        
    {
        self.currentResultLap.maxSpeed =  [NSNumber numberWithFloat:self.maxSpeed];
        self.currentResultLap.avgSpeed = [NSNumber numberWithDouble:self.currentDistance/
                          [[NSDate date] timeIntervalSinceDate:self.startRunningTime] ] ; 
        self.currentResultLap.runDistance = [NSNumber numberWithFloat:self.currentDistance];
        self.currentResultLap.runTime = [NSNumber numberWithDouble:                                         [[NSDate date] timeIntervalSinceDate:self.startRunningTime] ] ; 
        double restTime ;
        if ([self.currentLap.containsRest boolValue])
        {
            if ([self.currentLap.isRestTimeComputed boolValue])
            {
                restTime = [self.currentResultLap.runTime doubleValue] * [self.currentLap.restTimeComputeFactor doubleValue];
            }
            else {
                restTime = [self.currentLap.restTime doubleValue];
            }
            self.currentResultLap.restTime = [NSNumber numberWithDouble:restTime];
            self.restTime = restTime;
        }
        [self startNextStep];
    }
            
    
}
-(double)getSpeedFromLastSpeedDataRecords
{
    return self.locationManager.location.speed;
    
//    SpeedData *first, *last;
//    if ([self.speedDataInfo count] >0)
//    {
//    first = [self.speedDataInfo objectAtIndex:0];
//    
//    last = [self.speedDataInfo lastObject];
//    double timeInSeconds = [last.time timeIntervalSinceDate:first.time];
//    if (timeInSeconds == 0.0)
//    {
//        return 0.0;
//    }
//    double distance = [last.distance doubleValue] - [first.distance doubleValue];
//    return distance/timeInSeconds;
//    }
//    return 0.0;
}
-(void)collectData
{
    if (self.runningNow)
    {
        SpeedData* data = [NSEntityDescription insertNewObjectForEntityForName:@"SpeedData" inManagedObjectContext:DataContext];
        data.lapResult = self.currentResultLap;
        data.time = [NSDate date];
        data.speed = [NSNumber numberWithDouble:self.locationManager.location.speed];
        data.alt = [NSNumber numberWithDouble:self.locationManager.location.altitude];
        data.longitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.longitude];
        data.lat = [NSNumber numberWithDouble:self.locationManager.location.coordinate.latitude];
        data.distance = [NSNumber numberWithDouble:self.currentDistance];
        [self.speedDataInfo addObject:data];
        if ([self.speedDataInfo count] > NumberOfDataObjectsForAvgSpeed)
        {
            [self.speedDataInfo removeObjectAtIndex:0];
        }
        if (self.locationManager.location.speed > self.maxSpeed)
        {
            self.maxSpeed = self.locationManager.location.speed;
        }
        
        [self checkPartialSoundConditions];
        
        if ([[RunTrainerShared instance] monitorTempo] && self.runningNow && [[NSDate date] timeIntervalSinceDate:self.tempoWarningStart] > [[RunTrainerShared instance]  checkTempoIntervalSeconds])
        {
            self.tempoWarningStart = [NSDate date];
            
            double speed = [[RunTrainerShared instance] requiredTempo];
            if (speed == 0.0 && CurrentRunTime != 0.0)
                speed = self.currentDistance/CurrentRunTime;
            double currentSpeed  = [self getSpeedFromLastSpeedDataRecords];
            double percent = currentSpeed * 100.0/speed;
            
            if (percent -100 > [[RunTrainerShared instance] tempoDiffersThreshold])
                [self.delegate notifyGoSlower];
            else if (100 - percent > [[RunTrainerShared instance] tempoDiffersThreshold])
                [self.delegate notifyGoFaster];
            
        }
        [DataContext save:nil];
        
        [self.delegate notifyDataUpdated];
    }
   
   
}

-(void)prepareLocationManager
{
    if (_locationManager == nil)
    {
               CLLocationManager* manager = [[CLLocationManager alloc] init];
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        manager.distanceFilter = 0.2;
        
        manager.delegate = self;
        
        [manager requestAlwaysAuthorization];
        [manager startUpdatingLocation];
        
        _locationManager = manager;
    }
}
-(void)startTraining
{
    
    [self prepareLocationManager];
    
    if (self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    }
    self.runningNow = self.restingNow = NO;
    self.currentLapIndex = -1;
    [self clearProperties];
    
    self.currentResult = [NSEntityDescription insertNewObjectForEntityForName:@"Result" inManagedObjectContext:DataContext];
    self.currentResult.training = self.training;
    self.currentResult.trainingDate = [NSDate date];
    self.currentResult.trainingName = self.training.trainingName;
    
    //okrążenia idą do tablicy bo można z niej wybierać elementy po indeksie
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"lapNumber" ascending:true];
    self.laps = [[[self.training.laps allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
    trainingInProgress = YES;
    [self startNextStep];
}
CLLocation *oldLocation;

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
     CLLocation* newLocation = [locations lastObject];
    if (self.runningNow && oldLocation!=nil)
    {
        double distance = [newLocation distanceFromLocation:oldLocation];
        self.currentDistance += distance;
        double altDifference = newLocation.altitude - oldLocation.altitude;
        if (altDifference >0.0)
        {
            ascend += altDifference;
        }
        else if (altDifference <0.0)
        {
            descend -= altDifference;
        }
    }
    oldLocation = newLocation;

}
int fullSeconds = 0;// 10 razy na sekunde
-(void)onTick:(id)timer
{
    if (self.runningNow && trainingInProgress)
    {               [self checkEndRunConditions];
        if ( ++fullSeconds%10==0)
        {
            [self collectData];
        }
    
    }
    else if (self.restingNow)
    {
        [self checkEndRestConditions];
    }
}
NSTimer* stepsTimer;
-(void)startMetronome
{
  if (![RunTrainerShared instance].useMetronome)
      return;
    
    NSTimeInterval beatsPerSecond = 1.0/( [RunTrainerShared instance].stepsPerMinute / 60.0);
    stepsTimer =[NSTimer scheduledTimerWithTimeInterval:beatsPerSecond target:self selector:@selector(stepTicked:) userInfo:nil repeats:YES];
            
}
-(void)stopMetronome
{
    if (stepsTimer != nil)
    {
        [stepsTimer invalidate];
        stepsTimer = nil;
    }
}
-(void)stepTicked:(id)timer
{
    [self.delegate notifyStepSound];
}
@end
