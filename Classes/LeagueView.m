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
#import "MainView.h"

@implementation LeagueView
@synthesize mainView;
@synthesize table;
@synthesize divisionLabel;
@synthesize seriesLabel;
@synthesize maxseriesLabel;
@synthesize filter;
@synthesize dialogDivision;
@synthesize dialogSeries;
@synthesize leagues;
@synthesize selected_clubid;
@synthesize dialogBox;


- (void)createDialogBox
{
    if (dialogBox == nil)
    {
        dialogBox = [[DialogBoxView alloc] initWithNibName:@"DialogBoxView" bundle:nil];
        dialogBox.delegate = self;
    }
}

- (void)removeDialogBox
{
	if(dialogBox != nil)
	{
		[dialogBox.view removeFromSuperview];
	}
}

-(void)updateView
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
        divisionLabel.text = [NSString stringWithFormat:@"%d", [Globals i].selectedDivision];
        seriesLabel.text = [NSString stringWithFormat:@"%d", [Globals i].selectedSeries];
        maxseriesLabel.text = [NSString stringWithFormat:@"%d", [[Globals i] getMaxSeries:[Globals i].selectedDivision]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch(buttonIndex)
	{
		case 0: //Club Info
		{
			[mainView jumpToClubViewer:selected_clubid];
			break;
		}
        case 1: //Challenge
		{
			[mainView jumpToChallenge:selected_clubid];
			break;
		}
	}
}

-(IBAction)homeButton_tap:(id)sender
{
	if(!(([Globals i].selectedDivision == [[[Globals i] getClubData][@"division"] intValue])&&
		 ([Globals i].selectedSeries == [[[Globals i] getClubData][@"series"] intValue])))
	{	
		[[Globals i] showLoadingAlert];
		[NSThread detachNewThreadSelector: @selector(getHomeLeagueData) toTarget:self withObject:nil];
	}
}

-(IBAction)divisionButton_tap:(id)sender
{
	
    [self createDialogBox];
	dialogBox.titleText = @"Division #";
	dialogBox.whiteText = @"Please keyin a division number";
	dialogBox.dialogType = 5;
	[[[[[self.view superview] superview] superview] superview] insertSubview:dialogBox.view atIndex:7];
	[dialogBox updateView];
}

- (void)returnText:(NSString *)text
{
	NSUInteger number = [text intValue];
	
	if([dialogBox.titleText isEqualToString:@"Series #"])
	{
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
        
		[self removeDialogBox];
	}
	else 
	{
		dialogDivision = number;
		[self removeDialogBox];
		if(number > 0 && number < 1001)
		{
            [self createDialogBox];
            dialogBox.titleText = @"Series #";
            dialogBox.whiteText = [NSString stringWithFormat:@"Keyin a series number range 1 to %d", [[Globals i] getMaxSeries:dialogDivision]];
            dialogBox.dialogType = 5;
            [[[[[self.view superview] superview] superview] superview] insertSubview:dialogBox.view atIndex:7];
            [dialogBox updateView];
		}
	}
}

-(void)getHomeLeagueData
{
	@autoreleasepool {
	
		NSString *selDiv = [[Globals i] getClubData][@"division"];
		NSString *selSer = [[Globals i] getClubData][@"series"];
		
		[Globals i].selectedDivision = [selDiv intValue];
		[Globals i].selectedSeries = [selSer intValue];
		
		[[Globals i] updateLeagueData:selDiv:selSer];
		self.leagues = [[Globals i] getLeagueData];
		divisionLabel.text = [NSString stringWithFormat:@"%d", [Globals i].selectedDivision];
		seriesLabel.text = [NSString stringWithFormat:@"%d", [Globals i].selectedSeries];
		maxseriesLabel.text = [NSString stringWithFormat:@"%d", [[Globals i] getMaxSeries:[Globals i].selectedDivision]];
		[table reloadData];
		
		[[Globals i] removeLoadingAlert];
	}
}

-(void)getLeagueData
{
	@autoreleasepool {
	
		[[Globals i] updateLeagueData:[NSString stringWithFormat:@"%d", [Globals i].selectedDivision]:[NSString stringWithFormat:@"%d", [Globals i].selectedSeries]];
		self.leagues = [[Globals i] getLeagueData];
		divisionLabel.text = [NSString stringWithFormat:@"%d", [Globals i].selectedDivision];
		seriesLabel.text = [NSString stringWithFormat:@"%d", [Globals i].selectedSeries];
		maxseriesLabel.text = [NSString stringWithFormat:@"%d", [[Globals i] getMaxSeries:[Globals i].selectedDivision]];
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
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeagueCell" owner:self options:nil];
		cell = (LeagueCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	
	NSDictionary *rowData = (self.leagues)[row];
	if([rowData[@"club_id"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
	{
		cell.club.textColor = [UIColor yellowColor];
		cell.played.textColor = [UIColor yellowColor];
		cell.won.textColor = [UIColor yellowColor];
		cell.draw.textColor = [UIColor yellowColor];
		cell.lost.textColor = [UIColor yellowColor];
		cell.goalfor.textColor = [UIColor yellowColor];
		cell.goalagaints.textColor = [UIColor yellowColor];
		cell.goaldif.textColor = [UIColor yellowColor];
		cell.points.textColor = [UIColor yellowColor];
	}
	//cell.pos.text = [NSString stringWithFormat:@"%d", row+1];
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
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = (self.leagues)[indexPath.row];
	if([rowData[@"club_id"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
	{
		
	}
	else
	{
		selected_clubid = [[NSString alloc] initWithString: [rowData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
		UIActionSheet *actionSheet = [[UIActionSheet alloc]
									  initWithTitle:@"Options"
									  delegate:self
									  cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil
									  otherButtonTitles:@"Club Info", @"Challenge", nil];
		actionSheet.tag = 1;
		[actionSheet showFromTabBar:[[mainView leagueTabBarController] tabBar]];
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

