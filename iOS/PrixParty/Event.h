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
@property (nonatomic, strong) NSDate *eventDate;
@property (nonatomic, strong) CLLocation *eventLocation;

@end
