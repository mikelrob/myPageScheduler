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

@interface MDRSettingViewController : UITableViewController <EKCalendarChooserDelegate, UITextFieldDelegate>{
    IBOutlet UITableView *theTableView;
    NSArray *events;

}

@property (strong, nonatomic) MDRSettingsStore *settings;

@end
