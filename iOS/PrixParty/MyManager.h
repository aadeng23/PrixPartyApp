//
//  MyManager.h
//  PrixParty
//
//  Created by Angela Deng on 4/14/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import <foundation/Foundation.h>

@interface MyManager : NSObject

@property (nonatomic, retain) NSString *globalString;
@property (nonatomic, retain) NSMutableArray *favoritesList;

+ (id)sharedManager;

@end
