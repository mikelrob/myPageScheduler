//
//  MDRWorkEventCell.h
//  myPageScheduler
//
//  Created by Michael Robinson on 27/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRIndicatorView.h"

@interface MDRWorkEventCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *workEventNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet MDRIndicatorView *allDayIndicator;

@end
