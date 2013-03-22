//
//  ConnectDataController.m
//  PrixParty
//
//  Created by Angela Deng on 3/20/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "ConnectDataController.h"

@implementation ConnectDataController


- (id)init {
    if (self = [super init]) {
        self.tweetsRecentList = [NSMutableArray new];
        self.tweetsTrendingList = [NSMutableArray new];
        
        return self;
    }
    return nil;
}

- (void)setTweetsTrendingList:(NSMutableArray *)newList {
    if(_tweetsTrendingList != newList){
        _tweetsTrendingList = [newList mutableCopy];
    }
}

- (void)setTweetsRecentList:(NSMutableArray *)newList {
    if(_tweetsRecentList != newList){
        _tweetsRecentList = [newList mutableCopy];
    }
}

- (NSUInteger)sizeOfList:(NSMutableArray *)list{
    return [list count];
}

- (Tweet *)objectInListAtIndex:(NSMutableArray *)list index:(NSUInteger)theIndex{
    
    return [list objectAtIndex:theIndex];
}

- (void)addTweet:(NSMutableArray *)list tweet:(Tweet *)tweet{
    
    [list addObject:tweet];
}

/*- (void)addEventTest{
    
    NSString *title = @"Some Cool Event";
    
    NSString *startDateString = @"1999-07-13 10:45:32";
    NSString *endDateString = @"1999-08-29 11:45:32";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate= [dateFormatter dateFromString:startDateString];
    NSDate *endDate = [dateFormatter dateFromString:endDateString];
    
    NSString *description = @"this is a really cool event that everyone should come to.";
    double cost = 10.00;
    
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:-30 longitude:90];
    
    NSMutableArray *tagsList = [[NSMutableArray alloc] init];
    
    Event *testEvent = [[Event alloc] initWithParams:title startDate:startDate endDate:endDate store:self.eventsStore description:description admission:cost location:testLocation tags:tagsList];
    
    [self addTweet:testEvent];
    
}*/
@end
