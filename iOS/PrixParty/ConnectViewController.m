//
//  ConnectViewController.m
//  PrixParty
//
//  Created by Angela Deng on 3/5/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "ConnectViewController.h"
#import "PrixPartyAppDelegate.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface ConnectViewController (){
    
    NSMutableData *webDataTrending;
    NSMutableData *webDataRecent;
    NSMutableArray *tweetsRecentList;
    NSMutableArray *tweetsTrendingList;
    
    NSString *searchURL;
    NSString *nextPageTrending;
    NSString *nextPageRecent;
    NSString *refreshPageTrending;
    NSString *refreshPageRecent;
    NSString *twitterUserTimelineRequestURLBasic;
    NSString *twitterSearchRequestURLBasic;
    
    UIRefreshControl *refreshControlTrending;
    UIRefreshControl *refreshControlRecent;
    UITableViewController *trendingController;
    UITableViewController *recentController;
    BOOL recentLoadInProgress;
    BOOL trendingLoadInProgress;
    
}

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation ConnectViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _accountStore = [[ACAccountStore alloc] init];
    
    //Initializing properties
    tweetsRecentList = [[NSMutableArray alloc] init];
    tweetsTrendingList = [[NSMutableArray alloc] init];
    webDataRecent = [[NSMutableData alloc] init];
    webDataTrending = [[NSMutableData alloc] init];
    trendingController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    recentController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:trendingController];
    [self addChildViewController:recentController];
    trendingController.tableView = self.connectTrendingTableView;
    recentController.tableView = self.connectRecentTableView;
    
    // Initializing observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recentDataDidLoad:) name:kPPConnectRecentChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trendingDataDidLoad:) name:kPPConnectTrendingChangeNotification object:nil];
    
    //Twitter searches, setting up to pull in from Twitter
    searchURL = @"https://api.twitter.com/1.1/search/tweets.json";
    
    recentLoadInProgress = NO;
    trendingLoadInProgress = NO;
    [self loadFirstData];
    
    //Setting up look of view
    self.view.backgroundColor = [UIColor blackColor];
    self.connectRecentTableView.backgroundColor = [UIColor clearColor];
    self.connectTrendingTableView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"plainnavigationbar.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.composeTweetButton.tintColor = [UIColor grayColor];
    
    UIFont *font = [UIFont fontWithName:@"Futura" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.tintColor = [UIColor grayColor];
    
    //Setting up refresh properties for Twitter
    trendingController.refreshControl = [[UIRefreshControl alloc]init];
    recentController.refreshControl = [[UIRefreshControl alloc] init];    
    [trendingController.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [recentController.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

    //Show necessary tableviews
    self.connectRecentTableView.hidden = YES;
    self.connectTrendingTableView.hidden = NO;
    self.recentLoadIndicator.hidden = YES;

    if ([self userHasAccessToTwitter]) {
        NSLog(@"Has access to Twitter!");
    } else {
        NSLog(@"Does not have twitter");
    }
    
    if ([self userHasAccessToFacebook]) {
        NSLog(@"Has access to Facebook");
    } else {
        NSLog(@"Does not have access to Facebook");
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
     NSLog(@"Mark at %@", [NSDate date]);
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPPConnectRecentChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPPConnectTrendingChangeNotification object:nil];
}

- (IBAction)composeTweetButtonPressed:(UIBarButtonItem *)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"I love the @PrixPartyApp!"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
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
    NSLog(@"%s called", __PRETTY_FUNCTION__);
    
    if(self.connectTrendingTableView.hidden == NO)
    {
        [self refreshTrending];
    }
    else
    {
        [self refreshRecent];
    }
}

# pragma mark - Data Loading

- (void)loadFirstData{
    NSLog(@"%s called", __PRETTY_FUNCTION__);
    NSLog(@"lfd IsMainThread: %@", ([NSThread isMainThread]) ? @"YES" : @"NO");
    [self.trendingLoadIndicator startAnimating];
    [self.recentLoadIndicator startAnimating];
    
    [self fetchSearchForTrending:@"formula1" next:NO];
    [self fetchSearchForRecent:@"austin" next:NO];
}

- (void)loadMoreData{
    NSLog(@"%s called", __PRETTY_FUNCTION__);
    NSLog(@"lmd IsMainThread: %@", ([NSThread isMainThread]) ? @"YES" : @"NO");
    if(self.connectTrendingTableView.hidden == NO){
        [self.trendingLoadIndicator startAnimating];
        [self fetchSearchForTrending:@"formula1" next:YES];
    }
    else{   
        [self.recentLoadIndicator startAnimating];
        [self fetchSearchForRecent:@"austin" next:YES];
    }
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (BOOL)userHasAccessToFacebook
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
}

- (void)fetchTimelineForUser:(NSString *)username
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/statuses/user_timeline.json"];
                 NSDictionary *params = @{@"screen_name" : username,
                                          @"include_rts" : @"0",
                                          @"trim_user" : @"1",
                                          @"count" : @"1"};
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *timelineData =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if (timelineData) {
                                 NSLog(@"Timeline Response: %@\n", timelineData);
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}

- (void)fetchSearchForTrending:(NSString *)query next:(BOOL)next
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 
                 NSURL *url;
                 NSDictionary *params;
                 
                 if(next == NO)
                 {
                     url = [NSURL URLWithString:searchURL];
                     params = @{@"q" : query,
                                @"count" : @"20"};
                 }
                 else
                 {
                     NSString *newURL = [searchURL copy];
                     newURL = [newURL stringByAppendingString:nextPageTrending];
                     NSLog(@"Trending NextResults URL: %@", newURL);
                     url = [NSURL URLWithString:newURL];
                     params = nil;
                 }
                 
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *queryData =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if (queryData) {
                                 NSArray *statuses = [queryData valueForKey:@"statuses"];
                                 [statuses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                                     [tweetsTrendingList addObject:[self retrieveTweetFromDataSource:obj]];
                                 }];
                                 
                                 NSDictionary *search_metadata = [queryData objectForKey:@"search_metadata"];
                                 if ([search_metadata valueForKey:@"next_results"] != Nil) {
                                     nextPageTrending = [search_metadata valueForKey:@"next_results"];
                                     NSLog(@"Set nextPageTrending: %@", nextPageTrending);
                                 }
                                 
                                 if ([search_metadata valueForKey:@"refresh_url"] != Nil) {
                                     refreshPageTrending = [search_metadata valueForKey:@"refresh_url"];
                                     NSLog(@"Set refreshPageTrending: %@", refreshPageTrending);
                                 }
                                 
                                 // Fire off event to stop loading animations, reload, etc.
                                 [self performSelectorOnMainThread:@selector(postTrendingDataDidLoadEvent) withObject:Nil waitUntilDone:NO];
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}

- (void) refreshTrending
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 
                 NSURL *url;
                 NSDictionary *params;
                 
                 
                 NSString *newURL = [searchURL copy];
                 if (refreshPageTrending != nil) {
                     newURL = [newURL stringByAppendingString:refreshPageTrending];
                 }
                 
                 NSLog(@"Trending NextResults URL: %@", newURL);
                 url = [NSURL URLWithString:newURL];
                 params = nil;
                 
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *queryData =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if (queryData) {
                                 NSArray *statuses = [queryData valueForKey:@"statuses"];
                                 [statuses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                                     [tweetsTrendingList insertObject:[self retrieveTweetFromDataSource:obj] atIndex:idx];
                                 }];
                                 
                                 NSDictionary *search_metadata = [queryData objectForKey:@"search_metadata"];

                                 if ([search_metadata valueForKey:@"next_results"] != Nil) {
                                     nextPageTrending = [search_metadata valueForKey:@"next_results"];
                                     NSLog(@"Set nextPageTrending: %@", nextPageTrending);
                                 }
                                 
                                 if ([search_metadata valueForKey:@"refresh_url"] != Nil) {
                                     refreshPageTrending = [search_metadata valueForKey:@"refresh_url"];
                                     NSLog(@"Set refreshPageTrending: %@", refreshPageTrending);
                                 }
                                 
                                 // Fire off event to stop loading animations, reload, etc.
                                 [self performSelectorOnMainThread:@selector(postTrendingDataDidLoadEvent) withObject:Nil waitUntilDone:NO];
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}


- (void) postTrendingDataDidLoadEvent {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPPConnectTrendingChangeNotification object:self];
}

- (void) trendingDataDidLoad:(NSNotification *)note {
    NSLog(@"Got trending data");
    NSLog(@"tddl IsMainThread: %@", ([NSThread isMainThread]) ? @"YES" : @"NO");
    
    [self.trendingLoadIndicator stopAnimating]; // THIS IS STILL SLOW
    [self.connectTrendingTableView reloadData];
    trendingLoadInProgress = NO;
    [trendingController.refreshControl endRefreshing];
}

- (void)fetchSearchForRecent:(NSString *)query next:(BOOL)next
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 
                 NSURL *url;
                 NSDictionary *params;
                 
                 if(next == NO)
                 {
                     url = [NSURL URLWithString:searchURL];
                     params = @{@"q" : query,
                                @"count" : @"20"};
                 }
                 else
                 {
                     NSString *newURL = [searchURL copy];
                     newURL = [newURL stringByAppendingString:nextPageTrending];
                     NSLog(@"Recent NextResults URL: %@", newURL);
                     url = [NSURL URLWithString:newURL];
                     params = nil;
                 }
                 
                 
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *recentData =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if (recentData) {
                                 NSArray *statuses = [recentData valueForKey:@"statuses"];
                                 [statuses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                                     [tweetsRecentList addObject:[self retrieveTweetFromDataSource:obj]];
                                 }];
                                 
                                 NSDictionary *search_metadata = [recentData objectForKey:@"search_metadata"];
                                 if ([search_metadata valueForKey:@"next_results"] != Nil) {
                                     nextPageRecent = [search_metadata valueForKey:@"next_results"];
                                     NSLog(@"Set nextPageRecent: %@", nextPageRecent);
                                 }
                                 
                                 if ([search_metadata valueForKey:@"refresh_url"] != Nil) {
                                     refreshPageRecent = [search_metadata valueForKey:@"refresh_url"];
                                     NSLog(@"Set refreshPageRecent: %@", refreshPageRecent);
                                 }

                                 // Fire off event to stop loading animations, reload, etc.
                                 [self performSelectorOnMainThread:@selector(postRecentDataDidLoadEvent) withObject:Nil waitUntilDone:NO];
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}

- (void) refreshRecent
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 
                 NSURL *url;
                 NSDictionary *params;
                 
                     NSString *newURL = [searchURL copy];
                     if (refreshPageRecent != nil) {
                         newURL = [newURL stringByAppendingString:refreshPageRecent];
                     }
                     NSLog(@"Recent RefreshResults URL: %@", newURL);
                     url = [NSURL URLWithString:newURL];
                     params = nil;
                 
                 
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *recentData =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if (recentData) {
                                 NSArray *statuses = [recentData valueForKey:@"statuses"];
                                 [statuses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                                     [tweetsRecentList insertObject:[self retrieveTweetFromDataSource:obj] atIndex:idx];
                                 }];
                                 
                                 NSDictionary *search_metadata = [recentData objectForKey:@"search_metadata"];

                                 if ([search_metadata valueForKey:@"next_results"] != Nil){
                                     nextPageRecent = [search_metadata valueForKey:@"next_results"];
                                     NSLog(@"Set nextPageRecent: %@", nextPageRecent);
                                 }
                                 
                                 if ([search_metadata valueForKey:@"refresh_url"] != Nil) {
                                     refreshPageRecent = [search_metadata valueForKey:@"refresh_url"];
                                     NSLog(@"Set refreshPageRecent: %@", refreshPageRecent);
                                 }
                                 
                                 // Fire off event to stop loading animations, reload, etc.
                                 [self performSelectorOnMainThread:@selector(postRecentDataDidLoadEvent) withObject:Nil waitUntilDone:NO];
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}


- (void) postRecentDataDidLoadEvent {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPPConnectRecentChangeNotification object:self];
}

- (void) recentDataDidLoad:(NSNotification *)note {
    NSLog(@"Got recent data");
    NSLog(@"rddl IsMainThread: %@", ([NSThread isMainThread]) ? @"YES" : @"NO");
    [self.recentLoadIndicator stopAnimating];
    [self.connectRecentTableView reloadData];
    [recentController.refreshControl endRefreshing];
    recentLoadInProgress = NO;
}

- (Tweet *)retrieveTweetFromDataSource:(NSDictionary *) obj{

    Tweet *newTweet = [[Tweet alloc] init];
    NSDictionary *user = [obj valueForKey:@"user"];
    newTweet.profName = [user valueForKey:@"name"];
    newTweet.tweetText = [obj valueForKey:@"text"];
    newTweet.userName = [user valueForKey:@"screen_name"];
    newTweet.date = [obj valueForKey:@"created_at"];
    
    NSString *picURL = [user valueForKey:@"profile_image_url"];
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
    
    if(self.connectTrendingTableView.hidden == NO){
        if((y > h + reload_distance) && !trendingLoadInProgress) {
            trendingLoadInProgress = YES;
            [self loadMoreData];
        }
    } else {
        if((y > h + reload_distance) && !recentLoadInProgress) {
            recentLoadInProgress = YES;
            [self loadMoreData];
        }
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
        NSLog(@"SIZE trending %u",[tweetsTrendingList count]);
        return [tweetsTrendingList count];
    }
    else{
        NSLog(@"SIZE recent %u",[tweetsRecentList count]);
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
    return 10.0f;
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
