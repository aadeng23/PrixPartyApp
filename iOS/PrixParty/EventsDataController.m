//
//  EventsDataController.m
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "EventsDataController.h"
#import "PrixPartyAppDelegate.h"
#import "PPSearchRadius.h"
#import "PPCircleView.h"

@interface EventsDataController()
@property (nonatomic, assign) BOOL mapPinsPlaced;
@property (nonatomic, strong) NSMutableArray *allPosts;

@end


@implementation EventsDataController

@synthesize allPosts;
@synthesize mapPinsPlaced;
@synthesize postsToRemove;
@synthesize postsThatAreNew;



- (id)init {
    if (self = [super init]) {
        self.eventsList = [NSMutableArray new];
        self.favoritesList = [NSMutableArray new];
        self.eventsCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        self.eventsStore = [EKEventStore new];
        manager = [MyManager sharedManager];
        return self;
    }
    return nil;
}

- (void)setEventsList:(NSMutableArray *)newList {
    if(_eventsList != newList){
        _eventsList = [newList mutableCopy];
    }
}

- (NSUInteger)sizeOfList{
    return [self.eventsList count];
}

- (Event *)objectInListAtIndex:(NSUInteger)theIndex{
    
    return [self.eventsList objectAtIndex:theIndex];
}

- (void)addEvent:(Event *)event{
    bool unique = YES;
    for (Event * temp in allPosts) {
        if ([event equalToPost:temp]) {
            NSLog(@"Event %@ found equal to %@", event.eventName, temp.eventName);
        } else {
            NSLog(@"Event %@ found NOT equal to %@", event.eventName, temp.eventName);
            unique = NO;
        }
    }
    if (unique) {
        NSLog(@"Adding event %@ because it is unique", event.eventName);
        [self.eventsList addObject:event];
    } else {
        NSLog(@"Not adding event %@ because it is a copy", event.eventName);
    }

}

- (void)addToFavorites:(Event *)event{
    
    [manager.favoritesList addObject:event];
}

- (void)removeFromFavorites:(Event *)event{
    
    [manager.favoritesList removeObjectIdenticalTo:event];
}


#pragma mark - Fetch map pins

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance {
	PFQuery *query = [PFQuery queryWithClassName:kPPParseEventsClassKey];
    
	if (currentLocation == nil) {
		NSLog(@"%s got a nil location!", __PRETTY_FUNCTION__);
        currentLocation = [[CLLocation alloc] initWithLatitude:30.274486 longitude:-97.746048];
	}
    
	// If no objects are loaded in memory, we look to the cache first to fill the table
	// and then subsequently do a query against the network.
	/*
    if ([self.allPosts count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
    */
    
	// Query for posts sort of kind of near our current location.
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:kPPParseLocationKey nearGeoPoint:point withinKilometers:kPPWallPostMaximumSearchDistance];
	//[query includeKey:kPPParseUserKey];
	query.limit = kPPWallPostsSearch;
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"error in geo query!"); // todo why is this ever happening?
		} else {
			// We need to make new post objects from objects,
			// and update allPosts and the map to reflect this new array.
			// But we don't want to remove all annotations from the mapview blindly,
			// so let's do some work to figure out what's new and what needs removing.
            
			// 1. Find genuinely new posts:
			postsThatAreNew = [[NSMutableArray alloc] initWithCapacity:kPPWallPostsSearch];
			// (Cache the objects we make for the search in step 2:)
			NSMutableArray *allNewPosts = [[NSMutableArray alloc] initWithCapacity:kPPWallPostsSearch];
			for (PFObject *object in objects) {
				Event *newPost = [[Event alloc] initWithPFObject:object];
				[allNewPosts addObject:newPost];
				BOOL found = NO;
				for (Event *currentPost in allPosts) {
					if ([newPost equalToPost:currentPost]) {
						found = YES;
					}
				}
                NSLog(@"Loop 1: Adding %@, which was %d", newPost.eventName, found);
				if (!found) {
					[postsThatAreNew addObject:newPost];
				}
			}
			// newPosts now contains our new objects.
            
			// 2. Find posts in allPosts that didn't make the cut.
			postsToRemove = [[NSMutableArray alloc] initWithCapacity:kPPWallPostsSearch];
			for (Event *currentPost in allPosts) {
				BOOL found = NO;
				// Use our object cache from the first loop to save some work.
				for (Event *allNewPost in allNewPosts) {
					if ([currentPost equalToPost:allNewPost]) {
						found = YES;
					}
				}
                 NSLog(@"Loop 1: Removing %@, which was %d", currentPost.eventName, found);
				if (!found) {
					[postsToRemove addObject:currentPost];
				}
			}
			// postsToRemove has objects that didn't come in with our new results.
            
			// 3. Configure our new posts; these are about to go onto the map.
			for (Event *newPost in postsThatAreNew) {
				CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:newPost.coordinate.latitude longitude:newPost.coordinate.longitude];
                
				// Animate all pins after the initial load:
				newPost.animatesDrop = mapPinsPlaced;
                NSLog(@"Loop 3: Configuring %@", newPost.eventName);
                [self addEvent:newPost];
			}
            
			// At this point, newAllPosts contains a new list of post objects.
			// We should add everything in newPosts to the map, remove everything in postsToRemove,
			// and add newPosts to allPosts.
            
            [allPosts addObjectsFromArray:postsThatAreNew];
			[allPosts removeObjectsInArray:postsToRemove];
            
            for (Event *newPost in allPosts) {
                NSLog(@"Title: %@", newPost.eventName);
                //[self addEvent:newPost];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kPPEventDataLoadedNotification object:self];
            
            self.mapPinsPlaced = YES;
		}
	}];
}

// When we update the search filter distance, we need to update our pins' titles to match.
- (void)updatePostsForLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy) nearbyDistance {
	for (Event *post in allPosts) {
		CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:post.coordinate.latitude longitude:post.coordinate.longitude];
		// if this post is outside the filter distance, don't show the regular callout.
        //CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
		
        //rREF: [mapView viewForAnnotation:post];
		//rREF: [(MKPinAnnotationView *) [mapView viewForAnnotation:post] setPinColor:post.pinColor];
	}
}

- (void) viewDealloc {
    self.mapPinsPlaced  = NO;
}


@end
