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

// Center latitude and longitude of the annotion view.
// The implementation of this property must be KVO compliant.
//nyc
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


//nyc
@property (nonatomic, readonly, copy) NSString *eventName;
@property (nonatomic, readonly, copy) NSString *description;

//parse
//nyc
// Other properties:
@property (nonatomic, readonly, strong) PFObject *object;
@property (nonatomic, readonly, strong) PFGeoPoint *geopoint;

@property (nonatomic, readonly) MKPinAnnotationColor pinColor;
@property (nonatomic, assign) BOOL animatesDrop;



- (id)initWithPFObject:(PFObject *)object;
- (BOOL)equalToPost:(Event *)aPost;

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside;

@end
