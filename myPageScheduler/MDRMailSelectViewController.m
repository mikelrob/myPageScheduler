//
//  MDRMailSelectViewController.m
//  myPageScheduler
//
//  Created by Michael Robinson on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MDRMailSelectViewController.h"

@interface MDRMailSelectViewController ()

@end

@implementation MDRMailSelectViewController

@synthesize reportBugButton = _reportBugButton, featureRequestButton = _featureRequestButton, otherButton = _otherButton;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction Methods

- (void)reportBugButtonPressed:(id)sender{
    [self sendMailWithSubject:@"Bug found in mySchedule App" andBody:@"We found a bug!..."];
}

- (void)featureRequestButtonPressed:(id)sender{
    [self sendMailWithSubject:@"I've had an idea!" andBody:@"I've been using mySchedule App and it would be really handy to have..."];
}

- (void)otherButtonPressed:(id)sender{
    [self sendMailWithSubject:nil andBody:nil];
}
     
- (void)sendMailWithSubject:(NSString *)subjectString andBody:(NSString *)msgBodyString{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    NSArray *recipientsArray = [NSArray arrayWithObject:@"mikelrob@iamprogrammer.co.uk"];
    [mailComposer setToRecipients:recipientsArray];
    [mailComposer setSubject:subjectString];
    [mailComposer setMessageBody:msgBodyString isHTML:NO];
    [mailComposer setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.tabBarController.navigationController presentModalViewController:mailComposer animated:YES];
    
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self.tabBarController.navigationController dismissModalViewControllerAnimated:YES];
}


@end
