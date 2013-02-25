//
//  ConnectViewController.m
//  PrixParty
//
//  Created by Angela Deng on 2/24/13.
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    
    switch(sender.selectedSegmentIndex){
            //Trending
        case 0:
            self.trendingTableView.hidden = NO;
            self.photosCollectionView.hidden = YES;
            break;
            //Photos
        case 1:
            self.trendingTableView.hidden = YES;
            self.photosCollectionView.hidden = NO;
            break;
        default:
            break;
            
    }
    
}
@end
