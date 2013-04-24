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

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geopoint;

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *friendlyLocation;
@property (nonatomic, copy) NSString *entryPriceString;

//r Redefine these properties to make them read/write for internal class accesses and mutations.
//r: do


//end variables
@end

@implementation Event
//r: synthesize all
@synthesize coordinate;
@synthesize eventName;
@synthesize description;
@synthesize friendlyLocation;
@synthesize entryPriceString;

@synthesize title;
@synthesize subtitle;

@synthesize object;
@synthesize geopoint;
@synthesize animatesDrop;
@synthesize pinColor;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate
        andTitle:(NSString *)aTitle
        andSubtitle:(NSString *)aSubtitle
        andFriendlyLocation:(NSString *)aFriendlyLocation
        andEntryPriceString:(NSString *)aEntryPriceString {
	self = [super init];
	if (self) {
		self.coordinate = aCoordinate;

		self.eventName = aTitle;
        self.title = aTitle; // Pin title
        
		self.description = aSubtitle;
        
        self.friendlyLocation = aFriendlyLocation;
        self.subtitle = aFriendlyLocation; // pin subtitle
        
        self.entryPriceString = aEntryPriceString;
        
		
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
    NSString *aFriendlyLocation = [anObject objectForKey:kPPParseEventFriendlyLocationKey];
    NSString *aEntryPriceString = [anObject objectForKey:kPPParseEventEntryPriceStringKey];
    
    return [self initWithCoordinate:aCoordinate
            andTitle:aTitle
            andSubtitle:aSubtitle
            andFriendlyLocation:aFriendlyLocation
            andEntryPriceString:aEntryPriceString];
}


- (BOOL)equalToPost:(Event *)aPost {
	if (aPost == nil) {
        NSLog(@"aPost is nil so short circuiting with NO");
		return NO;
	}
    
	if (aPost.object && self.object) {
		// We have a PFObject inside the PAWPost, use that instead.
		if ([aPost.object.objectId compare:self.object.objectId] != NSOrderedSame) {
			return NO;
		}
		return YES;
	} else {
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

-(NSString *)getFriendlyDateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    NSDate * temp = [object objectForKey:kPPParseEventStartDateKey];
    /*
     if (temp != nil) {
        NSLog(@"Event %@ has date %@", eventName, temp);
    }
     */
    return [df stringFromDate:temp];
}

-(Event *)convertFromDictionary:(NSDictionary *)dic{
    /*
    _eventBasic.title = name;
    _eventBasic.startDate = startDate;
    _eventBasic.endDate = endDate;
    
    _eventDescription = description;
    _eventAdmission = admission;
    _eventLocation = location;
    _eventTags = tags;
    _favorite = NO;*/
}

@end

