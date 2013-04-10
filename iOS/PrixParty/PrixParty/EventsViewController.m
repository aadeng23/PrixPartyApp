//
//  EventsViewController.m
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsDetailViewController.h"
#import "PrixPartyAppDelegate.h"
#import "PPSearchRadius.h"
#import "PPCircleView.h"

@interface EventsViewController ()
@property (nonatomic, strong) CLLocationManager *_locationManager;
@property (nonatomic, strong) PPSearchRadius *searchRadius;
//@property (nonatomic, strong) PPCircleView *circleView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, copy) NSString *className;
//@property (nonatomic, strong) PPWallPostsTableViewController *wallPostsTableViewController;
@property (nonatomic, assign) BOOL mapPinsPlaced;
@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;

@property (nonatomic, strong) NSMutableArray *allPosts;

@end

@implementation EventsViewController

@synthesize mapView;
@synthesize _locationManager = locationManager;
@synthesize eventsListTableView;
@synthesize allPosts;
@synthesize mapPinsPlaced;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataController = [[EventsDataController alloc] init];
        [self.dataController addEventTest];
    }
    return self;
}*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EventsDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:200.0f/255.0f green:22.0f/255.0f blue:22.0f/255.0f alpha:0.5f];
    self.eventsListTableView.backgroundColor = [UIColor clearColor];
    
    /*UIImage * targetImage = [UIImage imageNamed:@"triangles.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [targetImage drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"squares.png"]];
    
    self.eventsListTableView.hidden = NO;
    self.mapView.hidden = YES;
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];

    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(30.29079, -97.74652), MKCoordinateSpanMake(0.008516, 0.021801));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(distanceFilterDidChange:) name:kPPFilterDistanceChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kPPLocationChangeNotification object:nil];
    
    self.mapPannedSinceLocationUpdate = NO;
	[self startStandardUpdates];
    
    //r
	//PrixPartyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //[self queryForAllPostsNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
}

- (void) viewWillAppear:(BOOL) animated {
    [locationManager startUpdatingLocation];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[locationManager stopUpdatingLocation];
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[locationManager stopUpdatingLocation];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kPPFilterDistanceChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kPPLocationChangeNotification object:nil];
	
	self.mapPinsPlaced = NO; // reset this for the next time we show the map.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [self.dataController sizeOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EventCell";
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Event *eventAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    
    UIImage *rowBackground;
    //UIImage *selectionBackground;
    NSInteger sectionRows = [self.eventsListTableView numberOfRowsInSection:[indexPath section]];
    NSInteger row = [indexPath row];
    
    /*if (row == 0 && row == sectionRows - 1)
    {
        rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
        //selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
    }
    else */if (row == 0)
    {
        rowBackground = [UIImage imageNamed:@"Top_Cel.png"];
        //selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
    }
    else if (row == sectionRows - 1)
    {
        rowBackground = [UIImage imageNamed:@"BottomCel.png"];
        //selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
    }
    else
    {
        rowBackground = [UIImage imageNamed:@"CenterCel.png"];
        //selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
    }
    ((UIImageView *)cell.backgroundView).image = rowBackground;
    //((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Top_Cel.png"]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.textLabel.text = eventAtIndex.eventName;
    cell.detailTextLabel.text = eventAtIndex.description;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }*/
 

#pragma mark - Table view delegate

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     EventsDetailViewController *detailViewController = [[EventsDetailViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}*/


- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            //list view
        case 0:
            self.eventsListTableView.hidden = NO;
            self.mapView.hidden = YES;
            break;
        case 1:
            self.eventsListTableView.hidden = YES;
            self.mapView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowEventDetails"]) {
        
        EventsDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.event = [self.dataController objectInListAtIndex:[self.eventsListTableView indexPathForSelectedRow].row];
    }
}

#pragma mark - NSNotificationCenter notification handlers

- (void)distanceFilterDidChange:(NSNotification *)note {
	CLLocationAccuracy filterDistance = [[[note userInfo] objectForKey:kPPFilterDistanceKey] doubleValue];
	PrixPartyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
	if (self.searchRadius == nil) {
		self.searchRadius = [[PPSearchRadius alloc] initWithCoordinate:appDelegate.currentLocation.coordinate radius:appDelegate.filterDistance];
		[mapView addOverlay:self.searchRadius];
	} else {
		self.searchRadius.radius = appDelegate.filterDistance;
	}
    
	// Update our pins for the new filter distance:
	[self updatePostsForLocation:appDelegate.currentLocation withNearbyDistance:filterDistance];
	
	// If they panned the map since our last location update, don't recenter it.
	if (!self.mapPannedSinceLocationUpdate) {
		// Set the map's region centered on their location at 2x filterDistance
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);
        
		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = NO;
	} else {
		// Just zoom to the new search radius (or maybe don't even do that?)
		MKCoordinateRegion currentRegion = mapView.region;
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(currentRegion.center, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);
        
		BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = oldMapPannedValue;
	}
}

- (void)locationDidChange:(NSNotification *)note {
    NSLog(@"LocationDidChange!");
	PrixPartyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
	// If they panned the map since our last location update, don't recenter it.
	if (!self.mapPannedSinceLocationUpdate) {
		// Set the map's region centered on their new location at 2x filterDistance
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);
        
		BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = oldMapPannedValue;
	} // else do nothing.
    
	// If we haven't drawn the search radius on the map, initialize it.
	/*
     if (self.searchRadius == nil) {
     self.searchRadius = [[PPSearchRadius alloc] initWithCoordinate:appDelegate.currentLocation.coordinate radius:appDelegate.filterDistance];
     [mapView addOverlay:self.searchRadius];
     } else {
     self.searchRadius.coordinate = appDelegate.currentLocation.coordinate;
     }
	 */
    
	// Update the map with new pins:
	[self queryForAllPostsNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
	// And update the existing pins to reflect any changes in filter distance:
	[self updatePostsForLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
}


#pragma mark - CLLocationManagerDelegate methods and helpers

- (void)startStandardUpdates {
	if (nil == locationManager) {
		locationManager = [[CLLocationManager alloc] init];
	}
    
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
	// Set a movement threshold for new events.
	locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    
	[locationManager startUpdatingLocation];
    
	CLLocation *currentLocation = locationManager.location;
	if (currentLocation) {
		PrixPartyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		appDelegate.currentLocation = currentLocation;
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	switch (status) {
		case kCLAuthorizationStatusAuthorized:
			NSLog(@"kCLAuthorizationStatusAuthorized");
			// Re-enable the post button if it was disabled before.
			self.navigationItem.rightBarButtonItem.enabled = YES;
			[locationManager startUpdatingLocation];
			break;
		case kCLAuthorizationStatusDenied:
			NSLog(@"kCLAuthorizationStatusDenied");
        {{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PrixParty can’t access your current location.\n\nTo view nearby posts or create a post at your current location, turn on access for PrixParty to your location in the Settings app under Location Services." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
            // Disable the post button.
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }}
			break;
		case kCLAuthorizationStatusNotDetermined:
			NSLog(@"kCLAuthorizationStatusNotDetermined");
			break;
		case kCLAuthorizationStatusRestricted:
			NSLog(@"kCLAuthorizationStatusRestricted");
			break;
	}
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
	NSLog(@"%s", __PRETTY_FUNCTION__);
    
	PrixPartyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	appDelegate.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSLog(@"Error: %@", [error description]);
    
	if (error.code == kCLErrorDenied) {
		[locationManager stopUpdatingLocation];
	} else if (error.code == kCLErrorLocationUnknown) {
		// todo: retry?
		// set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
		                                                message:[error description]
		                                               delegate:nil
		                                      cancelButtonTitle:nil
		                                      otherButtonTitles:@"Ok", nil];
		[alert show];
	}
}

#pragma mark - MKMapViewDelegate methods

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	MKOverlayView *result = nil;
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	// Only display the search radius in iOS 5.1+
	if (version >= 5.1f && [overlay isKindOfClass:[PPSearchRadius class]]) {
		result = [[PPCircleView alloc] initWithSearchRadius:(PPSearchRadius *)overlay];
		[(MKOverlayPathView *)result setFillColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.2]];
		[(MKOverlayPathView *)result setStrokeColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.7]];
		[(MKOverlayPathView *)result setLineWidth:2.0];
	}
	return result;
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
	// Let the system handle user location annotations.
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
    
	static NSString *pinIdentifier = @"CustomPinAnnotation";
    
	// Handle any custom annotations.
	if ([annotation isKindOfClass:[Event class]])
	{
		// Try to dequeue an existing pin view first.
		MKPinAnnotationView *pinView = (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
        
		if (!pinView)
		{
			// If an existing pin view was not available, create one.
			pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
			                                          reuseIdentifier:pinIdentifier];
		}
		else {
			pinView.annotation = annotation;
		}
		pinView.pinColor = [(Event *)annotation pinColor];
		pinView.animatesDrop = [((Event *)annotation) animatesDrop];
        
        //r -- canShowCallout is false so that it does not attempt anontation
        // pinView.canShowCallout = YES;
		pinView.canShowCallout = NO;
        
		return pinView;
	}
    
	return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	id<MKAnnotation> annotation = [view annotation];
	if ([annotation isKindOfClass:[Event class]]) {
		Event *post = [view annotation];
        //r followup!!!
		//[eventsListTableView highlightCellForPost:post];
	} else if ([annotation isKindOfClass:[MKUserLocation class]]) {
		// Center the map on the user's current location:
		PrixPartyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);
        
		[self.mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = NO;
	}
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	id<MKAnnotation> annotation = [view annotation];
	if ([annotation isKindOfClass:[Event class]]) {
		Event *post = [view annotation];
		//r followup!
//        [wallPostsTableViewController unhighlightCellForPost:post];
	}
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	self.mapPannedSinceLocationUpdate = YES;
}


#pragma mark - Fetch map pins

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance {
    NSLog(@"This!");
	PFQuery *query = [PFQuery queryWithClassName:kPPParseEventsClassKey];
    
	if (currentLocation == nil) {
		NSLog(@"%s got a nil location!", __PRETTY_FUNCTION__);
	}
    
	// If no objects are loaded in memory, we look to the cache first to fill the table
	// and then subsequently do a query against the network.
	if ([self.allPosts count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
    
	// Query for posts sort of kind of near our current location.
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:kPPParseLocationKey nearGeoPoint:point withinKilometers:kPPWallPostMaximumSearchDistance];
	//[query includeKey:kPPParseUserKey];
	query.limit = kPPWallPostsSearch;
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"error in geo query!"); // todo why is this ever happening?
		} else {
            NSLog(@"no error!");
			// We need to make new post objects from objects,
			// and update allPosts and the map to reflect this new array.
			// But we don't want to remove all annotations from the mapview blindly,
			// so let's do some work to figure out what's new and what needs removing.
            
			// 1. Find genuinely new posts:
			NSMutableArray *newPosts = [[NSMutableArray alloc] initWithCapacity:kPPWallPostsSearch];
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
				if (!found) {
					[newPosts addObject:newPost];
				}
			}
			// newPosts now contains our new objects.
            
			// 2. Find posts in allPosts that didn't make the cut.
			NSMutableArray *postsToRemove = [[NSMutableArray alloc] initWithCapacity:kPPWallPostsSearch];
			for (Event *currentPost in allPosts) {
				BOOL found = NO;
				// Use our object cache from the first loop to save some work.
				for (Event *allNewPost in allNewPosts) {
					if ([currentPost equalToPost:allNewPost]) {
						found = YES;
					}
				}
				if (!found) {
					[postsToRemove addObject:currentPost];
				}
			}
			// postsToRemove has objects that didn't come in with our new results.
            
			// 3. Configure our new posts; these are about to go onto the map.
			for (Event *newPost in newPosts) {
				CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:newPost.coordinate.latitude longitude:newPost.coordinate.longitude];
                
				// Animate all pins after the initial load:
				newPost.animatesDrop = mapPinsPlaced;
                
                [self.dataController addEvent:newPost];
			}
            
			// At this point, newAllPosts contains a new list of post objects.
			// We should add everything in newPosts to the map, remove everything in postsToRemove,
			// and add newPosts to allPosts.
			[mapView removeAnnotations:postsToRemove];
			[mapView addAnnotations:newPosts];
			[allPosts addObjectsFromArray:newPosts];
			[allPosts removeObjectsInArray:postsToRemove];
            
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
		[mapView viewForAnnotation:post];
		[(MKPinAnnotationView *) [mapView viewForAnnotation:post] setPinColor:post.pinColor];
	}
}



@end


