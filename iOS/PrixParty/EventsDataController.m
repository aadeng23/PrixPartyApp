//
//  EventsDataController.m
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "EventsDataController.h"

@implementation EventsDataController


- (id)init {
    if (self = [super init]) {
        self.eventsList = [NSMutableArray new];
        self.eventsCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        self.eventsStore = [EKEventStore new];
        
        return self;
    }
    return nil;
}

- (void)setEventsList:(NSMutableArray *)newList {
    if(_eventsList != newList){
        _eventsList = [newList mutableCopy];
    }
}

- (NSUInteger)sizeOfList{
    return [self.eventsList count];
}

- (Event *)objectInListAtIndex:(NSUInteger)theIndex{
    
    return [self.eventsList objectAtIndex:theIndex];
}

- (void)addEvent:(Event *)event{
    
    [self.eventsList addObject:event];
}

- (void)addEventTest{
    
    NSString *title = @"Some Cool Event";
    
    NSString *startDateString = @"1999-07-13 10:45:32";
    NSString *endDateString = @"1999-08-29 11:45:32";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate= [dateFormatter dateFromString:startDateString];
    NSDate *endDate = [dateFormatter dateFromString:endDateString];
    
    NSString *description = @"this is a really cool event that everyone should come to.";
    double cost = 10.00;
    
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:-30 longitude:90];
    
    NSMutableArray *tagsList = [[NSMutableArray alloc] init];
    
    Event *testEvent = [[Event alloc] initWithParams:title startDate:startDate endDate:endDate store:self.eventsStore description:description admission:cost location:testLocation tags:tagsList];
 
    [self addEvent:testEvent];   
    
}


@end
