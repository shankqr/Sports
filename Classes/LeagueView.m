//
//  LeagueView.m
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "LeagueView.h"
#import "LeagueCell.h"
#import "Globals.h"

@implementation LeagueView
@synthesize table;
@synthesize divisionLabel;
@synthesize seriesLabel;
@synthesize maxseriesLabel;
@synthesize dialogDivision;
@synthesize dialogSeries;
@synthesize leagues;
@synthesize selected_clubid;

- (void)updateView
{
    if (UIScreen.mainScreen.bounds.size.height != 568 && !iPad)
    {
        [table setFrame:CGRectMake(0, table.frame.origin.y, 320, UIScreen.mainScreen.bounds.size.height-table.frame.origin.y)];
    }
    
	if(([Globals i].selectedDivision == 0)&&([Globals i].selectedSeries == 0))
	{	
		[[Globals i] showLoadingAlert];
		[NSThread detachNewThreadSelector: @selector(getHomeLeagueData) toTarget:self withObject:nil];
	}
    else
    {
        divisionLabel.text = [NSString stringWithFormat:@"%ld", (long)[Globals i].selectedDivision];
        seriesLabel.text = [NSString stringWithFormat:@"%ld", (long)[Globals i].selectedSeries];
        maxseriesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[Globals i] getMaxSeries:[Globals i].selectedDivision]];
    }
}

- (IBAction)homeButton_tap:(id)sender
{
	if(!(([Globals i].selectedDivision == [[[Globals i] getClubData][@"division"] integerValue])&&
		 ([Globals i].selectedSeries == [[[Globals i] getClubData][@"series"] integerValue])))
	{	
		[[Globals i] showLoadingAlert];
		[NSThread detachNewThreadSelector: @selector(getHomeLeagueData) toTarget:self withObject:nil];
	}
}

- (IBAction)divisionButton_tap:(id)sender
{
    [[Globals i] showDialogBlock:@"Enter a Division number:"
                                :5
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //OK button is clicked
         {
             NSInteger number = [text integerValue];
             dialogDivision = number;
             if(number > 0 && number < 1001)
             {
                 NSString *dt = [NSString stringWithFormat:@"Enter a Series number range 1 to %ld", (long)[[Globals i] getMaxSeries:dialogDivision]];
                 
                 [[Globals i] showDialogBlock:dt
                                             :5
                                             :^(NSInteger index, NSString *text)
                  {
                      if (index == 1) //OK button is clicked
                      {
                          NSInteger number = [text integerValue];
                          if(number > 0 && number < [[Globals i] getMaxSeries:dialogDivision]+1)
                          {
                              dialogSeries = number;
                              if(!(([Globals i].selectedDivision == dialogDivision)&&
                                   ([Globals i].selectedSeries == dialogSeries)))
                              {
                                  [[Globals i] showLoadingAlert];
                                  [Globals i].selectedDivision = dialogDivision;
                                  [Globals i].selectedSeries = dialogSeries;
                                  [NSThread detachNewThreadSelector: @selector(getLeagueData) toTarget:self withObject:nil];
                              }
                          }
                      }
                  }];
             }
             
         }
     }];
}

- (void)getHomeLeagueData
{
	@autoreleasepool {
	
		NSString *selDiv = [[Globals i] getClubData][@"division"];
		NSString *selSer = [[Globals i] getClubData][@"series"];
		
		[Globals i].selectedDivision = [selDiv integerValue];
		[Globals i].selectedSeries = [selSer integerValue];
		
		[[Globals i] updateLeagueData:selDiv:selSer];
		self.leagues = [[Globals i] getLeagueData];
		divisionLabel.text = [NSString stringWithFormat:@"%ld", (long)[Globals i].selectedDivision];
		seriesLabel.text = [NSString stringWithFormat:@"%ld", (long)[Globals i].selectedSeries];
		maxseriesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[Globals i] getMaxSeries:[Globals i].selectedDivision]];
		[table reloadData];
		
		[[Globals i] removeLoadingAlert];
	}
}

- (void)getLeagueData
{
	@autoreleasepool {
	
		[[Globals i] updateLeagueData:[NSString stringWithFormat:@"%ld", (long)[Globals i].selectedDivision]:[NSString stringWithFormat:@"%ld", (long)[Globals i].selectedSeries]];
		self.leagues = [[Globals i] getLeagueData];
		divisionLabel.text = [NSString stringWithFormat:@"%ld", (long)[Globals i].selectedDivision];
		seriesLabel.text = [NSString stringWithFormat:@"%ld", (long)[Globals i].selectedSeries];
		maxseriesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[Globals i] getMaxSeries:[Globals i].selectedDivision]];
		[table reloadData];
		
		[[Globals i] removeLoadingAlert];
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"LeagueCell";
	LeagueCell *cell = (LeagueCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
        NSString *nibName = @"LeagueCell";
        
        if ([[[Globals i] GameType] isEqualToString:@"football"])
        {
            nibName = @"LeagueCell";
        }
        else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
        {
            nibName = @"LeagueCell";
        }
        else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
        {
            nibName = @"LeagueCell_baseball";
        }
        else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
        {
            nibName = @"LeagueCell_baseball";
        }
        
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
		cell = (LeagueCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	
	NSDictionary *rowData = (self.leagues)[row];
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
	//cell.pos.text = [NSString stringWithFormat:@"%ld", row+1];
	cell.club.text = rowData[@"club_name"];
	cell.played.text = rowData[@"Played"];
	cell.won.text = rowData[@"Win"];
	cell.draw.text = rowData[@"Draw"];
	cell.lost.text = rowData[@"Lose"];
	cell.goalagaints.text = rowData[@"GA"];
	cell.goalfor.text = rowData[@"GF"];
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
	return [self.leagues count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return LeagueView_cellheight;
}

@end

