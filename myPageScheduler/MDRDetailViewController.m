//
//  MDRDetailViewController.m
//  myPageScheduler
//
//  Created by Michael Robinson on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "MDRDetailViewController.h"
#import "MDRSettingsStore.h"
#import "WorkEvent.h"
#import "MDRWorkEventCell.h"

@interface MDRDetailViewController ()

@end

@implementation MDRDetailViewController

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
    EKCalendar *calendar = [theEventStore calendarWithIdentifier:calendarNameString];
    
    for (WorkEvent *workEvent in self.eventsArray) {
        EKEvent *calendarEvent = [[EKEvent alloc] init];
        calendarEvent.title = [self.settings eventName];
        calendarEvent.location = [self.settings eventLocation];
        calendarEvent.calendar = calendar;
        NSError *error;
        [theEventStore saveEvent:calendarEvent span:EKSpanThisEvent commit:YES error:&error];
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

@end
