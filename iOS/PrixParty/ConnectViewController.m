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

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[ConnectDataController alloc] init];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.connectTrendingTableView.backgroundColor = [UIColor clearColor];
    self.connectRecentTableView.backgroundColor = [UIColor clearColor];
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.connectTrendingTableView.hidden = NO;
    self.connectRecentTableView.hidden = YES;
    
    //setup after view
    //[[self connectRecentTableView]setDelegate:self];
    //[[self connectTrendingTableView]setDelegate:self];
    
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
            self.dataController.mode = @"Trending";
            self.connectTrendingTableView.hidden = NO;
            self.connectRecentTableView.hidden = YES;
            [self.dataController updateData];
            NSLog(@"counttrend %u", [self.dataController.tweetsTrendingList count]);
            [[self connectTrendingTableView] reloadData];
            break;
        case 1:
            self.dataController.mode = @"Recent";
            self.connectTrendingTableView.hidden = YES;
            self.connectRecentTableView.hidden= NO;
            [self.dataController updateData];
             NSLog(@"countrecent %u", [self.dataController.tweetsRecentList count]);
            [[self connectRecentTableView] reloadData];
            break;
        default:
            break;
    }
}


#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if([self.dataController.mode isEqualToString:@"Trending"]){
        NSLog(@"counttrendsize %u", [self.dataController.tweetsTrendingList count]);
        return [self.dataController.tweetsTrendingList count];
        
    }
    else{
        NSLog(@"countrecentsize %u", [self.dataController.tweetsRecentList count]);
        return [self.dataController.tweetsRecentList count];
    }
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *CellIdentifier = @"TweetCell";
    UITableViewCell *cell;
    
    NSLog(@"RERER");
    if([self.dataController.mode isEqualToString:@"Trending"]){
        
        cell = [self.connectTrendingTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        Tweet *tweet = [self.dataController objectInListAtIndex:self.dataController.tweetsTrendingList theIndex:indexPath.row];
        
        NSString *username = tweet.profName;
        NSString *tweetText = tweet.tweetText;

        cell.textLabel.text = @"BOO";
        cell.detailTextLabel.text = tweetText;
    }
    else{
        
        cell = [self.connectRecentTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        Tweet *tweet = [self.dataController objectInListAtIndex:self.dataController.tweetsRecentList theIndex:indexPath.row];
        
        NSString *username = tweet.profName;
        NSString *tweetText = tweet.tweetText;
        
        cell.textLabel.text = @"HAHA";
        cell.detailTextLabel.text = tweetText;

    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


@end
