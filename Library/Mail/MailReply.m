//
//  MailReply.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MailReply.h"
#import "Globals.h"

@implementation MailReply
@synthesize mailData;
@synthesize rows;
@synthesize inputCell;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateView
{
    //[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    //NSDictionary *rowHeader1 = @{@"h1": @"To"};
    //NSDictionary *row10 = @{@"t1": @"Enter name here..."};
    //NSArray *rows1 = @[rowHeader1, row10];
    
    NSDictionary *rowHeader2 = @{@"h1": @"Message"};
    NSDictionary *row20 = @{@"t1": @"Enter text here...", @"t1_height": @"84"};
    NSArray *rows2 = @[rowHeader2, row20];
    
    //NSDictionary *rowHeader3 = @{@"h1": @"Options"};
    NSDictionary *rowDone = @{@"r1": @"Send", @"r1_center": @"1"};
    NSDictionary *rowCancel = @{@"r1": @"Cancel", @"r1_center": @"1", @"r1_color": @"1"};
    NSArray *rows3 = @[rowDone, rowCancel];
    
    self.rows = @[rows2, rows3];
    
	[self.tableView reloadData];
	[self.view setNeedsDisplay];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    return (self.rows)[indexPath.section][indexPath.row];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [[Globals i] dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
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
	return [[Globals i] dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.rows count]-1)
    {
        inputCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITextView *inputTV = (UITextView *)[inputCell viewWithTag:7];
        
        if(indexPath.row == 0) //Send Reply
        {
            if([inputTV.text length] > 0)
            {
                [inputTV resignFirstResponder];
                
                [self replyMail:inputTV];
            }
        }
        else if(indexPath.row == 1) //Cancel
        {
            [[Globals i] backTemplate];
            inputTV.text = @"";
        }
    }
    
	return nil;
}

- (void)replyMail:(UITextView *)textview
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [[Globals i] wsClubData][@"club_id"],
                          @"club_id",
                          [[Globals i] wsClubData][@"club_name"],
                          @"club_name",
                          mailData[@"mail_id"],
                          @"mail_id",
                          mailData[@"club_id"],
                          @"from_id",
                          mailData[@"reply_counter"],
                          @"reply_counter",
                          textview.text,
                          @"message",
                          nil];
    
    [Globals postServerLoading:dict :@"PostMailReply" :^(BOOL success, NSData *data)
    {
        dispatch_async(dispatch_get_main_queue(), ^{// IMPORTANT - Only update the UI on the main thread

            if (success)
            {
                [[Globals i] replyCounterPlus:mailData[@"mail_id"]]; //Since we r the one that reply, no need to show red dot
                [[Globals i] updateMailReply:mailData[@"mail_id"]]; //To show our reply and fetch latest reply from server
                [[Globals i] backTemplate];
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
