//
//  LeagueSlide.m
//  FM
//
//  Created by Shankar Nathan on 3/24/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "LeagueSlide.h"
#import "Globals.h"
#import "MainCell.h"

@implementation LeagueSlide

- (void)viewDidLoad
{
    [self updateView];
}

- (void)updateView
{
    NSDictionary *wsSeasonData = [[Globals i] getCurrentSeasonData];
	self.leagueRound.text = wsSeasonData[@"league_round"];
	
	NSArray *chunks = [wsSeasonData[@"league_start"] componentsSeparatedByString: @", "];
	NSArray *chunks2 = [chunks[1] componentsSeparatedByString: @" "];
	NSString *monthfull = chunks2[0];
	NSString *monthshort = [monthfull substringWithRange:NSMakeRange(0,3)];
	NSString *daymonth = chunks2[1];
	
	self.leagueStartMonth.text = [monthshort uppercaseString];
	self.leagueStartDay.text = daymonth;
	
	chunks = [wsSeasonData[@"league_end"] componentsSeparatedByString: @", "];
	chunks2 = [chunks[1] componentsSeparatedByString: @" "];
	monthfull = chunks2[0];
	monthshort = [monthfull substringWithRange:NSMakeRange(0,3)];
	daymonth = chunks2[1];
	
	self.leagueEndMonth.text = [monthshort uppercaseString];
	self.leagueEndDay.text = daymonth;
}

- (void)touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{
	[self.mainCell changeSlideNow];
}

@end
