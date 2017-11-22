//
//  SpeedChartView.h
//  RunTrainerIOS
//
//  Created by jarek on 07.09.2012.
//
//

#import <UIKit/UIKit.h>

@interface SpeedChartView : UIView

@property (strong)NSMutableArray* speedDataSet;
-(void)prepareData;
- (IBAction)pinchSent:(UIPinchGestureRecognizer *)sender;
- (IBAction)panDone:(UIPanGestureRecognizer *)sender;

@property int panOffset;
@property double scale;
@end
