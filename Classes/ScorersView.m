//
//  ScorersView.m
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "ScorersView.h"
#import "SimplePlayerCell.h"
#import "Globals.h"
#import "MainView.h"

@implementation ScorersView
@synthesize players;
@synthesize selected_clubid;
@synthesize curDivision;
@synthesize curSeries;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch(buttonIndex)
	{
		case 0: //Club Info
		{
			[[Globals i].mainView showClubViewer:selected_clubid];
			break;
		}
	}
}

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

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"SimplePlayerCell";
	SimplePlayerCell *cell = (SimplePlayerCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimplePlayerCell" owner:self options:nil];
		cell = (SimplePlayerCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.players)[row];
	NSString *player_id = rowData[@"player_id"];
	player_id = player_id;
	NSString *name = rowData[@"player_name"];
	NSString *age = rowData[@"player_age"];
	NSString *goals = rowData[@"Score"];
	cell.playerName.text = [NSString stringWithFormat:@"%@ (Age: %@)", name, age];
	
	NSString *salary = [[Globals i] numberFormat:rowData[@"player_salary"]];
	NSString *mvalue = [[Globals i] numberFormat:rowData[@"player_value"]]; 
	cell.playerValue.text = [NSString stringWithFormat:@"$%@/week (Market Value: $%@)", salary, mvalue];
	
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        cell.position.text = [NSString stringWithFormat:@"(Total Goals: %@)", goals];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        cell.position.text = [NSString stringWithFormat:@"(Total Goals: %@)", goals];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        cell.position.text = [NSString stringWithFormat:@"(Total Points: %@)", goals];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        cell.position.text = [NSString stringWithFormat:@"(Total Runs: %@)", goals];
    }
	
	NSInteger f = ([player_id integerValue] % 1000);
	NSString *fname = [NSString stringWithFormat:@"z%ld.png", (long)f];
	[cell.faceImage setImage:[UIImage imageNamed:fname]];
	
	return cell;
}

#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = (self.players)[indexPath.row];
	selected_clubid = [[NSString alloc] initWithString:rowData[@"club_id"]];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"View"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Club Info", nil];
	actionSheet.tag = 1;
	[actionSheet showFromTabBar:[[[Globals i].mainView leagueTabBarController] tabBar]];
	
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.players count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70*SCALE_IPAD;
}

@end
