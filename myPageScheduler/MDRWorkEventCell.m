//
//  MDRWorkEventCell.m
//  myPageScheduler
//
//  Created by Michael Robinson on 27/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MDRWorkEventCell.h"

@implementation MDRWorkEventCell

@synthesize workEventNameLabel, locationLabel, startDateLabel, endDateLabel, allDayIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
