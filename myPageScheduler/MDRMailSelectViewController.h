//
//  MDRMailSelectViewController.h
//  myPageScheduler
//
//  Created by Michael Robinson on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MDRMailSelectViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
}

@property (strong, nonatomic)IBOutlet UIButton *reportBugButton;
@property (strong, nonatomic)IBOutlet UIButton *featureRequestButton;
@property (strong, nonatomic)IBOutlet UIButton *otherButton;

- (IBAction)reportBugButtonPressed:(id)sender;
- (IBAction)featureRequestButtonPressed:(id)sender;
- (IBAction)otherButtonPressed:(id)sender;

@end
