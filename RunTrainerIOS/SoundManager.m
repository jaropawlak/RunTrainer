//
//  SoundManager.m
//  RunTrainerIOS
//
//  Created by jarek on 10.08.2012.
//
//

#import "SoundManager.h"

@implementation SoundManager
AVAudioPlayer* audioPlayer;
AVAudioPlayer* stepsPlayer;
AVSpeechSynthesizer *synth;
+(SoundManager*)instance
{
    static dispatch_once_t once;
    static SoundManager* sharedInstance;
    dispatch_once(&once, ^{sharedInstance = [[self alloc] init];});
    [self setupAudioSession];
    return sharedInstance;
}
+(void)setupAudioSession
{
    NSError *activationError = nil;
       [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback  error:&activationError];
    UInt32 oth=1;
    UInt32 sz_oth = sizeof(oth);
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sz_oth, &oth);
    synth = [[AVSpeechSynthesizer alloc] init];
}
-(void)playSound: (NSString*) sound
{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], sound]];
	
	NSError *error;
    if (audioPlayer != nil && [audioPlayer isPlaying])
    {
        [audioPlayer stop];
    }
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;
	
	if (audioPlayer == nil)
		NSLog(@"%@",[error description]);
	else
		[audioPlayer play];
}
-(void)playNumber:(NSInteger)number
{
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:[NSString stringWithFormat:@"%i",(int)number]];
    
    [synth speakUtterance:utterance];

}
-(void)playStart
{
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:NSLocalizedString(@"GO", nil)];
    
    [synth speakUtterance:utterance];
    //[self playSound:@"Go_4.m4a"];
}
-(void)playStop{
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:NSLocalizedString(@"STOP", nil)];
    
    [synth speakUtterance:utterance];
}
-(void)playFaster{
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:NSLocalizedString(@"FASTER", nil)];
    
    [synth speakUtterance:utterance];
}
-(void)playSlower{
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:NSLocalizedString(@"SLOWER", nil)];
    
    [synth speakUtterance:utterance];
}
-(void)playPartAccomplished{
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:NSLocalizedString(@"CHECKPOINT", nil)];
    
    [synth speakUtterance:utterance];
}
-(void)playEnd{
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:NSLocalizedString(@"DONE", nil)];
    
    [synth speakUtterance:utterance];
}
-(void)playStep
{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"bip.mp3"]];
	
	NSError *error;
    if (stepsPlayer != nil && [stepsPlayer isPlaying])
    {
        [stepsPlayer stop];
    }
	stepsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	stepsPlayer.numberOfLoops = 0;
	
	if (stepsPlayer == nil)
		NSLog(@"%@",[error description]);
	else
		[stepsPlayer play];

}

@end
