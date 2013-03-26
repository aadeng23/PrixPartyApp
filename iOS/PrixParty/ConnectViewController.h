//
//  ConnectViewController.h
//  PrixParty
//
//  Created by Angela Deng on 3/5/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectDataController.h"
#import "Tweet.h"

@interface ConnectViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *connectTrendingTableView;
@property (weak, nonatomic) IBOutlet UITableView *connectRecentTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) ConnectDataController *dataController;

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender;

@end
