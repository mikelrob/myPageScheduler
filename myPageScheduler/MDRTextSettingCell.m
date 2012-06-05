//
//  MDRTextSettingCell.m
//  myPageScheduler
//
//  Created by Michael Robinson on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MDRTextSettingCell.h"

@implementation MDRTextSettingCell

@synthesize textSettingLabel = _textSettingLabel;
@synthesize textSetting = _textSetting;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect frame = CGRectMake(10, 15, 130, 15);
        _textSettingLabel = [[UILabel alloc] initWithFrame:frame];
        _textSettingLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _textSettingLabel.opaque = YES;
        _textSettingLabel.backgroundColor = [UIColor clearColor];
        frame = CGRectMake(156, 12, 125, 22);
        _textSetting = [[MDRTextField alloc] initWithFrame:frame];
        _textSetting.placeholder = @"enter here";
        _textSetting.returnKeyType = UIReturnKeyDone;
        _textSetting.font = [UIFont systemFontOfSize:17.0];
        _textSetting.textColor = [UIColor colorWithRed:0.220 green:0.329 blue:0.529 alpha:1.000];
        _textSetting.textAlignment = UITextAlignmentRight;
        _textSetting.key = nil;
        _textSetting.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textSetting.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [self.contentView addSubview:_textSettingLabel];
        [self.contentView addSubview:_textSetting];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
