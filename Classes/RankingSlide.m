//
//  RankingSlide.m
//  FM
//
//  Created by Shankar Nathan on 3/24/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "RankingSlide.h"
#import "Globals.h"
#import "MainCell.h"

@implementation RankingSlide

- (void)viewDidLoad
{
    [self updateView];
}

- (void)updateView
{
    NSDictionary *wsClubData = [[Globals i] getClubData];
	self.divisionLabel.text = wsClubData[@"division"];
	self.seriesLabel.text = wsClubData[@"series"];
	self.positionLabel.text = wsClubData[@"league_ranking"];
	self.undefeatedLabel.text = wsClubData[@"undefeated_counter"];
}

- (void)touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{
	[self.mainCell changeSlideNow];
}

@end
