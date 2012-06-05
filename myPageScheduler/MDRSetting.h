//
//  MDRSetting.h
//  myPageScheduler
//
//  Created by Michael Robinson on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kTextType,
    kCalendarType,
    kBoolType
} MDRSettingType;

@interface MDRSetting : NSObject {
//    MDRSettingType settingType;
//    id setting;
}

@property (nonatomic) MDRSettingType settingType;
@property (strong, nonatomic) NSString *settingName;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) id setting;

@end
