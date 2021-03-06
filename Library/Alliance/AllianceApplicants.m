//
//  AllianceApplicants.m
//  Kingdom
//
//  Created by Shankar on 10/23/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "AllianceApplicants.h"
#import "AllianceObject.h"
#import "Globals.h"

@implementation AllianceApplicants

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
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetAllianceApply/%@",
                       [[Globals i] world_url], self.aAlliance.alliance_id];
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
             
             if ([returnArray count] > 0)
             {
                 NSDictionary *row0 = @{@"n1": @"No.", @"h1": @"Club"};
                 [returnArray insertObject:row0 atIndex:0];
                 
                 self.rows = [@[returnArray] mutableCopy];
             }
             else //A message when no data is present
             {
                 NSDictionary *row0 = @{@"r1": @"No applicants yet.", @"r1_center": @"1", @"r1_color": @"1"};
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
        
        return @{@"n1": [NSString stringWithFormat:@"%ld", (long)indexPath.row], @"r1": r1, @"i2": @"arrow_right"};
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
            
            if([self.aAlliance.leader_id isEqualToString:[[Globals i] wsClubDict][@"club_id"]]) //You are the leader
            {
                self.selected_aid = [[NSString alloc] initWithString:[[Globals i] wsClubDict][@"alliance_id"]];
                self.selected_clubname = rowData[@"club_name"];
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:rowData[@"club_name"]
                                      message:rowData[@"message"]
                                      delegate:self
                                      cancelButtonTitle:@"Close"
                                      otherButtonTitles:@"View Profile", @"Approve", @"Reject", nil];
                [alert show];
            }
            else
            {
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:self.selected_clubid forKey:@"club_id"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                                    object:self
                                                                  userInfo:userInfo];
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
    else if(buttonIndex == 2) //Approve
	{
        NSString *wsurl = [NSString stringWithFormat:@"%@/AllianceApprove/%@/%@/%@",
                           [[Globals i] world_url], self.selected_aid, self.selected_clubid, self.selected_clubname];
        
        [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                if([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"0"])
                {
                    [UIManager.i showDialog:@"Unable to Approve! Maximum Members Reached. Upgrade this Alliance to increase the total members allowed."];
                }
                else
                {
                    [self updateView];
                    
                    NSInteger totalmembers = [self.aAlliance.total_members integerValue] + 1;
                    self.aAlliance.total_members = [NSString stringWithFormat:@"%ld", (long)totalmembers];
                    
                    [[Globals i] showToast:@"Club Approved!"
                             optionalTitle:nil
                             optionalImage:@"tick_yes"];
                }
             }
         }];
    }
    else if(buttonIndex == 3) //Reject
	{
        NSString *wsurl = [NSString stringWithFormat:@"%@/AllianceReject/%@/%@/%@",
                           [[Globals i] world_url], self.selected_aid, self.selected_clubid, self.selected_clubname];
        
        [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 [self updateView];
                 
                 [[Globals i] showToast:@"Club Rejected!"
                          optionalTitle:nil
                          optionalImage:@"tick_yes"];
             }
         }];
    }
}

@end
