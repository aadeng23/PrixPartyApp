//
//  EventsDataController.h
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface EventsDataController : NSObject

@property (nonatomic,copy) NSMutableArray *eventsList;

- (NSUInteger)sizeOfList;
- (Event *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addEvent:(Event *)event;
- (void)addEventTest;

//- (void)sortListByDate;
/// sort by date/time, sort by location, sort by price, sort by tags

@end
