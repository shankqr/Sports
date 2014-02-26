//
//  NextMatchSlide.m
//  FM
//
//  Created by Shankar Nathan on 3/23/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "NextMatchSlide.h"
#import "Globals.h"
#import "MainCell.h"

@implementation NextMatchSlide

- (void)viewDidLoad 
{
    [self updateView];
}

- (void)updateView
{
    if([[[Globals i] getMatchData] count] > 0)
	{
		NSDictionary *rowData = [[Globals i] getMatchData][0];
		self.clubName.text = rowData[@"club_home_name"];
		self.rivalName.text = rowData[@"club_away_name"];
		
		NSArray *chunks = [rowData[@"match_datetime"] componentsSeparatedByString: @", "];
		NSArray *chunks2 = [chunks[1] componentsSeparatedByString: @" "];
		NSString *monthfull = chunks2[0];
		NSString *monthshort = [monthfull substringWithRange:NSMakeRange(0,3)];
		NSString *daymonth = chunks2[1];
		
		self.matchMonth.text = [monthshort uppercaseString];
		self.matchDay.text = daymonth;
		
		if ([rowData[@"match_type_id"] isEqualToString:@"1"])
		{
            [self.matchtypeImage setImage:[UIImage imageNamed:@"slide_next_league.png"]];
		}
		else
		{
            [self.matchtypeImage setImage:[UIImage imageNamed:@"slide_next_cup.png"]];
		}
	}
	else
	{
		self.clubName.text = @"";
		self.rivalName.text = @"";
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
