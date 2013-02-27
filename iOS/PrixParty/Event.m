//
//  Event.m
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id)initWithName:(NSString *)name description:(NSString *)description date:(NSDate *)date admission:(double)admission location:(CLLocation *)location{
    
    self = [super init];
    if (self) {
        
        _eventName = name;
        _eventDescription = description;
        _eventDate = date;
        _eventAdmission = admission;
        _eventLocation = location;
        
        return self;
    }
    return nil;
}


@end
