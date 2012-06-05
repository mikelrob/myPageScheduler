//
//  WorkEvent.h
//  myPageScheduler
//
//  Created by Michael Robinson on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WorkEvent : NSManagedObject

@property (nonatomic, retain) NSNumber * allDay;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * location;

@end
