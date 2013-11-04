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
        
        NSString *key = kMDREventTitleKey;
        NSString *eventTitle = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        if (eventTitle == nil) {
            eventTitle = @"Work";
        }
        MDRSetting *eventTitleSetting = [[MDRSetting alloc] init];
        eventTitleSetting.setting = eventTitle;
        eventTitleSetting.settingName = @"Event Name";
        eventTitleSetting.settingType = kTextType;
        eventTitleSetting.key = key;

        key = kMDREventLocationKey;
        NSString *eventLocation = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        MDRSetting *eventLocationSetting = [[MDRSetting alloc] init];
        eventLocationSetting.setting = eventLocation;
        eventLocationSetting.settingName = @"Event Location";
        eventLocationSetting.settingType = kTextType;
        eventLocationSetting.key = key;
        
        key = kMDRCalendarTitleKey;
        NSString *calendarTitle = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        MDRSetting *calendarTitleSetting = [[MDRSetting alloc] init];
        calendarTitleSetting.setting = calendarTitle;
        calendarTitleSetting.settingName = @"Calendar";
        calendarTitleSetting.settingType = kCalendarType;
        calendarTitleSetting.key = key;
        
        key = kMDRShowDayOffEventKey;
        NSNumber *shouldDisplay = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        MDRSetting *shouldDisplayDayOffEvent = [[MDRSetting alloc] init];
        shouldDisplayDayOffEvent.setting = shouldDisplay;
        shouldDisplayDayOffEvent.settingName = @"Show Day Off Event";
        shouldDisplayDayOffEvent.settingType = kBoolType;
        shouldDisplayDayOffEvent.key = key;
        
        //see header for index list order
        settingsStore = [[NSArray alloc] initWithObjects:calendarTitleSetting, eventTitleSetting, eventLocationSetting, shouldDisplayDayOffEvent, nil];
        
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
    [[NSUserDefaults standardUserDefaults] setValue:newEventName forKey:kMDREventTitleKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)eventName{
    MDRSetting *setting = [settingsStore objectAtIndex:kEventNameIndex];
    return setting.setting;
}

- (void)setEventLocation:(NSString *)newEventLocation{
    MDRSetting *setting = [settingsStore objectAtIndex:kEventLocationIndex];
    setting.setting = newEventLocation;
    [[NSUserDefaults standardUserDefaults] setValue:newEventLocation forKey:kMDREventLocationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)eventLocation{
    MDRSetting *setting = [settingsStore objectAtIndex:kEventLocationIndex];
    return setting.setting;
}

- (void)setCalendarTitle:(NSString *)newCalendarTitle{
    MDRSetting *setting = [settingsStore objectAtIndex:kCalendarTitleIndex];
    setting.setting = newCalendarTitle;
    [[NSUserDefaults standardUserDefaults] setValue:newCalendarTitle forKey:kMDRCalendarTitleKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)calendarTitle{
    MDRSetting *setting = [settingsStore objectAtIndex:kCalendarTitleIndex];
    return setting.setting;
}

- (void)setShowDayOffEvents:(BOOL)shouldDisplay{
    MDRSetting *setting = [settingsStore objectAtIndex:kShowDayOffEventsIndex];
    setting.setting = [NSNumber numberWithBool:shouldDisplay];
    [[NSUserDefaults standardUserDefaults] setValue:setting.setting forKey:kMDRShowDayOffEventKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)displaysOnDaysOff{
    MDRSetting *setting = [settingsStore objectAtIndex:kShowDayOffEventsIndex];
    BOOL shouldDisplay = [setting.setting boolValue];
    return shouldDisplay;
}

@end
