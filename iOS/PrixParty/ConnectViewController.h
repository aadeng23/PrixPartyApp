//
//  ConnectViewController.h
//  PrixParty
//
//  Created by Angela Deng on 3/5/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "AFJSONRequestOperation.h"


@interface ConnectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *connectTrendingTableView;
@property (weak, nonatomic) IBOutlet UITableView *connectRecentTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender;

@end
