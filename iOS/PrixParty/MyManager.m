//
//  MyManager.m
//  PrixParty
//
//  Created by Angela Deng on 4/14/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "MyManager.h"


@implementation MyManager

@synthesize globalString;
@synthesize favoritesList;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        globalString = @"Default";
        favoritesList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


@end
