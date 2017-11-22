//
//  SpeedChartViewController.m
//  RunTrainerIOS
//
//  Created by jarek on 06.09.2012.
//
//

#import "SpeedChartViewController.h"
#import "SpeedChartView.h"
@interface SpeedChartViewController () <UIScrollViewDelegate>

@end

@implementation SpeedChartViewController
@synthesize resultLap = _resultLap;
@synthesize speedView = _speedView;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:true];
    self.speedView.speedDataSet = [[[self.resultLap.speedData allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
   
    [self.speedView prepareData];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"Speed/Altitude",nil);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setSpeedView:nil];
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.speedView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [view setNeedsDisplay];
    
}

@end
