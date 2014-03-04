//
//  EventsView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "EventsView.h"
#import "Globals.h"

@implementation EventsView

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateView
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@",
                       [[Globals i] world_url], self.serviceNameDetail];
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
             
             if ([returnArray count] > 0)
             {
                 NSDictionary *row0 = @{@"h1": (returnArray)[0][@"event_row1"]};
                 
                 NSDictionary *row1 = @{@"align_top": @"1", @"r1": (returnArray)[0][@"event_row2"], @"r2": (returnArray)[0][@"event_row3"]};
                 
                 //Update time left in seconds for event to end
                 NSTimeInterval serverTimeInterval = [[Globals i] updateTime];
                 NSString *strDate = (returnArray)[0][@"event_ending"];
                 strDate = [NSString stringWithFormat:@"%@ -0000", strDate];
                 NSDate *endDate = [[[Globals i] getDateFormat] dateFromString:strDate];
                 NSTimeInterval endTime = [endDate timeIntervalSince1970];
                 self.b1s = endTime - serverTimeInterval;
                 
                 NSDictionary *row2;
                 NSDictionary *row3;
                 
                 if (self.b1s > 0)
                 {
                     row2 = @{@"r1_color": @"1", @"r1": [NSString stringWithFormat:@"Ending in %@", [[Globals i] getCountdownString:self.b1s]]};
                     row3 = @{@"r1": [NSString stringWithFormat:@"Your Score: %@ (XP Gain)", [Globals i].wsClubData[@"xp_gain"]]};
                 }
                 else
                 {
                     row2 = @{@"r1_color": @"1", @"r1": @"This tournament has ended. Congratulations to all winners listed bellow. Prepare yourselves, as a new tournament will begin soon!"};
                     if ([[Globals i].wsClubData[@"xp_history"] isEqualToString:@"0"])
                     {
                         row3 = @{@"r1": @"Thank you for playing."};
                     }
                     else
                     {
                         row3 = @{@"r1": [NSString stringWithFormat:@"Your Score was %@ (XP Gain)", [Globals i].wsClubData[@"xp_history"]]};
                     }
                 }
                 
                 if ([self.isAlliance isEqualToString:@"1"])
                 {
                     row3 = @{@"r1": @"Make sure you are a member of an Alliance to participate and win prizes."};
                 }
                 
                 [returnArray insertObject:row0 atIndex:0];
                 [returnArray addObject:row1];
                 [returnArray addObject:row2];
                 [returnArray addObject:row3];
                 
                 self.rows = [@[returnArray] mutableCopy];
                 
                 //Add loading header
                 NSMutableArray *rowLoading = [@[@{@"h1": @"Loading..."}] mutableCopy];
                 [self.rows addObject:rowLoading];
                 
                 [self.tableView reloadData];
                 [self.view setNeedsDisplay];
                 
                 [self updateList:(returnArray)[0][@"event_id"]];
             }
         }
     }];
}

- (void)updateList:(NSString *)event_id
{
    NSString *wsurl;
    
    if (self.b1s > 0)
    {
        wsurl = [NSString stringWithFormat:@"%@/%@", [[Globals i] world_url], self.serviceNameList];
    }
    else
    {
        wsurl = [NSString stringWithFormat:@"%@/%@/%@", [[Globals i] world_url], self.serviceNameResult, event_id];
    }
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
         if (success)
         {
             NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
             
             if ([returnArray count] > 0)
             {
                 NSDictionary *row0 = @{@"h1": @"", @"n1": @"No.", @"r1": @"Club (Alliance)", @"c1": @"XP Gain"};
                 if ([self.isAlliance isEqualToString:@"1"])
                 {
                     row0 = @{@"h1": @"", @"n1": @"No.", @"r1": @"Alliance", @"c1": @"XP Gain"};
                 }
                 
                 [returnArray insertObject:row0 atIndex:0];
                 
                 //Remove loading row
                 [self.rows removeObjectAtIndex:1];
                 
                 [self.rows addObject:returnArray];
                 
                 if (self.b1s > 0)
                 {
                     if (!self.gameTimer.isValid)
                     {
                         self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
                     }
                 }
                 else
                 {
                     if (self.gameTimer.isValid)
                     {
                         [self.gameTimer invalidate];
                         self.gameTimer = nil;
                     }
                 }
                 
                 [self.tableView reloadData];
                 [self.view setNeedsDisplay];
             }
         }
         });
     }];
}

- (void)clearView
{
    self.rows = nil;
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

- (void)onTimer
{
    self.b1s = self.b1s-1;
    
    [self redrawView];
}

- (void)redrawView
{
    self.rows[0][3] = @{@"r1_color": @"1", @"r1": [NSString stringWithFormat:@"Ending in %@", [[Globals i] getCountdownString:self.b1s]]};
    
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *returnRow;
    NSDictionary *row1 = (self.rows)[indexPath.section][indexPath.row];
    
    if (indexPath.row == 0) //Header row
    {
        returnRow = row1;
	}
    else
    {
        if (indexPath.section == 0) //Details row
        {
            returnRow = row1;
        }
        else
        {
            if ([self.isAlliance isEqualToString:@"1"])
            {
                returnRow = @{@"align_top": @"1", @"n1": [NSString stringWithFormat:@"%ld", (long)indexPath.row], @"r1": row1[@"name"], @"c1": row1[@"xp_gain"]};
            }
            else
            {
                NSString *r2 = row1[@"club_name"];
                if ([row1[@"alliance_name"] length] > 2)
                {
                    r2 = [NSString stringWithFormat:@"(%@)", row1[@"alliance_name"]];
                }
                else
                {
                    r2 = @"(NO ALLIANCE)";
                }
        
                returnRow = @{@"align_top": @"1", @"n1": [NSString stringWithFormat:@"%ld", (long)indexPath.row], @"r1": row1[@"club_name"], @"r2": r2, @"c1": row1[@"xp_gain"]};
            }
        }
    }
    
    return returnRow;
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
    if ((indexPath.section > 0) && (indexPath.row > 0)) //Not Details and Header row
    {
        NSDictionary *rowData = self.rows[indexPath.section][indexPath.row];
        
        if ([self.isAlliance isEqualToString:@"1"])
        {
            NSString *aid = rowData[@"alliance_id"];
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:aid forKey:@"alliance_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewAlliance"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if(![rowData[@"club_id"] isEqualToString:[[Globals i] wsClubData][@"club_id"]])
        {
            NSString *selected_clubid = [[NSString alloc] initWithString:rowData[@"club_id"]];
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:selected_clubid forKey:@"club_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    
	return nil;
}

@end
