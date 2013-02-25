//
//  ConnectViewController.h
//  PrixParty
//
//  Created by Angela Deng on 2/24/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectPhotosCollectionView.h"
#import "ConnectTrendingTableView.h"

@interface ConnectViewController : UIViewController
@property (weak, nonatomic) IBOutlet ConnectPhotosCollectionView *photosCollectionView;
@property (weak, nonatomic) IBOutlet ConnectTrendingTableView *trendingTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentValueChanged:(id)sender;

@end
