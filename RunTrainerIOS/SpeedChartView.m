//
//  SpeedChartView.m
//  RunTrainerIOS
//
//  Created by jarek on 07.09.2012.
//
//

#import "SpeedChartView.h"
#import "SpeedData.h"

#define pointsPerEntry 10
@interface SpeedChartView()
@property NSMutableArray* speed;
@property NSMutableArray* alt;
@property NSMutableArray* times;
@property double minAlt ;
@property double maxAlt ;
@property double minSpeed ;
@property double maxSpeed;

@end

@implementation SpeedChartView
@synthesize speedDataSet=_speedDataSet;
@synthesize speed=_speed;
@synthesize alt=_alt;
@synthesize times=_times;
@synthesize minAlt=_minAlt;
@synthesize minSpeed = _minSpeed;
@synthesize maxSpeed = _maxSpeed;
@synthesize maxAlt = _maxAlt;
@synthesize panOffset = _panOffset;
@synthesize scale = _scale;


-(void)prepareData
{
       _minAlt = 50000;
    _minSpeed = 5000;
    _maxSpeed = 0;
    _maxAlt = 0;
     self.scale = 1.0;
    // 1. ilość wpisów
    //int numberOfEntries = [_speedDataSet count];

      for (SpeedData* item in _speedDataSet)
    {
      if ([item.alt doubleValue] < _minAlt)
          _minAlt = [item.alt doubleValue];
        if ([item.alt doubleValue] > _maxAlt)
            _maxAlt = [item.alt doubleValue];

      if ([item.speed doubleValue] > _maxSpeed)
           _maxSpeed = [item.speed doubleValue];
      if ([item.speed doubleValue] < _minSpeed)
          _minSpeed = [item.speed doubleValue];
            
    }
        
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        // Initialization code
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}
#define yaxisOffset 30

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (_panOffset <0)
        _panOffset = 0;
  
    int speedEntry = 0;
    double scaledPointsPerEntry = pointsPerEntry * self.scale;
    
    int totalLength = [_speedDataSet count] * scaledPointsPerEntry;
    
    if (_panOffset > totalLength)
        _panOffset = totalLength;
    
    int firstPointToWrite = 0;//self.panOffset/scaledPointsPerEntry;
   // int endPointToWrite = (self.panOffset + self.bounds.size.width)/scaledPointsPerEntry;
    
    float mariginForAxis = 40;
    
    float height = self.bounds.size.height - mariginForAxis;
    
   CGContextRef context=  UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3);
    [[UIColor blackColor] setFill];
    int i = firstPointToWrite;
    CGContextBeginPath(context);
    int widthPoint = (i * scaledPointsPerEntry)-_panOffset;
    int pointHeight;
    if (i < [_speedDataSet count])
    {
        pointHeight =  height - height*( [[(SpeedData*)[self.speedDataSet objectAtIndex:i] speed] floatValue] -_minSpeed)/(_maxSpeed-_minSpeed);
        
        CGContextMoveToPoint(context,widthPoint , height - height*( [[(SpeedData*)[self.speedDataSet objectAtIndex:i] speed] floatValue] -_minSpeed)/(_maxSpeed-_minSpeed));
        while (++i < _speedDataSet.count)
        {
            if (widthPoint < yaxisOffset && i*scaledPointsPerEntry-_panOffset >yaxisOffset)
            {
                speedEntry = i;
            }
            widthPoint = (i * scaledPointsPerEntry)-_panOffset;
            CGContextAddLineToPoint(context, widthPoint, height - height*( [[(SpeedData*)[self.speedDataSet objectAtIndex:i] speed] floatValue]-_minSpeed)/(_maxSpeed-_minSpeed));
        }
    }
    [[UIColor greenColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    i=firstPointToWrite;
    
    
    CGContextBeginPath(context);
    widthPoint = (i * scaledPointsPerEntry)-_panOffset;
    CGContextMoveToPoint(context, widthPoint, height - height*( [[[self.speedDataSet objectAtIndex:i] alt] floatValue] -_minAlt)/(_maxAlt-_minAlt));
    while (++i < _speedDataSet.count )
    {
        if (widthPoint < yaxisOffset && i*scaledPointsPerEntry-_panOffset >yaxisOffset)
        {
            speedEntry = i;
        }
        widthPoint = (i * scaledPointsPerEntry)-_panOffset;
        CGContextAddLineToPoint(context, widthPoint, height - height*( [[[self.speedDataSet objectAtIndex:i] alt] floatValue]-_minAlt)/( (_maxAlt-_minAlt) == 0 ? 1 : (_maxAlt-_minAlt)  ));
    }
    [[UIColor redColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    float fullHeight = self.bounds.size.height;
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0,(height + fullHeight) /2);
    CGContextAddLineToPoint(context, self.bounds.size.width, (height + fullHeight) /2);
    [[UIColor blackColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
       i = firstPointToWrite;
    NSDate* firstTime = [[_speedDataSet objectAtIndex:0] time];
     CGContextSetLineWidth(context, 1);
    int every5Seconds = 0;
    while (++i < _speedDataSet.count)
    {
         widthPoint = (i * scaledPointsPerEntry)-_panOffset;
        CGPoint point;
        point.x = widthPoint;
        point.y = (height + fullHeight )/2;
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, widthPoint, height);
        CGContextAddLineToPoint(context, widthPoint, (height + fullHeight )/2);
        NSDate* timeNow = [[_speedDataSet objectAtIndex:i] time];
        if (every5Seconds++ % 5 ==0)
        {
        [[NSString stringWithFormat:@"%i", (int)[timeNow timeIntervalSinceDate:firstTime] ] drawAtPoint:point withFont:[UIFont systemFontOfSize:12] ];
        }
              
        CGContextDrawPath(context, kCGPathStroke);
    }
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, yaxisOffset,0);
    CGContextAddLineToPoint(context, yaxisOffset, height);
    CGContextDrawPath(context, kCGPathStroke);
    CGPoint point = CGPointMake(yaxisOffset, 0);
    
    point.y = height - height*( [[(SpeedData*)[self.speedDataSet objectAtIndex:speedEntry] speed] floatValue]-_minSpeed)/(_maxSpeed-_minSpeed);

    [[UIColor greenColor] setFill];
    [[NSString stringWithFormat:@"%@",  [[RunTrainerShared instance] formatSpeed:[[(SpeedData*)[_speedDataSet objectAtIndex:speedEntry ] speed] floatValue]] ] drawAtPoint:point withFont:[UIFont systemFontOfSize:12] ];
     
      point.y = height - height*( [[[self.speedDataSet objectAtIndex:speedEntry] alt] floatValue]-_minAlt)/(_maxAlt-_minAlt);
    [[UIColor redColor] setFill];
     [[NSString stringWithFormat:@"%.0f m", [[[_speedDataSet objectAtIndex:speedEntry ] alt] floatValue]] drawAtPoint:point withFont:[UIFont systemFontOfSize:12] ];


   
}


- (IBAction)pinchSent:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateEnded )
    {
        self.scale *=  sender.scale;
        self.panOffset *= sender.scale;
        [sender setScale:1.0];
        [self setNeedsDisplay];
    }
    
}
- (IBAction)panDone:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged ||sender.state == UIGestureRecognizerStateEnded)
    {
        
        CGPoint point=  [sender translationInView:self];
        self.panOffset += -point.x;
        point.x = point.y =0;
        
        [sender setTranslation:point inView:self];
        [self setNeedsDisplay];
        
    }
   }

@end
