//
//  Match.m
//  FFC
//
//  Created by Shankar on 4/2/09.
//  Copyright 2010 Tapfantasy. All rights reserved.	
//

#import "MatchView.h"
#import "MainView.h"
#import "MatchCell.h"
#import "Globals.h"
#import "ChallengeView.h"

@implementation MatchView
@synthesize mainView;
@synthesize matches;
@synthesize filter;
@synthesize selected_clubid;
@synthesize selected_matchid;
@synthesize matchLive;
@synthesize challengeBox;

- (void)updateView
{
	if ([filter isEqualToString:@"Future"])
	{
        self.matches = [[Globals i] getMatchData];
	}
	else if ([filter isEqualToString:@"Played"])
	{
        self.matches = [[Globals i] getMatchPlayedData];
	}
	else if ([filter isEqualToString:@"Challenge"])
	{
        [[Globals i] updateChallengesData];
		self.matches = [[Globals i] getChallengesData];
	}
    
	[self.tableView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch(actionSheet.tag)
	{
		case 1: //Upcoming
		{
			switch(buttonIndex)
			{
				case 0:
				{
					[mainView showClubViewer:selected_clubid];
					break;
				}
                case 1: //Challenge
                {
                    [mainView showChallenge:selected_clubid];
                    break;
                }
			}
			break;	
		}
			
		case 2: //Played
		{
			switch(buttonIndex)
			{
				case 0:
				{
					[mainView showClubViewer:selected_clubid];
					break;
				}
				case 1: //Match Report
				{
                    [Globals i].challengeMatchId = selected_matchid;
                    [mainView reportMatch];
					break;
				}
			}
			break;	
		}
			
		case 3: //Challenge
		{
			switch(buttonIndex)
			{
				case 0:
				{
					[mainView showClubViewer:selected_clubid];
					break;
				}
				case 1: //View challenge
				{
					[Globals i].challengeMatchId = selected_matchid;
                    if (challengeBox == nil) 
                    {
                        challengeBox = [[ChallengeView alloc] initWithNibName:@"ChallengeView" bundle:nil];
                        challengeBox.mainView = self.mainView;
                    }
					[[Globals i] showTemplate:@[challengeBox] :@"Challenge" :0];
					[challengeBox viewChallenge:selected_row];
					break;
				}
			}
			break;	
		}

	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"MatchCell";
	MatchCell *cell = (MatchCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MatchCell" owner:self options:nil];
		cell = (MatchCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.matches)[row];
	
	BOOL isHome = [rowData[@"club_home"] isEqualToString:[[Globals i] getClubData][@"club_id"]];
	
	if ([filter isEqualToString:@"Played"]) 
	{
		CGRect frame = CGRectMake(MatchView_frame_x, 18*SCALE_IPAD, MatchView_frame_width, 21*SCALE_IPAD);
		UILabel* label = [[UILabel alloc] initWithFrame:frame];
		label.numberOfLines = 1;
		label.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_BIG_SIZE];
		label.backgroundColor = [UIColor clearColor];
		
		CGRect frame2 = CGRectMake(MatchView_frame2_x, 18*SCALE_IPAD, MatchView_frame2_width, 21*SCALE_IPAD);
		UILabel* label2 = [[UILabel alloc] initWithFrame:frame2];
		label2.numberOfLines = 1;
		label2.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_BIG_SIZE];
		label2.backgroundColor = [UIColor clearColor];
		label2.adjustsFontSizeToFitWidth = YES;
		label2.minimumScaleFactor = 0.5f;
		
		CGRect frame1 = CGRectMake(MatchView_frame1_x, MatchView_frame1_y, 100*SCALE_IPAD, 16*SCALE_IPAD);
		UILabel* label1 = [[UILabel alloc] initWithFrame:frame1];
		label1.numberOfLines = 1;
		label1.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
		label1.backgroundColor = [UIColor clearColor];
		
		if(isHome)
		{
			label.text = [[rowData[@"home_score"] stringByAppendingString:@"-"] stringByAppendingString:rowData[@"away_score"]];
			label2.text = rowData[@"club_away_name"];
			
			if ([rowData[@"home_score"] integerValue] > [rowData[@"away_score"] integerValue]) 
			{
				label.textColor = [UIColor greenColor];
				label1.textColor = [UIColor greenColor];
				label1.text = @"WIN";
			}
			else if ([rowData[@"home_score"] integerValue] == [rowData[@"away_score"] integerValue])
			{
				label.textColor = [UIColor yellowColor];
				label1.textColor = [UIColor yellowColor];
				label1.text = @"DRAW";
			}
			else 
			{
				label.textColor = [UIColor redColor];
				label1.textColor = [UIColor redColor];
				label1.text = @"LOSE";
			}

		}
		else
		{
			label.text = [[rowData[@"away_score"] stringByAppendingString:@"-"] stringByAppendingString:rowData[@"home_score"]];
			label2.text = rowData[@"club_home_name"];
			
			if ([rowData[@"away_score"] integerValue] > [rowData[@"home_score"] integerValue]) 
			{
				label.textColor = [UIColor greenColor];
				label1.textColor = [UIColor greenColor];
				label1.text = @"WIN";
			}
			else if ([rowData[@"home_score"] integerValue] == [rowData[@"away_score"] integerValue])
			{
				label.textColor = [UIColor yellowColor];
				label1.textColor = [UIColor yellowColor];
				label1.text = @"DRAW";
			}
			else 
			{
				label.textColor = [UIColor redColor];
				label1.textColor = [UIColor redColor];
				label1.text = @"LOSE";
			}
		}
		
		[cell addSubview:label];
		[cell addSubview:label1];
		[cell addSubview:label2];
	}
	else 
	{
		if(isHome)
		{
			cell.matchClubName1.text = rowData[@"club_away_name"];
		}
		else
		{
			cell.matchClubName1.text = rowData[@"club_home_name"];
		}
	}
	
	if ([rowData[@"match_type_id"] isEqualToString:@"1"]) 
	{
        [cell.matchClubLogo1 setImage:[UIImage imageNamed:@"matchleague.png"]];
	}
	else if ([rowData[@"match_type_id"] isEqualToString:@"2"]) 
	{
        [cell.matchClubLogo1 setImage:[UIImage imageNamed:@"matchcup.png"]];
	}
	else if ([rowData[@"match_type_id"] isEqualToString:@"3"])
	{
        [cell.matchClubLogo1 setImage:[UIImage imageNamed:@"matchfriendly.png"]];
	}
    else
	{
        [cell.matchClubLogo1 setImage:[UIImage imageNamed:@"matchstar.png"]];
	}
	
	NSArray *chunks;
	if ([filter isEqualToString:@"Challenge"] || [filter isEqualToString:@"Invite"])
	{
		chunks = [rowData[@"challenge_datetime"] componentsSeparatedByString: @", "];
	}
	else
	{
		chunks = [rowData[@"match_datetime"] componentsSeparatedByString: @", "];
	}
	
	NSString *dayweek = chunks[0];
	//NSString *dayweekshort = [dayweek substringWithRange:NSMakeRange(0,3)];
	NSArray *chunks2 = [chunks[1] componentsSeparatedByString: @" "];
	NSString *monthfull = chunks2[0];
	NSString *monthshort = [monthfull substringWithRange:NSMakeRange(0,3)];
	NSString *daymonth = chunks2[1];
	//NSString *year = [chunks objectAtIndex: 2];
	
	cell.matchDay.text = dayweek;
	cell.matchDate.text = daymonth;
	cell.matchMonth.text = [monthshort uppercaseString];
	
	return cell;
}

#pragma mark Table View Delegate Methods
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = (self.matches)[indexPath.row];
	BOOL isHome = [rowData[@"club_home"] isEqualToString:[[Globals i] getClubData][@"club_id"]];
	if(isHome)
	{
		selected_clubid = [[NSString alloc] initWithString: [rowData[@"club_away"] stringByReplacingOccurrencesOfString:@"," withString:@""]];	
	}
	else
	{
		selected_clubid = [[NSString alloc] initWithString: [rowData[@"club_home"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
	}
	
	selected_matchid = [[NSString alloc] initWithString: [rowData[@"match_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
	
    selected_row = indexPath.row;
    
	if ([filter isEqualToString:@"Future"]) 
	{
		UIActionSheet *actionSheet = [[UIActionSheet alloc]
									  initWithTitle:@"Options"
									  delegate:self
									  cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil
									  otherButtonTitles:@"Club Info", @"Challenge", nil];
		actionSheet.tag = 1;
		[actionSheet showInView:self.view];
	}
	else if ([filter isEqualToString:@"Played"]) 
	{
		UIActionSheet *actionSheet = [[UIActionSheet alloc]
									  initWithTitle:@"View"
									  delegate:self
									  cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil
									  otherButtonTitles:@"Club Info", @"Match Report", nil];
		actionSheet.tag = 2;
		[actionSheet showInView:self.view];
	}
	else if ([filter isEqualToString:@"Challenge"]) 
	{
		UIActionSheet *actionSheet = [[UIActionSheet alloc]
									  initWithTitle:@"View"
									  delegate:self
									  cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil
									  otherButtonTitles:@"Club Info", @"View Challenge", nil];
		actionSheet.tag = 3;
		[actionSheet showInView:self.view];
	}
	
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.matches count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60*SCALE_IPAD;
}

@end
