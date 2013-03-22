//
//  EventsLabelViewController.h
//  PrixParty
//
//  Created by Angela Deng on 3/10/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;

@interface EventsDetailViewController : UITableViewController

@property (strong, nonatomic) Event *event;
@property (weak, nonatomic) IBOutlet UILabel *eventNameDetail;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationDetail;
@property (weak, nonatomic) IBOutlet UILabel *eventDateDetail;
@property (weak, nonatomic) IBOutlet UILabel *eventAdmissionDetail;
@property (weak, nonatomic) IBOutlet UILabel *eventDescriptionDetail;

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventAdmissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDescriptionLabel;

@end
