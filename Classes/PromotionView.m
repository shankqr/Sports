//
//  PromotionView.m
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "PromotionView.h"
#import "LeagueCell.h"
#import "Globals.h"

@implementation PromotionView
@synthesize table;
@synthesize divisionLabel;
@synthesize seriesLabel;
@synthesize maxseriesLabel;
@synthesize filter;
@synthesize leagues;
@synthesize selected_clubid;
@synthesize posOffset;
@synthesize totalRow;

- (void)viewDidLoad
{
    if (UIScreen.mainScreen.bounds.size.height != 568 && !iPad)
    {
        [table setFrame:CGRectMake(0, table.frame.origin.y, 320, UIScreen.mainScreen.bounds.size.height-table.frame.origin.y)];
    }
}

- (void)updateView
{
	self.leagues = [[Globals i] getLeagueData];
	divisionLabel.text = [NSString stringWithFormat:@"%ld", (long)[Globals i].selectedDivision];
	seriesLabel.text = [NSString stringWithFormat:@"%ld", (long)[Globals i].selectedSeries];
	maxseriesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[Globals i] getMaxSeries:[Globals i].selectedDivision]];
	
	self.filter = @"Promotion";
	posOffset = 0;
	if([Globals i].selectedDivision > 5)
	{
		totalRow = [self.leagues count]/2;
	}
	else 
	{
		if([self.leagues count] > 0)
		{
			totalRow = 1;
		}
		else 
		{
			totalRow = 0;
		}

	}
	[table reloadData];
}

- (IBAction)segmentTap:(id)sender
{
	switch([sender selectedSegmentIndex])
	{
		case 0: //Promotion
		{
			
			self.filter = @"Promotion";
			posOffset = 0;
			if([Globals i].selectedDivision > 5)
			{
				totalRow = [self.leagues count]/2;
			}
			else 
			{
				if([self.leagues count] > 0)
				{
					totalRow = 1;
				}
				else 
				{
					totalRow = 0;
				}
				
			}
			[table reloadData];
			break;
		}
		case 1: //Demotion
		{
			self.filter = @"Demotion";
			posOffset = [self.leagues count]/2;
			totalRow = [self.leagues count]/2;
			[table reloadData];
			break;
		}
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"LeagueCell";
	LeagueCell *cell = (LeagueCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeagueCell" owner:self options:nil];
		cell = (LeagueCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	
	NSDictionary *rowData = (self.leagues)[row+posOffset];
	if([rowData[@"club_id"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
	{
		cell.club.textColor = [UIColor redColor];
		cell.played.textColor = [UIColor redColor];
		cell.won.textColor = [UIColor redColor];
		cell.draw.textColor = [UIColor redColor];
		cell.lost.textColor = [UIColor redColor];
		cell.goalfor.textColor = [UIColor redColor];
		cell.goalagaints.textColor = [UIColor redColor];
		cell.goaldif.textColor = [UIColor redColor];
		cell.points.textColor = [UIColor redColor];
	}
	cell.club.text = rowData[@"club_name"];
	cell.played.text = rowData[@"Played"];
	cell.won.text = rowData[@"Win"];
	cell.draw.text = rowData[@"Draw"];
	cell.lost.text = rowData[@"Lose"];
	cell.goalfor.text = rowData[@"GF"];
	cell.goalagaints.text = rowData[@"GA"];
	cell.goaldif.text = rowData[@"GD"];
	cell.points.text = rowData[@"Pts"];
    
    cell.backgroundColor = [UIColor clearColor];

	return cell;
}

#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = (self.leagues)[indexPath.row];
	if([rowData[@"club_id"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
	{
		
	}
	else
	{
		selected_clubid = [[NSString alloc] initWithString:rowData[@"club_id"]];
		NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:selected_clubid forKey:@"club_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                            object:self
                                                          userInfo:userInfo];
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return totalRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return LeagueView_cellheight;
}

@end

