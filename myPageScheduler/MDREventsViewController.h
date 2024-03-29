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
    IBOutlet UIToolbar *_toolbar;

}

@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) MDRSettingsStore *settings;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)viewButtonPressed:(id)sender;
- (IBAction)delButtonPressed:(id)sender;

@end
