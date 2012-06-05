//
//  MDREventsViewController.m
//  myPageScheduler
//
//  Created by Michael Robinson on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "MDREventsViewController.h"
#import "MDRSettingsStore.h"
#import "WorkEvent.h"
#import "MDRWorkEventCell.h"
#import "MDRMainViewController.h"

@interface MDREventsViewController ()

@end

@implementation MDREventsViewController

@synthesize eventsArray;
@synthesize settings = _settings;

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.eventsArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction Methods

- (void)saveButtonPressed:(id)sender{
    EKEventStore *theEventStore = [[EKEventStore alloc] init];
    NSString *calendarNameString = [self.settings calendarTitle];
    if ([calendarNameString length] == 0) {
        //alert calendar not set and break from method
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Calendar Set!"
                                                        message:@"Navigate to app settings to set calendar."
                                                       delegate:self
                                              cancelButtonTitle:nil otherButtonTitles:@"Settings", nil];
        alert.tag = 0;
        [alert show];
        
    }else {
        NSArray *localCalendars = [theEventStore calendars];
        EKCalendar *calendar;
        for (EKCalendar *prospective in localCalendars) {
            if ([prospective.title caseInsensitiveCompare:calendarNameString] == NSOrderedSame) {
                calendar = prospective;
                break;
            }
        }

        
        for (WorkEvent *workEvent in self.eventsArray) {
            EKEvent *calendarEvent = [EKEvent eventWithEventStore:theEventStore];
            //test for day off
            if ([workEvent.startDate compare:workEvent.endDate] == NSOrderedSame 
                && !([calendarEvent.title caseInsensitiveCompare:@"Holiday"] == NSOrderedSame)) {
                if ([self.settings displaysOnDaysOff]) {
                    calendarEvent.title = @"Day Off";
                    calendarEvent.location = nil;
                    calendarEvent.allDay = TRUE;
                    calendarEvent.calendar = calendar;
                    calendarEvent.startDate = workEvent.startDate;
                    calendarEvent.endDate = workEvent.endDate;
                }
            } else {
                calendarEvent.title = [self.settings eventName];
                calendarEvent.location = [self.settings eventLocation];
                calendarEvent.calendar = calendar;
                calendarEvent.startDate = workEvent.startDate;
                calendarEvent.endDate = workEvent.endDate;
                calendarEvent.allDay = [workEvent.allDay boolValue];
            }
            
            NSError *error;
            BOOL saveSuccess = [theEventStore saveEvent:calendarEvent span:EKSpanThisEvent commit:YES error:&error];
            if (!saveSuccess) {
                NSLog(@"%@", error.description);
            }
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Would you like to sign out?"
                                                       delegate:self 
                                              cancelButtonTitle:@"Sign Out" 
                                              otherButtonTitles:@"No", nil];
        alert.tag = 1;
        [alert show];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDRWorkEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkEventCell"];
    WorkEvent *event = [self.eventsArray objectAtIndex:indexPath.row];
    //configure cell
    cell.workEventNameLabel.text = event.name;
    cell.locationLabel.text = event.location;
    cell.allDayIndicator.on = [event.allDay boolValue];
    
    cell.startDateLabel.text = [NSDateFormatter localizedStringFromDate:event.startDate 
                                                              dateStyle:NSDateFormatterShortStyle 
                                                              timeStyle:NSDateFormatterShortStyle];
    cell.endDateLabel.text = [NSDateFormatter localizedStringFromDate:event.endDate
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterShortStyle];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 0:                 //calendar not set alert
            if (buttonIndex == 0) {
                UINavigationController *navController = self.navigationController;
                [navController popViewControllerAnimated:NO];
                MDRMainViewController *mainView = [[navController viewControllers] objectAtIndex:0];
                [mainView performSegueWithIdentifier:@"showSettings" sender:self];
            }
            
            break;
            
        case 1:                 //sign out alert
            switch (buttonIndex) {
                case 0:
                {
                    //sign out
                    UINavigationController *navController = self.navigationController;
                    [navController popViewControllerAnimated:YES];
                    MDRMainViewController *mainView = (MDRMainViewController *)[[navController viewControllers] objectAtIndex:0];
                    NSURL *addressURL = [NSURL URLWithString:@"https://mypage.apple.com/myPage?logout=true"];
                    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:addressURL];
                    [mainView.theWebView loadRequest:URLRequest];
                    break;
                }
                    
                default:
                    //all others - do not sign out
                    break;
            }
            
        default:
            break;
    }

}


@end
