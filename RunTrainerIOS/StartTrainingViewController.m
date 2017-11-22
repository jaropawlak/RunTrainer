//
//  StartTrainingViewController.m
//  RunTrainerIOS
//
//  Created by jarek on 17.07.2012.
//  Copyright (c) 2012 Majatech. All rights reserved.
//

#import "StartTrainingViewController.h"
#import "TrainingManager.h"
#import "SoundManager.h"
#import "StaticLibrary.h"

#import "Training+TrainingDescription.h"


@interface StartTrainingViewController ()
@property TrainingManager* trainingManager;
@property (nonatomic, strong) IBOutlet UIView *contentView;

@end

@implementation StartTrainingViewController
@synthesize statusText;
@synthesize speedText;
@synthesize distanceText;
@synthesize trainingManager = _trainingManager;
@synthesize training=_training;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];

   // self.title = self.training.trainingName;
    [self setupButtons];
    [self.yourTrainingImageView setHidden:self.training == nil];
    if (self.training != nil && !trainingInProgress)
    {
        _yourTraining.text = self.training.trainingName;
        self.trainingDescription.text = self.training.description;

    }
    if (self.trainingManager == nil)
    {
        self.trainingManager = [[TrainingManager alloc] init];
        [self.trainingManager prepareLocationManager];
    }

    //NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"lapNumber" ascending:true];
  //  self.laps = [[[self.training.laps allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];

}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];

}
- (void)viewDidLoad
{
     [super viewDidLoad];
   
    [self.startTrainingButton setTitle:NSLocalizedString(@"Start your training", nil) forState:UIControlStateNormal];
    [self.selectYourTrainingButton setTitle:NSLocalizedString(@"Select your training", nil) forState:UIControlStateNormal];
    self.statusText.text = NSLocalizedString(@"Ready", nil);
    self.title= NSLocalizedString(@"Trainings",nil);

    //_menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self prepareSliding:_menuButton];
    
}


- (void)viewDidUnload
{
    [self setStatusText:nil];
    [self setSpeedText:nil];
    [self setDistanceText:nil];
    [self setTrainingDescription:nil];
    [self setTrainingDescription:nil];
    [self setYourTrainingImageView:nil];
    
       [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


bool trainingInProgress = NO;
bool runningNow = YES;
-(void)setupButtons
{   
    //[self.selectYourTrainingButton setupAsTurquiseButton];
    
    if (trainingInProgress)
    {
       // [self.startTrainingButton setupAsRedButton];

        [self.startTrainingButton setTitle:NSLocalizedString(@"Stop training",nil) forState:UIControlStateNormal];
        [self.selectYourTrainingButton setHidden:YES];
    }
    else
    {
        [self.selectYourTrainingButton setHidden:NO];
    }
    if (self.training == nil)
    {
        [_startTrainingButton setHidden:YES];
    }
    if (self.training != nil && !trainingInProgress)
    {
       // [self.startTrainingButton setupAsTurquiseButton];
        [_startTrainingButton setHidden:NO];
        
        NSInteger countdown = [RunTrainerShared instance].trainingCountdown;
        if (countdown ==0)
        {
           [self.startTrainingButton setTitle:NSLocalizedString(@"Start now",nil) forState:UIControlStateNormal];         
        }
        else
        {
            NSString* delayedTitle = [NSString stringWithFormat:NSLocalizedString(@"Start in %i s.",nil), countdown];
             [self.startTrainingButton setTitle:delayedTitle forState:UIControlStateNormal];
        }
    
    }

}
- (IBAction)startTraining:(id)sender {
    
    if (self.training == nil)
    {
        // to się nigdy nie powinno zdarzyć bo nie widać guzika jak nie ma treningu
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No training",nil) message:NSLocalizedString(@"Please select training first!",nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(trainingInProgress)
    {
        [self.trainingManager stopTraining];
        return;
    }
    NSInteger countDown = [RunTrainerShared instance].trainingCountdown;
    if (countDown >0)
    {
        [self.startTrainingButton setTitle:NSLocalizedString(@"Prepare yourself",nil) forState:UIControlStateNormal];
        [self performSelector:@selector(startTrainingSession) withObject:nil afterDelay:countDown];
        seconds= countDown;
        delayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownTick) userInfo:nil repeats:YES];
    }
    else
    {
        [self startTrainingSession];
    }

}
-(void)startTrainingSession
{
    
    if (!trainingInProgress)
    {
    if (self.trainingManager != nil){
        self.trainingManager =nil;
    }
    self.trainingManager = [[TrainingManager alloc] init];
    self.trainingManager.delegate = self;
    self.trainingManager.training = self.training;
    trainingInProgress = YES;
    [self setupButtons];
    [self.trainingManager startTraining];
    }
}
-(void)notifyTrainingFinished:(double)result
{
    trainingInProgress = NO;
    [self setupButtons];
       
    self.speedText.text = @"";
    self.distanceText.text =@"";
        [[SoundManager instance] playEnd];
    self.statusText.text = NSLocalizedString(@"FINISHED",nil);
   
}

-(void)notifyStartRunning
{
    runningNow = YES;
    self.statusText.text = NSLocalizedString(@"RUN",nil);
    [[SoundManager instance] playStart];
}
-(void)notifyStopRunning
{
    runningNow = NO;
    self.statusText.text = NSLocalizedString(@"STOP",nil);
    self.distanceText.text = @"";
    self.speedText.text = @"";
        [[SoundManager instance] playStop];
}
-(void)notifyPartialSound{
           [[SoundManager instance] playPartAccomplished];
}
-(void)notifyGoFaster{
    
    self.statusText.text = NSLocalizedString(@"Run faster",nil);
        [[SoundManager instance] playFaster];
}
-(void)notifyGoSlower{
    self.statusText.text = NSLocalizedString(@"Slow down",nil);
        [[SoundManager instance] playSlower];
}
-(void)notifyDataUpdated{
    if (trainingInProgress)
    {
        self.distanceText.text = [NSString stringWithFormat:NSLocalizedString(@" %.2f m",nil), _trainingManager.currentDistance];
        self.statusText.text = self.trainingManager.status;
        if (runningNow)
        {
        self.speedText.text = [[RunTrainerShared instance] formatSpeed:[_trainingManager getSpeedFromLastSpeedDataRecords] ];        
        }
        else
        {
            self.speedText.text =self.distanceText.text =@"N/A";
        }
    }
}
-(void)notifyStepSound
{
    [[SoundManager instance] playStep];

}
NSTimer* delayTimer;
int seconds;

-(void)countDownTick
{
    
    if (--seconds ==0)
    {
        [delayTimer invalidate];
    }
    if(!trainingInProgress)
    {
        [[SoundManager instance] playNumber:seconds];
    [self.startTrainingButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Start in %i s.",nil),seconds] forState:UIControlStateNormal];
    }
}

@end
