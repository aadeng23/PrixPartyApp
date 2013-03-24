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
@property (nonatomic, copy) NSString *tweet;
@property (nonatomic) UIImage *userPic;
@property (nonatomic, copy) NSString *date;

-(id)initWithBasics:(NSString *)profName tweet:(NSString *)tweet;

-(id)initWithParams:(NSString *)profName userName:(NSString *)userName tweet:(NSString *)tweet userPic:(UIImage *)userPic date:(NSString *)date;

@end
