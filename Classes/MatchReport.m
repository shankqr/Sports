//
//  MatchReport.m
//  FFC
//
//  Created by Shankar on 7/13/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MatchReport.h"
#import "MainView.h"
#import "Globals.h"

@implementation MatchReport
@synthesize matchid;
@synthesize weatherImage;
@synthesize headerLabel;
@synthesize dateLabel;
@synthesize matchReport;

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    [self endMatch];
}

- (void)updateView:(NSString*)MatchID
{
	matchid = [[NSString alloc] initWithString:MatchID];
	[[Globals i] showLoadingAlert];
	[NSThread detachNewThreadSelector: @selector(getMatchInfoData) toTarget:self withObject:nil];
}

- (void)redrawView
{
	NSDictionary *wsMatchData = [[Globals i] getMatchInfoData];
	
	dateLabel.text = wsMatchData[@"match_datetime"];
	
	headerLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@",
						wsMatchData[@"club_home_name"],
						wsMatchData[@"home_score"],
						wsMatchData[@"away_score"],
						wsMatchData[@"club_away_name"]];
	
	switch([wsMatchData[@"weather_id"] integerValue])
	{
		case 0:
			[weatherImage setImage:[UIImage imageNamed:@"weather0.png"]];
			break;
		case 1:
			[weatherImage setImage:[UIImage imageNamed:@"weather1.png"]];
			break;
		case 2:
			[weatherImage setImage:[UIImage imageNamed:@"weather2.png"]];
			break;
		case 3:
			[weatherImage setImage:[UIImage imageNamed:@"weather3.png"]];
			break;
		default:
			[weatherImage setImage:[UIImage imageNamed:@"weather2.png"]];
			break;
	}
	
	NSArray *wsMatchHighlights = [[Globals i] getMatchHighlightsData];
	
	NSString *report = @"";
	for(NSDictionary *rowData in wsMatchHighlights)
	{
		NSString *highlightLine = [rowData[@"highlight"] stringByAppendingString:@" "];
		report = [report stringByAppendingString:highlightLine];
	}
	
	matchReport.text = report;
}

- (void)getMatchInfoData
{
	@autoreleasepool {
	
		[[Globals i] updateMatchInfoData:matchid];
		NSDictionary *wsMatchData = [[Globals i] getMatchInfoData];
		
		dateLabel.text = wsMatchData[@"match_datetime"];
		
		headerLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@",
							wsMatchData[@"club_home_name"],
							wsMatchData[@"home_score"],
							wsMatchData[@"away_score"],
							wsMatchData[@"club_away_name"]];
		
		switch([wsMatchData[@"weather_id"] integerValue])
		{
			case 0:
				[weatherImage setImage:[UIImage imageNamed:@"weather0.png"]];
				break;
			case 1:
				[weatherImage setImage:[UIImage imageNamed:@"weather1.png"]];
				break;
			case 2:
				[weatherImage setImage:[UIImage imageNamed:@"weather2.png"]];
				break;
			case 3:
				[weatherImage setImage:[UIImage imageNamed:@"weather3.png"]];
				break;
			default:
				[weatherImage setImage:[UIImage imageNamed:@"weather2.png"]];
				break;
		}
		
		[self performSelectorOnMainThread:@selector(setMatchReport) withObject:nil waitUntilDone:NO];
	
	}
}

- (void)setMatchReport
{
	[[Globals i] updateMatchHighlightsData:matchid];
	NSArray *wsMatchHighlights = [[Globals i] getMatchHighlightsData];
	
	NSString *report = @"";
	for(NSDictionary *rowData in wsMatchHighlights)
	{
		NSString *highlightLine = [rowData[@"highlight"] stringByAppendingString:@" "];
		report = [report stringByAppendingString:highlightLine];
	}
	
	matchReport.text = report;
	[[Globals i] removeLoadingAlert];
}

- (void)endMatch
{
	NSDictionary *wsMatchData = [[Globals i] getMatchInfoData];
    if ([wsMatchData[@"match_type_id"] isEqualToString:@"3"])
    {
        NSString *enemy_club = wsMatchData[@"club_home_name"];
        NSString *enemy_score = wsMatchData[@"home_score"];
        NSString *my_club = wsMatchData[@"club_away_name"];
        NSString *my_score = wsMatchData[@"away_score"];
        
        if([wsMatchData[@"club_home"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
        {
            enemy_club = wsMatchData[@"club_away_name"];
            enemy_score = wsMatchData[@"away_score"];
            my_club = wsMatchData[@"club_home_name"];
            my_score = wsMatchData[@"home_score"];
        }
        
        NSString *spectators = wsMatchData[@"spectators"];
        NSString *ticket_sales = wsMatchData[@"ticket_sales"];
        NSString *challenge_win = wsMatchData[@"challenge_win"];
        NSString *challenge_lose = wsMatchData[@"challenge_lose"];
        
        NSInteger enemy_club_score = [enemy_score integerValue];
        NSInteger my_club_score = [my_score integerValue];
        
        NSString *extra_desc = [NSString stringWithFormat:@"There were %@ spectators and ticket sales came to $%@. ", [[Globals i] numberFormat:spectators], [[Globals i] numberFormat:ticket_sales]];
        NSString *message = @"";
        NSString *challenge_money = @"0";
        if(my_club_score == enemy_club_score) //DRAW
        {
            message = [NSString stringWithFormat:@"My Club %@ accepted %@ challenge and draw %ld - %ld", my_club, enemy_club, (long)my_club_score, (long)enemy_club_score];
        }
        if(my_club_score > enemy_club_score) //WIN
        {
            message = [NSString stringWithFormat:@"My Club %@ accepted %@ challenge and won %ld - %ld", my_club, enemy_club, (long)my_club_score, (long)enemy_club_score];
            NSInteger money_win = [challenge_win integerValue];
            if (money_win>0)
            {
                challenge_money = [NSString stringWithFormat:@"They paid us $%@ according to the challenge bet. ", [[Globals i] numberFormat:challenge_win]];
                extra_desc = [extra_desc stringByAppendingString:challenge_money];
            }
            [[Globals i] winSound];
        }
        if(my_club_score < enemy_club_score) //LOSE
        {
            message = [NSString stringWithFormat:@"My Club %@ accepted %@ challenge and lose %ld - %ld", my_club, enemy_club, (long)my_club_score, (long)enemy_club_score];
            NSInteger money_lose = [challenge_lose integerValue];
            if (money_lose>0)
            {
                challenge_money = [NSString stringWithFormat:@"We paid them $%@ according to the challenge bet. ", [[Globals i] numberFormat:challenge_lose]];
                extra_desc = [extra_desc stringByAppendingString:challenge_money];
            }
            [[Globals i] loseSound];
        }
        
        [[Globals i] fbPublishStory:message :extra_desc :@"match_friendly.png"];
        
        [[Globals i] updateClubData]; //Money from bet, xp and level updated
        
        //Display to gamer
        if(![challenge_money isEqualToString:@"0"])
        {
            [[Globals i] showDialog:challenge_money];
        }
    }
}

@end
