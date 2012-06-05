//
//  MDREventsViewController.h
//  myPageScheduler
//
//  Created by Michael Robinson on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRSettingsStore.h"

@interface MDREventsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
//    IBOutlet UITableView *theTableView;
}

@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) MDRSettingsStore *settings;

//@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)saveButtonPressed:(id)sender;

@end
