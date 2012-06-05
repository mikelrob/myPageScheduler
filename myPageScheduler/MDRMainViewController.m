//
//  MDRMainViewController.m
//  myPageScheduler
//
//  Created by Michael Robinson on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MDRMainViewController.h"
#import "MDRAppDelegate.h"
#import "MDRSettingViewController.h"
#import "WorkEvent.h"
#import "MDREventsViewController.h"

@interface MDRMainViewController ()

@end

@implementation MDRMainViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize settings = _settings;
@synthesize theWebView;

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
    self.managedObjectContext = ((MDRAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSURL *url = [NSURL URLWithString: //@"http://mikels-macbook-air.local/~mikelrob/kronosschedule.html"];
                                        @"http://mypage.apple.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [theWebView loadRequest:request];
    self.navigationItem.title = @"myPage";
    _settings = [[MDRSettingsStore alloc] init];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier caseInsensitiveCompare:@"showSettings"] == NSOrderedSame) {
        //prepare for settings segue
        MDRSettingViewController *settingsViewController = segue.destinationViewController;
        settingsViewController.settings = self.settings;
    } else if ([segue.identifier caseInsensitiveCompare:@"showWorkEvents"] == NSOrderedSame) {
        MDREventsViewController *workEventsDetailViewController = segue.destinationViewController;
        workEventsDetailViewController.eventsArray = [NSArray arrayWithArray:events];
        workEventsDetailViewController.settings = self.settings;
    } else if ([segue.identifier caseInsensitiveCompare:@"showHelp"] == NSOrderedSame) {

    }
    
}

#pragma mark - IBAction Methods

- (void)exportButtonPressed:(id)sender{
    
    //get week data
    NSRange dateStringRange = [webContentString rangeOfString:@"schedule begins" options:NSBackwardsSearch || NSCaseInsensitiveSearch];
    //found location now go to end of that string
    dateStringRange.location += dateStringRange.length;
    //set length to get date in form LLL 00, 0000
    dateStringRange.length = 15;
    NSString *dateString = [webContentString substringWithRange:dateStringRange];
    
    NSArray *monthNameArray = [NSArray arrayWithObjects: @"months", @"jan", @"feb", @"mar", @"apr", @"may", @"jun", @"jul", @"aug", @"sep", @"oct", @"nov", @"dec", nil ];
    NSRange monthRange = {NSNotFound,0};
    int dateMonth = 0;
    while (monthRange.location == NSNotFound && dateMonth < [monthNameArray count]) { //keep searching until found or end of array
        monthRange = [dateString rangeOfString:[monthNameArray objectAtIndex:++dateMonth]
                                       options:NSCaseInsensitiveSearch];
    }
    
//    NSLog(@"Month selected %@ - %i", [monthNameArray objectAtIndex:dateMonth], dateMonth);
    
    NSScanner *dateScanner = [NSScanner scannerWithString:dateString];
    //    NSLog(@"%@", [scanner string]);
    [dateScanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int dateDay = 0;
//    BOOL dayDetected = 
    [dateScanner scanInt:&dateDay];
    [dateScanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int dateYear = 0;
//    BOOL yearDetected = 
    [dateScanner scanInt:&dateYear];
    
//    NSLog(@"Day scanned - %@, Year scanned - %@",dayDetected ? @"Yes" : @"No", yearDetected ? @"Yes" : @"No");

    //get schedule data
    NSArray *dayNameArray = [NSArray arrayWithObjects:@"saturday", @"sunday", @"monday", @"tuesday", @"wednesday", @"thursday", @"friday", nil];
    events = [[NSMutableArray alloc] initWithCapacity:[dayNameArray count]];
    NSString *entityName = [[WorkEvent class] description];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName 
                                              inManagedObjectContext:self.managedObjectContext];
    //get data ready for creating date from date components
    NSDateComponents *startDate = [[NSDateComponents alloc] init];
    NSDateComponents *endDate = [[NSDateComponents alloc] init];
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [userCalendar timeZone];
    
    //set up scanner to extract schedule data
    NSString *tempString = [webContentString substringFromIndex:dateStringRange.location + dateStringRange.length];
    NSRange tempRange = [tempString rangeOfString:@"</table>" 
                                                      options:NSCaseInsensitiveSearch];
    NSString *scheduleString = [tempString substringFromIndex:tempRange.location + tempRange.length];
    NSRange endOfTableRange = [scheduleString rangeOfString:@"</table>"
                                                    options:NSCaseInsensitiveSearch];
    NSRange scannerStringRange = {0, endOfTableRange.location};
    NSScanner *scheduleScanner = [NSScanner scannerWithString:[scheduleString substringWithRange:scannerStringRange]];
    [scheduleScanner setCaseSensitive:NO];
    
//    NSLog(@"%@",[scheduleScanner string]);
    
    for (int i = 0; i < [dayNameArray count]; i++) {
        WorkEvent *newWorkEvent = [[WorkEvent alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        newWorkEvent.name = [self.settings eventName];
        if ([self.settings eventLocation]) {
            newWorkEvent.location = [self.settings eventLocation];
        }
        
        //check if Time Away
        BOOL scanSuccess = false;
        scanSuccess = [scheduleScanner scanUpToString:[dayNameArray objectAtIndex:i] intoString:NULL];
        if (scanSuccess) {
            NSRange scanRange = {[scheduleScanner scanLocation], 100};
            NSRange timeAwayRange = [scheduleString rangeOfString:@"Time Away" 
                                                      options:NSCaseInsensitiveSearch 
                                                        range:scanRange];
            BOOL onHoliday = timeAwayRange.location != NSNotFound;
            if (onHoliday) {
                newWorkEvent.name = @"Holiday";
                newWorkEvent.location = @"";
                newWorkEvent.allDay = [NSNumber numberWithBool:TRUE];
            
            }else {
                
                //try to extract start date
                @try {
                    [scheduleScanner setScanLocation:scheduleScanner.scanLocation + 100];
                    scanSuccess = [scheduleScanner scanUpToString:@"\">" intoString:NULL];
                    if (!scanSuccess) {
                        @throw [NSException exceptionWithName:@"String scanning failed" 
                                                       reason:@"Could not detect \">"  //- ">
                                                     userInfo:nil];
                    }
                    //parse time details
                    int scannedInt = 0;
                    [scheduleScanner setScanLocation:scheduleScanner.scanLocation + 2]; //move past the ">
                    scanSuccess = [scheduleScanner scanInt:&scannedInt];
//                    NSLog(@"%@", [[scheduleScanner string] substringFromIndex:[scheduleScanner scanLocation]]);
                    if (!scanSuccess){
                        @throw [NSException exceptionWithName:@"String scanning failed" 
                                                       reason:@"Could not scan integer value"
                                                     userInfo:nil];
                    }
                    startDate.hour = scannedInt;
                    [scheduleScanner setScanLocation:scheduleScanner.scanLocation + 1];
                    scanSuccess = [scheduleScanner scanInt:&scannedInt];
//                    NSRange logRange = {[scheduleScanner scanLocation], 30};
//                    NSLog(@"%@",[[scheduleScanner string] substringWithRange:logRange]);
                    if (!scanSuccess) {
                        @throw [NSException exceptionWithName:@"String scanning failed" 
                                                       reason:@"Could not scan integer value"
                                                     userInfo:nil];
                    }
                    startDate.minute = scannedInt;
                    NSString *meridiemString;
                    scanSuccess = [scheduleScanner scanUpToString:@"</td>" intoString:&meridiemString];
                    if (!scanSuccess) {
                        @throw [NSException exceptionWithName:@"String scanning failed"
                                                       reason:@"Could not scan meridian value"
                                                     userInfo:nil];
                    }
                    if ([meridiemString caseInsensitiveCompare:@"pm"] == NSOrderedSame && startDate.hour != 12) {
                        startDate.hour = startDate.hour + 12;
                    }
                    startDate.timeZone = timeZone;
                }
                @catch (NSException *exception) {
                    //handle exception condition
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:exception.name
                                                                    message:exception.reason
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Ok", nil];
                    [alert show];
                    break;
                    
                }
                @finally {
                    //clean up if necessary
                }
                
                //try to extract end date
                @try {
                    scanSuccess = [scheduleScanner scanUpToString:@"\">" intoString:nil];
                    if (!scanSuccess) {
                        @throw [NSException exceptionWithName:@"String scanning failed" 
                                                       reason:@"Could not detect \">"  //- ">
                                                     userInfo:nil];
                    }
                    
//                    NSRange logRange = {[scheduleScanner scanLocation], 300};
//                    NSLog(@"%@",[[scheduleScanner string] substringWithRange:logRange]);
                    [scheduleScanner setScanLocation:scheduleScanner.scanLocation + 2];
                    scanSuccess = [scheduleScanner scanUpToString:@"\">" intoString:nil];
                    if (!scanSuccess) {
                        @throw [NSException exceptionWithName:@"String scanning failed" 
                                                       reason:@"Could not detect \">"  //- ">
                                                     userInfo:nil];
                    }
                    [scheduleScanner setScanLocation:scheduleScanner.scanLocation + 2];
                    int scannedInt = 0;
                    scanSuccess = [scheduleScanner scanInt:&scannedInt];
                    if (!scanSuccess) {
                        @throw [NSException exceptionWithName:@"String scanning failed" 
                                                       reason:@"Could not scan integer value"  //- ">
                                                     userInfo:nil];
                    }
                    endDate.hour = scannedInt;
                    [scheduleScanner setScanLocation:scheduleScanner.scanLocation + 1];
                    scanSuccess = [scheduleScanner scanInt:&scannedInt];
                    if (!scanSuccess) {
                        @throw [NSException exceptionWithName:@"String scanning failed" 
                                                       reason:@"Could not scan integer value"  //- ">
                                                     userInfo:nil];
                    }
                    endDate.minute = scannedInt;
                    NSString *meridiemString;
                    scanSuccess = [scheduleScanner scanUpToString:@"</td>" intoString:&meridiemString];
                    if ([meridiemString caseInsensitiveCompare:@"pm"] == NSOrderedSame && endDate.hour != 12) {
                        endDate.hour = endDate.hour + 12;
                    }
                    endDate.timeZone = timeZone;
                }
                @catch (NSException *exception) {
                    //handle exception condition
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:exception.name
                                                                    message:exception.reason
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Ok", nil];
                    [alert show];
                    break;
                }
                @finally {
                    //clean up if necessary
                }
                startDate.day = endDate.day = dateDay + i;
                startDate.month = endDate.month = dateMonth;
                startDate.year = endDate.year = dateYear;
                newWorkEvent.startDate = [userCalendar dateFromComponents:startDate];                
                newWorkEvent.endDate = [userCalendar dateFromComponents:endDate];
            }
        }
        
        [events insertObject:newWorkEvent atIndex:i];
    }
    
    [self performSegueWithIdentifier:@"showWorkEvents" sender:self];
    
}

- (void)settingsButtonPressed:(id)sender{
//    MDRSettingViewController *vc = [[MDRSettingViewController alloc] init];
//    vc.managedObjectContext = self.managedObjectContext;
    [self performSegueWithIdentifier:@"showSettings" sender:self];
    
}

#pragma mark - Custom Accessors

- (MDRSettingsStore *)settings{
    if (_settings == nil) {
        _settings = [[MDRSettingsStore alloc] init];
    }
    return _settings;
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    exportButton.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSRange rangeOfKronosSchedule = [webView.request.URL.absoluteString rangeOfString:@"kronosSchedule" options:NSCaseInsensitiveSearch];
    if (rangeOfKronosSchedule.location != NSNotFound) {
        exportButton.enabled = YES;
        webContentString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
