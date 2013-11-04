//
//  MDRSettingsStore.h
//  myPageScheduler
//
//  Created by Michael Robinson on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDRSetting.h"

//NSUserDefaults value keys
#define kMDRCalendarTitleKey        @"calendarTitle"
#define kMDREventTitleKey           @"eventTitle"
#define kMDREventLocationKey        @"eventLocation"
#define kMDRShowDayOffEventKey      @"showDayOffEvents"

typedef enum{
    kCalendarTitleIndex = 0,
    kEventNameIndex,
    kEventLocationIndex,
    kShowDayOffEventsIndex
}settingStoreIndexes;

@interface MDRSettingsStore : NSObject {
    NSArray *settingsStore;
}

- (id)settingAtIndex:(NSUInteger)index;
- (MDRSettingType)settingTypeAtIndex:(NSUInteger)index;
- (NSUInteger)count;
- (void)setEventName:(NSString *)newEventName;
- (NSString *)eventName;
- (void)setEventLocation:(NSString *)newEventLocation;
- (NSString *)eventLocation;
- (void)setCalendarTitle:(NSString *)newCalendarTitle;
- (NSString *)calendarTitle;
- (BOOL)displaysOnDaysOff;
- (void)setShowDayOffEvents:(BOOL)shouldDisplay;


@end
