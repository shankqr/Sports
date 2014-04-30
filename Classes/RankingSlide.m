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
    NSDictionary *wsClubDict = [[Globals i] getClubData];
	self.divisionLabel.text = wsClubDict[@"division"];
	self.seriesLabel.text = wsClubDict[@"series"];
	self.positionLabel.text = wsClubDict[@"league_ranking"];
	self.undefeatedLabel.text = wsClubDict[@"undefeated_counter"];
}

- (void)touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{
	[self.mainCell changeSlideNow];
}

@end
