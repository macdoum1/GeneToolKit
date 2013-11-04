//
//  HelpViewController.m
//  GeneToolKit
//
//  Created by Michael MacDougall on 4/14/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import "HelpViewController.h"

@implementation HelpViewController

@synthesize helpHTMLView;

- (void) viewWillAppear:(BOOL)animated
{
    //***Load Manual HTML file***
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"manual" ofType:@"html" inDirectory:nil];
    NSString* htmlStr = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [helpHTMLView loadHTMLString:htmlStr baseURL:nil];
    //***************************
}

@end
