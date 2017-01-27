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

@interface MailDetail ()

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) MailReply *mailReply;

@end

@implementation MailDetail

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateMailDetail"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"UpdateMailDetail"])
    {
        [self updateView];
    }
}

- (void)scrollUp
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)updateView
{
    NSString *bold = @"";
    NSString *r1_font = @"14.0";
    NSString *r2_font = @"12.0";
    NSString *b1_font = @"10.0";
    NSString *i1 = @"";

    NSArray *rows1 = @[self.mailRow];
    
    if ([self.updateReplies isEqualToString:@"1"])
    {
        [[Globals i] updateMailReply:self.mailData[@"mail_id"]];
        self.updateReplies = @"0";
    }
    
    NSArray *rows2 = [[Globals i] findMailReply:self.mailData[@"mail_id"]];
    NSDictionary *rowData;
    NSMutableArray *rowTemp = [[NSMutableArray alloc] init];
    NSDictionary *rowHeader2 = @{@"h1": @"Replies"};
    [rowTemp addObject:rowHeader2];
    for (NSUInteger i = 0; i < [rows2 count]; i++)
    {
        i1 = @"";
        if (rows2[i][@"logo_pic"] != nil)
        {
            if ([rows2[i][@"logo_pic"] integerValue] > 0)
            {
                i1 = [NSString stringWithFormat:@"c%@", rows2[i][@"logo_pic"]];
            }
        }
        
        rowData = @{@"i1": i1, @"i1_aspect": @"1", @"r1": rows2[i][@"club_name"], @"r2": rows2[i][@"message"], @"b1": [[Globals i] getTimeAgo:rows2[i][@"date_posted"]], @"r1_bold": @"1", @"r1_font": r1_font, @"r2_bold": bold, @"r2_font": r2_font, @"b1_bold": bold, @"b1_color": @"5", @"b1_font": b1_font};
        [rowTemp addObject:rowData];
    }
    
    NSDictionary *rowHeader = @{@"h1": @"Options"};
    NSDictionary *rowReply = @{@"r1": @"Reply",  @"r1_align": @"1", @"i2": @"arrow_right"};
    NSDictionary *rowDelete = @{@"r1": @"Delete", @"r1_align": @"1", @"r1_color": @"1"};
    NSArray *rows3 = @[rowHeader, rowReply, rowDelete];
    
    if (![self.mailData[@"club_id"] isEqualToString:@"0"])
    {
        NSDictionary *rowProfile = @{@"r1": @"View Sender's Profile",  @"r1_align": @"1", @"i2": @"arrow_right"};
        rows3 = @[rowHeader, rowReply, rowDelete, rowProfile];
    }
    
    if ([rowTemp count] > 1)
    {
        self.rows = [@[rows1, (NSArray *)rowTemp, rows3] mutableCopy];
    }
    else
    {
        self.rows = [@[rows1, rows3] mutableCopy];
    }
    
	[self.tableView reloadData];
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
    CGFloat height = [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    return height;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.rows count]-1)
    {
        if (indexPath.row == 1)
        {
            self.mailReply = [[MailReply alloc] initWithStyle:UITableViewStylePlain];
            self.mailReply.mailData = self.mailData;
            self.mailReply.title = @"Reply";
            [self.mailReply updateView];

            [UIManager.i showTemplate:@[self.mailReply] :self.mailReply.title :10];
        }
        else if(indexPath.row == 2) //Delete
        {
            NSString *service_name = @"DeleteMail";
            NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                               self.mailData[@"mail_id"], [Globals i].wsClubDict[@"club_id"]];
            
            [Globals getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
             {
                 if (success)
                 {
                     [[Globals i] deleteLocalMail:self.mailData[@"mail_id"]];
                     
                     [UIManager.i closeTemplate];
                     
                     [[Globals i] showToast:@"Mail Deleted!"
                              optionalTitle:nil
                              optionalImage:@"tick_yes"];
                 }
             }];
        }
        else if (indexPath.row == 3) //View senders profile
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:self.mailData[@"club_id"] forKey:@"club_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    
	return nil;
}

@end
