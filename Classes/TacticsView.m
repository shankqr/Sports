//
//  TacticsView.m
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "TacticsView.h"
#import "Globals.h"
#import "MainView.h"

@implementation TacticsView
@synthesize mainView;
@synthesize tid;
@synthesize tacticsLogo;
@synthesize scrollView;
@synthesize pageControl;
@synthesize viewControllers;

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for(unsigned i = 0; i < TACTICS_TOTAL; i++)
	{
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
	
    //a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * TACTICS_TOTAL, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    pageControl.numberOfPages = TACTICS_TOTAL;	
}

-(void)updateView
{	
	[self showTactics];
}

- (void)loadScrollViewWithPage:(int)page 
{
    if (page < 0) return;
    if (page >= TACTICS_TOTAL) return;
	
    UIImageView *controller = viewControllers[page];
    if ((NSNull *)controller == [NSNull null])
	{
        controller = [[UIImageView alloc] init];
		CGRect frame = CGRectMake(0, 0, 225*SCALE_IPAD, 300*SCALE_IPAD);
		frame.origin.x = (scrollView.frame.size.width * page) + TacticsView_frame_offset;
		frame.origin.y = TacticsView_frame_y;
		controller.frame = frame;
        [controller setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tactic_%d.png", page]]];
		viewControllers[page] = controller;
		
		int level = [[Globals i] getLevel];
		int page1 = page+1;
		int unlocklevel = page1*page1;
		
		if(unlocklevel > level)
		{
			[scrollView addSubview:controller];
			
			UIImageView *lockedLogo = [[UIImageView alloc] init];
			CGRect frame1 = CGRectMake(0, 0, 226*SCALE_IPAD, 301*SCALE_IPAD);
			frame1.origin.x = (scrollView.frame.size.width * page) + TacticsView_frame_offset;
			frame1.origin.y = TacticsView_frame_y;
			lockedLogo.frame = frame1;
            [lockedLogo setImage:[UIImage imageNamed:@"tactic_locked.png"]];
		
			UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE_IPAD, 180*SCALE_IPAD, 205*SCALE_IPAD, 30*SCALE_IPAD)];
			myLabel.text = [NSString stringWithFormat:@"UNLOCK AT LEVEL %d", unlocklevel];
			[myLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_BIG_SIZE]];
			myLabel.backgroundColor = [UIColor clearColor];
			//myLabel.shadowColor = [UIColor grayColor];
			//myLabel.shadowOffset = CGSizeMake(1,1);
			myLabel.textColor = [UIColor whiteColor];
			myLabel.textAlignment = NSTextAlignmentCenter;
			myLabel.numberOfLines = 1;
			myLabel.adjustsFontSizeToFitWidth = YES;
			myLabel.minimumScaleFactor = 0.5f;
			[lockedLogo addSubview:myLabel];
			
			[scrollView addSubview:lockedLogo];
		}
		else 
		{
			if ([[[Globals i] getClubData][@"tactic"] intValue] != page)
			{
				UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setImage:[UIImage imageNamed:@"button_accept.png"] forState:UIControlStateNormal];
				CGRect buttonFrame = CGRectMake(65*SCALE_IPAD, 260*SCALE_IPAD, 90*SCALE_IPAD, 30*SCALE_IPAD);
				[button setFrame:buttonFrame];
				button.tag = page;
				[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			
				[controller addSubview:button];
				[controller bringSubviewToFront:button];
				[controller setUserInteractionEnabled:YES];
			}
			else 
			{
				UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(60*SCALE_IPAD, 260*SCALE_IPAD, 100*SCALE_IPAD, 30*SCALE_IPAD)];
				myLabel.text = @"USING";
				[myLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_BIG_SIZE]];
				myLabel.backgroundColor = [UIColor redColor];
				myLabel.textColor = [UIColor whiteColor];
				myLabel.textAlignment = NSTextAlignmentCenter;
				myLabel.numberOfLines = 1;
				myLabel.adjustsFontSizeToFitWidth = YES;
				myLabel.minimumScaleFactor = 0.5f;
				
				[controller addSubview:myLabel];
			}
			
			[scrollView addSubview:controller];
		}
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) 
	{
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
	// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
	[self loadScrollViewWithPage:pageControl.currentPage-1];
	[self loadScrollViewWithPage:pageControl.currentPage];
	[self loadScrollViewWithPage:pageControl.currentPage+1];
	
	CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}

- (void)showTactics
{
	pageControl.currentPage = [[[Globals i] getClubData][@"tactic"] intValue];
	[self loadScrollViewWithPage:pageControl.currentPage-1];
	[self loadScrollViewWithPage:pageControl.currentPage];
	[self loadScrollViewWithPage:pageControl.currentPage+1];
	
	CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
}

- (void)buttonPressed:(id)sender
{
    [mainView buttonSound];
    
    int rowOfButton=[sender tag];
    tid = [NSString stringWithFormat:@"%d", rowOfButton];
    [[Globals i] changeTactic:tid];
    [[Globals i] updateClubData];
		
		NSMutableArray *controllers = [[NSMutableArray alloc] init];
		for(unsigned i = 0; i < TACTICS_TOTAL; i++)
		{
			[controllers addObject:[NSNull null]];
		}
		self.viewControllers = controllers;
		
		for (UIView *view in self.scrollView.subviews)
		{
			[view removeFromSuperview];
		}
		
    [self showTactics];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
        [[Globals i] settPurchasedProduct:@"14"];
		[mainView buyProduct:[[Globals i] getProductIdentifiers][@"refill"]];
	}
}

@end
