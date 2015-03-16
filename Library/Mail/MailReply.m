//
//  MailReply.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MailReply.h"
#import "Globals.h"

@interface MailReply ()

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) UITableViewCell *inputCell;

@end

@implementation MailReply

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delaysContentTouches = NO;
    for (id obj in self.tableView.subviews)
    {
        if ([obj respondsToSelector:@selector(setDelaysContentTouches:)])
        {
            [obj setDelaysContentTouches:NO];
        }
    }
}

- (void)updateView
{
    NSDictionary *rowHeader2 = @{@"h1": @"Message"};
    NSDictionary *row20 = @{@"t1": @"Enter text here...", @"t1_height": @"84"};
    NSArray *rows2 = @[rowHeader2, row20];
    
    //NSDictionary *rowHeader3 = @{@"h1": @"Options"};
    NSDictionary *rowDone = @{@"r1": @"Send", @"r1_align": @"1"};
    NSDictionary *rowCancel = @{@"r1": @"Cancel", @"r1_align": @"1", @"r1_color": @"1"};
    NSArray *rows3 = @[rowDone, rowCancel];
    
    self.rows = [@[rows2, rows3] mutableCopy];
    
	[self.tableView reloadData];
}

- (void)replyMail:(UITextView *)textview
{
    NSString *is_alliance = self.mailData[@"is_alliance"];
    
    if (is_alliance == nil) //its from db
    {
        NSString *alliance_id = self.mailData[@"alliance_id"];
        if ([alliance_id isEqualToString:@"-1"])
        {
            is_alliance = @"0";
        }
        else
        {
            is_alliance = @"1";
        }
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Globals i].wsClubDict[@"club_id"],
                          @"club_id",
                          [Globals i].wsClubDict[@"club_name"],
                          @"club_name",
                          [Globals i].wsClubDict[@"logo_pic"],
                          @"logo_pic",
                          self.mailData[@"mail_id"],
                          @"mail_id",
                          self.mailData[@"club_id"],
                          @"from_id",
                          self.mailData[@"reply_counter"],
                          @"reply_counter",
                          textview.text,
                          @"message",
                          self.mailData[@"to_id"],
                          @"to_id",
                          is_alliance,
                          @"is_alliance",
                          nil];
    
    NSString *service_name = @"PostMailReply";
    [Globals postServerLoading:dict :service_name :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{// IMPORTANT - Only update the UI on the main thread
             
             if (success)
             {
                 NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 if ([returnValue isEqualToString:@"1"]) //Stored Proc Success
                 {
                     [[Globals i] replyCounterPlus:self.mailData[@"mail_id"]]; //Since we r the one that reply, no need to show red dot
                     [[Globals i] updateMailReply:self.mailData[@"mail_id"]]; //To show our reply and fetch latest reply from server
                     [[Globals i] closeTemplate];
                     textview.text = @"";
                     
                     [[Globals i] showToast:@"Message Sent!"
                              optionalTitle:nil
                              optionalImage:@"tick_yes"];
                 }
                 
             }
         });
     }];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    return (self.rows)[indexPath.section][indexPath.row];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    return dcell;
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
        self.inputCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITextView *inputTV = (UITextView *)[self.inputCell viewWithTag:7];
        
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
            [[Globals i] closeTemplate];
            
            inputTV.text = @"";
        }
    }
    
	return nil;
}

@end
