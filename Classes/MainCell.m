//
//  MainCell.m
//  FFC
//
//  Created by Shankar on 8/18/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

#import "MainCell.h"
#import "Globals.h"
#import "MainView.h"
#import "LeagueSlide.h"
#import "NextMatchSlide.h"
#import "RankingSlide.h"
#import "LastMatchSlide.h"
#import "CustomBadge.h"

@implementation MainCell

@synthesize activeSlide;
@synthesize leagueSlide;
@synthesize rankingSlide;
@synthesize nextmatchSlide;
@synthesize lastmatchSlide;
@synthesize slidesTimer;
@synthesize timerIndex;
@synthesize achievementsBadge;
@synthesize mailBadge;

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
    [self setBackgroundColor:[UIColor clearColor]];
    
    if(!slidesTimer.isValid)
    {
        [self createSlides];
        [self createButtons];
    }
}

- (void)createAchievementBadges
{
    if (achievementsBadge == nil)
    {
        achievementsBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%ld", (long)[[Globals i] getAchievementsBadge]]
                                               withStringColor:[UIColor whiteColor]
                                                withInsetColor:[UIColor redColor]
                                                withBadgeFrame:YES
                                           withBadgeFrameColor:[UIColor whiteColor]
                                                     withScale:SCALE_IPAD
                                                   withShining:YES];
        
        [achievementsBadge setFrame:[self getBadgeFrame:12 width:achievementsBadge.frame.size.width height:achievementsBadge.frame.size.height]];
        
        [self addSubview:achievementsBadge];
        [achievementsBadge bringSubviewToFront:self];
    }
}

- (void)updateAchievementBadges
{
    if ([[Globals i] getAchievementsBadge] > 0)
    {
        [self createAchievementBadges];
        [achievementsBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%ld", (long)[[Globals i] getAchievementsBadge]]];
        [achievementsBadge setHidden:NO];
    }
    else
    {
        [achievementsBadge setHidden:YES];
    }
}

- (void)createMailBadges
{
    if (mailBadge == nil)
    {
        mailBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%ld", (long)[[Globals i] getMailBadgeNumber]]
                                               withStringColor:[UIColor whiteColor]
                                                withInsetColor:[UIColor redColor]
                                                withBadgeFrame:YES
                                           withBadgeFrameColor:[UIColor whiteColor]
                                                     withScale:SCALE_IPAD
                                                   withShining:YES];
        
        [mailBadge setFrame:[self getBadgeFrame:1 width:mailBadge.frame.size.width height:mailBadge.frame.size.height]];
        
        [self addSubview:mailBadge];
        [mailBadge bringSubviewToFront:self];
    }
}

- (void)updateMailBadges
{
    if ([[Globals i] getMailBadgeNumber] > 0)
    {
        [self createMailBadges];
        [mailBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%ld", (long)[[Globals i] getMailBadgeNumber]]];
        [mailBadge setHidden:NO];
    }
    else
    {
        [mailBadge setHidden:YES];
    }
}

- (void)createSlides
{
    //Create Slides
	timerIndex = 1;
    
	leagueSlide = [[LeagueSlide alloc] initWithNibName:@"LeagueSlide" bundle:nil];
	leagueSlide.mainCell = self;
	[leagueSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [leagueSlide updateView];
    
	rankingSlide = [[RankingSlide alloc] initWithNibName:@"RankingSlide" bundle:nil];
	rankingSlide.mainCell = self;
	[rankingSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [rankingSlide updateView];
    
	nextmatchSlide = [[NextMatchSlide alloc] initWithNibName:@"NextMatchSlide" bundle:nil];
	nextmatchSlide.mainCell = self;
	[nextmatchSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [nextmatchSlide updateView];
    
	lastmatchSlide = [[LastMatchSlide alloc] initWithNibName:@"LastMatchSlide" bundle:nil];
	lastmatchSlide.mainCell = self;
	[lastmatchSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [lastmatchSlide updateView];
    
    if(!slidesTimer.isValid)
    {
        slidesTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    
    //[self changeSlideNow];
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

- (void)createButtons
{
    [self addPosButton:@"News" tag:1 imageDefault:@"button_mails"];
	[self addPosButton:@"Squad" tag:2 imageDefault:@"button_squad"];
	[self addPosButton:@"Formations" tag:3 imageDefault:@"button_tactics"];
	[self addPosButton:@"Training" tag:4 imageDefault:@"button_train"];
	[self addPosButton:@"Fixtures" tag:5 imageDefault:@"button_match"];
    [self addPosButton:@"League" tag:6 imageDefault:@"button_league"];
	[self addPosButton:@"Cup" tag:7 imageDefault:@"button_cup"];
	[self addPosButton:@"Transfers" tag:8 imageDefault:@"button_transfer"];
	[self addPosButton:@"Finances" tag:9 imageDefault:@"button_finance"];
	[self addPosButton:@"Stadium" tag:10 imageDefault:@"button_city"];
    [self addPosButton:@"Club" tag:11 imageDefault:@"button_club"];
	[self addPosButton:@"Awards" tag:12 imageDefault:@"button_achievements"];
	[self addPosButton:@"Club Store" tag:13 imageDefault:@"button_store"];
	[self addPosButton:@"Coach" tag:14 imageDefault:@"button_coach"];
	[self addPosButton:@"Staff" tag:15 imageDefault:@"button_staff"];
    [self addPosButton:@"Fans" tag:16 imageDefault:@"button_fan"];
	[self addPosButton:@"World Map" tag:17 imageDefault:@"button_map"];
	[self addPosButton:@"Ranking" tag:18 imageDefault:@"button_leaderboard"];
	[self addPosButton:@"More Games" tag:19 imageDefault:@"button_friends"];
	[self addPosButton:@"Help" tag:20 imageDefault:@"button_help"];
    [self addPosButton:@"Logout" tag:21 imageDefault:@"button_news"];
}

- (CGRect)getBadgeFrame:(NSInteger)tag
                  width:(NSInteger)width
                 height:(NSInteger)height
{
    UIImage *imgD = [UIImage imageNamed:@"button_mails"];
    
    NSInteger sizex = (imgD.size.width*SCALE_IPAD/2);
    NSInteger sizey = (imgD.size.height*SCALE_IPAD/2);
    
    NSInteger column_width = self.frame.size.width / buttons_per_row;
    NSInteger column_start_x = (column_width - sizex) / 2;
    NSInteger column_height = sizey + menu_label_height + menu_margin_y;
    
    NSInteger button_col = ((tag-1) % buttons_per_row);
    NSInteger posx = button_col * column_width + column_start_x;
    
    NSInteger button_row = ((tag-1) / buttons_per_row);
    NSInteger posy = button_row * column_height + menu_start_y;
    
    return CGRectMake(posx-CELL_CONTENT_SPACING, posy-CELL_CONTENT_SPACING, width, height);
}

- (void)addPosButton:(NSString *)label
				 tag:(NSInteger)tag
        imageDefault:(NSString *)imageDefault
{
    UIImage *imgD = [UIImage imageNamed:imageDefault];
    UIImage *imgH = nil;
    
    NSInteger sizex = (imgD.size.width*SCALE_IPAD/2);
    NSInteger sizey = (imgD.size.height*SCALE_IPAD/2);
    
    NSInteger column_width = self.frame.size.width / buttons_per_row;
    NSInteger column_start_x = (column_width - sizex) / 2;
    NSInteger column_height = sizey + menu_label_height + menu_margin_y;
    
    NSInteger button_col = ((tag-1) % buttons_per_row);
    NSInteger posx = button_col * column_width + column_start_x;
    
    NSInteger button_row = ((tag-1) / buttons_per_row);
    NSInteger posy = button_row * column_height + menu_start_y;
    
	UIButton *button = [[Globals i] buttonWithTitle:@""
                                             target:self
                                           selector:@selector(posButton_tap:)
                                              frame:CGRectMake(posx, posy, sizex, sizey)
                                              image:imgD
                                       imagePressed:imgH
                                      darkTextColor:YES];
    
	button.tag = tag;
	[self addSubview:button];
	
	UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx-column_start_x, posy+sizey, column_width, menu_label_height)];
	myLabel.tag = tag;
	myLabel.text = label;
    myLabel.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
	myLabel.backgroundColor = [UIColor clearColor];
	myLabel.shadowColor = [UIColor grayColor];
	myLabel.shadowOffset = CGSizeMake(1,1);
	myLabel.textColor = [UIColor whiteColor];
	myLabel.textAlignment = NSTextAlignmentCenter;
	myLabel.numberOfLines = 1;
	myLabel.adjustsFontSizeToFitWidth = YES;
	myLabel.minimumScaleFactor = 0.5f;
	[self addSubview:myLabel];
}

- (void)posButton_tap:(id)sender
{
	NSInteger theTag = [sender tag];
	[[Globals i].mainView menuButton_tap:theTag];
}

@end
