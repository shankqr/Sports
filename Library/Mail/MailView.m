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
@synthesize rows;
@synthesize mailDetail;

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
    
    [self refreshTable];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    [[Globals i] settLocalMailData:self.rows];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
	[super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
	[super didMoveToParentViewController:parent];
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
    return [[Globals i] dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

#pragma mark Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[Globals i] dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (mailDetail == nil)
    {
        mailDetail = [[MailDetail alloc] initWithStyle:UITableViewStylePlain];
    }
    mailDetail.mailData = (self.rows)[indexPath.row];
    
    if ([(self.rows)[indexPath.row][@"open_read"] isEqualToString:@"0"])
    {
        (self.rows)[indexPath.row][@"open_read"] = @"1";
        [[Globals i] settLocalMailData:self.rows];
        [self.tableView reloadData];
        
        [mailDetail getReplies];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"UpdateBadges"
         object:self];
    }
    
    [[Globals i] pushTemplateNav:mailDetail];
    
    [mailDetail scrollUp];

	return nil;
}

@end
