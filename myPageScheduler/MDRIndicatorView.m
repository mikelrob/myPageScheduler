//
//  MDRIndicatorView.m
//  myPageScheduler
//
//  Created by Michael Robinson on 19/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MDRIndicatorView.h"

@implementation MDRIndicatorView

@synthesize on = _on;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _on = FALSE;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *indicatorColor;
    if (self.on) {
        indicatorColor = [UIColor greenColor];
    } else {
        indicatorColor = [UIColor redColor];
    }
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGColorSpaceRef deviceColorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)indicatorColor.CGColor, nil];
    CGGradientRef radialGradient = CGGradientCreateWithColors(deviceColorSpace, (__bridge CFArrayRef)colors, NULL);
    CGPoint startCenter = CGPointMake( w * 0.66, h * 0.33);
    CGPoint endCenter = startCenter;
    //set clipping so not to fill the rectangular view
    CGContextBeginPath (context);
    CGContextAddArc (context, w/2.0, h/2.0, ((w>h) ? h : w)/2.0, 0.0, 2.0 * M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    CGContextDrawRadialGradient(context, radialGradient, startCenter, 2.0, endCenter, 4.0, kCGGradientDrawsAfterEndLocation);
    
}

#pragma mark Custom Accessor/Mutator
- (void)setOn:(BOOL)on{
    _on = on;
    [self setNeedsDisplay];
}

- (void)setOn{
    _on = TRUE;
    [self setNeedsDisplay];
}

- (void)setOff{
    _on = FALSE;
    [self setNeedsDisplay];
}

@end
