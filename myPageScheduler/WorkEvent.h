//
//  WorkEvent.h
//  myPageScheduler
//
//  Created by Michael Robinson on 15/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WorkEvent : NSManagedObject

@property (nonatomic, strong) NSNumber * allDay;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDate * startDate;

@end
