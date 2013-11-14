//
//  MatchReport.m
//  FFC
//
//  Created by Shankar on 7/13/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MatchReport.h"

@implementation MatchReport
@synthesize mainView;
@synthesize matchid;
@synthesize weatherImage;
@synthesize headerLabel;
@synthesize dateLabel;
@synthesize matchReport;


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (IBAction)cancelButton_tap:(id)sender
{
	[mainView backSound];
    
    [self endMatch];
	
    [self.mainView showHeader];
	[self.mainView showFooter];
	[mainView updateHeader];
	[self.view removeFromSuperview];
}

- (void)updateView:(NSString*)MatchID
{
	matchid = [[NSString alloc] initWithString:MatchID];
	[[Globals i] showLoadingAlert:self.view];
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
	
	switch([wsMatchData[@"weather_id"] intValue])
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
		
		switch([wsMatchData[@"weather_id"] intValue])
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
	[[Globals i] removeLoadingAlert:self.view];
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
        
        int enemy_club_score = [enemy_score intValue];
        int my_club_score = [my_score intValue];
        
        NSString *extra_desc = [NSString stringWithFormat:@"There were %@ spectators and ticket sales came to $%@. ", [[Globals i] numberFormat:spectators], [[Globals i] numberFormat:ticket_sales]];
        NSString *message = @"";
        NSString *challenge_money = @"0";
        if(my_club_score == enemy_club_score) //DRAW
        {
            message = [NSString stringWithFormat:@"My Club %@ accepted %@ challenge and draw %d - %d", my_club, enemy_club, my_club_score, enemy_club_score];
        }
        if(my_club_score > enemy_club_score) //WIN
        {
            message = [NSString stringWithFormat:@"My Club %@ accepted %@ challenge and won %d - %d", my_club, enemy_club, my_club_score, enemy_club_score];
            int money_win = [[challenge_win stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
            if (money_win>0)
            {
                challenge_money = [NSString stringWithFormat:@"They paid us $%@ according to the challenge bet. ", [[Globals i] numberFormat:challenge_win]];
                extra_desc = [extra_desc stringByAppendingString:challenge_money];
            }
            [mainView winSound];
        }
        if(my_club_score < enemy_club_score) //LOSE
        {
            message = [NSString stringWithFormat:@"My Club %@ accepted %@ challenge and lose %d - %d", my_club, enemy_club, my_club_score, enemy_club_score];
            int money_lose = [[challenge_lose stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
            if (money_lose>0)
            {
                challenge_money = [NSString stringWithFormat:@"We paid them $%@ according to the challenge bet. ", [[Globals i] numberFormat:challenge_lose]];
                extra_desc = [extra_desc stringByAppendingString:challenge_money];
            }
            [mainView loseSound];
        }
        
        [self.mainView FallbackPublishStory:message:extra_desc:@"match_friendly.png"];
        
        [[Globals i] updateClubData];
        
        //Display to gamer
        if(![challenge_money isEqualToString:@"0"])
        {
            [self.mainView showAlert:GAME_NAME
                            subtitle:@"Accountant Says:"
                             message:challenge_money];
        }
    }
}


@end
