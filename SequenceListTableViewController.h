//
//  SequenceListTableViewController.h
//  GeneToolKit
//
//  Created by Michael MacDougall on 2/18/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"
#import "Sequence.h"
#import "SequenceDetailViewController.h"
#import "SequenceCell.h"
#import <MessageUI/MessageUI.h>


@interface SequenceListTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

//Access to singleton
@property (nonatomic, retain) SingletonManager *sharedManager;

//Variable to hold MFMailComposeViewController Picker
@property (nonatomic, retain) MFMailComposeViewController *picker;


- (IBAction)includeSequenceChange:(id)sender;
- (IBAction)emailFASTA:(id)sender;

@end
