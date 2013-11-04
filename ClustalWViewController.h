//
//  ClustalWViewController.h
//  GeneToolKit
//
//  Created by Michael MacDougall on 4/14/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SingletonManager.h"
#import "Sequence.h"
#import <MessageUI/MessageUI.h>

@interface ClustalWViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

//IBOutlet to UIWebView
@property (nonatomic, retain) IBOutlet UIWebView *outputWebView;

//Alignment in ALN and Tree in Phylip
@property (nonatomic, retain) NSString *rawAlignment;
@property (nonatomic, retain) NSString *rawTree;

//Variable to hold MFMailComposeViewController Picker
@property (nonatomic, retain) MFMailComposeViewController *picker;

@property (nonatomic, retain) SingletonManager *sharedManager;

//IBActions
- (IBAction)emailAlignment:(id)sender;

@end
