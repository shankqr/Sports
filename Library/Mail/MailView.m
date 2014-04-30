//
//  MailView.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MailView.h"
#import "MailDetail.h"
#import "Globals.h"

@implementation MailView

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateMailView"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"UpdateMailView"])
    {
        [self refreshTable];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self refreshTable];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    [[Globals i] settLocalMailData:self.rows];
}

- (void)updateView
{
	[[Globals i] showLoadingAlert];
    [NSThread detachNewThreadSelector: @selector(getRowsData) toTarget:self withObject:nil];
}

- (void)getRowsData
{
	@autoreleasepool
    {
		[[Globals i] updateMailData];

        [self refreshTable];
		
		[[Globals i] removeLoadingAlert];
	}
}

- (void)refreshTable
{
    self.rows = [[Globals i] gettLocalMailData];
    [self.tableView reloadData];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *row1 = (self.rows)[[indexPath row]];
    NSDictionary *rowData;
    NSString *content;
    
    if ([row1[@"title"] isEqualToString:@""])
    {
        content = row1[@"message"];
    }
    else
    {
        content = row1[@"title"];
    }
    
    if ([row1[@"open_read"] isEqualToString:@"1"])
    {
        rowData = @{@"r1": row1[@"club_name"], @"r2": content, @"r3": [[Globals i] getTimeAgo:row1[@"date_posted"]], @"i1": @"icon_mail_read"};
    }
    else
    {
        rowData = @{@"r1": row1[@"club_name"], @"r2": content, @"r3": [[Globals i] getTimeAgo:row1[@"date_posted"]], @"i1": @"icon_mail_unread"};
    }
    
    return rowData;
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

#pragma mark Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mailDetail == nil)
    {
        self.mailDetail = [[MailDetail alloc] initWithStyle:UITableViewStylePlain];
    }
    self.mailDetail.mailData = (self.rows)[indexPath.row];
    
    if ([(self.rows)[indexPath.row][@"open_read"] isEqualToString:@"0"])
    {
        (self.rows)[indexPath.row][@"open_read"] = @"1";
        [[Globals i] settLocalMailData:self.rows];
        [self.tableView reloadData];
        
        [self.mailDetail getReplies];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"UpdateBadges"
         object:self];
    }
    
    [[Globals i] showTemplate:@[self.mailDetail] :@"Mail"];
    
    [self.mailDetail scrollUp];

	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TABLE_HEADER_VIEW_HEIGHT)];
    [headerView setBackgroundColor:[UIColor blackColor]];
    
    UIButton *button1 = [[Globals i] dynamicButtonWithTitle:@"Mark all as Read!"
                                                    target:self
                                                  selector:@selector(button1_tap:)
                                                     frame:CGRectMake(20*SCALE_IPAD, 5*SCALE_IPAD, 280*SCALE_IPAD, 46*SCALE_IPAD)
                                                      type:@"1"];
    
    [headerView addSubview:button1];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_FOOTER_VIEW_HEIGHT;
}

- (void)button1_tap:(id)sender
{
    for(NSMutableDictionary *rowData in self.rows)
    {
        rowData[@"open_read"] = @"1";
    }
    
    [[Globals i] settLocalMailData:self.rows];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateBadges"
     object:self];
    
    [[Globals i] showToast:@"All Marked as Read!"
             optionalTitle:nil
             optionalImage:@"tick_yes"];
}

@end
