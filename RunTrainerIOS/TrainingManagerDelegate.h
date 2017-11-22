//
//  TrainingManagerDelegate.h
//  RunTrainerIOS
//
//  Created by jarek on 23.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TrainingManagerDelegate <NSObject>
@optional
-(void)notifyTrainingFinished:(double)result;
-(void)notifyStartRunning;
-(void)notifyStopRunning;
-(void)notifyPartialSound;
-(void)notifyGoFaster;
-(void)notifyGoSlower;
-(void)notifyDataUpdated;
-(void)notifyStepSound;
@end
