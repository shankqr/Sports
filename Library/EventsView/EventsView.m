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

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    if ([self.updateOnWillAppear isEqualToString:@"1"])
    {
        [self updateView];
    }
}

- (void)updateView
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@",
                       [[Globals i] world_url], self.serviceName];
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
             
             if ([returnArray count] > 0)
             {
                 NSDictionary *row0 = @{@"h1": @"", @"r1": @"Club (Alliance)", @"c1": @"Rank"};
                 [returnArray insertObject:row0 atIndex:0];
                 
                 self.rows = [@[returnArray] mutableCopy];
             }
             
             [self.tableView reloadData];
             [self.view setNeedsDisplay];
         }
     }];
}

- (void)clearView
{
    self.rows = nil;
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *row1 = (self.rows)[indexPath.section][indexPath.row];
    
    if (indexPath.row == 0) //Header row
    {
        return row1;
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
    
        return @{@"align_top": @"1", @"r1": row1[@"club_name"], @"r2": r2, @"r3": [NSString stringWithFormat:@"%@ XP Gained", row1[@"xp"]], @"c1": [NSString stringWithFormat:@"%ld", (long)indexPath.row], @"i1": [NSString stringWithFormat:@"c%@.png", row1[@"logo_pic"]]};
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) //Not Header row
    {
        NSDictionary *rowData = self.rows[indexPath.section][indexPath.row];
        
        if(![rowData[@"club_id"] isEqualToString:[[Globals i] wsClubData][@"club_id"]])
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
