//
//  AddSequenceViewController.m
//  GeneToolKit
//
//  Created by Michael MacDougall on 2/18/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import "AddSequenceViewController.h"

@implementation AddSequenceViewController

@synthesize accessionLabel, accessionField, outputField, modeSwitch, ncbiRequestButton, receivedData, sharedManager, header, notes;

//***viewWillAppear***
- (void)viewWillAppear:(BOOL)animated
{
    // Ensure right mode is selected onAppear
    [self showAccessionAndHideSequence];
    
    // Initialize Data For NSRequest
    receivedData = [[NSMutableData alloc] init];
    
    // Get access to singleton
    sharedManager = [SingletonManager sharedManager];
    
    // Color Border around textView
    outputField.layer.borderWidth = 5.0f;
    outputField.layer.borderColor = [[UIColor grayColor] CGColor];
    notes.layer.borderWidth = 5.0f;
    notes.layer.borderColor = [[UIColor grayColor] CGColor];
    
    // Set TextField Delegate
    accessionField.delegate = self;
    header.delegate = self;
}
//********************

//***Lock Orientation***
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
//**********************

//***Send Request to NCBI through TOGOWS***
- (IBAction)ncbiRequest:(id)sender
{
    // Building Query String
    NSString *query = accessionField.text;
    NSString *searchRequestString = [NSString stringWithFormat:@"http://togows.dbcls.jp/entry/nucleotide/%@.fasta",query];
    
    // Set up URLRequest with timeout
    NSURLRequest *searchRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:searchRequestString]
                                   cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // Establish Connection (or not)
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:searchRequest delegate:self];
    if(connection)
    {
        NSLog(@"Here");
    }
    else
    {
        // Push UIAlert for failed Connection
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Check Internet Connection"
                                                          message:@"Could Not Establish Connection"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}
//*****************************************

//***Add Sequence To Array***
- (IBAction)addSequence:(id)sender
{
    if([accessionField.text isEqual: @""] || [outputField.text isEqual:@""])
    {
        // Push UIAlert for empty fields
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Empty Fields"
                                                          message:@"Please enter more information"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    else
    {
        // Create sequence from text fields
        Sequence *tempSequence = [[Sequence alloc]init];
        tempSequence.name = accessionField.text;
        tempSequence.sequence = outputField.text;
        tempSequence.header = header.text;
        tempSequence.notes = notes.text;
        tempSequence.included = true;
        
        // Add to Singleton's sequenceArray
        [sharedManager.sequenceArray addObject:tempSequence];
        
        //Close Pushed View
        UINavigationController *uiNav = self.navigationController;
        [uiNav popViewControllerAnimated:YES];
    }
}
//***************************

//***Input Mode Switcher***
- (IBAction)segmentedControlIndexChanged
{
    // Empty Fields
    accessionField.text = @"";
    header.text = @"";
    outputField.text = @"";
    
    // Determine which segment is selected
    if(modeSwitch.selectedSegmentIndex == 0)
    {
        [self showAccessionAndHideSequence];
    }
    else
    {
        [self hideAccessionAndShowSequence];
    }
}
//*************************

//***Hide Accession Mode and Show Sequence Mode***
- (void)hideAccessionAndShowSequence
{
    [accessionLabel setText:@"Name:"];
    outputField.editable = true;
    outputField.text = @"Enter Sequence Here";
    ncbiRequestButton.hidden = true;
}
//************************************************

//***Show Accession Mode and Hide Sequence Mode***
- (void)showAccessionAndHideSequence
{
    [accessionLabel setText:@"Accession Number:"];
    outputField.editable = false;
    outputField.text = @"Sequence Output Here";
    ncbiRequestButton.hidden = false;
}
//************************************************

//***NSURLConnection didReceiveResponse Delegate Method***
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
    NSLog(@"did receive response");
}
//*********************************************************

//***NSURLConnection didReceiveData Delegate Method***
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}
//****************************************************

//***NSURLConnection didFailWithError Delegate Method***
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Check Internet Connection"
                                                      message:@"Could Not Establish Connection"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}
//***************************************************

//***NSURLConnection didFinishLoading Delegate Method***
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished loading");
    NSString *dataStr = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    outputField.text = dataStr;
    NSArray *separatedComponents = [dataStr componentsSeparatedByString:@"\n"];
    header.text = separatedComponents[0];
    
    //Separating out header from sequence data
    NSString *stringToRemove = [NSString stringWithFormat:@"%@%@",separatedComponents[0],@"\n"];
    outputField.text = [dataStr stringByReplacingOccurrencesOfString:stringToRemove withString:@""];
}
//******************************************************

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
