//
//  MainCell.m
//  FFC
//
//  Created by Shankar on 8/18/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell
@synthesize mainView;
@synthesize activeSlide;
@synthesize leagueSlide;
@synthesize rankingSlide;
@synthesize nextmatchSlide;
@synthesize lastmatchSlide;
@synthesize slidesTimer;
@synthesize timerIndex;
@synthesize webView;
@synthesize fbLogoutButton;
@synthesize fbShareButton;
@synthesize achievementsBadge;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self createSlides];
    [self createWebView];
}

- (void)createWebView
{
    webView.autoresizesSubviews = YES;
    webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [webView setDelegate:self];
    NSString *urlAddress = [[NSString alloc] initWithFormat:@"%@_files/footer.html", WS_URL];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void)createAchievementBadges
{
    if (achievementsBadge == nil)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            achievementsBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", [[Globals i] getAchievementsBadge]]
                                                   withStringColor:[UIColor whiteColor]
                                                    withInsetColor:[UIColor redColor]
                                                    withBadgeFrame:YES
                                               withBadgeFrameColor:[UIColor whiteColor]
                                                         withScale:2.0
                                                       withShining:YES];
            
            [achievementsBadge setFrame:CGRectMake(322, 848, achievementsBadge.frame.size.width, achievementsBadge.frame.size.height)];
        }
        else
        {
            achievementsBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", [[Globals i] getAchievementsBadge]]
                                                   withStringColor:[UIColor whiteColor]
                                                    withInsetColor:[UIColor redColor]
                                                    withBadgeFrame:YES
                                               withBadgeFrameColor:[UIColor whiteColor]
                                                         withScale:1.0
                                                       withShining:YES];
            
            [achievementsBadge setFrame:CGRectMake(66, 507, achievementsBadge.frame.size.width, achievementsBadge.frame.size.height)];
        }
        [self insertSubview:achievementsBadge atIndex:200];
    }
}

- (void)removeAchievementBadges
{
	if(achievementsBadge != nil)
	{
		[achievementsBadge removeFromSuperview];
	}
}

- (void)updateAchievementBadges
{
    if ([[Globals i] getAchievementsBadge] > 0)
    {
        [self createAchievementBadges];
        [achievementsBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%d", [[Globals i] getAchievementsBadge]]];
        [achievementsBadge setHidden:NO];
    }
    else
    {
        [achievementsBadge setHidden:YES];
    }
}

- (void)createAssociationBadge
{
    CustomBadge *aBadge = nil;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        aBadge = [CustomBadge customBadgeWithString:@"NEW"
                                               withStringColor:[UIColor whiteColor]
                                                withInsetColor:[UIColor redColor]
                                                withBadgeFrame:YES
                                           withBadgeFrameColor:[UIColor whiteColor]
                                                     withScale:2.0
                                                   withShining:YES];
        
        [aBadge setFrame:CGRectMake(600, 10, aBadge.frame.size.width, aBadge.frame.size.height)];
    }
    else
    {
        aBadge = [CustomBadge customBadgeWithString:@"NEW"
                                               withStringColor:[UIColor whiteColor]
                                                withInsetColor:[UIColor redColor]
                                                withBadgeFrame:YES
                                           withBadgeFrameColor:[UIColor whiteColor]
                                                     withScale:1.0
                                                   withShining:YES];
        
        [aBadge setFrame:CGRectMake(250, 5, aBadge.frame.size.width, aBadge.frame.size.height)];
    }
    
    [self insertSubview:aBadge atIndex:210];
}

- (void)createSlides
{
    //Create Slides
	timerIndex = 1;
    
	leagueSlide = [[LeagueSlide alloc] initWithNibName:@"LeagueSlide" bundle:nil];
	leagueSlide.mainView = self;
	[leagueSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [leagueSlide updateView];
    
	rankingSlide = [[RankingSlide alloc] initWithNibName:@"RankingSlide" bundle:nil];
	rankingSlide.mainView = self;
	[rankingSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [rankingSlide updateView];
    
	nextmatchSlide = [[NextMatchSlide alloc] initWithNibName:@"NextMatchSlide" bundle:nil];
	nextmatchSlide.mainView = self;
	[nextmatchSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [nextmatchSlide updateView];
    
	lastmatchSlide = [[LastMatchSlide alloc] initWithNibName:@"LastMatchSlide" bundle:nil];
	lastmatchSlide.mainView = self;
	[lastmatchSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [lastmatchSlide updateView];
    
	slidesTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
	[self changeSlideNow];
}

- (void)changeSlide
{
	if (timerIndex == 5)
	{
		timerIndex = 1;
	}
	
	switch (timerIndex)
	{
		case 1:
            [lastmatchSlide.view removeFromSuperview];
			[rankingSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
			[self addSubview:rankingSlide.view];
            [rankingSlide updateView];
			activeSlide = rankingSlide.view;
			break;
		case 2:
            [rankingSlide.view removeFromSuperview];
			[leagueSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
			[self addSubview:leagueSlide.view];
            [leagueSlide updateView];
			activeSlide = leagueSlide.view;
			break;
		case 3:
            [leagueSlide.view removeFromSuperview];
			[nextmatchSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
			[self addSubview:nextmatchSlide.view];
            [nextmatchSlide updateView];
			activeSlide = nextmatchSlide.view;
			break;
		case 4:
            [nextmatchSlide.view removeFromSuperview];
			[lastmatchSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
			[self addSubview:lastmatchSlide.view];
            [lastmatchSlide updateView];
			activeSlide = lastmatchSlide.view;
			break;
	}
}

- (void)changeSlideNow
{
	[self changeSlide];
	timerIndex += 1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self changeSlideNow];
}

-(void)onTimer
{
    [self changeSlide];
    timerIndex += 1;
}

- (void)showSlide
{
    [self changeSlideNow];
    if(!slidesTimer.isValid)
    {
        slidesTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
}

- (void)hideSlide
{
    if(activeSlide != nil)
    {
        [activeSlide removeFromSuperview];
    }
}

- (IBAction)button1:(id)sender
{
    [mainView menuButton_tap:1];
}

- (IBAction)button2:(id)sender
{
    [mainView menuButton_tap:2];
}

- (IBAction)button3:(id)sender
{
    [mainView menuButton_tap:27];
}

- (IBAction)button4:(id)sender
{
    [mainView menuButton_tap:4];
}

- (IBAction)button5:(id)sender
{
    [mainView menuButton_tap:5];
}

- (IBAction)button6:(id)sender
{
    [mainView menuButton_tap:6];
}

- (IBAction)button7:(id)sender
{
    [mainView menuButton_tap:7];
}

- (IBAction)button8:(id)sender
{
    [mainView menuButton_tap:8];
}

- (IBAction)button9:(id)sender
{
    [mainView menuButton_tap:9];
}

- (IBAction)button10:(id)sender
{
    [mainView menuButton_tap:10];
}

- (IBAction)button11:(id)sender
{
    [mainView menuButton_tap:11];
}

- (IBAction)button12:(id)sender
{
    [mainView menuButton_tap:12];
}

- (IBAction)button13:(id)sender
{
    [mainView menuButton_tap:13];
}

- (IBAction)button14:(id)sender
{
    [mainView menuButton_tap:14];
}

- (IBAction)button15:(id)sender
{
    [mainView menuButton_tap:15];
}

- (IBAction)button16:(id)sender
{
    [mainView menuButton_tap:16];
}

- (IBAction)button17:(id)sender
{
    [mainView menuButton_tap:17];
}

- (IBAction)button18:(id)sender
{
    [mainView menuButton_tap:18];
}

- (IBAction)button19:(id)sender
{
    [mainView menuButton_tap:19];
}

- (IBAction)button20:(id)sender
{
    [mainView menuButton_tap:20];
}

- (IBAction)button21:(id)sender
{
    [mainView menuButton_tap:21];
}

- (IBAction)button22:(id)sender
{
    [mainView menuButton_tap:22];
}

- (IBAction)buttonCity:(id)sender
{
    [mainView menuButton_tap:23];
}

- (IBAction)buttonTrain:(id)sender
{
    [mainView menuButton_tap:24];
}

- (IBAction)buttonLogout:(id)sender
{
    [mainView menuButton_tap:25];
}

- (IBAction)buttonShare:(id)sender
{
    [mainView menuButton_tap:26];
}

@end
