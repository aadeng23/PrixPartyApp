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
        
        EKEventStore *store = [[EKEventStore alloc] init];
        
        NSDate *today = [NSDate date]; // Get ref to todays date
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *weekdayComponents =
        [gregorian components:(NSWeekdayOrdinalCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit) fromDate:today];
        NSInteger weekday = [weekdayComponents weekday]; // Sun == 1, Mon == 2, Tue...
        NSInteger weekdayOrdinal = [weekdayComponents weekdayOrdinal]; // First weekday month == 1 etc...
        NSInteger month = [weekdayComponents month];
        NSLog (@"%i %i %i", weekday, weekdayOrdinal, month);
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
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:1965];
    [comps setMonth:1];
    [comps setDay:6];
    [comps setHour:14];
    [comps setMinute:10];
    [comps setSecond:0];
    NSCalendar *cal = [NSCalendar new];
    NSDate *date = [cal dateFromComponents:comps];
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSLog(@"print date %@", date);
    //NSString *dateString = [formatter stringFromDate:date];
    
   // NSLog(@"date %@ ASDFASDFASDFASDF",dateString);
    
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:-30 longitude:90];
    
    NSMutableArray *tagsList = [[NSMutableArray alloc] init];
    
    Event *testEvent = [[Event alloc] initWithName:@"PrixParty" description:@"A really fun party!" date:date admission:0.00 location:testLocation tags:tagsList favorite:false];
   // NSLog(@"DATE %@",testDate);
    
    [self addEvent:testEvent];
    
    
}


@end
