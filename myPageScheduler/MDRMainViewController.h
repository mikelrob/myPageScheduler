//
//  MDRMainViewController.h
//  myPageScheduler
//
//  Created by Michael Robinson on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MDRSettingsStore.h"

@interface MDRMainViewController : UIViewController <UIWebViewDelegate>{
    IBOutlet UIWebView *theWebView;
    IBOutlet UIBarButtonItem *exportButton;
    NSMutableArray *events;
    NSString *webContentString;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) MDRSettingsStore *settings;
@property (strong, nonatomic) UIWebView *theWebView;

- (IBAction)exportButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;


@end
