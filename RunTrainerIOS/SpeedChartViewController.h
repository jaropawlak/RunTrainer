//
//  SpeedChartViewController.h
//  RunTrainerIOS
//
//  Created by jarek on 06.09.2012.
//
//

#import <UIKit/UIKit.h>
#import "ResultLap.h"
#import "SpeedData.h"
#import "SpeedChartView.h"

@interface SpeedChartViewController : UIViewController
@property ResultLap* resultLap;


@property (weak, nonatomic) IBOutlet SpeedChartView *speedView;
@end
