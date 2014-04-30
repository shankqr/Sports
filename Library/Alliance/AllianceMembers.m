//
//  AllianceMembers.m
//  Kingdom
//
//  Created by Shankar on 10/23/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "AllianceMembers.h"
#import "AllianceObject.h"
#import "Globals.h"

@implementation AllianceMembers

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
    
    [self emptyTable];
}

- (void)emptyTable
{
    self.rows = nil;
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

- (void)updateView
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetAllianceMembers/%@",
                       [[Globals i] world_url], self.aAlliance.alliance_id];
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
             
             if ([returnArray count] > 0)
             {
                 NSDictionary *row0 = @{@"n1": @"No.", @"h1": @"Club", @"c1": @"Level"};
                 [returnArray insertObject:row0 atIndex:0];
                 
                 self.rows = [@[returnArray] mutableCopy];
             }
             else //A message when no data is present
             {
                 NSDictionary *row0 = @{@"r1": @"This Alliance is empty and has no Members!", @"r1_center": @"1", @"r1_color": @"1"};
                 NSArray *rows1 = @[row0];
                 
                 self.rows = [@[rows1] mutableCopy];
             }
             
             [self.tableView reloadData];
             [self.view setNeedsDisplay];
         }
     }];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = self.rows[indexPath.section][indexPath.row];
    
    if (indexPath.row == 0) //Header row
    {
        return rowData;
	}
    else
    {
        NSString *r1 = rowData[@"club_name"];
        NSInteger the_xp = [rowData[@"xp"] integerValue];
        NSInteger the_level = [[Globals i] levelFromXp:the_xp];
        NSString *c1 = [[Globals i] intString:the_level];
        
        if([rowData[@"club_id"] isEqualToString:[[Globals i] wsClubDict][@"club_id"]]) //You are in this row
        {
            return @{@"n1": [NSString stringWithFormat:@"%ld", (long)indexPath.row], @"r1": r1, @"c1": c1};
        }
        else
        {
            return @{@"n1": [NSString stringWithFormat:@"%ld", (long)indexPath.row], @"r1": r1, @"c1": c1, @"i2": @"arrow_right"};
        }
    }
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

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) //Not Header row
    {
        NSDictionary *rowData = self.rows[indexPath.section][indexPath.row];
        
        if(![rowData[@"club_id"] isEqualToString:[[Globals i] wsClubDict][@"club_id"]])
        {
            self.selected_clubid = [[NSString alloc] initWithString:rowData[@"club_id"]];
            self.selected_aid = [[NSString alloc] initWithString:[[Globals i] wsClubDict][@"alliance_id"]];
            self.selected_clubname = rowData[@"club_name"];

            if([self.aAlliance.leader_id isEqualToString:[[Globals i] wsClubDict][@"club_id"]]) //You are the leader
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:rowData[@"club_name"]
                                      message:rowData[@"message"]
                                      delegate:self
                                      cancelButtonTitle:@"Close"
                                      otherButtonTitles:@"View Profile", @"Send Message", @"Kick Out", nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:rowData[@"club_name"]
                                      message:rowData[@"message"]
                                      delegate:self
                                      cancelButtonTitle:@"Close"
                                      otherButtonTitles:@"View Profile", @"Send Message", nil];
                [alert show];
            }
        }
    }
	return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1) //View Profile
	{
		NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.selected_clubid forKey:@"club_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
    else if(buttonIndex == 2) //Send Message
	{
        NSString *isAlli = @"0";
        NSString *toID = self.selected_clubid;
        NSString *toName = self.selected_clubname;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:isAlli forKey:@"is_alli"];
        [userInfo setObject:toID forKey:@"to_id"];
        [userInfo setObject:toName forKey:@"to_name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MailCompose"
                                                            object:self
                                                          userInfo:userInfo];
    }
    else if(buttonIndex == 3) //Kick Out
	{
        NSString *wsurl = [NSString stringWithFormat:@"%@/AllianceKick/%@/%@/%@",
                           [[Globals i] world_url], self.selected_aid, self.selected_clubid, self.selected_clubname];
        
        [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 [self updateView];
                 
                 NSInteger totalmembers = [self.aAlliance.total_members integerValue] - 1;
                 self.aAlliance.total_members = [NSString stringWithFormat:@"%ld", (long)totalmembers];
                 
                 [[Globals i] showDialog:@"Success! The Club will be informed in the News that they have been Kicked Out."];
             }
         }];
    }
}

@end
