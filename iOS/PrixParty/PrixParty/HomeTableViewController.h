//
//  HomeTableViewController.h
//  PrixParty
//
//  Created by Angela Deng on 4/13/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "MyManager.h"

@interface HomeTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIView *emptyFavsView;
@property (weak, nonatomic) IBOutlet UILabel *emptyFavsMessage;

@end
