//
//  MDRTextSettingCell.h
//  myPageScheduler
//
//  Created by Michael Robinson on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRTextField.h"

@interface MDRTextSettingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *textSettingLabel;
@property (strong, nonatomic) IBOutlet MDRTextField *textSetting;

@end
