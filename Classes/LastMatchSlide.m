//
//  LastMatchSlide.m
//  FM
//
//  Created by Shankar Nathan on 3/24/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "LastMatchSlide.h"
#import "Globals.h"

@implementation LastMatchSlide
@synthesize mainView;
@synthesize matchtypeImage;
@synthesize clubName;
@synthesize rivalName;
@synthesize matchMonth;
@synthesize matchDay;
@synthesize clubScore;
@synthesize rivalScore;


- (void)viewDidLoad
{
    [self updateView];
	
	[super viewDidLoad];
}

- (void)updateView
{
    if([[[Globals i] getMatchPlayedData] count] > 0)
	{
		NSDictionary *rowData = [[Globals i] getMatchPlayedData][0];
		clubName.text = rowData[@"club_home_name"];
		rivalName.text = rowData[@"club_away_name"];
		clubScore.text = rowData[@"home_score"];
		rivalScore.text = rowData[@"away_score"];
		
		NSArray *chunks = [rowData[@"match_datetime"] componentsSeparatedByString: @", "];
		NSArray *chunks2 = [chunks[1] componentsSeparatedByString: @" "];
		NSString *monthfull = chunks2[0];
		NSString *monthshort = [monthfull substringWithRange:NSMakeRange(0,3)];
		NSString *daymonth = chunks2[1];
		
		matchMonth.text = [monthshort uppercaseString];
		matchDay.text = daymonth;
		
		if ([rowData[@"match_type_id"] isEqualToString:@"1"])
		{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_prev_league.png"]];
            }
            else
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_prev_league.png"]];
            }
		}
		else if ([rowData[@"match_type_id"] isEqualToString:@"2"])
		{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_prev_cup.png"]];
            }
            else
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_prev_cup.png"]];
            }
		}
		else
		{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_prev_friendly.png"]];
            }
            else
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_prev_friendly.png"]];
            }
		}
	}
	else
	{
		clubName.text = @"UNKNOWN FC";
		rivalName.text = @"UNKNOWN FC";
		clubScore.text = @"0";
		rivalScore.text = @"0";
		matchMonth.text = @"JAN";
		matchDay.text = @"1";
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{
	[mainView changeSlideNow];
}

@end
