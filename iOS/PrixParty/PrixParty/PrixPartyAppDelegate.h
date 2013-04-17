//
//  PrixPartyAppDelegate.h
//  PrixParty
//
//  Created by Angela Deng on 2/24/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsViewController.h"
#import <CoreLocation/CoreLocation.h>

//r: check if this is correct
static NSString * const kPPParseEventsClassKey = @"Events";

static NSString * const kPPParseLocationKey = @"ParseLocation";
static NSString * const kPPParseEventNameKey = @"EventName";
static NSString * const kPPParseEventDescKey = @"Description";
static NSString * const kPPParseEventFriendlyLocationKey = @"FriendlyLocation";
static NSString * const kPPParseEventEntryPriceStringKey = @"EntryPriceString";

static NSUInteger const kPPWallPostsSearch = 20; // query limit for pins and tableviewcells
static double const kPPWallPostMaximumSearchDistance = 100.0;

//r: explain
static NSString * const kPPFilterDistanceChangeNotification = @"kPPFilterDistanceChangeNotification";
static NSString * const kPPLocationChangeNotification = @"kPPLocationChangeNotification";
static NSString * const kPPPostCreatedNotification = @"kPPPostCreatedNotification";
static NSString * const kPPEventDataLoadedNotification = @"kPPEventDataLoadedNotification";

//r: explain
static NSString * const kPPFilterDistanceKey = @"filterDistance";



static double const kPPFeetToMeters = 0.3048;
static double const kPPFeetToMiles = 5280.0;
static double const kPPMetersInAKilometer = 1000.0;

@interface PrixPartyAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//r
@property (nonatomic, assign) CLLocationAccuracy filterDistance;
@property (nonatomic, strong) CLLocation *currentLocation;

@end
