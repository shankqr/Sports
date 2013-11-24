//
//  FansView.m
//  FFC
//
//  Created by Shankar Nathan on 5/27/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "FansView.h"
#import "Globals.h"
#import "MainView.h"

@implementation FansView
@synthesize mainView;
@synthesize membersLabel;
@synthesize moodLabel;
@synthesize expectationLabel;
@synthesize sponsorLabel;

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
	
	membersLabel.text = [[Globals i] numberFormat:wsClubData[@"fan_members"]];
	moodLabel.text = [NSString stringWithFormat:@"LEVEL %d", [wsClubData[@"fan_mood"] intValue]/10];
	expectationLabel.text = wsClubData[@"fan_expectation_def"];
	
	NSString *sponsor = @"$ ";
	sponsor = [sponsor stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_sponsors"]]];
	sponsorLabel.text = sponsor;
	
	[self.view setNeedsDisplay];
}

-(IBAction)hireButton_tap:(id)sender
{
	[self confirmPurchase];
}

- (IBAction)addfunds_tap:(id)sender
{
    [[Globals i] showBuy];
}

- (void)confirmPurchase
{
    [[Globals i] settPurchasedProduct:@"5"];
    [mainView buyProduct:[[Globals i] getProductIdentifiers][@"staff"]];
}

@end
