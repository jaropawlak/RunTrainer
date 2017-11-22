//
//  Training+TrainingDescription.m
//  RunTrainerIOS
//
//  Created by jarek on 06.11.2012.
//
//

#import "Training+TrainingDescription.h"
#import "Lap.h"
@implementation Training (TrainingDescription)
-(NSString*)description
{
   
    
    
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"lapNumber" ascending:true];
    NSArray* lapInfo = [[self.laps allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] ;
    return [self.class descriptionForLaps:lapInfo];
    
}
+(NSString*)descriptionForLaps:(NSArray*)laps
{
    
    int lapCount = [laps count];
    if ( lapCount==0)
    {
        return NSLocalizedString(@"no laps defined",nil);
    }
    
    
    bool isRepeating = NO;
    int repeatCount = 0;
    NSString* currentLapDescription = @"";
    for (int i = 0 ; i < lapCount ; ++i)
    {
        Lap* lap = [laps objectAtIndex:i];
        
        if (i > 0)
        {
            Lap* previousLap = [laps objectAtIndex:i-1];
            
            if (lap.runDistance.doubleValue == previousLap.runDistance.doubleValue &&
                lap.runTime.doubleValue == previousLap.runTime.doubleValue &&
                lap.restTime.doubleValue == previousLap.restTime.doubleValue &&
                lap.restTimeComputeFactor.doubleValue == previousLap.restTimeComputeFactor.doubleValue&&
                lap.containsRest.boolValue == previousLap.containsRest.boolValue &&
                lap.isRestTimeComputed.boolValue == previousLap.isRestTimeComputed.boolValue)
            {
                
                if (isRepeating)
                {
                    ++repeatCount;
                    
                } else
                    repeatCount=2;
                
                isRepeating = YES;
                continue;
            }
            else if (isRepeating)
            {
                
                isRepeating = NO;
                currentLapDescription=[currentLapDescription stringByAppendingFormat:NSLocalizedString(@" and repeat it %i times. ",nil), repeatCount];
                repeatCount = 0;
                
            }
            else
            {
                currentLapDescription=[currentLapDescription stringByAppendingFormat:@"."];
            }
        }
        bool timeBasedLap = [lap.runTime intValue ]>0;
        currentLapDescription=[currentLapDescription stringByAppendingFormat:NSLocalizedString(@"Run %@ %@",nil), timeBasedLap ? lap.runTime : lap.runDistance, timeBasedLap? @"s":@"m"];
        if ([lap.containsRest boolValue])
        {
            if ([lap.isRestTimeComputed boolValue])
            {
                currentLapDescription=[currentLapDescription stringByAppendingFormat:NSLocalizedString(@" then rest %@ times your run time",nil), lap.restTimeComputeFactor];
            }
            else
            {
                currentLapDescription=[currentLapDescription stringByAppendingFormat:NSLocalizedString(@" then rest %@ s",nil), lap.restTime];
            }
        }
        
    }
    if (isRepeating)
    {
        currentLapDescription=[currentLapDescription stringByAppendingFormat:NSLocalizedString(@" and repeat it %i times. ",nil), repeatCount];
    }
    return currentLapDescription;
}
@end
