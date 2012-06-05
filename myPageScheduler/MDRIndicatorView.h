//
//  MDRIndicatorView.h
//  myPageScheduler
//
//  Created by Michael Robinson on 19/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDRIndicatorView : UIView

@property(nonatomic, getter = isOn) BOOL on;

- (void)setOn;
- (void)setOff;

@end
