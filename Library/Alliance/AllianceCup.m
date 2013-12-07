//
//  AllianceCup.m
//  Sports
//
//  Created by Shankar on 12/6/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "AllianceCup.h"
#import "FixtureCell.h"
#import "Globals.h"

@implementation AllianceCup
@synthesize filter;
@synthesize matches;
@synthesize selected_clubid;
@synthesize curRound;
@synthesize totalRound;

- (void)updateView
{
    if ([filter isEqualToString:@"minus0"])
	{
        [[Globals i] updateAllianceCupFixturesData:[NSString stringWithFormat:@"%li", (long)curRound]];
        self.matches = [[Globals i] getAllianceCupFixturesData];
	}
	else if ([filter isEqualToString:@"minus1"])
	{
        [[Globals i] updateAllianceCupFixturesData:[NSString stringWithFormat:@"%li", (long)curRound-1]];
        self.matches = [[Globals i] getAllianceCupFixturesData];
	}
	else if ([filter isEqualToString:@"minus2"])
	{
        [[Globals i] updateAllianceCupFixturesData:[NSString stringWithFormat:@"%li", (long)curRound-2]];
		self.matches = [[Globals i] getAllianceCupFixturesData];
	}
    
	[self.tableView reloadData];
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
    
	return cell;
}

#pragma mark Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.matches count];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60*SCALE_IPAD;
}

@end
