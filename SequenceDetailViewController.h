//
//  SequenceDetailViewController.h
//  GeneToolKit
//
//  Created by Michael MacDougall on 2/20/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Sequence.h"

@interface SequenceDetailViewController : UIViewController

//Currently selected sequence in TableView
@property (nonatomic, retain) Sequence *selectedSequence;

//IBOutlets to user interface elements
@property (nonatomic, retain) IBOutlet UILabel *sequenceName;
@property (nonatomic, retain) IBOutlet UITextView *sequence;
@property (nonatomic, retain) IBOutlet UILabel *header;
@property (nonatomic, retain) IBOutlet UITextView *notes;

@end
