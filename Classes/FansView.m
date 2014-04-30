//
//  FansView.m
//  FFC
//
//  Created by Shankar Nathan on 5/27/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "FansView.h"
#import "Globals.h"

@implementation FansView
@synthesize membersLabel;
@synthesize moodLabel;
@synthesize expectationLabel;
@synthesize sponsorLabel;

- (void)updateView
{
	NSDictionary *wsClubDict = [[Globals i] getClubData];
	
	membersLabel.text = [[Globals i] numberFormat:wsClubDict[@"fan_members"]];
	moodLabel.text = [NSString stringWithFormat:@"LEVEL %ld", (long)[wsClubDict[@"fan_mood"] integerValue]/10];
	expectationLabel.text = @"Do better next Season";
	
	NSString *sponsor = @"$ ";
	sponsor = [sponsor stringByAppendingString:[[Globals i] numberFormat:wsClubDict[@"revenue_sponsors"]]];
	sponsorLabel.text = sponsor;
	
	[self.view setNeedsDisplay];
}

@end
