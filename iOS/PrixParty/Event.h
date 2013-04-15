//
//  Event.h
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <EventKit/EventKit.h>

@interface Event : NSObject

@property (nonatomic, copy) EKEvent *eventBasic;
@property (nonatomic, copy) NSString *eventDescription;
@property (nonatomic) double eventAdmission;
@property (nonatomic, strong) CLLocation *eventLocation;
@property (nonatomic, copy) NSMutableArray *eventTags;
@property (nonatomic) BOOL favorite;

-(id)initWithBasics:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate store:(EKEventStore *)store;

-(id)initWithParams:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate store:(EKEventStore *)store description:(NSString *)description admission:(double)admission location:(CLLocation *)location tags:(NSMutableArray *)tags;

-(void)setDateWithString:(NSString *)startDateString endDate:(NSString *)endDateString;

-(NSDictionary *)convertToDictionary;

@end
