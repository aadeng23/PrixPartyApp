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

- (NSUInteger)sizeOfList;
- (Event *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addEvent:(Event *)event;
- (void)addEventTest;
- (void)addToFavorites:(Event *)event;
- (void)removeFromFavorites:(Event *)event;

@end
