//
//  MDRSettingViewController.h
//  myPageScheduler
//
//  Created by Michael Robinson on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>
#import "MDRSettingsStore.h"
#import "MDRTextSettingCell.h"

@interface MDRSettingViewController : UITableViewController <EKCalendarChooserDelegate, UITextFieldDelegate>{
//    MDRSettingsStore *settings;
    IBOutlet UITableView *theTableView;
    NSArray *events;
    MDRTextSettingCell *_tvCell;
}

@property (strong, nonatomic) MDRSettingsStore *settings;
//@property (strong, nonatomic) MDRTextSettingCell *textSetting;

- (IBAction)textFieldValueChanged:(id)sender;

@end
