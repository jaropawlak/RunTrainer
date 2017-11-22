//
//  SoundManager.h
//  RunTrainerIOS
//
//  Created by jarek on 10.08.2012.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject

+(SoundManager*) instance;


-(void)playStart;
-(void)playStop;
-(void)playFaster;
-(void)playSlower;
-(void)playPartAccomplished;
-(void)playEnd;
-(void)playStep;
-(void)playNumber:(NSInteger)number;
@end
