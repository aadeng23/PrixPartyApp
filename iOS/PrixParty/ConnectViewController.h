//
//  ConnectViewController.h
//  PrixParty
//
//  Created by Angela Deng on 3/5/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *connectTrendingTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *connectRecentTableView;
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender;

@end
