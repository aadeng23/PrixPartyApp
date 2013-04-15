//
//  Event.m
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "Event.h"
@class EventsDataController;

@implementation Event

-(id)initWithBasics:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate store:(EKEventStore *)store{
    
    self = [super init];
    if (self) {
        _eventBasic = [EKEvent eventWithEventStore:store];
        _eventBasic.title = name;
        _eventBasic.startDate = startDate;
        _eventBasic.endDate = endDate;
        
        return self;
    }
    return nil;
}

-(id)initWithParams:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate store:(EKEventStore *)store description:(NSString *)description  admission:(double)admission location:(CLLocation *)location tags:(NSMutableArray *)tags{
    
    self = [super init];
    if (self) {
        
        _eventBasic = [EKEvent eventWithEventStore:store];
        _eventBasic.title = name;
        _eventBasic.startDate = startDate;
        _eventBasic.endDate = endDate;
        
        _eventDescription = description;
        _eventAdmission = admission;
        _eventLocation = location;
        _eventTags = tags;
        _favorite = NO;
        
        return self;
    }
    return nil;
}


-(void)setDateWithString:(NSString *)startDateString endDate:(NSString *)endDateString{
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    NSDate *startDate= [dateFormater dateFromString:startDateString];
    NSDate *endDate = [dateFormater dateFromString:endDateString];
    _eventBasic.startDate = startDate;
    _eventBasic.endDate = endDate;
}



-(Event *)convertFromDictionary:(NSDictionary *)dic{
    /*
    _eventBasic.title = name;
    _eventBasic.startDate = startDate;
    _eventBasic.endDate = endDate;
    
    _eventDescription = description;
    _eventAdmission = admission;
    _eventLocation = location;
    _eventTags = tags;
    _favorite = NO;*/
}

@end
