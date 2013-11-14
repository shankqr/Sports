//
//  RankingSlide.m
//  FM
//
//  Created by Shankar Nathan on 3/24/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "RankingSlide.h"
#import "Globals.h"

@implementation RankingSlide
@synthesize mainView;
@synthesize divisionLabel;
@synthesize seriesLabel;
@synthesize positionLabel;
@synthesize undefeatedLabel;


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewDidLoad
{
    [self updateView];
}

- (void)viewDidAppear:(BOOL)animated
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
	divisionLabel.text = wsClubData[@"division"];
	seriesLabel.text = wsClubData[@"series"];
	positionLabel.text = wsClubData[@"league_ranking"];
	undefeatedLabel.text = wsClubData[@"undefeated_counter"];
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
