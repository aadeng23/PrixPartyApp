//
//  EventsMapViewController.h
//  PrixParty
//
//  Created by Angela Deng on 2/24/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "EventsMapView.h"

@interface EventsMapViewController : UIViewController
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet EventsMapView *mapView;

@end
