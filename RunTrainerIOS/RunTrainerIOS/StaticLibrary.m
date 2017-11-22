//
//  StaticLibrary.m
//  RunTrainerIOS
//
//  Created by jarek on 27.12.2012.
//
//

#import "StaticLibrary.h"
#import <QuartzCore/QuartzCore.h>

@implementation StaticLibrary
+(void)roundCorners:(UIView*)view
{
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 1.5;
    view.layer.cornerRadius = 8;

}
+(void)gradient:(UIView*)view
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [view.layer addSublayer:gradient ];
}
@end
