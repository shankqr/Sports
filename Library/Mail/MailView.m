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

@interface MailView ()

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSMutableArray *mailArray;
@property (nonatomic, strong) MailDetail *mailDetail;

@end

@implementation MailView

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
                                                 name:@"UpdateMailView"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"UpdateMailView"])
    {
        //TODO: Check if currentview b4 refrestTable
        [self refreshTable];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self refreshTable];
}

- (void)updateView
{
    //Get all mail from mail_id=0 because need to see if there is reply
    NSString *service_name = @"GetMail";
    NSString *wsurl = [NSString stringWithFormat:@"/0/%@/%@",
                       [Globals i].wsClubDict[@"club_id"],
                       [Globals i].wsClubDict[@"alliance_id"]];
    
    [Globals getServerNew:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
             
             if ([returnArray count] > 0)
             {
                 [Globals i].wsMailArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                 
                 [[Globals i] addLocalMailData:[Globals i].wsMailArray];
                 
                 [self refreshTable];
             }
         }
     }];
}

- (void)refreshTable
{
    self.rows = nil;
    [self.tableView reloadData];
    
    self.mailArray = [[Globals i] gettLocalMailData];
    
    if (self.mailArray.count > 0)
    {
        self.rows = [@[self.mailArray] mutableCopy];
    }
    
    [self.tableView reloadData];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = (self.rows)[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) //Mail List
    {
        NSDictionary *row1 = (self.mailArray)[[indexPath row]];

        NSString *title = row1[@"title"];
        NSString *content;
        if ([title isEqualToString:@""] || title == nil)
        {
            content = row1[@"message"];
            
            NSInteger MINLENGTH = 30;
            content = ([content length]>MINLENGTH ? [content substringToIndex:MINLENGTH] : content);
        }
        else
        {
            content = title;
        }
        
        NSString *bkg;
        NSString *i0;
        NSString *i1 = @"";
        NSString *bold;
        NSString *r1_font;
        NSString *r2_font;
        NSString *b1_font;
        if ([row1[@"open_read"] isEqualToString:@"1"])
        {
            bkg = @"bkg3";
            i0 = @"mail_read";
            bold = @"";
            r1_font = @"14.0";
            r2_font = @"12.0";
            b1_font = @"10.0";
        }
        else
        {
            bkg = @"";
            i0 = @"mail_unread";
            bold = @"1";
            r1_font = @"15.0";
            r2_font = @"13.0";
            b1_font = @"11.0";
        }
        
        if (row1[@"logo_pic"] != nil)
        {
            if ([row1[@"logo_pic"] integerValue] > 0)
            {
                i1 = [NSString stringWithFormat:@"c%@", row1[@"logo_pic"]];
            }
        }
        
        NSString *club_name = row1[@"club_name"];
        NSString *time_ago = [[Globals i] getTimeAgo:row1[@"date_posted"]];
        
        if (content == nil)
        {
            content = @" ";
        }
        
        if (club_name == nil)
        {
            club_name = @"System";
        }
        
        if (time_ago == nil)
        {
            time_ago = @" ";
        }
        
        rowData = @{@"bkg_prefix": bkg, @"i0": i0, @"i1": i1, @"i1_aspect": @"1", @"i2": @"arrow_right", @"r1": club_name, @"r1_bold": bold, @"r1_font": r1_font, @"r2": content, @"r2_bold": bold, @"r2_font": r2_font, @"b1": time_ago, @"b1_bold": bold, @"b1_color": @"5", @"b1_font": b1_font};
    }
    
    return rowData;
}

- (void)button1_tap:(id)sender
{
    for (NSMutableDictionary *rowData in self.mailArray)
    {
        rowData[@"open_read"] = @"1";
    }
    
    [[Globals i] settLocalMailData:self.mailArray];
    [self.tableView reloadData];
    
    [[Globals i] showToast:@"All Marked as Read!"
             optionalTitle:nil
             optionalImage:@"tick_yes"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (self.mailDetail == nil)
        {
            self.mailDetail = [[MailDetail alloc] initWithStyle:UITableViewStylePlain];
        }
        
        NSMutableDictionary *rd = [[self getRowData:indexPath] mutableCopy];
        [rd removeObjectsForKeys:@[@"bkg_prefix", @"i2"]];
        
        self.mailDetail.mailRow = rd;
        self.mailDetail.mailData = (self.mailArray)[indexPath.row];
        
        if ([(self.mailArray)[indexPath.row][@"open_read"] isEqualToString:@"0"])
        {
            (self.mailArray)[indexPath.row][@"open_read"] = @"1";
            [[Globals i] settLocalMailData:self.mailArray];
            [self.tableView reloadData];
            
            self.mailDetail.updateReplies = @"1";
        }
        else
        {
            self.mailDetail.updateReplies = @"0";
        }
        
        self.mailDetail.title = @"Mail";
        [[Globals i] showTemplate:@[self.mailDetail] :self.mailDetail.title];
        [self.mailDetail updateView];
        
        [self.mailDetail scrollUp];
    }
    
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, TABLE_HEADER_VIEW_HEIGHT)];
    [headerView setBackgroundColor:[UIColor blackColor]];
    
    CGFloat button_width = 280.0f*SCALE_IPAD;
    CGFloat button_height = 44.0f*SCALE_IPAD;
    CGFloat button_x = (UIScreen.mainScreen.bounds.size.width - button_width)/2;
    CGFloat button_y = (TABLE_HEADER_VIEW_HEIGHT - button_height);
    
    UIButton *button1 = [[Globals i] dynamicButtonWithTitle:@"Mark all as Read!"
                                                    target:self
                                                  selector:@selector(button1_tap:)
                                                     frame:CGRectMake(button_x, button_y, button_width, button_height)
                                                      type:@"3"];
    
    [headerView addSubview:button1];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_FOOTER_VIEW_HEIGHT;
}

@end
