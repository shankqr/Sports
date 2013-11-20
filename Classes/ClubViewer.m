//
//  ClubViewer.m
//  FFC
//
//  Created by Shankar on 7/13/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "ClubViewer.h"
#import "Globals.h"
#import "MainView.h"

@implementation ClubViewer
@synthesize mainView;
@synthesize clubid;
@synthesize fb_name;
@synthesize fb_url;
@synthesize logoImage;
@synthesize homeImage;
@synthesize awayImage;
@synthesize clubNameLabel;
@synthesize foundedLabel;
@synthesize stadiumLabel;
@synthesize fansLabel;
@synthesize financeLabel;
@synthesize sponsorLabel;
@synthesize levelLabel;
@synthesize divisionLabel;
@synthesize seriesLabel;
@synthesize positionLabel;
@synthesize coachLabel;
@synthesize logo_url;
@synthesize home_url;
@synthesize away_url;

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (IBAction)closeButton_tap:(id)sender
{

}

- (void)clearView
{
	clubNameLabel.text = @"";
	foundedLabel.text = @"";
	stadiumLabel.text = @"";
	fansLabel.text = @"";
	financeLabel.text = @"";
	sponsorLabel.text = @"";
	levelLabel.text = @"";
	divisionLabel.text = @"";
	seriesLabel.text = @"";
	positionLabel.text = @"";
	coachLabel.text = @"";
	[logoImage setImage:nil];
	[homeImage setImage:nil];
	[awayImage setImage:nil];
}

- (void)updateView
{
	[self drawView];
}

- (void)updateViewId:(NSString*)ClubID
{	
	[self clearView];
	clubid = [[NSString alloc] initWithString:ClubID];
	[Globals i].selectedClubId = clubid;
	[[Globals i] showLoadingAlert];
	[NSThread detachNewThreadSelector: @selector(getClubInfoData) toTarget:self withObject:nil];
}

- (void)updateViewFb:(NSString*)fb_id
{
	[self clearView];
	fb_name = [[NSString alloc] initWithString:fb_id];
	[[Globals i] showLoadingAlert];
	[NSThread detachNewThreadSelector: @selector(getClubInfoDataFb) toTarget:self withObject:nil];
}

-(void)getClubInfoData
{
	@autoreleasepool {
	
		[[Globals i] updateClubInfoData:clubid];
		[self drawView];
		
		[[Globals i] removeLoadingAlert];
	}
}

-(void)getClubInfoDataFb
{
	@autoreleasepool {
	
		[[Globals i] updateClubInfoFb:fb_name];
		[self drawView];
		
		[[Globals i] removeLoadingAlert];
	}
}

- (void)drawView
{
	NSDictionary *wsClubData = [[Globals i] getClubInfoData];
	if(wsClubData.count > 0)
	{
		[Globals i].selectedClubId = [wsClubData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
		
		clubNameLabel.text = wsClubData[@"club_name"];
        NSString *date = wsClubData[@"date_found"];
        if ([date length] > 0)
        {
            date = [date substringToIndex:[date length] - 9];
        }
		foundedLabel.text = date;
		stadiumLabel.text = wsClubData[@"stadium"];
		fansLabel.text = [[Globals i] numberFormat:wsClubData[@"fan_members"]];
		financeLabel.text = [[Globals i] numberFormat:wsClubData[@"balance"]];
		sponsorLabel.text = [[Globals i] numberFormat:wsClubData[@"revenue_sponsors"]];
        int xp = [[wsClubData[@"xp"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
        int level = [[Globals i] levelFromXp:xp];
		levelLabel.text = [NSString stringWithFormat:@"%d", level];
		divisionLabel.text = wsClubData[@"division"];
		seriesLabel.text = wsClubData[@"series"];
		positionLabel.text = wsClubData[@"league_ranking"];
		coachLabel.text = [NSString stringWithFormat:@"LEVEL %d", [wsClubData[@"coach_id"] intValue]];
		
		logo_url = wsClubData[@"logo_pic"];
		home_url = wsClubData[@"home_pic"];
		away_url = wsClubData[@"away_pic"];
	
		[self loadLogo];
		[self loadHome];
		[self loadAway];
	}
}

- (void)loadLogo
{
	if([logo_url length] > 5)
	{
		NSURL *url = [NSURL URLWithString:logo_url];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [[UIImage alloc] initWithData:data];
		[logoImage setImage:img];
	}
	else 
	{
		NSString *fname = [NSString stringWithFormat:@"c%@.png", logo_url];
		[logoImage setImage:[UIImage imageNamed:fname]];
	}
}

- (void)loadHome
{
	if([home_url length] > 5)
	{
		NSURL *url = [NSURL URLWithString:home_url];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [[UIImage alloc] initWithData:data];
		[homeImage setImage:img];
	}
	else 
	{
		NSString *fname = [NSString stringWithFormat:@"j%@.png", home_url];
		[homeImage setImage:[UIImage imageNamed:fname]];
	}
}

- (void)loadAway
{
	if([away_url length] > 5)
	{
		NSURL *url = [NSURL URLWithString:away_url];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [[UIImage alloc] initWithData:data];
		[awayImage setImage:img];
	}
	else 
	{
		NSString *fname = [NSString stringWithFormat:@"j%@.png", away_url];
		[awayImage setImage:[UIImage imageNamed:fname]];
	}
}

- (IBAction)challengeButton_tap:(id)sender
{
	
	[mainView showChallenge:[Globals i].selectedClubId];
}

@end
