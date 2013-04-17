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
#import "MyManager.h"

@interface EventsDataController : NSObject{
    MyManager *manager;
}

@property (nonatomic,copy) NSMutableArray *eventsList;
@property (nonatomic) NSCalendar *eventsCalendar;
@property (nonatomic) NSMutableArray *favoritesList;
@property (nonatomic) EKEventStore *eventsStore;

@property (nonatomic, strong) NSMutableArray *postsToRemove;
@property (nonatomic, strong) NSMutableArray *postsThatAreNew;

- (NSUInteger)sizeOfList;
- (Event *)objectInListAtIndex:(NSUInteger)theIndex;

// rayne
- (void)addEvent:(Event *)event;
- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance;
- (void)updatePostsForLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy) nearbyDistance;
- (void) viewDealloc;

// angela
- (void)addToFavorites:(Event *)event;
- (void)removeFromFavorites:(Event *)event;


//- (void)sortListByDate;
/// sort by date/time, sort by location, sort by price, sort by tags

@end
