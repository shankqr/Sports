//
//  MailCompose.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MailCompose.h"
#import "Globals.h"

@implementation MailCompose

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateView];
    [self updateInputs];
}

- (void)updateView
{
    NSDictionary *rowHeader1 = @{@"h1": @"To"};
    NSDictionary *row10 = @{@"t1": @"Enter name here..."};
    NSArray *rows1 = @[rowHeader1, row10];
    
    NSDictionary *rowHeader2 = @{@"h1": @"Message"};
    NSDictionary *row20 = @{@"t1": @"Enter text here...", @"t1_height": @"84"};
    NSArray *rows2 = @[rowHeader2, row20];
    
    //NSDictionary *rowHeader3 = @{@"h1": @"Options"};
    NSDictionary *rowDone = @{@"r1": @"Send", @"r1_center": @"1"};
    NSDictionary *rowCancel = @{@"r1": @"Cancel", @"r1_center": @"1", @"r1_color": @"1"};
    NSArray *rows3 = @[rowDone, rowCancel];
    
    self.rows = @[rows1, rows2, rows3];
    
    [self.view setNeedsDisplay];
	[self.tableView reloadData];
}

- (void)updateInputs
{
    self.inputCell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    self.inputCell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    UITextField *tvName = (UITextField *)[self.inputCell1 viewWithTag:6];
    
    if ([self.isAlliance isEqualToString:@"1"])
    {
        [tvName setEnabled:NO];
    }
    else if (![self.toName isEqualToString:@""])
    {
        [tvName setEnabled:NO];
    }
    else
    {
        [tvName setEnabled:YES];
    }
    
    [tvName setText:self.toName];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    return (self.rows)[indexPath.section][indexPath.row];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rows count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows[section] count];
}

#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.rows count]-1)
    {
        UITextField *tvName = (UITextField *)[self.inputCell1 viewWithTag:6];
        UITextView *tvMessage = (UITextView *)[self.inputCell2 viewWithTag:7];
        
        if(indexPath.row == 0) //Send Mail
        {
            if([tvMessage.text length] > 0)
            {
                [tvMessage resignFirstResponder];
                
                [self sendMail:tvMessage];
                
                tvName.text = @"";
                tvMessage.text = @"";
            }
        }
        else if(indexPath.row == 1) //Cancel
        {
            [[Globals i] closeTemplate];
            
            tvName.text = @"";
            tvMessage.text = @"";
        }
    }
    
	return nil;
}

- (void)sendMail:(UITextView *)textview
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [[Globals i] wsClubData][@"club_id"],
                          @"club_id",
                          [[Globals i] wsClubData][@"club_name"],
                          @"club_name",
                          self.isAlliance,
                          @"is_alliance",
                          self.toID,
                          @"to_id",
                          self.toName,
                          @"to_name",
                          textview.text,
                          @"message",
                          nil];
    
    [Globals postServerLoading:dict :@"PostMailCompose" :^(BOOL success, NSData *data)
    {
        dispatch_async(dispatch_get_main_queue(), ^{// IMPORTANT - Only update the UI on the main thread
            
            if (success)
            {
                [[Globals i] closeTemplate];
                textview.text = @"";
                
                [[Globals i] showToast:@"Message Sent!"
                         optionalTitle:nil
                         optionalImage:@"tick_yes"];
            }
            else
            {
                [[Globals i] showDialogError];
            }
        });
    }];
}

@end
