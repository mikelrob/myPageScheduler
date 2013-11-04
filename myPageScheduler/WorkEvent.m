//
//  WorkEvent.m
//  myPageScheduler
//
//  Created by Michael Robinson on 15/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkEvent.h"


@implementation WorkEvent

@dynamic allDay;
@dynamic endDate;
@dynamic identifier;
@dynamic location;
@dynamic name;
@dynamic startDate;

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ %@ %@", self.name, [self.startDate description], [self.endDate description]];
}

@end
