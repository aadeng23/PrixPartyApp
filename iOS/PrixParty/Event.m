//
//  Event.m
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id)initWithName:(NSString *)name description:(NSString *)description date:(NSDateComponents *)date admission:(double)admission location:(CLLocation *)location tags:(NSString *)tags favorite:(BOOL)favorite{
    
    self = [super init];
    if (self) {
        
        _eventName = name;
        _eventDescription = description;
        _eventDate = date;
        _eventAdmission = admission;
        _eventLocation = location;
        _eventTags = tags;
        _favorite = favorite;
        
        return self;
    }
    return nil;
}


@end
