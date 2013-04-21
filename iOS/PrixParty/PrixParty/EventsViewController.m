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

@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;

@end

@implementation EventsViewController

@synthesize mapView;
@synthesize _locationManager = locationManager;
@synthesize eventsListTableView;



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
    
    //Setting background and navigation bar
    self.view.backgroundColor = [UIColor blackColor];
    self.eventsListTableView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    //Setting segment controls
    [self.segmentedControl setImage:[UIImage imageNamed:@"listbuttonselect.png"] forSegmentAtIndex:0];
    [self.segmentedControl setImage:[UIImage imageNamed:@"mapbutton.png"] forSegmentAtIndex:1];
    [self.segmentedControl setDividerImage:[UIImage imageNamed:@"leftside_select.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    //UITabBar customization
    UIImage *tabBackground = [[UIImage imageNamed:@"home_cell.png"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tabBarController.tabBar  setBackgroundImage:tabBackground];
    [self.tabBarController.tabBar setSelectionIndicatorImage:
     [UIImage imageNamed:@"home_cell.png"]];
    
    //Show view
    self.eventsListTableView.hidden = NO;
    self.mapView.hidden = YES;
    
    //Event map view stuff
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(30.29079, -97.74652), MKCoordinateSpanMake(0.251964, 0.24522));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(distanceFilterDidChange:) name:kPPFilterDistanceChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kPPLocationChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDataDidLoad:) name: kPPEventDataLoadedNotification object:nil];
    
    self.mapPannedSinceLocationUpdate = NO;
	[self startStandardUpdates];
    
    //r
	PrixPartyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self.dataController queryForAllPostsNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPPEventDataLoadedNotification object:nil];
	
    [self.dataController viewDealloc]; // reset this for the next time we show the map.
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
    return [self.dataController sizeOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"regcell.png"]];
    
    //Setting date formatter
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    //Getting labels from cell
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *descriptionLabel = (UILabel *)[cell.contentView viewWithTag:3];
    Event *eventAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    
    //Setting label settings
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
    nameLabel.font = [UIFont fontWithName:@"Futura" size:15.0];
    nameLabel.text = eventAtIndex.eventName;
    
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
    dateLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
    //r: Enable this! as soon as date formatting is a thing
    [dateLabel setText:[eventAtIndex getFriendlyDateString]];
    
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
    descriptionLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
    
    descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    descriptionLabel.numberOfLines = 2;

    //r: these lines were found in a merge conflict but I'm not 100% what happened
    // so they are here for historical reasons, in case we need the changes.
    // but they're in Rayne's version of the file, so probably not.
    /*
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    */

    //r: the event model did change, however
    nameLabel.text = eventAtIndex.eventName;
    dateLabel.text = [eventAtIndex getFriendlyDateString];
    descriptionLabel.text = eventAtIndex.description;
    
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
            [self.segmentedControl setImage:[UIImage imageNamed:@"listbuttonselect.png"] forSegmentAtIndex:0];
            [self.segmentedControl setImage:[UIImage imageNamed:@"mapbutton.png"] forSegmentAtIndex:1];
            [self.segmentedControl setDividerImage:[UIImage imageNamed:@"leftside_select.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            self.eventsListTableView.hidden = NO;
            self.mapView.hidden = YES;
            break;
        case 1:
            [self.segmentedControl setImage:[UIImage imageNamed:@"listbutton.png"] forSegmentAtIndex:0];
            [self.segmentedControl setImage:[UIImage imageNamed:@"mapbuttonselect.png"] forSegmentAtIndex:1];
           [self.segmentedControl setDividerImage:[UIImage imageNamed:@"rightside_select.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
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
       // detailViewController.dataController = self.dataController;
        detailViewController.event = [self.dataController objectInListAtIndex:[self.eventsListTableView indexPathForSelectedRow].row];
        
        detailViewController.navBar = self.navigationController.navigationBar;
        
        UIImage *toImage = [UIImage imageNamed:@"plainnavigationbar.png"];
        [UIView transitionWithView:self.view
                          duration:10.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.navigationController.navigationBar setBackgroundImage:toImage forBarMetrics:UIBarMetricsDefault];
                        } completion:nil];
        
        //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"plainnavigationbar.png"] forBarMetrics:UIBarMetricsDefault];
        //self.navigationItem.backBarButtonItem.tintColor = [UIColor redColor];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Return" style:UIBarButtonItemStyleBordered target:nil action:nil];
        backButton.tintColor = [UIColor clearColor];
        [[self navigationItem] setBackBarButtonItem:backButton];
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
	[self.dataController updatePostsForLocation:appDelegate.currentLocation withNearbyDistance:filterDistance];
	
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
	[self.dataController queryForAllPostsNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
	// And update the existing pins to reflect any changes in filter distance:
	[self.dataController updatePostsForLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
}

- (void) eventDataDidLoad:(NSNotification *)note {
    [mapView removeAnnotations:self.dataController.postsToRemove];
    [mapView addAnnotations:self.dataController.postsThatAreNew];
    
    [eventsListTableView reloadData];
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
//	NSLog(@"%s", __PRETTY_FUNCTION__);
    
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
        
        pinView.canShowCallout = YES;
        
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        
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





@end


