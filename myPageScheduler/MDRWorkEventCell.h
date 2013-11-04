//
//  MDRWorkEventCell.h
//  myPageScheduler
//
//  Created by Michael Robinson on 27/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDRWorkEventCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dayNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;

@end
