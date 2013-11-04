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
#import "MDRAppDelegate.h"

@interface MDREventsViewController ()

@end

@implementation MDREventsViewController

@synthesize eventsArray = _eventsArray;
@synthesize settings = _settings;
@synthesize managedObjectContext = _managedObjectContext;

//#define TESTING

#pragma mark - UIViewController Methods

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

- (void)viewWillAppear:(BOOL)animated{
//    self.navigationController.toolbarHidden = NO;
    _toolbar.hidden = YES;
#ifdef TESTING
    _toolbar.hidden = NO;
#endif
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier caseInsensitiveCompare:@"showSavedEvents"] == NSOrderedSame) {
        MDREventsViewController *savedEventsVC = segue.destinationViewController;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; 
        NSManagedObjectContext *existingEventsContext = self.managedObjectContext;/*[[NSManagedObjectContext alloc] init];
        [existingEventsContext setPersistentStoreCoordinator:self.managedObjectContext.persistentStoreCoordinator];
        savedEventsVC.managedObjectContext = existingEventsContext;
                                                                                   */
        NSString *entityName = [[WorkEvent class] description];
        fetchRequest.entity = [NSEntityDescription entityForName:entityName 
                                          inManagedObjectContext:existingEventsContext];
        WorkEvent *firstElement = [self.eventsArray objectAtIndex:0];
        WorkEvent *lastElement = [self.eventsArray objectAtIndex:6];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K >= %@ && %K =< %@",
                                  @"startDate",
                                  firstElement.startDate,
                                  @"startDate",
                                  lastElement.endDate];
        fetchRequest.predicate = predicate;
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSError *error;
        savedEventsVC.eventsArray = [existingEventsContext executeFetchRequest:fetchRequest error:&error];
        if (savedEventsVC.eventsArray == nil) {
            //process error
            NSLog(@"fetch rquest error %@", [error description]);
        }
        
    }
}

#pragma mark - IBAction Methods

- (void)saveButtonPressed:(id)sender{
    EKEventStore *theEventStore = [[EKEventStore alloc] init];
    
    [theEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        //handle access here
        if (granted) {
            NSLog(@"Access granted");
        } else {
            NSLog(@"Not granted");
        }
    }];
    NSString *calendarNameString = [self.settings calendarTitle];
    if ([calendarNameString length] == 0) {
        //alert calendar not set and break from method
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Calendar Set!"
                                                        message:@"Navigate to app settings to set calendar."
                                                       delegate:self
                                              cancelButtonTitle:nil otherButtonTitles:@"Settings", nil];
        alert.tag = 0;
        [alert show];
        
    } else {
        NSArray *calendars = [theEventStore calendarsForEntityType:EKEntityTypeEvent];
        NSMutableArray *writeableCalendars = [[NSMutableArray alloc] initWithCapacity:1];
        for (EKCalendar *prospective in calendars) {
            if ([prospective allowsContentModifications]) {
                [writeableCalendars addObject:prospective];
            }
        }
        EKCalendar *calendar;
        for (EKCalendar *prospective in calendars) {
            if ([prospective.title caseInsensitiveCompare:calendarNameString] == NSOrderedSame) {
                calendar = prospective;
                break;
            }
        }

        NSError *error;
        BOOL saveSuccess[7] = { FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE };
        int i = 0;
        for (WorkEvent *workEvent in self.eventsArray) {
            //create EKEvent and populate with workEvent properties
            EKEvent *calendarEvent = [EKEvent eventWithEventStore:theEventStore];
            //test for hols or day off
            if ([workEvent.startDate compare:workEvent.endDate] == NSOrderedSame){
                if ([workEvent.name caseInsensitiveCompare:@"Holiday"] == NSOrderedSame) {
                    calendarEvent.title = @"Holiday";
                    calendarEvent.location = nil;
                    calendarEvent.allDay = TRUE;
                    calendarEvent.calendar = calendar;
                    calendarEvent.startDate = workEvent.startDate;
                    calendarEvent.endDate = workEvent.endDate;
                } else {
                    if ([self.settings displaysOnDaysOff]) {
                        calendarEvent.title = @"Day Off";
                        calendarEvent.location = nil;
                        calendarEvent.allDay = TRUE;
                        calendarEvent.calendar = calendar;
                        calendarEvent.startDate = workEvent.startDate;
                        calendarEvent.endDate = workEvent.endDate;
                    } else {
                        saveSuccess[i++] = TRUE;
                        continue;
                    }
                }
            } else {
                calendarEvent.title = [self.settings eventName];
                calendarEvent.location = [self.settings eventLocation];
                calendarEvent.calendar = calendar;
                calendarEvent.startDate = workEvent.startDate;
                calendarEvent.endDate = workEvent.endDate;
                calendarEvent.allDay = [workEvent.allDay boolValue];
            }
            workEvent.identifier = calendarEvent.eventIdentifier;
            
            //save EKEvents to calendarStore
            saveSuccess[i++] = [theEventStore saveEvent:calendarEvent span:EKSpanThisEvent commit:YES error:&error];
            
            if (error) {
                NSLog(@"%@", error.description);
            }
            
            //check calendar for confirmation of events saved and animate 'save' text in button to √
        }//end for-in
        BOOL allSaved = TRUE;
        for (int i = 0; i < 7; i++) {
            allSaved &= saveSuccess[i];
        }
        if (allSaved) {
            //save workEvents to coredata
            NSError *errorCD;
            if ([self.managedObjectContext save:&errorCD]){
                
                if (1){ //[theEventStore commit:&error]){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Calendar Events Saved!"
                                                            message:@"Would you like to sign out?"
                                                           delegate:self 
                                                  cancelButtonTitle:@"Sign Out" 
                                                  otherButtonTitles:@"No", nil];
                    alert.tag = 1;
                    [alert show];
                } else {
                    NSLog(@"%@", error.description);

                }
            } else {
                NSLog(@"%@", errorCD.description);
            }
            //commit changes to calendar store
            
            
            
        } else {
            for (int i = 0; i < 7; i++) {
                if (saveSuccess[i] == FALSE) {
                    NSLog(@"%@ %i failed to save", [(WorkEvent *)[self.eventsArray objectAtIndex:i] name], i);
                    NSLog(@"%@", error.description);
                }
            }
        }


    }
}

- (void)viewButtonPressed:(id)sender{
    
    [self performSegueWithIdentifier:@"showSavedEvents" sender:self];

}

- (void)delButtonPressed:(id)sender{
    NSURL *storeURL = [[(MDRAppDelegate *)([UIApplication sharedApplication].delegate) applicationDocumentsDirectory] URLByAppendingPathComponent:@"myPageScheduler.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDRWorkEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkEventCell"];
    WorkEvent *event = [self.eventsArray objectAtIndex:indexPath.row];
    //configure cell
    NSLog(@"%@", [event description]);
    NSCalendar *localCalendar = [NSCalendar currentCalendar];
    NSDateComponents *startDateComponents = [localCalendar components:NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:event.startDate];
    switch ([startDateComponents weekday]) {
        case 1:
            cell.dayNameLabel.text = @"Sun";
            break;
        case 2:
            cell.dayNameLabel.text = @"Mon";
            break;
        case 3:
            cell.dayNameLabel.text = @"Tues";
            break;
        case 4:
            cell.dayNameLabel.text = @"Wed";
            break;
        case 5:
            cell.dayNameLabel.text = @"Thurs";
            break;
        case 6:
            cell.dayNameLabel.text = @"Fri";
            break;
        case 7:
            cell.dayNameLabel.text = @"Sat";
            break;
        default:
            break;
    }
    if ([event.startDate compare:event.endDate] == NSOrderedSame) {
        if ([event.name caseInsensitiveCompare:@"Holiday"] == NSOrderedSame) {
            cell.startDateLabel.text = @"Holiday";
        } else {
            cell.startDateLabel.text = @"Day Off";
        }
        cell.startDateLabel.textColor = [UIColor colorWithRed:0.220 green:0.329 blue:0.529 alpha:1.000];
        cell.toLabel.text = @"";
        cell.endDateLabel.text = @"";
    } else {
        cell.startDateLabel.text = [NSDateFormatter localizedStringFromDate:event.startDate 
                                                              dateStyle:NSDateFormatterNoStyle 
                                                              timeStyle:NSDateFormatterShortStyle];
        cell.startDateLabel.textColor = [UIColor colorWithRed:0.220 green:0.329 blue:0.529 alpha:1.000];
        cell.endDateLabel.text = [NSDateFormatter localizedStringFromDate:event.endDate
                                                            dateStyle:NSDateFormatterNoStyle
                                                            timeStyle:NSDateFormatterShortStyle];
        cell.endDateLabel.textColor = [UIColor colorWithRed:0.220 green:0.329 blue:0.529 alpha:1.000];
    }
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

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
