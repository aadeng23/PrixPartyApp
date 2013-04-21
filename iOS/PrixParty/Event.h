//
//  Event.h
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <EventKit/EventKit.h>

@interface Event : NSObject

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@property (nonatomic, readonly, copy) NSString *eventName;
@property (nonatomic, readonly, copy) NSString *description;
@property (nonatomic, readonly, copy) NSString *friendlyLocation;
@property (nonatomic, readonly, copy) NSString *entryPriceString;
@property (nonatomic) BOOL favorite;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


// Parse Properties
@property (nonatomic, readonly, strong) PFObject *object;
@property (nonatomic, readonly, strong) PFGeoPoint *geopoint;

// Map properties
@property (nonatomic, readonly) MKPinAnnotationColor pinColor;
@property (nonatomic, assign) BOOL animatesDrop;



// Methods
- (id)initWithPFObject:(PFObject *)object;
- (BOOL)equalToPost:(Event *)aPost;
-(NSString *)getFriendlyDateString;

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside;

@end
