//
//  Event.m
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "Event.h"
#import "PrixPartyAppDelegate.h"

@class EventsDataController;

@interface Event ()
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geopoint;

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *description;

//r Redefine these properties to make them read/write for internal class accesses and mutations.
//r: do


//end variables
@end

@implementation Event
//r: synthesize all
@synthesize coordinate;
@synthesize eventName;
@synthesize description;

@synthesize object;
@synthesize geopoint;
@synthesize animatesDrop;
@synthesize pinColor;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle {
	self = [super init];
	if (self) {
		self.coordinate = aCoordinate;
		self.eventName = aTitle;
		self.description = aSubtitle;
		
        //r
        //self.animatesDrop = NO;
	}
	return self;
}


- (id)initWithPFObject:(PFObject *)anObject {
	self.object = anObject;
	self.geopoint = [anObject objectForKey:kPPParseLocationKey];
//	self.user = [anObject objectForKey:kPAWParseUserKey];
    
	[anObject fetchIfNeeded];
	CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
	NSString *aTitle = [anObject objectForKey:kPPParseEventNameKey];
	NSString *aSubtitle = [anObject objectForKey:kPPParseEventDescKey];
    
    return [self initWithCoordinate:aCoordinate andTitle:aTitle andSubtitle:aSubtitle];
}


- (BOOL)equalToPost:(Event *)aPost {
    NSLog(@"equalToPost called");
	if (aPost == nil) {
		return NO;
	}
    
	if (aPost.object && self.object) {
        NSLog(@"For event %@ we got 1", self.eventName);
		// We have a PFObject inside the PAWPost, use that instead.
		if ([aPost.object.objectId compare:self.object.objectId] != NSOrderedSame) {
			return NO;
		}
		return YES;
	} else {
        NSLog(@"For event %@ we got 2", self.eventName);
		// Fallback code:
        
		if ([aPost.eventName    compare:self.eventName]    != NSOrderedSame ||
			[aPost.description compare:self.description] != NSOrderedSame ||
			aPost.coordinate.latitude  != self.coordinate.latitude ||
			aPost.coordinate.longitude != self.coordinate.longitude ) {
			return NO;
		}
        
		return YES;
	}
}



@end

