//
//  EventsDetailViewController.m
//  PrixParty
//
//  Created by Angela Deng on 3/10/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "EventsDetailViewController.h"
#import "Event.h"

@interface EventsDetailViewController ()
- (void)configureView;
@end

@implementation EventsDetailViewController

- (void)setEvent:(Event *) newEvent
{
    if (_event != newEvent) {
        _event = newEvent;
        // Update the view.
        
        [self configureView];
    }
    
}

- (void)configureView
{
    // Update the user interface for the detail item.
    Event *theEvent = self.event;
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
    }
    if (theEvent) {
        self.eventNameLabel.text = @"WWW"; //theEvent.eventName;
        self.eventLocationLabel.text = @"COOL"; //theEvent.eventLocation;
        self.eventDateLabel.text = @"%@ %@",[formatter stringFromDate:(NSDate *)theEvent.eventBasic.startDate],[formatter stringFromDate:(NSDate *)theEvent.eventBasic.endDate];
        self.eventAdmissionLabel.text = @"aSDFASDF"; //theEvent.eventAdmission;
        self.eventDescriptionLabel.text = theEvent.eventDescription;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
