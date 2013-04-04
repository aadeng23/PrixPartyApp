//
//  ConnectViewController.m
//  PrixParty
//
//  Created by Angela Deng on 3/5/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "ConnectViewController.h"


@interface ConnectViewController (){
    
    NSMutableData *webDataTrending;
    NSMutableData *webDataRecent;
    NSMutableArray *tweetsRecentList;
    NSMutableArray *tweetsTrendingList;
    
    NSString *trendingURL;
    NSString *recentURL;
    NSString *nextPageTrending;
    NSString *nextPageRecent;
    
    UIRefreshControl *refreshControlTrending;
    UIRefreshControl *refreshControlRecent;
    UITableViewController *trendingController;
    UITableViewController *recentController;
    BOOL loadInProgress;
    
}

@end

@implementation ConnectViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    tweetsRecentList = [[NSMutableArray alloc] init];
    tweetsTrendingList = [[NSMutableArray alloc] init];
    webDataRecent = [[NSMutableData alloc] init];
    webDataTrending = [[NSMutableData alloc] init];
    trendingController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    recentController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    
    trendingURL = @"http://search.twitter.com/search.json?q=%40twitterapi";
    recentURL = @"http://search.twitter.com/search.json?q=%40formula1";
    
    [self addChildViewController:trendingController];
    [self addChildViewController:recentController];
    
    loadInProgress = NO;
    [self loadFirstData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:200.0f/255.0f green:22.0f/255.0f blue:22.0f/255.0f alpha:0.5f];
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    trendingController.tableView = self.connectTrendingTableView;
    recentController.tableView = self.connectRecentTableView;
    
    trendingController.refreshControl = [[UIRefreshControl alloc]init];
    recentController.refreshControl = [[UIRefreshControl alloc] init];
    
    [trendingController.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [recentController.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

    self.connectRecentTableView.hidden = YES;
    self.connectTrendingTableView.hidden = NO;
    
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
            self.connectRecentTableView.hidden= NO;
            self.connectTrendingTableView.hidden = YES;
            
            break;
        default:
            break;
    }
}

- (void)refresh:(id)sender
{
    
    AFJSONRequestOperation *operationTrending;
    AFJSONRequestOperation *operationRecent;
    
    if(self.connectTrendingTableView.hidden == NO){
        
        NSURL *urlTrending = [NSURL URLWithString:trendingURL];
        NSURLRequest *requestTrending = [NSURLRequest requestWithURL:urlTrending];
        
        operationTrending = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestTrending success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [tweetsTrendingList removeAllObjects];
            id results = [JSON valueForKey:@"results"];
            [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                
                Tweet *newTweet = [[Tweet alloc] init];
                newTweet.profName = [obj valueForKey:@"from_user_name"];
                newTweet.tweetText = [obj valueForKey:@"text"];
                NSString *picURL = [obj valueForKey:@"profile_image_url"];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
                newTweet.userPic = image;
                
                [tweetsTrendingList addObject:newTweet];
            }];
            
            nextPageTrending = [JSON valueForKey:@"next_page"];
            
            [self.connectTrendingTableView reloadData];
            [(UIRefreshControl *)sender endRefreshing];
            loadInProgress = NO;
            
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [(UIRefreshControl *)sender endRefreshing];
        }];
    }
    else{
        NSURL *urlRecent = [NSURL URLWithString:recentURL];
        NSURLRequest *requestRecent = [NSURLRequest requestWithURL:urlRecent];
        
        operationRecent = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestRecent success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [tweetsRecentList removeAllObjects];
            id results = [JSON valueForKey:@"results"];
            [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                
                Tweet *newTweet = [[Tweet alloc] init];
                newTweet.profName = [obj valueForKey:@"from_user_name"];
                newTweet.tweetText = [obj valueForKey:@"text"];
                NSString *picURL = [obj valueForKey:@"profile_image_url"];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
                newTweet.userPic = image;
                
                [tweetsRecentList addObject:newTweet];
            }];
            
            nextPageRecent = [JSON valueForKey:@"next_page"];
            
            [self.connectRecentTableView reloadData];
            [(UIRefreshControl *)sender endRefreshing];
            loadInProgress = NO;
            
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [(UIRefreshControl *)sender endRefreshing];
        }];
    }
    
    [operationTrending start];
    [operationRecent start];
}

- (void)loadFirstData{
    
    NSURL *urlTrending = [NSURL URLWithString:trendingURL];
    NSURL *urlRecent = [NSURL URLWithString:recentURL];
    
    NSURLRequest *requestTrending = [NSURLRequest requestWithURL:urlTrending];
    NSURLRequest *requestRecent = [NSURLRequest requestWithURL:urlRecent];
    
    AFJSONRequestOperation *operationTrending = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestTrending success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        id results = [JSON valueForKey:@"results"];
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            Tweet *newTweet = [[Tweet alloc] init];
            newTweet.profName = [obj valueForKey:@"from_user_name"];
            newTweet.tweetText = [obj valueForKey:@"text"];
            NSString *picURL = [obj valueForKey:@"profile_image_url"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
            newTweet.userPic = image;
            
            [tweetsTrendingList addObject:newTweet];
        }];
        
        nextPageTrending = [JSON valueForKey:@"next_page"];
        [self.connectTrendingTableView reloadData];
        
    } failure:nil];
    
    AFJSONRequestOperation *operationRecent = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestRecent success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        id results = [JSON valueForKey:@"results"];
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            Tweet *newTweet = [[Tweet alloc] init];
            newTweet.profName = [obj valueForKey:@"from_user_name"];
            newTweet.tweetText = [obj valueForKey:@"text"];
            NSString *picURL = [obj valueForKey:@"profile_image_url"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
            newTweet.userPic = image;
          
            [tweetsRecentList addObject:newTweet];
        }];
        
        nextPageRecent = [JSON valueForKey:@"next_page"];
        [self.connectRecentTableView reloadData];
    
    }failure:nil];
    
    [operationTrending start];
    [operationRecent start];
}

- (void)loadMoreData{
    
    
    AFJSONRequestOperation *operationTrending;
    AFJSONRequestOperation *operationRecent;
    
    if(self.connectTrendingTableView.hidden == NO){
        
        [self.trendingLoadIndicator startAnimating];
        NSString *newURL = [NSString stringWithFormat:@"http://search.twitter.com/search.json%@",nextPageTrending];
        NSURL *url = [NSURL URLWithString:newURL];
        NSURLRequest *requestTrending = [NSURLRequest requestWithURL:url];
        
        operationTrending = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestTrending success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            id results = [JSON valueForKey:@"results"];
            [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                
                Tweet *newTweet = [[Tweet alloc] init];
                newTweet.profName = [obj valueForKey:@"from_user_name"];
                newTweet.tweetText = [obj valueForKey:@"text"];
                NSString *picURL = [obj valueForKey:@"profile_image_url"];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
                newTweet.userPic = image;
                
                [tweetsTrendingList addObject:newTweet];
            }];
            
            nextPageTrending = [JSON valueForKey:@"next_page"];
            [self.connectTrendingTableView reloadData];
            loadInProgress = NO;
            [self.trendingLoadIndicator stopAnimating];
            
        } failure:nil];
    }
    else{
        
        [self.recentLoadIndicator startAnimating];
        NSString *newURL = [NSString stringWithFormat:@"http://search.twitter.com/search.json%@",nextPageRecent];
        NSURL *url = [NSURL URLWithString:newURL];
        NSURLRequest *requestRecent = [NSURLRequest requestWithURL:url];
        
        operationRecent = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestRecent success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            id results = [JSON valueForKey:@"results"];
            [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                
                Tweet *newTweet = [[Tweet alloc] init];
                newTweet.profName = [obj valueForKey:@"from_user_name"];
                newTweet.tweetText = [obj valueForKey:@"text"];
                NSString *picURL = [obj valueForKey:@"profile_image_url"];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
                newTweet.userPic = image;
                
                [tweetsRecentList addObject:newTweet];
            }];
            
            nextPageRecent = [JSON valueForKey:@"next_page"];
            [self.connectRecentTableView reloadData];
            loadInProgress = NO;
            [self.trendingLoadIndicator stopAnimating];
            
        }failure:nil];
    }
    
    [operationTrending start];
    [operationRecent start];
}

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
    if((y > h + reload_distance) && !loadInProgress) {
        loadInProgress = YES;
        [self loadMoreData];
    }
}


#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(tableView == self.connectTrendingTableView){
        NSLog(@"SIZE %u",[tweetsTrendingList count]);
        return [tweetsTrendingList count];
    }
    else{
        return [tweetsRecentList count];
    }
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *CellIdentifier = @"TweetCell";
    UITableViewCell *cell;
    NSString *profname;
    NSString *tweetText;
    UIImage *userPic;
    
    if(tableView == self.connectTrendingTableView){
        
        if(cell == nil){
            cell = [self.connectTrendingTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        Tweet *tweet = [tweetsTrendingList objectAtIndex:indexPath.row];

        profname = tweet.profName;
        tweetText = tweet.tweetText;
        userPic = tweet.userPic;
        
    }
    else{
        
        if(cell == nil){
            cell = [self.connectRecentTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        Tweet *tweet = [tweetsRecentList objectAtIndex:indexPath.row];
        
        profname = tweet.profName;
        tweetText = tweet.tweetText;
        userPic = tweet.userPic;

    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:16.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12.0];
    
    cell.textLabel.text = profname;
    cell.detailTextLabel.text = tweetText;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.imageView.image = userPic;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if(tableView == self.connectTrendingTableView){
        cell = [self tableView:self.connectTrendingTableView cellForRowAtIndexPath:indexPath];
    }
    else{
        cell = [self tableView:self.connectRecentTableView cellForRowAtIndexPath:indexPath];
    }
   
    NSString *cellText = cell.detailTextLabel.text;
    
    UIFont *cellFont = [UIFont fontWithName:@"Avenir-Book" size:12.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
     
    return labelSize.height + 40;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *footer = [[UILabel alloc] init];
    footer.text = @"Loading...";
    
    return footer;
    
}

@end
