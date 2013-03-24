//
//  Tweet.m
//  PrixParty
//
//  Created by Angela Deng on 3/20/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

-(id)initWithParams:(NSString *)profName userName:(NSString *)userName tweet:(NSString *)tweet userPic:(UIImage *)userPic date:(NSString *)date{
    
    _profName = profName;
    _userName = userName;
    _tweet = tweet;
    _userPic = userPic;
    _date = date;
}

-(id)initWithBasics:(NSString *)profName tweet:(NSString *)tweet{
    
    _profName = profName;
    _tweet = tweet;
    
}

@end
