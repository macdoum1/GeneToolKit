//
//  AddSequenceViewController.h
//  GeneToolKit
//
//  Created by Michael MacDougall on 2/18/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Sequence.h"
#import "SingletonManager.h"


@interface AddSequenceViewController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate>

//IBOutlets to User Interface Elements
@property (nonatomic, strong) IBOutlet UILabel *accessionLabel;
@property (nonatomic, strong) IBOutlet UITextField *accessionField;
@property (nonatomic, strong) IBOutlet UITextView *outputField;
@property (nonatomic, strong) IBOutlet UISegmentedControl *modeSwitch;
@property (nonatomic, strong) IBOutlet UIButton *ncbiRequestButton;
@property (nonatomic, strong) IBOutlet UITextField *header;
@property (nonatomic, strong) IBOutlet UITextView *notes;

//Variable to hold NCBI received data & singleton
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) SingletonManager *sharedManager;

//IBActions
- (IBAction)ncbiRequest:(id)sender;
- (IBAction)addSequence:(id)sender;
- (IBAction)segmentedControlIndexChanged;


@end
