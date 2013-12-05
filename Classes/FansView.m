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
@synthesize membersLabel;
@synthesize moodLabel;
@synthesize expectationLabel;
@synthesize sponsorLabel;

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
	
	membersLabel.text = [[Globals i] numberFormat:wsClubData[@"fan_members"]];
	moodLabel.text = [NSString stringWithFormat:@"LEVEL %ld", (long)[wsClubData[@"fan_mood"] integerValue]/10];
	expectationLabel.text = @"Do better next Season";
	
	NSString *sponsor = @"$ ";
	sponsor = [sponsor stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_sponsors"]]];
	sponsorLabel.text = sponsor;
	
	[self.view setNeedsDisplay];
}

- (IBAction)hireButton_tap:(id)sender
{
	[self confirmPurchase];
}

- (IBAction)addfunds_tap:(id)sender
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"BuyFunds"
     object:self];
}

- (void)confirmPurchase
{
    [[Globals i] settPurchasedProduct:@"5"];
    [[Globals i].mainView buyProduct:[[Globals i] getProductIdentifiers][@"staff"]];
}

@end
