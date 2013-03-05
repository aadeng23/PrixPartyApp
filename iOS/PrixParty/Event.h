//
//  Event.h
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Event : NSObject

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventDescription;
@property (nonatomic) double eventAdmission;
@property (nonatomic, strong) NSDateComponents *eventDate;
@property (nonatomic, strong) CLLocation *eventLocation;
@property (nonatomic, copy) NSMutableArray *eventTags;
@property (nonatomic) BOOL favorite;

-(id)initWithName:(NSString *)name description:(NSString *)description date:(NSDateComponents *)date admission:(double)admission location:(CLLocation *)location tags:(NSMutableArray *)tags favorite:(BOOL)favorite;

@end
