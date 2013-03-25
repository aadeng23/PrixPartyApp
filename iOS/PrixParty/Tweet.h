//
//  Tweet.h
//  PrixParty
//
//  Created by Angela Deng on 3/20/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, copy) NSString *profName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *tweetText;
@property (nonatomic) UIImage *userPic;
@property (nonatomic, copy) NSString *date;

-(id)initWithBasics:(NSString *)profName tweetText:(NSString *)tweetText;

-(id)initWithParams:(NSString *)profName userName:(NSString *)userName tweetText:(NSString *)tweetText userPic:(UIImage *)userPic date:(NSString *)date;

@end
