//
//  ConnectViewController.m
//  PrixParty
//
//  Created by Angela Deng on 3/5/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "ConnectViewController.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.connectTrendingTableView.hidden = NO;
    self.connectRecentTableView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            //list view
        case 0:
            self.connectTrendingTableView.hidden = NO;
            self.connectRecentTableView.hidden = YES;
            break;
        case 1:
            self.connectTrendingTableView.hidden = YES;
            self.connectRecentTableView.hidden= NO;
            break;
        default:
            break;
    }
}
@end
