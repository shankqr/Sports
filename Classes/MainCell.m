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
    
    if(!self.slidesTimer.isValid)
    {
        [self createSlides];
        [self createButtons];
    }
}

- (void)createAchievementBadges
{
    if (self.achievementsBadge == nil)
    {
        self.achievementsBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%ld", (long)[[Globals i] getAchievementsBadge]]
                                               withStringColor:[UIColor whiteColor]
                                                withInsetColor:[UIColor redColor]
                                                withBadgeFrame:YES
                                           withBadgeFrameColor:[UIColor whiteColor]
                                                     withScale:SCALE_IPAD
                                                   withShining:YES];
        
        [self.achievementsBadge setFrame:[self getBadgeFrame:2 width:self.achievementsBadge.frame.size.width height:self.achievementsBadge.frame.size.height]];
        
        [self addSubview:self.achievementsBadge];
        [self.achievementsBadge bringSubviewToFront:self];
    }
}

- (void)updateAchievementBadges
{
    if ([[Globals i] getAchievementsBadge] > 0)
    {
        [self createAchievementBadges];
        [self.achievementsBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%ld", (long)[[Globals i] getAchievementsBadge]]];
        [self.achievementsBadge setHidden:NO];
    }
    else
    {
        [self.achievementsBadge setHidden:YES];
    }
}

- (void)createMailBadges
{
    if (self.mailBadge == nil)
    {
        self.mailBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%ld", (long)[[Globals i] getMailBadgeNumber]]
                                               withStringColor:[UIColor whiteColor]
                                                withInsetColor:[UIColor redColor]
                                                withBadgeFrame:YES
                                           withBadgeFrameColor:[UIColor whiteColor]
                                                     withScale:SCALE_IPAD
                                                   withShining:YES];
        
        [self.mailBadge setFrame:[self getBadgeFrame:1 width:self.mailBadge.frame.size.width height:self.mailBadge.frame.size.height]];
        
        [self addSubview:self.mailBadge];
        [self.mailBadge bringSubviewToFront:self];
    }
}

- (void)updateMailBadges
{
    if ([[Globals i] getMailBadgeNumber] > 0)
    {
        [self createMailBadges];
        [self.mailBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%ld", (long)[[Globals i] getMailBadgeNumber]]];
        [self.mailBadge setHidden:NO];
    }
    else
    {
        [self.mailBadge setHidden:YES];
    }
}

- (void)createSlides
{
    //Create Slides
	self.timerIndex = 1;
    
	self.leagueSlide = [[LeagueSlide alloc] initWithNibName:@"LeagueSlide" bundle:nil];
	self.leagueSlide.mainCell = self;
	[self.leagueSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [self.leagueSlide updateView];
    
	self.rankingSlide = [[RankingSlide alloc] initWithNibName:@"RankingSlide" bundle:nil];
	self.rankingSlide.mainCell = self;
	[self.rankingSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [self.rankingSlide updateView];
    
	self.nextmatchSlide = [[NextMatchSlide alloc] initWithNibName:@"NextMatchSlide" bundle:nil];
	self.nextmatchSlide.mainCell = self;
	[self.nextmatchSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [self.nextmatchSlide updateView];
    
	self.lastmatchSlide = [[LastMatchSlide alloc] initWithNibName:@"LastMatchSlide" bundle:nil];
	self.lastmatchSlide.mainCell = self;
	[self.lastmatchSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
    [self.lastmatchSlide updateView];
    
    if(!self.slidesTimer.isValid)
    {
        self.slidesTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    
    //[self changeSlideNow];
}

- (void)changeSlide
{
	if (self.timerIndex == 5)
	{
		self.timerIndex = 1;
	}
	
	switch (self.timerIndex)
	{
		case 1:
            [self.lastmatchSlide.view removeFromSuperview];
			[self.rankingSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
			[self insertSubview:self.rankingSlide.view atIndex:0];
            [self.rankingSlide updateView];
			self.activeSlide = self.rankingSlide.view;
			break;
		case 2:
            [self.rankingSlide.view removeFromSuperview];
			[self.leagueSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
			[self insertSubview:self.leagueSlide.view atIndex:0];
            [self.leagueSlide updateView];
			self.activeSlide = self.leagueSlide.view;
			break;
		case 3:
            [self.leagueSlide.view removeFromSuperview];
			[self.nextmatchSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
			[self insertSubview:self.nextmatchSlide.view atIndex:0];
            [self.nextmatchSlide updateView];
			self.activeSlide = self.nextmatchSlide.view;
			break;
		case 4:
            [self.nextmatchSlide.view removeFromSuperview];
			[self.lastmatchSlide.view setFrame:CGRectMake(SLIDE_x, SLIDE_y, SLIDE_width, SLIDE_height)];
			[self insertSubview:self.lastmatchSlide.view atIndex:0];
            [self.lastmatchSlide updateView];
			self.activeSlide = self.lastmatchSlide.view;
			break;
	}
}

- (void)changeSlideNow
{
	[self changeSlide];
	self.timerIndex += 1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self changeSlideNow];
}

-(void)onTimer
{
    [self changeSlide];
    self.timerIndex += 1;
}

- (void)showSlide
{
    [self changeSlideNow];
    if(!self.slidesTimer.isValid)
    {
        self.slidesTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
}

- (void)hideSlide
{
    if(self.activeSlide != nil)
    {
        [self.activeSlide removeFromSuperview];
    }
}

- (void)createButtons
{
    [self addAnimatedButton:@"Sale!" tag:1 imageDefault:@"button_cup"];
    
    [self addPosButton:@"Mail" tag:1 imageDefault:@"button_mails"];
    [self addPosButton:@"Task" tag:2 imageDefault:@"button_achievements"];
    [self addPosButton:@"Slots" tag:3 imageDefault:@"button_slot"];
    [self addPosButton:@"Training" tag:4 imageDefault:@"button_train"];
    [self addPosButton:@"Transfers" tag:5 imageDefault:@"button_transfer"];
	[self addPosButton:@"Squad" tag:6 imageDefault:@"button_squad"];
	[self addPosButton:@"Formations" tag:7 imageDefault:@"button_tactics"];
	[self addPosButton:@"Fixtures" tag:8 imageDefault:@"button_match"];
    [self addPosButton:@"League" tag:9 imageDefault:@"button_league"];
	[self addPosButton:@"Alliance" tag:10 imageDefault:@"button_cup"];
	[self addPosButton:@"Finances" tag:11 imageDefault:@"button_finance"];
	[self addPosButton:@"Stadium" tag:12 imageDefault:@"button_city"];
    [self addPosButton:@"Club" tag:13 imageDefault:@"button_club"];
	[self addPosButton:@"Club Store" tag:14 imageDefault:@"button_store"];
	[self addPosButton:@"Coach" tag:15 imageDefault:@"button_coach"];
	[self addPosButton:@"Staff" tag:16 imageDefault:@"button_staff"];
    [self addPosButton:@"Fans" tag:17 imageDefault:@"button_fan"];
    [self addPosButton:@"Ranking" tag:18 imageDefault:@"button_leaderboard"];
    [self addPosButton:@"Search" tag:19 imageDefault:@"button_friends"];
	[self addPosButton:@"World Map" tag:20 imageDefault:@"button_map"];
    [self addPosButton:@"Invite" tag:21 imageDefault:@"button_friends"];
    [self addPosButton:@"Feedback" tag:22 imageDefault:@"button_news"];
	[self addPosButton:@"More" tag:23 imageDefault:@"button_more"];
	[self addPosButton:@"Help" tag:24 imageDefault:@"button_help"];
    [self addPosButton:@"Logout" tag:25 imageDefault:@"button_logout"];
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
    
    return CGRectMake(posx-DEFAULT_CONTENT_SPACING, posy-DEFAULT_CONTENT_SPACING, width, height);
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

- (void)addAnimatedButton:(NSString *)label
                      tag:(NSInteger)tag
             imageDefault:(NSString *)imageDefault
{
    UIImage *imgD = [UIImage imageNamed:imageDefault];
    NSInteger sizex = (imgD.size.width*SCALE_IPAD/2);
    NSInteger sizey = (imgD.size.height*SCALE_IPAD/2);
    
    NSInteger column_width = self.frame.size.width / buttons_per_row;
    NSInteger column_start_x = (column_width - sizex) / 2;
    NSInteger column_height = sizey + menu_label_height + menu_margin_y;
    
    NSInteger posx = (buttons_per_row-1) * column_width + column_start_x;
    NSInteger posy = (tag-1) * column_height;
    
	UIButton *button = [[Globals i] buttonWithTitle:@""
                                             target:self
                                           selector:@selector(animatedButton_tap:)
                                              frame:CGRectMake(posx, posy, sizex, sizey)
                                              image:nil
                                       imagePressed:nil
                                      darkTextColor:YES];
    
    button.imageView.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"g1_0.png"],
                                        [UIImage imageNamed:@"g1_1.png"],
                                        [UIImage imageNamed:@"g1_2.png"],
                                        [UIImage imageNamed:@"g1_3.png"],
                                        [UIImage imageNamed:@"g1_4.png"],
                                        [UIImage imageNamed:@"g1_5.png"],
                                        nil];
    
    button.imageView.animationDuration = 0.5;
    button.imageView.animationRepeatCount = 0;
    [button.imageView startAnimating];
    
    [button setBackgroundImage:[UIImage animatedImageNamed:@"g1_" duration: 1.0]
                      forState: UIControlStateNormal];
    
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

- (void)animatedButton_tap:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ViewSales" object:self];
}

@end
