//
//  ConnectDataController.m
//  PrixParty
//
//  Created by Angela Deng on 3/20/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "ConnectDataController.h"

@interface ConnectDataController (){
    
    NSMutableData *webDataTrending;
    NSMutableData *webDataRecent;
    NSURLConnection *connectionTrending;
    NSURLConnection *connectionRecent;
}
@end

@implementation ConnectDataController


- (id)init {
    if (self = [super init]) {
        self.tweetsRecentList = [[NSMutableArray alloc] init];
        self.tweetsTrendingList = [[NSMutableArray alloc] init];
        self.mode = @"Trending";
        
        return self;
    }
    return nil;
}

/*- (void)setTweetsTrendingList:(NSMutableArray *)newList {
    if(_tweetsTrendingList != newList){
        _tweetsTrendingList = [newList mutableCopy];
    }
}

- (void)setTweetsRecentList:(NSMutableArray *)newList {
    if(_tweetsRecentList != newList){
        _tweetsRecentList = [newList mutableCopy];
    }
}*/


- (Tweet *)objectInListAtIndex:(NSMutableArray *)list theIndex:(NSUInteger)theIndex{
    
    return [list objectAtIndex:theIndex];
}

- (void)addTweet:(NSMutableArray *)list tweet:(Tweet *)tweet{
    
    [list addObject:tweet];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    [webDataRecent setLength:0];
    [webDataTrending setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    if([self.mode isEqualToString:@"Trending"]){
        [webDataTrending appendData:data];
    }
    else{
        [webDataRecent appendData:data];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{

    NSLog(@"fail with error");
}

-(void)updateData{

    if([self.mode isEqualToString:@"Trending"]){
            
        NSURL *url = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=%40twitterapi"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        connectionTrending = [NSURLConnection connectionWithRequest:request delegate:self];
        
        if(connectionTrending){
            webDataTrending = [[NSMutableData alloc] init]; 
        }
    }
    else{
        
        NSURL *url = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=%40formula1"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        connectionRecent = [NSURLConnection connectionWithRequest:request delegate:self];
        
        if(connectionRecent){
            webDataRecent = [[NSMutableData alloc] init];
        }
    }
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if([self.mode isEqualToString:@"Trending"]){

        NSDictionary *trendingDataDictionary = [NSJSONSerialization JSONObjectWithData:webDataTrending options:0 error:nil];
        NSArray *trendingResults = [trendingDataDictionary objectForKey:@"results"];
        
        for(NSDictionary *dic in trendingResults){
            NSString *profname = [dic objectForKey:@"from_user_name"];
            NSString *tweetText = [dic objectForKey:@"text"];
            NSString *picURL = [dic objectForKey:@"profile_image_url"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
            Tweet *newTweet = [[Tweet alloc] initWithBasics:profname tweetText:tweetText userPic:image];
            
            [self addTweet:self.tweetsTrendingList tweet:newTweet];
        }
    }
    else{
        
        NSDictionary *recentDataDictionary = [NSJSONSerialization JSONObjectWithData:webDataRecent options:0 error:nil];
        NSArray *recentResults = [recentDataDictionary objectForKey:@"results"];
        
        for(NSDictionary *dic in recentResults){
            NSString *profname = [dic objectForKey:@"from_user_name"];
            NSString *tweetText = [dic objectForKey:@"text"];
            NSString *picURL = [dic objectForKey:@"profile_image_url"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
            Tweet *newTweet = [[Tweet alloc] initWithBasics:profname tweetText:tweetText userPic:image];
            
            [self addTweet:self.tweetsRecentList tweet:newTweet];
        }

    }
    
}

@end
