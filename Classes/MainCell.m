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
        self.s1 = 0;
        self.b1s = 0;
        self.b2s = 0;
        self.b3s = 0;
        [self createSlides];
        [self createButtons];
    }
}

- (void)updateSalesButton
{
    [self.buttonSale removeFromSuperview];
    [self.labelSale removeFromSuperview];
    
    NSDictionary *wsData = [Globals i].wsSalesData;
    if (wsData != nil)
    {
        //Update time left in seconds for sale to end
        NSTimeInterval serverTimeInterval = [[Globals i] updateTime];
        NSString *strDate = wsData[@"sale_ending"];
        strDate = [NSString stringWithFormat:@"%@ -0000", strDate];
        NSDate *saleEndDate = [[[Globals i] getDateFormat] dateFromString:strDate];
        NSTimeInterval saleEndTime = [saleEndDate timeIntervalSince1970];
        self.b1s = saleEndTime - serverTimeInterval;
        
        if (self.b1s > 0)
        {
            [self addSaleButton:@"Sale!" imageDefault:@"icon_sale1"];
        }
    }
}

- (void)updateEventSoloButton
{
    [self.buttonEventSolo removeFromSuperview];
    [self.labelEventSolo1 removeFromSuperview];
    [self.labelEventSolo2 removeFromSuperview];
    
    [[Globals i] updateEventSolo];
    
    NSDictionary *wsData = [Globals i].wsEventSolo;
    if (wsData != nil)
    {
        //Update time left in seconds for event to end
        NSTimeInterval serverTimeInterval = [[Globals i] updateTime];
        NSString *strDate = wsData[@"event_ending"];
        strDate = [NSString stringWithFormat:@"%@ -0000", strDate];
        NSDate *endDate = [[[Globals i] getDateFormat] dateFromString:strDate];
        NSTimeInterval endTime = [endDate timeIntervalSince1970];
        self.b2s = endTime - serverTimeInterval;
        
        [self addEventSoloButton];
    }
    else
    {
        self.b2s = 0;
    }
}

- (void)updateEventAllianceButton
{
    [self.buttonEventAlliance removeFromSuperview];
    [self.labelEventAlliance1 removeFromSuperview];
    [self.labelEventAlliance2 removeFromSuperview];
    
    [[Globals i] updateEventAlliance];
    
    NSDictionary *wsData = [Globals i].wsEventAlliance;
    if (wsData != nil)
    {
        //Update time left in seconds for event to end
        NSTimeInterval serverTimeInterval = [[Globals i] updateTime];
        NSString *strDate = wsData[@"event_ending"];
        strDate = [NSString stringWithFormat:@"%@ -0000", strDate];
        NSDate *endDate = [[[Globals i] getDateFormat] dateFromString:strDate];
        NSTimeInterval endTime = [endDate timeIntervalSince1970];
        self.b3s = endTime - serverTimeInterval;
        
        [self addEventAllianceButton];
    }
    else
    {
        self.b3s = 0;
    }
}

- (void)createAchievementBadges
{
    if (self.achievementsBadge == nil)
    {
        NSString *str_num = [NSString stringWithFormat:@"%ld", (long)[[Globals i] getAchievementsBadge]];
        self.achievementsBadge = [CustomBadge customBadgeWithString:str_num withScale:SCALE_IPAD];
        
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
        NSString *str_num = [NSString stringWithFormat:@"%ld", (long)[[Globals i] getMailBadgeNumber]];
        self.mailBadge = [CustomBadge customBadgeWithString:str_num withScale:SCALE_IPAD];
        
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
        self.slidesTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
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

- (void)onTimer
{
    self.s1 = self.s1+1;
    
    if (self.s1%15 == 0) //Change slides every 15 sec
    {
        [self changeSlide];
        self.timerIndex += 1;
    }
    
    if (self.s1%6 == 0) //Toggle animated buttons label every 5 sec
    {
        if (self.timerIsShowing == NO)
        {
            self.timerIsShowing = YES;
        }
        else
        {
            self.timerIsShowing = NO;
        }
    }
    
    if (self.b1s > 0)
    {
        self.b1s = self.b1s-1;
        
        if (self.timerIsShowing == YES)
        {
            NSString *labelString = [[Globals i] getCountdownString:self.b1s];
            self.labelSale.text = labelString;
        }
        else
        {
            self.labelSale.text = @"SALE!";
        }
        
        [self.buttonSale setImage:[UIImage animatedImageNamed:@"icon_sale" duration:1.0]
                                   forState:UIControlStateNormal];
        
        if (self.b1s == 1)
        {
            [self.buttonSale removeFromSuperview];
            [self.labelSale removeFromSuperview];
        }
    }
    
    if (self.b2s > 0)
    {
        self.b2s = self.b2s-1;
        
        if (self.timerIsShowing == YES)
        {
            self.labelEventSolo1.text = @"Ending in";
            
            NSString *labelString = [[Globals i] getCountdownString:self.b2s];
            self.labelEventSolo2.text = labelString;
        }
        else
        {
            self.labelEventSolo1.text = @"Solo";
            self.labelEventSolo2.text = @"Tournament";
        }
    }
    else
    {
        if (self.timerIsShowing == YES)
        {
            self.labelEventSolo1.text = @"View";
            self.labelEventSolo2.text = @"Results";
        }
        else
        {
            self.labelEventSolo1.text = @"Solo";
            self.labelEventSolo2.text = @"Tournament";
        }
    }
    
    if (self.b3s > 0)
    {
        self.b3s = self.b3s-1;
        
        if (self.timerIsShowing == YES)
        {
            self.labelEventAlliance1.text = @"Ending in";
            
            NSString *labelString = [[Globals i] getCountdownString:self.b3s];
            self.labelEventAlliance2.text = labelString;
        }
        else
        {
            self.labelEventAlliance1.text = @"Alliance";
            self.labelEventAlliance2.text = @"Tournament";
        }
    }
    else
    {
        if (self.timerIsShowing == YES)
        {
            self.labelEventAlliance1.text = @"View";
            self.labelEventAlliance2.text = @"Results";
        }
        else
        {
            self.labelEventAlliance1.text = @"Alliance";
            self.labelEventAlliance2.text = @"Tournament";
        }
    }
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
    [self addPosButton:@"MAIL" tag:1 imageDefault:@"button_mails"];
    [self addPosButton:@"TASK" tag:2 imageDefault:@"button_achievements"];
    [self addPosButton:@"HOW TO PLAY" tag:3 imageDefault:@"button_help"];
    [self addPosButton:@"TRAINING" tag:4 imageDefault:@"button_train"];
    [self addPosButton:@"TRANSFERS" tag:5 imageDefault:@"button_transfer"];
	[self addPosButton:@"SQUAD" tag:6 imageDefault:@"button_squad"];
	[self addPosButton:@"FORMATIONS" tag:7 imageDefault:@"button_tactics"];
	[self addPosButton:@"FIXTURES" tag:8 imageDefault:@"button_match"];
    [self addPosButton:@"LEAGUE" tag:9 imageDefault:@"button_league"];
	[self addPosButton:@"ALLIANCE" tag:10 imageDefault:@"button_cup"];
	[self addPosButton:@"FINANCES" tag:11 imageDefault:@"button_finance"];
	[self addPosButton:@"STADIUM" tag:12 imageDefault:@"button_city"];
    [self addPosButton:@"CLUB" tag:13 imageDefault:@"button_club"];
	[self addPosButton:@"STORE" tag:14 imageDefault:@"button_store"];
	[self addPosButton:@"COACH" tag:15 imageDefault:@"button_coach"];
	[self addPosButton:@"STAFF" tag:16 imageDefault:@"button_staff"];
    [self addPosButton:@"FANS" tag:17 imageDefault:@"button_fan"];
    [self addPosButton:@"RANKINGS" tag:18 imageDefault:@"button_leaderboard"];
    [self addPosButton:@"SEARCH" tag:19 imageDefault:@"button_search"];
	[self addPosButton:@"WORLD" tag:20 imageDefault:@"button_map"];
    [self addPosButton:@"INVITE" tag:21 imageDefault:@"button_friends"];
    [self addPosButton:@"FEEDBACK" tag:22 imageDefault:@"button_news"];
	[self addPosButton:@"MORE" tag:23 imageDefault:@"button_more"];
    [self addPosButton:@"LOGOUT" tag:24 imageDefault:@"button_logout"];
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
    myLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:MENU_FONT_SIZE];
	myLabel.backgroundColor = [UIColor clearColor];
	myLabel.textColor = [UIColor whiteColor];
	myLabel.textAlignment = NSTextAlignmentCenter;
	myLabel.numberOfLines = 1;
	myLabel.adjustsFontSizeToFitWidth = YES;
	myLabel.minimumScaleFactor = 0.5f;
	[self addSubview:myLabel];
    
    if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        myLabel.textColor = [UIColor whiteColor];
        myLabel.shadowColor = [UIColor blackColor];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        myLabel.textColor = [UIColor whiteColor];
        myLabel.shadowColor = [UIColor blackColor];
    }
}

- (void)posButton_tap:(id)sender
{
	NSInteger theTag = [sender tag];
	[[Globals i].mainView menuButton_tap:theTag];
}

- (void)addSaleButton:(NSString *)label imageDefault:(NSString *)imageDefault
{
    UIImage *imgD = [UIImage imageNamed:imageDefault];
    NSInteger sizex = (imgD.size.width*SCALE_IPAD/2);
    NSInteger sizey = (imgD.size.height*SCALE_IPAD/2);
    
    NSInteger posx = self.frame.size.width - sizex;
    NSInteger posy = 0;
    
	self.buttonSale = [[Globals i] buttonWithTitle:@""
                                            target:self
                                          selector:@selector(saleButton_tap:)
                                             frame:CGRectMake(posx, posy, sizex, sizey)
                                             image:imgD
                                      imagePressed:nil
                                     darkTextColor:YES];
    
    [self.buttonSale setImage:[UIImage animatedImageNamed:@"icon_sale" duration:1.0]
                               forState:UIControlStateNormal];
    
	[self addSubview:self.buttonSale];
	
	self.labelSale = [[UILabel alloc] initWithFrame:CGRectMake(posx, posy+sizey-menu_label_height, sizex, menu_label_height)];
	self.labelSale.text = label;
    self.labelSale.font = [UIFont fontWithName:DEFAULT_FONT size:14.0f*SCALE_IPAD];
	self.labelSale.backgroundColor = [UIColor clearColor];
	self.labelSale.textColor = [UIColor whiteColor];
	self.labelSale.textAlignment = NSTextAlignmentCenter;
	self.labelSale.numberOfLines = 1;
	self.labelSale.adjustsFontSizeToFitWidth = YES;
	self.labelSale.minimumScaleFactor = 0.5f;
	[self addSubview:self.labelSale];
}

- (void)saleButton_tap:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ViewSales" object:self];
}

- (void)addEventSoloButton
{
    UIImage *imgD = [UIImage imageNamed:@"icon_green_normal"];
    UIImage *imgH = [UIImage imageNamed:@"icon_green_highlight"];
    NSInteger sizex = (imgD.size.width*SCALE_IPAD/2);
    NSInteger sizey = (imgD.size.height*SCALE_IPAD/2);
    
    NSInteger column_start_x = 10.0f*SCALE_IPAD;
    
    NSInteger posx = self.frame.size.width - sizex;
    NSInteger posy = 70.0f*SCALE_IPAD;
    
	self.buttonEventSolo = [[Globals i] buttonWithTitle:@""
                                            target:self
                                          selector:@selector(eventSoloButton_tap:)
                                             frame:CGRectMake(posx, posy, sizex, sizey)
                                             image:imgD
                                      imagePressed:imgH
                                     darkTextColor:YES];
    
	[self addSubview:self.buttonEventSolo];
	
	self.labelEventSolo1 = [[UILabel alloc] initWithFrame:CGRectMake(posx+(2*column_start_x), posy, sizex-(2*column_start_x), menu_label_height)];
    self.labelEventSolo1.font = [UIFont fontWithName:DEFAULT_FONT size:15.0f*SCALE_IPAD];
	self.labelEventSolo1.backgroundColor = [UIColor clearColor];
	self.labelEventSolo1.shadowColor = [UIColor grayColor];
	self.labelEventSolo1.shadowOffset = CGSizeMake(1,1);
	self.labelEventSolo1.textColor = [UIColor blackColor];
	self.labelEventSolo1.textAlignment = NSTextAlignmentCenter;
	self.labelEventSolo1.numberOfLines = 1;
	self.labelEventSolo1.adjustsFontSizeToFitWidth = YES;
	self.labelEventSolo1.minimumScaleFactor = 0.5f;
	[self addSubview:self.labelEventSolo1];
    
    self.labelEventSolo2 = [[UILabel alloc] initWithFrame:CGRectMake(posx+(2*column_start_x), posy+menu_label_height-DEFAULT_CONTENT_SPACING, sizex-(2*column_start_x), menu_label_height)];
    self.labelEventSolo2.font = [UIFont fontWithName:DEFAULT_FONT size:15.0f*SCALE_IPAD];
	self.labelEventSolo2.backgroundColor = [UIColor clearColor];
	self.labelEventSolo2.shadowColor = [UIColor grayColor];
	self.labelEventSolo2.shadowOffset = CGSizeMake(1,1);
	self.labelEventSolo2.textColor = [UIColor blackColor];
	self.labelEventSolo2.textAlignment = NSTextAlignmentCenter;
	self.labelEventSolo2.numberOfLines = 1;
	self.labelEventSolo2.adjustsFontSizeToFitWidth = YES;
	self.labelEventSolo2.minimumScaleFactor = 0.5f;
	[self addSubview:self.labelEventSolo2];
}

- (void)eventSoloButton_tap:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EventSolo" object:self];
}

- (void)addEventAllianceButton
{
    UIImage *imgD = [UIImage imageNamed:@"icon_yellow_normal"];
    UIImage *imgH = [UIImage imageNamed:@"icon_yellow_highlight"];
    NSInteger sizex = (imgD.size.width*SCALE_IPAD/2);
    NSInteger sizey = (imgD.size.height*SCALE_IPAD/2);
    
    NSInteger column_start_x = 10.0f*SCALE_IPAD;
    
    NSInteger posx = self.frame.size.width - sizex;
    NSInteger posy = 115.0f*SCALE_IPAD;
    
	self.buttonEventAlliance = [[Globals i] buttonWithTitle:@""
                                                 target:self
                                               selector:@selector(eventAllianceButton_tap:)
                                                  frame:CGRectMake(posx, posy, sizex, sizey)
                                                  image:imgD
                                           imagePressed:imgH
                                          darkTextColor:YES];
    
	[self addSubview:self.buttonEventAlliance];
	
	self.labelEventAlliance1 = [[UILabel alloc] initWithFrame:CGRectMake(posx+(2*column_start_x), posy, sizex-(2*column_start_x), menu_label_height)];
    self.labelEventAlliance1.font = [UIFont fontWithName:DEFAULT_FONT size:15.0f*SCALE_IPAD];
	self.labelEventAlliance1.backgroundColor = [UIColor clearColor];
	self.labelEventAlliance1.shadowColor = [UIColor grayColor];
	self.labelEventAlliance1.shadowOffset = CGSizeMake(1,1);
	self.labelEventAlliance1.textColor = [UIColor blackColor];
	self.labelEventAlliance1.textAlignment = NSTextAlignmentCenter;
	self.labelEventAlliance1.numberOfLines = 1;
	self.labelEventAlliance1.adjustsFontSizeToFitWidth = YES;
	self.labelEventAlliance1.minimumScaleFactor = 0.5f;
	[self addSubview:self.labelEventAlliance1];
    
    self.labelEventAlliance2 = [[UILabel alloc] initWithFrame:CGRectMake(posx+(2*column_start_x), posy+menu_label_height-DEFAULT_CONTENT_SPACING, sizex-(2*column_start_x), menu_label_height)];
    self.labelEventAlliance2.font = [UIFont fontWithName:DEFAULT_FONT size:15.0f*SCALE_IPAD];
	self.labelEventAlliance2.backgroundColor = [UIColor clearColor];
	self.labelEventAlliance2.shadowColor = [UIColor grayColor];
	self.labelEventAlliance2.shadowOffset = CGSizeMake(1,1);
	self.labelEventAlliance2.textColor = [UIColor blackColor];
	self.labelEventAlliance2.textAlignment = NSTextAlignmentCenter;
	self.labelEventAlliance2.numberOfLines = 1;
	self.labelEventAlliance2.adjustsFontSizeToFitWidth = YES;
	self.labelEventAlliance2.minimumScaleFactor = 0.5f;
	[self addSubview:self.labelEventAlliance2];
}

- (void)eventAllianceButton_tap:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EventAlliance" object:self];
}

@end
