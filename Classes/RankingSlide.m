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
@synthesize mainView;
@synthesize divisionLabel;
@synthesize seriesLabel;
@synthesize positionLabel;
@synthesize undefeatedLabel;

- (void)viewDidLoad
{
    [self updateView];
}

- (void)updateView
{
    NSDictionary *wsClubData = [[Globals i] getClubData];
	divisionLabel.text = wsClubData[@"division"];
	seriesLabel.text = wsClubData[@"series"];
	positionLabel.text = wsClubData[@"league_ranking"];
	undefeatedLabel.text = wsClubData[@"undefeated_counter"];
}

- (void)touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{
	[mainView changeSlideNow];
}

@end
