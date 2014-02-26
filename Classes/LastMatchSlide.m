//
//  LastMatchSlide.m
//  FM
//
//  Created by Shankar Nathan on 3/24/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "LastMatchSlide.h"
#import "Globals.h"
#import "MainCell.h"

@implementation LastMatchSlide

- (void)viewDidLoad
{
    [self updateView];
}

- (void)updateView
{
    if([[[Globals i] getMatchPlayedData] count] > 0)
	{
		NSDictionary *rowData = [[Globals i] getMatchPlayedData][0];
		self.clubName.text = rowData[@"club_home_name"];
		self.rivalName.text = rowData[@"club_away_name"];
		self.clubScore.text = rowData[@"home_score"];
		self.rivalScore.text = rowData[@"away_score"];
		
		NSArray *chunks = [rowData[@"match_datetime"] componentsSeparatedByString: @", "];
		NSArray *chunks2 = [chunks[1] componentsSeparatedByString: @" "];
		NSString *monthfull = chunks2[0];
		NSString *monthshort = [monthfull substringWithRange:NSMakeRange(0,3)];
		NSString *daymonth = chunks2[1];
		
		self.matchMonth.text = [monthshort uppercaseString];
		self.matchDay.text = daymonth;
		
		if ([rowData[@"match_type_id"] isEqualToString:@"1"])
		{
            [self.matchtypeImage setImage:[UIImage imageNamed:@"slide_prev_league.png"]];
		}
		else if ([rowData[@"match_type_id"] isEqualToString:@"3"])
		{
            [self.matchtypeImage setImage:[UIImage imageNamed:@"slide_prev_friendly.png"]];
		}
		else
		{
            [self.matchtypeImage setImage:[UIImage imageNamed:@"slide_prev_cup.png"]];
		}
	}
	else
	{
		self.clubName.text = @"";
		self.rivalName.text = @"";
		self.clubScore.text = @"";
		self.rivalScore.text = @"";
		self.matchMonth.text = @"";
		self.matchDay.text = @"";
        [self.matchtypeImage setImage:nil];
	}
}

- (void)touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{
	[self.mainCell changeSlideNow];
}

@end
