//
//  SingletonManager.m
//  GeneToolKit
//
//  Created by Michael MacDougall on 2/19/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import "SingletonManager.h"

@implementation SingletonManager
static SingletonManager *_sharedSingleton = nil;

@synthesize sequenceArray;

//***sharedManager***
+ (id)sharedManager
{
    @synchronized([SingletonManager class])
    {
        if(!_sharedSingleton)
        {
            _sharedSingleton = [[SingletonManager alloc] init];
        }
    }
    return _sharedSingleton;
}
//*******************


- (id)init
{
    // Initialize array if needed
    if (self = [super init])
    {
        sequenceArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
