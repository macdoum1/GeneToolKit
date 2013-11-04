//
//  SequenceDetailViewController.m
//  GeneToolKit
//
//  Created by Michael MacDougall on 2/20/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import "SequenceDetailViewController.h"

@implementation SequenceDetailViewController
@synthesize selectedSequence, sequence, sequenceName, header, notes;


- (void)viewWillAppear:(BOOL)animated
{
    // Fill Label and Text with content pushed from tableView
    sequenceName.text = selectedSequence.name;
    sequence.text = selectedSequence.sequence;
    header.text = selectedSequence.header;
    notes.text = selectedSequence.notes;
    
    // Color Border
    sequence.layer.borderWidth = 5.0f;
    sequence.layer.borderColor = [[UIColor grayColor] CGColor];
    notes.layer.borderWidth = 5.0f;
    notes.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
