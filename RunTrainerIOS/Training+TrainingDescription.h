//
//  Training+TrainingDescription.h
//  RunTrainerIOS
//
//  Created by jarek on 06.11.2012.
//
//

#import "Training.h"

@interface Training (TrainingDescription)
-(NSString*)description;
+(NSString*)descriptionForLaps:(NSArray*)laps;
@end
