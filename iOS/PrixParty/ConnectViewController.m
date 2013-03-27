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

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[ConnectDataController alloc] init];
    [self.dataController updateData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:200.0f/255.0f green:22.0f/255.0f blue:22.0f/255.0f alpha:0.5f];
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    /*self.dataController.mode = @"Recent";
    [self.dataController updateData];
    [self.connectRecentTableView reloadData];
    self.dataController.mode = @"Trending";
    [self.dataController updateData];
    [self.connectTrendingTableView reloadData];*/
    
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
            [self.dataController updateData];
            [self.connectTrendingTableView reloadData];
            self.connectTrendingTableView.hidden = NO;
            self.connectRecentTableView.hidden = YES;
            
            break;
        case 1:
            self.dataController.mode = @"Recent";
            [self.dataController updateData];
            NSLog(@"ERER");
            [self.connectRecentTableView reloadData];
            self.connectRecentTableView.hidden= NO;
            self.connectTrendingTableView.hidden = YES;
            
            
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
    NSString *profname;
    NSString *tweetText;
    UIImage *userPic;
    
    if([self.dataController.mode isEqualToString:@"Trending"]){
        
        cell = [self.connectTrendingTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Tweet *tweet = [self.dataController objectInListAtIndex:self.dataController.tweetsTrendingList theIndex:indexPath.row];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        profname = tweet.profName;
        tweetText = tweet.tweetText;
        userPic = tweet.userPic;
        
    }
    else{
        
        cell = [self.connectRecentTableView dequeueReusableCellWithIdentifier:CellIdentifier];
       
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        Tweet *tweet = [self.dataController objectInListAtIndex:self.dataController.tweetsRecentList theIndex:indexPath.row];
        
        profname = tweet.profName;
        tweetText = tweet.tweetText;
        userPic = tweet.userPic;

    }
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:16.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12.0];
    
    cell.textLabel.text = profname;
    cell.detailTextLabel.text = tweetText;
    cell.imageView.image = userPic;
    return cell;
}

/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cellforRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 15) //self.array is the array of items you are displaying
    {
        NSLog(@"ASDFASF");
    }
}*/

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    // NSLog(@"offset: %f", offset.y);
    // NSLog(@"content.height: %f", size.height);
    // NSLog(@"bounds.height: %f", bounds.size.height);
    // NSLog(@"inset.top: %f", inset.top);
    // NSLog(@"inset.bottom: %f", inset.bottom);
    // NSLog(@"pos: %f of %f", y, h);
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        //NSLog(@"load more rows");
        if([self.dataController.mode isEqualToString:@"Trending"]){
            [self.dataController loadMoreData];
             //NSLog(@"counttrend %u", [self.dataController.tweetsTrendingList count]);
            [self.connectTrendingTableView reloadData];
            
        }
        else{
            [self.dataController loadMoreData];
            //NSLog(@"counttrend %u", [self.dataController.tweetsRecentList count]);
            [self.connectRecentTableView reloadData];
        }
        
    }
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
     UITableViewCell *cell;
    if([self.dataController.mode isEqualToString:@"Trending"]){
        cell = [self.connectTrendingTableView cellForRowAtIndexPath:indexPath];
    }
    else{
        cell = [self.connectRecentTableView cellForRowAtIndexPath:indexPath];
    }
   
    NSString *cellText = cell.textLabel.text;
    NSLog(@"text %@", cellText);
    UIFont *cellFont = [UIFont fontWithName:@"Avenir-Book" size:12.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
     
    return labelSize.height + 40;

}*/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


@end
