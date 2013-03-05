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

- (void)addEvent:(Event *)sighting{
    
    [self.eventsList addObject:sighting];
}

- (void)addEventTest{
    
    NSDateComponents *testDate = [[NSDateComponents alloc] init];
    [testDate setDay:4];
    [testDate setMonth:5];
    [testDate setYear:2013];
    
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:-30 longitude:90];
    
    NSMutableArray *tagsList = [[NSMutableArray alloc] init];
    
    Event *testEvent = [[Event alloc] initWithName:@"PrixParty" description:@"A really fun party!" date:testDate admission:0.00 location:testLocation tags:tagsList favorite:false];
    
    [self addEvent:testEvent];
    
    
}


@end
