//
//  EventsViewController.h
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsListTableView.h"
#import <MapKit/MapKit.h>

@interface EventsViewController : UIViewController

@property (weak, nonatomic) IBOutlet EventsListTableView *eventsListTableView;
@property (weak, nonatomic) IBOutlet MKMapView *eventsMapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender;


@end
