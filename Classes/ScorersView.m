//
//  ScorersView.m
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "ScorersView.h"
#import "Globals.h"

@implementation ScorersView
@synthesize players;
@synthesize selected_clubid;
@synthesize curDivision;
@synthesize curSeries;

- (void)updateView
{
	if(!((self.curDivision == [[Globals i] selectedDivision])&&
		 (self.curSeries == [[Globals i] selectedSeries])))
	{
		if(!workingLeagueScorers)
		{
			self.curDivision = [[Globals i] selectedDivision];
			self.curSeries = [[Globals i] selectedSeries];
			[[Globals i] showLoadingAlert];
			[NSThread detachNewThreadSelector: @selector(getLeagueScorersData) toTarget:self withObject:nil];
		}
	}
}

- (void)getLeagueScorersData
{
	@autoreleasepool {
		workingLeagueScorers = YES;
		[[Globals i] updateLeagueScorersData:[NSString stringWithFormat:@"%lu", (unsigned long)curDivision]:[NSString stringWithFormat:@"%d", 10]];
		self.players = [NSMutableArray arrayWithArray:[[Globals i] getLeagueScorersData]];
		[self.tableView reloadData];
		[[Globals i] removeLoadingAlert];
		workingLeagueScorers = NO;
	}
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = (self.players)[[indexPath row]];
    
    NSString *player_id = rowData[@"player_id"];
	NSString *name = rowData[@"player_name"];
	NSString *age = rowData[@"player_age"];
	NSString *goals = rowData[@"Score"];
	NSString *r1 = [NSString stringWithFormat:@"%@ (Age: %@)", name, age];
	
	NSString *salary = [[Globals i] numberFormat:rowData[@"player_salary"]];
	NSString *mvalue = [[Globals i] numberFormat:rowData[@"player_value"]];
	NSString *r2 = [NSString stringWithFormat:@"$%@/week (Market Value: $%@)", salary, mvalue];
	
    NSString *r3;
    
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        r3 = [NSString stringWithFormat:@"(Total Goals: %@)", goals];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        r3 = [NSString stringWithFormat:@"(Total Goals: %@)", goals];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        r3 = [NSString stringWithFormat:@"(Total Points: %@)", goals];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        r3 = [NSString stringWithFormat:@"(Total Runs: %@)", goals];
    }
	
	NSInteger f = ([player_id integerValue] % 1000);
	NSString *fname = [NSString stringWithFormat:@"z%ld.png", (long)f];
    
    return @{@"align_top": @"1", @"r1": r1, @"r2": r2, @"r3": r3, @"i1": fname};
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = (self.players)[indexPath.row];
	selected_clubid = [[NSString alloc] initWithString:rowData[@"club_id"]];
	
	NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:selected_clubid forKey:@"club_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                        object:self
                                                      userInfo:userInfo];
	
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.players count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

@end
