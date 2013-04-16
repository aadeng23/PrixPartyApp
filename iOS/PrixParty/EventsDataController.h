//
//  EventsDataController.h
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import <EventKit/EventKit.h>

@interface EventsDataController : NSObject 

@property (nonatomic,copy) NSMutableArray *eventsList;
@property (nonatomic) NSCalendar *eventsCalendar;
@property (nonatomic) EKEventStore *eventsStore;

@property (nonatomic, strong) NSMutableArray *postsToRemove;
@property (nonatomic, strong) NSMutableArray *postsThatAreNew;

- (NSUInteger)sizeOfList;
- (Event *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addEvent:(Event *)event;
- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance;
- (void)updatePostsForLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy) nearbyDistance;
- (void) viewDealloc;


//- (void)sortListByDate;
/// sort by date/time, sort by location, sort by price, sort by tags

@end
