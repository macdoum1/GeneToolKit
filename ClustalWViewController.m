//
//  ClustalWViewController.m
//  GeneToolKit
//
//  Created by Michael MacDougall on 4/14/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import "ClustalWViewController.h"

@implementation ClustalWViewController

@synthesize outputWebView, rawAlignment, rawTree, picker, sharedManager;

//***viewWillAppear Method***
- (void) viewWillAppear:(BOOL)animated
{
    sharedManager = [SingletonManager sharedManager];
    
    //***OutputWebView Border***
    outputWebView.layer.borderWidth = 5.0f;
    outputWebView.layer.borderColor = [[UIColor grayColor] CGColor];
    //**************************
    
    //***MFMailComposeViewController Initialize and Delegate***
    picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //*********************************************************
    
    //***Reset rawAlignment***
    rawAlignment = @"";
    rawTree = @"";
    //************************

}
//***************************

- (void) viewDidAppear:(BOOL)animated
{
    //Sends to clustal if sequences are available, returns user to sequence list if not.
    if([sharedManager.sequenceArray count] >= 2)
    {
        [self sendToClustalW];
    }
    else
    {
        if([sharedManager.sequenceArray count] == 0)
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Sequences"
                                                              message:@"Please add sequences"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Not enough sequences"
                                                              message:@"Please add at least 2 unique sequences"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && ([alertView.title isEqual: @"No Sequences"] || [alertView.title isEqual: @"Not enough sequences"]))
    {
        [self.tabBarController setSelectedIndex:0];
    } 
}
//***Lock to landscape orientation***
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
//***********************************

//***sendToClustalW IBAction method***
- (void)sendToClustalW
{
    NSString *fasta = @"";
    for(int i=0; i < [sharedManager.sequenceArray count]; i++)
    {
        Sequence *tempSequence = [sharedManager.sequenceArray objectAtIndex:i];
        fasta = [NSString stringWithFormat:@"%@%@\n%@",fasta,tempSequence.header,tempSequence.sequence];
    }

    //***Set up header of request***
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:@"http://www.genebee.msu.su/clustal/clustal.php"]];
    NSString *boundary = @"0194784892923";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    //******************************
    
    //**Set up body of request***
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"seq\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:fasta] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"tree_type\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"dist" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //***************************
    
    //***Set request body***
    [request setHTTPBody:body];
    //**********************
    
    //***Send request object to request method on background thread***
    [self performSelectorInBackground:@selector(makeClustalRequest:) withObject:request];
    //****************************************************************
}
//************************************

//***makeClustalRequest (Background thread)***
- (void)makeClustalRequest:(NSMutableURLRequest*)request
{
    //***Initialize URL request arguments***
    NSError *error;
    NSURLResponse *response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString* resultStr = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    //**************************************
    
    //***Remove unneeded HTML***
    NSString *editedResults = @"";
    editedResults = [resultStr stringByReplacingOccurrencesOfString:@"<CENTER><FONT SIZE=+1 COLOR=\"#0000FF\"> Processing your request...</FONT></CENTER>" withString:@""];
    editedResults = [editedResults stringByReplacingOccurrencesOfString:@"<PRE></PRE><PRE></PRE><HR><P><CENTER><FONT SIZE=+2 COLOR=\"#0000FF\"> Basic Genebee ClustalW 1.83 Results</FONT><P></CENTER>" withString:@""];
    editedResults = [editedResults stringByReplacingOccurrencesOfString:@"<HR><CENTER><B>The aligned sequence in <FONT COLOR=\"#FF0000\"> </FONT> format (<FONT COLOR=\"#FF0000\"> </FONT> order )</B></CENTER>" withString:@""];
    editedResults = [editedResults stringByReplacingOccurrencesOfString:@"<CENTER><FONT SIZE=-1 COLOR=\"#0000FF\">" withString:@""];
    editedResults = [editedResults stringByReplacingOccurrencesOfString:@"Created: Sun Apr 14 2013</FONT></CENTER>" withString:@""];
    //**************************
    
    //***Change Background Color***
    editedResults = [editedResults stringByReplacingOccurrencesOfString:@"<BODY TEXT=\"#000000\" BGCOLOR=\"#FFFFCC\">" withString:@"<BODY TEXT=\"#000000\" BGCOLOR=\"#FFFFFF\">"];
    //*****************************
    
    //***Send edited results to main thread***
    [self performSelectorOnMainThread:@selector(showResults:) withObject:editedResults waitUntilDone:NO];
    //****************************************
}
//*********************************************

//***showResults (Main Thread method)***
- (void) showResults:(NSString*)results
{    
    //***Filter out components of result***
    NSArray *compArray = [results componentsSeparatedByString:@"<PRE>"];
    if([compArray count] >= 3)
    {
        NSArray *compArrayTwo = [compArray[1] componentsSeparatedByString:@"</PRE>"];
        NSArray *compArrayThree = [compArray[2] componentsSeparatedByString:@"</PRE>"];
        if([compArrayTwo count] >= 1 && [compArrayThree count] >= 1)
        {
            rawAlignment = compArrayTwo[0];
            rawTree = compArrayThree[0];
            //***Setup WebView***
            NSString *webStr = [NSString stringWithFormat:@"<PRE>%@</PRE><PRE>%@</PRE>", rawAlignment,rawTree];
            [outputWebView loadHTMLString:webStr baseURL:nil];
            //*******************
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error in sequences"
                                                              message:@"Please check sequences"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error in sequences"
                                                          message:@"Please check sequences"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    //*************************************
    
    
}
//**************************************

//***Write String to File***
-(void) writeString:(NSString *)input toFile:(NSString *)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.aln",
                          documentsDirectory,filename];
    [input writeToFile:fileName
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
}
//**************************

//***emailAlignment IBAction method***
- (IBAction)emailAlignment:(id)sender
{
    //***Save File***
    [self writeString:rawAlignment toFile:@"alignment"];
    //***************
    
    //***Get contents of file***
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/alignment.aln",
                          documentsDirectory];
    NSData *file = [[NSData alloc]initWithContentsOfFile:fileName];
    //**************************
    
    if(![rawAlignment isEqual: @""])
    {
        //***Open MFMailComposeViewController***
        [picker addAttachmentData:file mimeType:@"text/plain"  fileName:@"alignment.aln"];
        [self presentViewController:picker animated:YES completion:nil];
        //**************************************
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Alignment"
                                                          message:@"Please perform alignment first"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}
//************************************

//***MFMailComposeViewController Delegate didFinishWithResult Method
-(void)mailComposeController:(MFMailComposeViewController *)mailer didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self becomeFirstResponder];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//******************************************************************

@end
