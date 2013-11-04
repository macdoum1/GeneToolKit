//
//  Sequence.h
//  GeneToolKit
//
//  Created by Michael MacDougall on 2/19/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Sequence : UITableViewController

//***Sequence Data Model***

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *header;
@property (nonatomic, retain) NSString *sequence;
@property (nonatomic, retain) NSString *notes;

@end
