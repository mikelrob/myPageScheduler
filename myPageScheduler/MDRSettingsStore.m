//
//  MDRSettingsStore.m
//  myPageScheduler
//
//  Created by Michael Robinson on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MDRSettingsStore.h"

@implementation MDRSettingsStore

- (id)init{
    self = [super init];
    if (self) {
        
        NSString *key = [NSString stringWithString:kMDREventTitleKey];
        NSString *eventTitle = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        if (eventTitle == nil) {
            eventTitle = @"Work";
        }
        MDRSetting *eventTitleSetting = [[MDRSetting alloc] init];
        eventTitleSetting.setting = eventTitle;
        eventTitleSetting.settingName = @"Event Name";
        eventTitleSetting.settingType = kTextType;
        eventTitleSetting.key = key;

        key = [NSString stringWithString:kMDREventLocationKey];
        NSString *eventLocation = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        MDRSetting *eventLocationSetting = [[MDRSetting alloc] init];
        eventLocationSetting.setting = eventLocation;
        eventLocationSetting.settingName = @"Event Location";
        eventLocationSetting.settingType = kTextType;
        eventLocationSetting.key = key;
        
        key = [NSString stringWithString:kMDRCalendarTitleKey];
        NSString *calendarTitle = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        MDRSetting *calendarTitleSetting = [[MDRSetting alloc] init];
        calendarTitleSetting.setting = calendarTitle;
        calendarTitleSetting.settingName = @"Calendar";
        calendarTitleSetting.settingType = kCalendarType;
        calendarTitleSetting.key = key;
        
        key = [NSString stringWithString:kMDRDisplaysOnDaysOffKey];
        NSNumber *shouldDisplay = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        MDRSetting *shouldDisplayOnDaysOffSetting = [[MDRSetting alloc] init];
        shouldDisplayOnDaysOffSetting.setting = shouldDisplay;
        shouldDisplayOnDaysOffSetting.settingName = @"Display Event On Days Off";
        shouldDisplayOnDaysOffSetting.settingType = kBoolType;
        shouldDisplayOnDaysOffSetting.key = key;
        
        //see header for index list order
        settingsStore = [[NSArray alloc] initWithObjects:calendarTitleSetting, eventTitleSetting, eventLocationSetting, shouldDisplayOnDaysOffSetting, nil];
        
    }
    return self;
}

- (id)settingAtIndex:(NSUInteger)index{
    MDRSetting *setting = [settingsStore objectAtIndex:index];
    return setting;
}

- (MDRSettingType)settingTypeAtIndex:(NSUInteger)index{
    MDRSetting *setting = [settingsStore objectAtIndex:index];
    return setting.settingType;
}

- (NSUInteger)count{
    return [settingsStore count];
}

- (void)setEventName:(NSString *)newEventName{
    MDRSetting *setting = [settingsStore objectAtIndex:kEventNameIndex];
    setting.setting = newEventName;
    [[NSUserDefaults standardUserDefaults] setValue:newEventName forKey:@"eventTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)eventName{
    MDRSetting *setting = [settingsStore objectAtIndex:kEventNameIndex];
    return setting.setting;
}

- (void)setEventLocation:(NSString *)newEventLocation{
    MDRSetting *setting = [settingsStore objectAtIndex:kEventLocationIndex];
    setting.setting = newEventLocation;
    [[NSUserDefaults standardUserDefaults] setValue:newEventLocation forKey:@"eventLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)eventLocation{
    MDRSetting *setting = [settingsStore objectAtIndex:kEventLocationIndex];
    return setting.setting;
}

- (void)setCalendarTitle:(NSString *)newCalendarTitle{
    MDRSetting *setting = [settingsStore objectAtIndex:kCalendarTitleIndex];
    setting.setting = newCalendarTitle;
    [[NSUserDefaults standardUserDefaults] setValue:newCalendarTitle forKey:@"calendarTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)calendarTitle{
    MDRSetting *setting = [settingsStore objectAtIndex:kCalendarTitleIndex];
    return setting.setting;
}

- (void)setDisplaysOnDaysOff:(BOOL)shouldDisplay{
    MDRSetting *setting = [settingsStore objectAtIndex:kDisplaysOnDaysOffIndex];
    setting.setting = [NSNumber numberWithBool:shouldDisplay];
    [[NSUserDefaults standardUserDefaults] setValue:setting.setting forKey:@"displaysOnDaysOff"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)displaysOnDaysOff{
    MDRSetting *setting = [settingsStore objectAtIndex:kDisplaysOnDaysOffIndex];
    BOOL shouldDisplay = [setting.setting boolValue];
    return shouldDisplay;
}

@end
