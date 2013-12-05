//
//  OverView.m
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "OverView.h"
#import "Globals.h"
#import "OverviewCell.h"
#import "OverfirstCell.h"
#import "LeagueslideCell.h"

@implementation OverView
@synthesize maxDivision;
@synthesize curDivision;
@synthesize curSeries;

- (void)updateView
{
    NSString *myDiv = [[Globals i] getClubData][@"division"];
	NSString *mySer = [[Globals i] getClubData][@"series"];
	
	curDivision = [myDiv integerValue];
	curSeries = [mySer integerValue];
    
    NSDictionary *wsSeasonData = [[Globals i] getCurrentSeasonData];
	NSString *maxDiv = wsSeasonData[@"league_divisions"];
    
    maxDivision = [maxDiv integerValue];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) //First Row
        {
            LeagueslideCell *cell = (LeagueslideCell *)[tableView dequeueReusableCellWithIdentifier: @"LeagueslideCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeagueslideCell" owner:self options:nil];
                cell = (LeagueslideCell *)nib[0];
                [[cell subviews][0] setTag:111];
            }
            
            NSDictionary *wsSeasonData = [[Globals i] getCurrentSeasonData];
            cell.leagueRound.text = wsSeasonData[@"league_round"];
            
            NSArray *chunks = [wsSeasonData[@"league_start"] componentsSeparatedByString: @", "];
            NSArray *chunks2 = [chunks[1] componentsSeparatedByString: @" "];
            NSString *monthfull = chunks2[0];
            NSString *monthshort = [monthfull substringWithRange:NSMakeRange(0,3)];
            NSString *daymonth = chunks2[1];
            
            cell.leagueStartMonth.text = [monthshort uppercaseString];
            cell.leagueStartDay.text = daymonth;
            
            chunks = [wsSeasonData[@"league_end"] componentsSeparatedByString: @", "];
            chunks2 = [chunks[1] componentsSeparatedByString: @" "];
            monthfull = chunks2[0];
            monthshort = [monthfull substringWithRange:NSMakeRange(0,3)];
            daymonth = chunks2[1];
            
            cell.leagueEndMonth.text = [monthshort uppercaseString];
            cell.leagueEndDay.text = daymonth;
            
            return cell;
        }
        if (indexPath.row == 1) //Second Row
        {
            OverfirstCell *cell = (OverfirstCell *)[tableView dequeueReusableCellWithIdentifier: @"OverfirstCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OverfirstCell" owner:self options:nil];
                cell = (OverfirstCell *)nib[0];
                [[cell subviews][0] setTag:111];
            }
            
            return cell;
        }
        else if (indexPath.row > 1)
        {
            OverviewCell *cell = (OverviewCell *)[tableView dequeueReusableCellWithIdentifier: @"OverviewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OverviewCell" owner:self options:nil];
                cell = (OverviewCell *)nib[0];
                [[cell subviews][0] setTag:112];
            }
            
            [cell.divisionLabel setText:[NSString stringWithFormat:@"Division %ld (Total Series: %ld)", (long)indexPath.row-1, (long)[[Globals i] getMaxSeries:indexPath.row-1] ]];
            if (curDivision == indexPath.row)
            {
                if (indexPath.row-1 > 5)
                {
                    [cell.markerLabel setText:@"Be Top 5 and you get promoted here"];
                }
                else
                {
                    [cell.markerLabel setText:@"Be Top 1 and you get promoted here"];
                }
            }
            else if (curDivision == indexPath.row-1)
            {
                [cell.markerLabel setText:[NSString stringWithFormat:@"Your team is here at series %ld", (long)curSeries]];
            }
            else if (curDivision == indexPath.row-2)
            {
                [cell.markerLabel setText:@"Not Top 5 you get demoted here"];
            }
            else
            {
                [cell.markerLabel setText:@""];
            }
            
            return cell;
        }
    }
    
    return Nil;
}

#pragma mark Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return maxDivision + 2;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 160*SCALE_IPAD;
    }
    else if (indexPath.row == 1)
    {
        return 460*SCALE_IPAD;
    }
    else
    {
        return 60*SCALE_IPAD;
    }
}

@end
