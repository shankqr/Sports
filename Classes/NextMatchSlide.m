//
//  NextMatchSlide.m
//  FM
//
//  Created by Shankar Nathan on 3/23/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "NextMatchSlide.h"
#import "Globals.h"

@implementation NextMatchSlide
@synthesize mainView;
@synthesize matchtypeImage;
@synthesize clubName;
@synthesize rivalName;
@synthesize matchMonth;
@synthesize matchDay;



- (void)viewDidLoad 
{
    [self updateView];
	
    [super viewDidLoad];
}

- (void)updateView
{
    if([[[Globals i] getMatchData] count] > 0)
	{
		NSDictionary *rowData = [[Globals i] getMatchData][0];
		clubName.text = rowData[@"club_home_name"];
		rivalName.text = rowData[@"club_away_name"];
		
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
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_next_league.png"]];
            }
            else
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_next_league.png"]];
            }
		}
		else if ([rowData[@"match_type_id"] isEqualToString:@"2"])
		{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_next_cup.png"]];
            }
            else
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_next_cup.png"]];
            }
		}
		else
		{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_next_friendly.png"]];
            }
            else
            {
                [matchtypeImage setImage:[UIImage imageNamed:@"slide_next_friendly.png"]];
            }
		}
	}
	else
	{
		clubName.text = @"UNKNOWN FC";
		rivalName.text = @"UNKNOWN FC";
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
