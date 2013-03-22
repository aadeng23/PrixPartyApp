//
//  ConnectDataController.h
//  PrixParty
//
//  Created by Angela Deng on 3/20/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface ConnectDataController : NSObject

@property (nonatomic,copy) NSMutableArray *tweetsRecentList;
@property (nonatomic,copy) NSMutableArray *tweetsTrendingList;

- (NSUInteger)sizeOfList;
- (Tweet *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addTweet:(Tweet *)tweet;

//- (void)addTweetTest;


@end
