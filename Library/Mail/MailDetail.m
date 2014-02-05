//
//  MailDetail.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MailDetail.h"
#import "MailReply.h"
#import "Globals.h"

@implementation MailDetail
@synthesize mailData;
@synthesize rows;
@synthesize mailReply;

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
}

- (void)getReplies
{
    [[Globals i] updateMailReply:mailData[@"mail_id"]];
}

- (void)scrollUp
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)updateView
{
    NSString *content;
    
    if ([mailData[@"title"] isEqualToString:@""])
    {
        content = @"Message";
    }
    else
    {
        content = mailData[@"title"];
    }
    
    NSDictionary *rowHeader1 = @{@"h1": content};
    NSDictionary *row1 = @{@"r1": mailData[@"club_name"], @"r2": mailData[@"message"], @"r3": [[Globals i] getTimeAgo:mailData[@"date_posted"]]};
    NSArray *rows1 = @[rowHeader1, row1];
    
    [Apsalar event:@"Mail_Open" withArgs:row1];
    [Flurry logEvent:@"Mail_Open" withParameters:row1];
    
    NSArray *rows2 = [[Globals i] findMailReply:mailData[@"mail_id"]];
    NSDictionary *rowData;
    NSMutableArray *rowTemp = [[NSMutableArray alloc] init];
    NSDictionary *rowHeader2 = @{@"h1": @"Replies"};
    [rowTemp addObject:rowHeader2];
    for (NSUInteger i = 0; i < [rows2 count]; i++)
    {
        rowData = @{@"r1": rows2[i][@"club_name"], @"r2": rows2[i][@"message"], @"r3": [[Globals i] getTimeAgo:rows2[i][@"date_posted"]]};
        [rowTemp addObject:rowData];
    }
    
    NSDictionary *rowHeader = @{@"h1": @"Options"};
    NSDictionary *rowReply = @{@"r1": @"Reply",  @"r1_center": @"1", @"i2": @"arrow_right"};
    NSDictionary *rowDelete = @{@"r1": @"Delete", @"r1_center": @"1", @"r1_color": @"1"};
    NSArray *rows3 = @[rowHeader, rowReply, rowDelete];
    
    if (![mailData[@"club_id"] isEqualToString:@"0"])
    {
        NSDictionary *rowProfile = @{@"r1": @"View Sender's Profile",  @"r1_center": @"1", @"i2": @"arrow_right"};
        rows3 = @[rowHeader, rowReply, rowDelete, rowProfile];
    }
    
    if ([rowTemp count] > 1)
    {
        self.rows = @[rows1, (NSArray *)rowTemp, rows3];
    }
    else
    {
        self.rows = @[rows1, rows3];
    }
    
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
        if(indexPath.row == 1)
        {
            mailReply = [[MailReply alloc] initWithStyle:UITableViewStylePlain];
            mailReply.mailData = self.mailData;
            [mailReply updateView];
            [[Globals i] pushTemplateNav:mailReply];
        }
        else if(indexPath.row == 2) //Delete
        {
            NSString *wsurl = [NSString stringWithFormat:@"%@/DeleteMail/%@/%@",
                               [[Globals i] world_url], mailData[@"mail_id"], [[Globals i] wsClubData][@"club_id"]];
            
            [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
             {
                 if (success)
                 {
                     [[Globals i] deleteLocalMail:mailData[@"mail_id"]];
                     [[Globals i] backTemplate];
                     
                     [[Globals i] showToast:@"Mail Deleted!"
                              optionalTitle:nil
                              optionalImage:@"tick_yes"];
                 }
             }];
        }
        else if(indexPath.row == 3) //View senders profile
        {
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:mailData[@"club_id"] forKey:@"club_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    
	return nil;
}

@end
