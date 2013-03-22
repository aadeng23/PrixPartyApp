//
//  ConnectViewController.m
//  PrixParty
//
//  Created by Angela Deng on 3/5/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "ConnectViewController.h"

@interface ConnectViewController (){
    NSArray *tweets;
}

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
    //[self.dataController addEventTest];
    
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


#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dataController sizeOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell;
    
    if(self.connectRecentTableView.hidden == NO){
        
        static NSString *CellIdentifier = @"TweetCell";
    
        cell = [self.connectTrendingTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        NSDictionary *tweet = [tweets objectAtIndex:indexPath.row];
        NSString *text = [tweet objectForKey:@"text"];
        NSString *name = [[tweet objectForKey:@"user"] objectForKey:@"name"];

        cell.textLabel.text = text;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@", name];
    }
    else{
        
        static NSString *CellIdentifier = @"TweetCell";
        cell = [self.connectRecentTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

    }
       /* static NSString *CellIdentifier = @"TweetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }*/
  /*
    NSDictionary *tweet = [self.dataController.tweetsList objectAtIndex:indexPath.row];
    NSString *text = [tweet objectForKey:@"text"];
    NSString *name = [[tweet objectForKey:@"user"] objectForKey:@"name"];
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@", name];*/
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


@end
