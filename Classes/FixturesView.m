//
//  FixturesView.m
//  FFC
//
//  Created by Shankar Nathan on 5/29/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "FixturesView.h"
#import "FixtureCell.h"
#import "Globals.h"

@implementation FixturesView
@synthesize matches;
@synthesize filter;
@synthesize curDivision;
@synthesize curSeries;
@synthesize selected_clubid;

- (void)updateView
{
	if(!((self.curDivision == [[Globals i] selectedDivision])&&
	   (self.curSeries == [[Globals i] selectedSeries])))
	{
		if(!workingLeagueFixtures)
		{
			self.curDivision = [[Globals i] selectedDivision];
			self.curSeries = [[Globals i] selectedSeries];
			[[Globals i] showLoadingAlert];
			[NSThread detachNewThreadSelector: @selector(getMatchFixturesData) toTarget:self withObject:nil];
		}
	}
}

-(void)getMatchFixturesData
{
	@autoreleasepool {
	
		workingLeagueFixtures = YES;
		[[Globals i] updateMatchFixturesData:[NSString stringWithFormat:@"%d", curDivision]:[NSString stringWithFormat:@"%d", curSeries]];
		[self getTotalRound];
		[self.tableView reloadData];
		[[Globals i] removeLoadingAlert];
		workingLeagueFixtures = NO;
	
	}
}

- (void)getTotalRound
{
	totalRound = 1;
	for(NSDictionary *rowData in [[Globals i] getMatchFixturesData])
	{
		NSInteger thisRound = [rowData[@"season_week"] intValue];
		
		if(thisRound > totalRound)
		{
			totalRound = thisRound;
		}
	}
}

- (void)getTotalMatch:(NSInteger)round
{
	curRound = 0;
	for(NSDictionary *rowData in [[Globals i] getMatchFixturesData])
	{
		if([rowData[@"season_week"] isEqualToString:[NSString stringWithFormat:@"%d", round]])
		{
			curRound = curRound + 1;
		}
	}
}

- (void)applyFilter:(NSInteger)week
{
	NSMutableArray *filteredItems = [NSMutableArray array];
	for(NSDictionary *rowData in [[Globals i] getMatchFixturesData])
	{
		if([rowData[@"season_week"] isEqualToString:[NSString stringWithFormat:@"%d", week]])
		{
			[filteredItems addObject:rowData];
		}
	}
	self.matches = [NSMutableArray arrayWithArray:filteredItems];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"FixtureCell";
	FixtureCell *cell = (FixtureCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FixtureCell" owner:self options:nil];
		cell = (FixtureCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	[self applyFilter:indexPath.section + 1];
	if([self.matches count] > indexPath.row)
	{
		NSDictionary *rowData = (self.matches)[indexPath.row];
		NSArray *chunks = [rowData[@"match_datetime"] componentsSeparatedByString: @", "];
		NSString *dayweek = chunks[0];
		//NSString *dayweekshort = [dayweek substringWithRange:NSMakeRange(0,3)];
		NSArray *chunks2 = [chunks[1] componentsSeparatedByString: @" "];
		NSString *monthfull = chunks2[0];
		NSString *monthshort = [[monthfull substringWithRange:NSMakeRange(0,3)] uppercaseString];
		NSString *daymonth = chunks2[1];

		cell.matchDay.text = dayweek;
		cell.matchDate.text = daymonth;
		cell.matchMonth.text = monthshort;

		BOOL isHomeWinner = [rowData[@"club_winner"] isEqualToString:rowData[@"club_home"]];
		BOOL isAwayWinner = [rowData[@"club_winner"] isEqualToString:rowData[@"club_away"]];
		BOOL isMatchPlayed = [rowData[@"match_played"] isEqualToString:@"True"];
		
		cell.matchClubName1.text = rowData[@"club_home_name"];
		cell.matchClubName2.text = rowData[@"club_away_name"];
		
		if(isMatchPlayed)
		{
			cell.matchScore.text = [[rowData[@"home_score"] stringByAppendingString:@" - "] stringByAppendingString:rowData[@"away_score"]];
			
			if(isHomeWinner)
			{
				cell.matchClubName1.textColor = [UIColor greenColor];
				cell.matchClubName2.textColor = [UIColor redColor];
			}
			else
			{
				if(isAwayWinner)
				{
					cell.matchClubName1.textColor = [UIColor redColor];
					cell.matchClubName2.textColor = [UIColor greenColor];
				}
				else
				{
					cell.matchClubName1.textColor = [UIColor orangeColor];
					cell.matchClubName2.textColor = [UIColor orangeColor];
				}
			}
		}
		else 
		{
			cell.matchScore.text = @"vs";
		}

	}
    
    cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}

#pragma mark Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return totalRound;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	[self getTotalMatch:section + 1];
	return curRound;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [NSString stringWithFormat:@"Round %d  (Division %d Series %d)", section + 1, curDivision, curSeries];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60*SCALE_IPAD;
}

@end

