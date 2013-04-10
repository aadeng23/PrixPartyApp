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


@end
