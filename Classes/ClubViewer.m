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
@synthesize clubid;
@synthesize fb_name;
@synthesize fb_url;
@synthesize logoImage;
@synthesize homeImage;
@synthesize awayImage;
@synthesize clubNameLabel;
@synthesize allianceLabel;
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
    allianceLabel.text = @"";
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

- (void)getClubInfoData
{
	@autoreleasepool {
	
		[[Globals i] updateClubInfoData:clubid];
		[self drawView];
		
		[[Globals i] removeLoadingAlert];
	}
}

- (void)getClubInfoDataFb
{
	@autoreleasepool {
	
		[[Globals i] updateClubInfoFb:fb_name];
		[self drawView];
		
		[[Globals i] removeLoadingAlert];
	}
}

- (void)drawView
{
	NSDictionary *wsClubDict = [[Globals i] getClubInfoData];
	if(wsClubDict.count > 0)
	{
		[Globals i].selectedClubId = wsClubDict[@"club_id"];
		
		clubNameLabel.text = wsClubDict[@"club_name"];
        NSString *date = wsClubDict[@"date_found"];
        if ([date length] > 0)
        {
            date = [date substringToIndex:[date length] - 9];
        }
		foundedLabel.text = date;
		stadiumLabel.text = wsClubDict[@"stadium"];
		fansLabel.text = [[Globals i] numberFormat:wsClubDict[@"fan_members"]];
		financeLabel.text = [[Globals i] numberFormat:wsClubDict[@"balance"]];
		sponsorLabel.text = [[Globals i] numberFormat:wsClubDict[@"revenue_sponsors"]];
        NSInteger xp = [wsClubDict[@"xp"] integerValue];
        NSInteger level = [[Globals i] levelFromXp:xp];
		levelLabel.text = [NSString stringWithFormat:@"%ld", (long)level];
		divisionLabel.text = wsClubDict[@"division"];
		seriesLabel.text = wsClubDict[@"series"];
		positionLabel.text = wsClubDict[@"league_ranking"];
		coachLabel.text = [NSString stringWithFormat:@"LEVEL %ld", (long)[wsClubDict[@"coach_id"] integerValue]];
		
        if([wsClubDict[@"alliance_name"] length] > 0)
        {
            allianceLabel.text = wsClubDict[@"alliance_name"];
        }
        else
        {
            allianceLabel.text = @"Alliance: NONE";
        }
        
		logo_url = wsClubDict[@"logo_pic"];
		home_url = wsClubDict[@"home_pic"];
		away_url = wsClubDict[@"away_pic"];
	
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
	[[Globals i].mainView showChallenge:[Globals i].selectedClubId];
}

- (IBAction)mailButton_tap:(id)sender
{
    NSDictionary *wsClubDict = [[Globals i] getClubInfoData];

    NSString *isAlli = @"0";
    NSString *toID = [Globals i].selectedClubId;
    NSString *toName = wsClubDict[@"club_name"];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:isAlli forKey:@"is_alli"];
    [userInfo setObject:toID forKey:@"to_id"];
    [userInfo setObject:toName forKey:@"to_name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MailCompose"
                                                        object:self
                                                      userInfo:userInfo];
}

- (IBAction)allianceButton_tap:(id)sender
{
    NSDictionary *wsClubDict = [[Globals i] getClubInfoData];
    if([wsClubDict[@"alliance_name"] length] > 0)
    {
        NSString *aid = wsClubDict[@"alliance_id"];
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:aid forKey:@"alliance_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewAlliance"
                                                            object:self
                                                          userInfo:userInfo];
    }
    else
    {
        [UIManager.i showDialog:@"This club is not a member of any Alliance, please invite the manager to join your Alliance!"];
    }
}

@end
