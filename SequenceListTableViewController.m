//
//  SequenceListTableViewController.m
//  GeneToolKit
//
//  Created by Michael MacDougall on 2/18/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import "SequenceListTableViewController.h"

@implementation SequenceListTableViewController
@synthesize sharedManager, picker;

//***viewWillAppear***
- (void)viewWillAppear:(BOOL)animated
{
    // Get access to singleton
    sharedManager = [SingletonManager sharedManager];
    
    // Reload table data
    [self.tableView reloadData];
    
    //***MFMailComposeViewController Initialize and Delegate***
    picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //*********************************************************
}
//********************

//***Lock Orientation***
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
//**********************

//***Number of Sections***
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
//************************

//***Number of Rows***
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [sharedManager.sequenceArray count];
}
//********************

//***Populate Cells***
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    int currentRow = indexPath.row;
    Sequence *tempSeq = [sharedManager.sequenceArray objectAtIndex:currentRow];
    
    cell.textLabel.text = tempSeq.name;
    cell.detailTextLabel.text = tempSeq.header;
    
    return cell;
}
//********************

//***Deletion of Cells***
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [sharedManager.sequenceArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}
//***********************

//***Prepare for Storyboard Segue***
-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Detail"])
    {
        SequenceDetailViewController *sequenceDetailViewController = [segue destinationViewController];
        int currentRow = self.tableView.indexPathForSelectedRow.row;
        
        //Send
        Sequence *tempSequence = [sharedManager.sequenceArray objectAtIndex:currentRow];
        sequenceDetailViewController.selectedSequence = tempSequence;
    }
}
//**********************************

//**emailFASTA***
- (IBAction)emailFASTA:(id)sender
{
    if([sharedManager.sequenceArray count] != 0)
    {
        NSString *fasta = @"";
        for(int i=0; i < [sharedManager.sequenceArray count]; i++)
        {
            Sequence *tempSequence = [sharedManager.sequenceArray objectAtIndex:i];
            fasta = [NSString stringWithFormat:@"%@%@\n%@",fasta,tempSequence.header,tempSequence.sequence];
        }
        [self writeString:fasta toFile:@"GeneToolKit"];
        //***Get contents of file***
        NSArray *paths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *fileName = [NSString stringWithFormat:@"%@/GeneToolKit.fasta",
                              documentsDirectory];
        NSData *file = [[NSData alloc]initWithContentsOfFile:fileName];
        [picker addAttachmentData:file mimeType:@"text/plain"  fileName:@"GeneToolKit.fasta"];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Sequences"
                                                          message:@"Please add sequences"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}
//**************

//***MFMailComposeViewController Delegate didFinishWithResult Method
-(void)mailComposeController:(MFMailComposeViewController *)mailer didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self becomeFirstResponder];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//******************************************************************

//***Write String to File***
-(void) writeString:(NSString *)input toFile:(NSString *)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.fasta",
                          documentsDirectory,filename];
    [input writeToFile:fileName
            atomically:NO
              encoding:NSStringEncodingConversionAllowLossy
                 error:nil];
}
//**************************



@end
