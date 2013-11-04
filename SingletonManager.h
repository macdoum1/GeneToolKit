//
//  SingletonManager.h
//  GeneToolKit
//
//  Created by Michael MacDougall on 2/19/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import <Foundation/Foundation.h>

// Class acts as a persistent object that stores Array that will populate Sequence
// List TableViewController in a safe and secure manner

@interface SingletonManager : NSObject
{
    NSMutableArray *sequenceArray;
}

@property (nonatomic, retain) NSMutableArray *sequenceArray;

// If Grand Central Dispatch cannot find another instance of a SingletonManager
// Object a new one is created, otherwise a the existing object is returned.
+ (id)sharedManager;

@end
