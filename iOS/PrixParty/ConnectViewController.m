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
    recentURL = @"http://search.twitter.com/search.json?q=%40kitten";
    
    [self addChildViewController:trendingController];
    [self addChildViewController:recentController];
    
    loadInProgress = NO;
    [self loadFirstData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.connectRecentTableView.backgroundColor = [UIColor clearColor];
    self.connectTrendingTableView.backgroundColor = [UIColor clearColor];
    
    //self.tabBarItem setBac
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"plainnavigationbar.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    UIFont *font = [UIFont fontWithName:@"Futura" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.tintColor = [UIColor clearColor];
    
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

- (void)refresh:(id)sender{
    
    AFJSONRequestOperation *operationTrending;
    AFJSONRequestOperation *operationRecent;
    
    if(self.connectTrendingTableView.hidden == NO){
        
        NSURL *urlTrending = [NSURL URLWithString:trendingURL];
        NSURLRequest *requestTrending = [NSURLRequest requestWithURL:urlTrending];
        
        operationTrending = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestTrending success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [tweetsTrendingList removeAllObjects];
            id results = [JSON valueForKey:@"results"];
            [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
 
                [tweetsTrendingList addObject:[self retrieveTweetFromDataSource:obj]];
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
                
                [tweetsRecentList addObject:[self retrieveTweetFromDataSource:obj]];
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
           
            [tweetsTrendingList addObject:[self retrieveTweetFromDataSource:obj]];
        }];
        
        nextPageTrending = [JSON valueForKey:@"next_page"];
        [self.connectTrendingTableView reloadData];
        
    } failure:nil];
    
    AFJSONRequestOperation *operationRecent = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestRecent success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        id results = [JSON valueForKey:@"results"];
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            [tweetsRecentList addObject:[self retrieveTweetFromDataSource:obj]];
        }];
        
        nextPageRecent = [JSON valueForKey:@"next_page"];
        [self.connectRecentTableView reloadData];
    
    }failure:nil];
    
    [operationTrending start];
    [operationRecent start];
    
    /*Tweet *newTweet = [[Tweet alloc] init];
    newTweet.profName = @"from_user_name";
    newTweet.tweetText = @"text";
    newTweet.userName = @"from_user";
    newTweet.date = @"created_at";
    
    [tweetsRecentList addObject:newTweet];
    
    newTweet = [[Tweet alloc] init];
    newTweet.profName = @"from_user_name";
    newTweet.tweetText = @"textasdfasdfasdfaestustsutsutuasasetaaeR@#$@#$ASFASDFASFASDFASDFAW$@#$@#$@#$@#$SFAsdfasdfsfjoaekoakoeakwpfoasdofkasdokfpaskfpokawoekfapokpoksaodkfpokwepokfaposkdofakpowekfopaksdpofkpaoskofasf";
    newTweet.userName = @"from_user";
    newTweet.date = @"created_at";
    
    [tweetsRecentList addObject:newTweet];
    
    newTweet = [[Tweet alloc] init];
    newTweet.profName = @"from_user_name";
    newTweet.tweetText = @"awewerwerwerwrewwrwerwrerwrewrwerwerwerwerewrwerwerwer";
    newTweet.userName = @"from_user";
    newTweet.date = @"created_at";
    
    [tweetsRecentList addObject:newTweet];*/
   
}

- (void)loadMoreData{
    
    NSLog(@"loadrmore");
    
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
                [tweetsTrendingList addObject:[self retrieveTweetFromDataSource:obj]];
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
                
                [tweetsRecentList addObject:[self retrieveTweetFromDataSource:obj]];
            }];
            
            nextPageRecent = [JSON valueForKey:@"next_page"];
            [self.connectRecentTableView reloadData];
            loadInProgress = NO;
            [self.recentLoadIndicator stopAnimating];
            
        }failure:nil];
    }
    
    [operationRecent start];
    [operationTrending start];
    
}

- (Tweet *)retrieveTweetFromDataSource:(id) obj{

    Tweet *newTweet = [[Tweet alloc] init];
    newTweet.profName = [obj valueForKey:@"from_user_name"];
    newTweet.tweetText = [obj valueForKey:@"text"];
    newTweet.userName = [obj valueForKey:@"from_user"];
    newTweet.date = [obj valueForKey:@"created_at"];
    NSString *picURL = [obj valueForKey:@"profile_image_url"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
    newTweet.userPic = image;

    return newTweet;  
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 10;
    if((y > h + reload_distance) && !loadInProgress) {
        loadInProgress = YES;
        //[self loadMoreData];
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
        //NSLog(@"SIZE trending %u",[tweetsTrendingList count]);
        return [tweetsTrendingList count];
    }
    else{
        //NSLog(@"SIZE recent %u",[tweetsRecentList count]);
        return [tweetsRecentList count];
    }
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell;
    NSString *profname;
    NSString *tweetText;
    NSString *userName;
    NSString *date;
    UIImage *userPic;
    
    if(tableView == self.connectTrendingTableView){
        
        if(cell == nil){
            cell = [self.connectTrendingTableView dequeueReusableCellWithIdentifier:@"TweetCellTrending"];
        }
        
        Tweet *tweet = [tweetsTrendingList objectAtIndex:indexPath.row];

        profname = tweet.profName;
        userName = tweet.userName;
        date = tweet.date;
        tweetText = tweet.tweetText;
        userPic = tweet.userPic;
        
    }
    else{
        
        if(cell == nil){
            
            cell = [self.connectRecentTableView dequeueReusableCellWithIdentifier:@"TweetCellRecent"];
        }
        
        Tweet *tweet = [tweetsRecentList objectAtIndex:indexPath.row];
        
        profname = tweet.profName;
        userName = tweet.userName;
        date = tweet.date;
        tweetText = tweet.tweetText;
        userPic = tweet.userPic;

    }
    //Getting label pointers
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *profNameLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *userNameLabel = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:4];
    UILabel *tweetTextLabel = (UILabel *)[cell.contentView viewWithTag:5];
    
    //Setting fonts and sizes
    profNameLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
    profNameLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
    userNameLabel.font = [UIFont fontWithName:@"Futura" size:11.0];
    userNameLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
    dateLabel.font = [UIFont fontWithName:@"Futura" size:11.0];
    dateLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
    tweetTextLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
    tweetTextLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
    
    //Setting content
    profNameLabel.text = profname;
    NSString *atUserName = @"@";
    atUserName = [atUserName stringByAppendingString:userName];
    userNameLabel.text = atUserName;
    dateLabel.text = date;
    tweetTextLabel.text = tweetText;
    //tweetTextLabel.text = @"ASDFASFASFASDFASDFASDFASFASDFSDAF";
    
    //textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    //[textLabel sizeToFit];
    
    
   /* tweetTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tweetTextLabel.numberOfLines = 0;*/
    
    //[tweetTextLabel sizeToFit];
    CGSize constraintSize = CGSizeMake(247.0f, MAXFLOAT);

    CGSize textSize = [tweetTextLabel.text sizeWithFont:tweetTextLabel.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGRect newFrame = tweetTextLabel.frame;
    newFrame.size.height = textSize.height;
    UILabel *newTweetTextLabel = [[UILabel alloc] init];
    tweetTextLabel.frame = newFrame;
    //tweetTextLabel.text = @"ASDFASFASFASDFASDFASDFASFASDFSDAF";
    imageView.image = userPic;
    
     UILabel *tweetTextLabel2 = (UILabel *)[cell.contentView viewWithTag:5];
    
     //NSLog(@"height1 %f", tweetTextLabel2.frame.size.height);
    // NSLog(@"height2 %f", tweetTextLabel2.frame.size.height);
    
    
    /*int row = indexPath.row;
    int sectionRows = [tableView numberOfRowsInSection:1];
    UIImage *rowBackground;*/
    /*if (row == 0)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopCel01"]];
    }
    else if (row == sectionRows - 1)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BottomCel01"]];
        //selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
    }
    else
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CenterCel02"]];
        //selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
    }*/
    //((UIImageView *)cell.backgroundView).image = rowBackground;
    //((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;

   
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:rowBackground]];
    /*CGSize maximumLabelSize = CGSizeMake(247,CGFLOAT_MAX);
    
    CGSize expectedLabelSize = [tweetText sizeWithFont:textLabel.font
                                      constrainedToSize:maximumLabelSize
                                          lineBreakMode:NSLineBreakByWordWrapping];
   
    textLabel.frame = CGRectMake(0, 0, 320, expectedLabelSize.height);*/
    //textLabel.text = tweetText;
    
   // NSLog(@"line %@", textLabel.lineBreakMode);
    
    //NSLog(@"before %f", textLabel.frame.size.height);
    /*CGRect newFrame = textLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    textLabel.frame = newFrame;*/

    //NSLog(@"after %f", textLabel.frame.size.height);
    
    
    /* textLabel.attributedText = tweetText;
    CGSize maximumLabelSize = CGSizeMake(187,CGFLOAT_MAX);
    CGSize requiredSize = [textLabel sizeThatFits:maximumLabelSize];
    CGRect labelFrame = textLabel.frame;
    labelFrame.size.height = requiredSize.height;
    textLabel.frame = labelFrame;
    */
        
    
    
    /*cell.textLabel.font = [UIFont fontWithName:@"Futura" size:16.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
    
    cell.textLabel.text = profname;
    cell.detailTextLabel.text = tweetText;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.imageView.image = userPic;*/
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"regcell.png"]];
    
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
   
    //NSString *cellText = cell.detailTextLabel.text;
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:5];
    NSString *cellText = textLabel.text;    
    UIFont *cellFont = [UIFont fontWithName:@"Futura" size:12.0];
    CGSize constraintSize = CGSizeMake(247.0f, MAXFLOAT);
    //UILabel *tweetTextLabel = (UILabel *)[cell.contentView viewWithTag:5];
    
    //NSLog(@"heght %@ %f", tweetTextLabel.text ,tweetTextLabel.frame.size.height);
    
    CGSize textSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return textSize.height + 90; //tweetTextLabel.frame.size.height + 90;

}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *footer = [[UILabel alloc] init];
    footer.text = @"Loading...";
    
    return footer;
    
}*/

@end
