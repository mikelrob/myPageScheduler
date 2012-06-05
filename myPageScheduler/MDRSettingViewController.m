//
//  MDRSettingViewController.m
//  myPageScheduler
//
//  Created by Michael Robinson on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MDRSettingViewController.h"
#import "MDREventsViewController.h"
#import "MDRTextSettingCell.h"

@interface MDRSettingViewController ()

@end

@implementation MDRSettingViewController

@synthesize settings = _settings;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//- (void)viewWillAppear:(BOOL)animated{
//    [theTableView reloadData];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCalendarChooser"]) {
        
    }
}

#pragma mark - IBAction Methods


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.settings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    MDRSetting *setting = [self.settings settingAtIndex:indexPath.row];    
    //configure cell as per setting requirement
    switch ([self.settings settingTypeAtIndex:indexPath.row]) {
        case kTextType:{
            MDRTextSettingCell *textSettingCell = [tableView dequeueReusableCellWithIdentifier:@"TextSettingCell"];
            if (textSettingCell == nil) {
                textSettingCell = [[MDRTextSettingCell alloc] initWithStyle:0 reuseIdentifier:@"TextSettingCell"];
            }
            textSettingCell.textSettingLabel.text = setting.settingName;
            textSettingCell.textSetting.text = setting.setting;
            textSettingCell.textSetting.delegate = self;
            textSettingCell.textSetting.key = setting.key;
            cell = textSettingCell;
            break;
        }
            
        case kCalendarType:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarSettingCell"];
            cell.detailTextLabel.text = setting.setting;
            cell.textLabel.text = setting.settingName;
            
            break;
        }
        case kBoolType:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"BoolCell"];
            cell.textLabel.text = setting.settingName;
            if ([setting.setting boolValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        }
            
        default:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"NullCell"];
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch ([self.settings settingTypeAtIndex:indexPath.row]) {
        case kTextType:{
//            //pass firstresponder onto textlabel
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            UITextField *textField = (UITextField *)[cell viewWithTag:1];
//            [textField becomeFirstResponder];
            break;
        }
        case kCalendarType:{
            //if calendar type selected push a calendar chooser 
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            EKCalendarChooser *cc =
                [[EKCalendarChooser alloc] initWithSelectionStyle:EKCalendarChooserSelectionStyleSingle 
                                                     displayStyle:EKCalendarChooserDisplayWritableCalendarsOnly 
                                                       eventStore:eventStore];
            cc.delegate = self;
            cc.showsCancelButton = NO;
            cc.showsDoneButton = NO;
            [self.navigationController pushViewController:cc animated:YES];
            break;
        }
        case kBoolType:{
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.accessoryType == UITableViewCellAccessoryNone) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.settings setDisplaysOnDaysOff:TRUE];
            }else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [self.settings setDisplaysOnDaysOff:FALSE];
            }
            
            break;
        }
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    MDRSetting *setting = [settings settingAtIndex:indexPath.row];
//    cell.detailTextLabel.text = setting.setting;
//    
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark - EKCalendarChooser Delegate Methods

- (void)calendarChooserSelectionDidChange:(EKCalendarChooser *)calendarChooser{
    EKCalendar *calendar = [calendarChooser.selectedCalendars anyObject];
    NSLog(@"calendar selected: %@", calendar.title);
    [self.settings setCalendarTitle:calendar.title];
    [theTableView reloadData];
    
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(MDRTextField *)textField{
    NSLog(@"%@", textField.text);
    NSLog(@"%@", textField.key);
    
    //select setting to save as per key
    if ([textField.key caseInsensitiveCompare:kMDREventTitleKey] == NSOrderedSame) {
        [self.settings setEventName:textField.text];
    } else if ([textField.key caseInsensitiveCompare:kMDREventLocationKey] == NSOrderedSame) {
        [self.settings setEventLocation:textField.text];
    }
    
    [theTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

@end
