//
//  EventsViewController.h
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EventsDataController.h"
#import "Event.h"

@interface EventsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, MKMapViewDelegate>

@property (strong, nonatomic) EventsDataController *dataController;
@property (weak, nonatomic) IBOutlet UITableView *eventsListTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


- (IBAction)segmentValueChanged:(UISegmentedControl *)sender;

@end

