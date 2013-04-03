//
//  ConnectDataController.h
//  PrixParty
//
//  Created by Angela Deng on 3/20/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface ConnectDataController : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, copy) NSString *mode;
@property (nonatomic, strong) NSMutableArray *tweetsRecentList;
@property (nonatomic,strong) NSMutableArray *tweetsTrendingList;
@property (nonatomic) BOOL *networkCallInProgress;
@property (nonatomic) BOOL *firstLoad;
@property (nonatomic) BOOL *dataReceived;

- (Tweet *)objectInListAtIndex:(NSMutableArray *)list theIndex:(NSUInteger)theIndex;
- (void)addTweet:(NSMutableArray *)list tweet:(Tweet *)tweet;
- (void)updateData;
- (void)loadMoreData;

@end
