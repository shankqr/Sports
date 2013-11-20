//
//  SubsView.m
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "SubsView.h"
#import "Globals.h"
#import "MainView.h"

@implementation SubsView
@synthesize mainView;
@synthesize ivBackground;
@synthesize fid;
@synthesize squadSelecter;
@synthesize selectedPlayer;
@synthesize nwPlayer;
@synthesize selectedPos;

- (void)createSub
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        [self addPosButton:@"sgk" label:@"GK" tag:1 posx:Subs_x1 posy:Subs_y1];
        [self addPosButton:@"sd" label:@"Defend" tag:2 posx:Subs_x2 posy:Subs_y2];
        [self addPosButton:@"sim" label:@"Center" tag:3 posx:Subs_x3 posy:Subs_y2];
        [self addPosButton:@"sfw" label:@"Forward" tag:4 posx:Subs_x4 posy:Subs_y2];
        [self addPosButton:@"sw" label:@"Winger" tag:5 posx:Subs_x5 posy:Subs_y2];
        [self addPosButton:@"captain" label:@"Captain" tag:6 posx:Subs_x2 posy:Subs_y3];
        [self addPosButton:@"penalty" label:@"Penalty" tag:7 posx:Subs_x3 posy:Subs_y3];
        [self addPosButton:@"freekick" label:@"Free Kick" tag:8 posx:Subs_x4 posy:Subs_y3];
        [self addPosButton:@"cornerkick" label:@"Corner Kick" tag:9 posx:Subs_x5 posy:Subs_y3];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        [self addPosButton:@"sgk" label:@"GK" tag:1 posx:Subs_x1_hockey posy:Subs_y1_hockey];
        [self addPosButton:@"sd" label:@"Defend" tag:2 posx:Subs_x2_hockey posy:Subs_y2_hockey];
        [self addPosButton:@"sim" label:@"Center" tag:3 posx:Subs_x3_hockey posy:Subs_y2_hockey];
        [self addPosButton:@"sfw" label:@"Forward" tag:4 posx:Subs_x4_hockey posy:Subs_y2_hockey];
        [self addPosButton:@"sw" label:@"Winger" tag:5 posx:Subs_x5_hockey posy:Subs_y2_hockey];
        [self addPosButton:@"captain" label:@"Captain" tag:6 posx:Subs_x2_hockey posy:Subs_y3_hockey];
        [self addPosButton:@"penalty" label:@"Penalty" tag:7 posx:Subs_x3_hockey posy:Subs_y3_hockey];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        [self addPosButton:@"sgk" label:@"Point Guard" tag:1 posx:136*SCALE_IPAD posy:290*SCALE_IPAD];
        [self addPosButton:@"sd" label:@"Shooting Guard" tag:2 posx:236*SCALE_IPAD posy:240*SCALE_IPAD];
        [self addPosButton:@"sim" label:@"Center" tag:3 posx:56*SCALE_IPAD posy:190*SCALE_IPAD];
        [self addPosButton:@"sfw" label:@"Power Forward" tag:4 posx:236*SCALE_IPAD posy:138*SCALE_IPAD];
        [self addPosButton:@"sw" label:@"Small Forward" tag:5 posx:35*SCALE_IPAD posy:110*SCALE_IPAD];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        [self addPosButton:@"sgk" label:@"Bench 1" tag:1 posx:Subs_x1_baseball posy:Subs_y1_baseball];
        [self addPosButton:@"sd" label:@"Bench 2" tag:2 posx:Subs_x2_baseball posy:Subs_y2_baseball];
        [self addPosButton:@"sim" label:@"Bench 3" tag:3 posx:Subs_x3_baseball posy:Subs_y2_baseball];
        [self addPosButton:@"sfw" label:@"Bench 4" tag:4 posx:Subs_x4_baseball posy:Subs_y2_baseball];
        [self addPosButton:@"sw" label:@"Bench 5" tag:5 posx:Subs_x5_baseball posy:Subs_y2_baseball];
        [self addPosButton:@"captain" label:@"Captain" tag:6 posx:Subs_x2_baseball posy:Subs_y3_baseball];
    }
}

- (void)animateChangePos
{
	@autoreleasepool {

		[[Globals i] changePlayerFormation:self.nwPlayer :self.selectedPos];
		[self updateView];
		[[Globals i] removeLoadingAlert];
	}
}

-(IBAction)posButton_tap:(id)sender
{
	int theTag = [sender tag];//( ( UIControl * )sender ).tag;
	
	switch(theTag)
	{
		case 1:
			self.selectedPos = @"sgk";
			self.selectedPlayer = [[Globals i] getClubData][@"sgk"];
			break;
		case 2:
			self.selectedPos = @"sd";
			self.selectedPlayer = [[Globals i] getClubData][@"sd"];
			break;
		case 3:
			self.selectedPos = @"sim";
			self.selectedPlayer = [[Globals i] getClubData][@"sim"];
			break;
		case 4:
			self.selectedPos = @"sfw";
			self.selectedPlayer = [[Globals i] getClubData][@"sfw"];
			break;
		case 5:
			self.selectedPos = @"sw";
			self.selectedPlayer = [[Globals i] getClubData][@"sw"];
			break;
		case 6:
			self.selectedPos = @"captain";
			self.selectedPlayer = [[Globals i] getClubData][@"captain"];
			break;
		case 7:
			self.selectedPos = @"penalty";
			self.selectedPlayer = [[Globals i] getClubData][@"penalty"];
			break;
		case 8:
			self.selectedPos = @"freekick";
			self.selectedPlayer = [[Globals i] getClubData][@"freekick"];
			break;
		case 9:
			self.selectedPos = @"cornerkick";
			self.selectedPlayer = [[Globals i] getClubData][@"cornerkick"];
			break;
	}
	
	self.selectedPlayer = [self.selectedPlayer stringByReplacingOccurrencesOfString:@"," withString:@""];
	
	[self launchSquadSelect];
}

-(void)updateView
{
	[Globals i].selectedPos = @"0";
	[self removeAllPos];
	[self createSub];
}

- (void)removeAllPos
{
	for (UIView *view in self.view.subviews) 
	{
		if(view.tag > 0)
		{
			[view removeFromSuperview];
		}
	}
}

- (void)addPosButton:(NSString *)pos
			   label:(NSString *)label
				 tag:(int)tag
				posx:(int)posx
				posy:(int)posy
{
	UIImage *buttonBackground = [UIImage imageNamed:@""];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@""];

	NSDictionary *wsClubData = [[Globals i] getClubData];
	NSString *player_id = wsClubData[pos];
	player_id = [player_id stringByReplacingOccurrencesOfString:@"," withString:@""];
	NSString *player_name = @"";
	NSMutableArray *players = [[Globals i] getMySquadData];
	
	for(NSDictionary *rowData in players)
	{
		if([[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] isEqualToString:player_id])
		{
			player_name = rowData[@"player_name"];
		}
	}
	
	NSArray *chunks = [player_name componentsSeparatedByString: @" "];
	NSString *lastname = @"N/A";
	
	if(chunks.count > 1)
	{
		NSString *firstname = chunks[0];
		NSString *firstnamecharacter = [[firstname substringWithRange:NSMakeRange(0,1)] stringByAppendingString:@"."];
		lastname = [firstnamecharacter stringByAppendingString:chunks[1]];
	}
	if(chunks.count == 1)
	{
		lastname = chunks[0];
	}
	
	UIButton *button = [[Globals i] buttonWithTitle:@""
                                             target:self
                                           selector:@selector(posButton_tap:)
                                              frame:CGRectMake(posx, posy, 60*SCALE_IPAD, 40*SCALE_IPAD)
                                              image:buttonBackground
                                       imagePressed:buttonBackgroundPressed
                                      darkTextColor:YES];
	
    [button setImage:[UIImage imageNamed:@"jerseypos.png"] forState:UIControlStateNormal];
    
	button.tag = tag;
    if (chunks.count > 1)
    {
        button.alpha = 1.0;
    }
    else
    {
        button.alpha = 0.6;
    }
	[self.view addSubview:button];
	
	UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx-(5*SCALE_IPAD), posy+(35*SCALE_IPAD), 70*SCALE_IPAD,20*SCALE_IPAD)];
	myLabel.tag = tag;
	myLabel.text = lastname;
	myLabel.backgroundColor = [UIColor darkGrayColor];
	myLabel.shadowColor = [UIColor grayColor];
	myLabel.shadowOffset = CGSizeMake(1,1);
	myLabel.textColor = [UIColor whiteColor];
	myLabel.textAlignment = NSTextAlignmentCenter;
	myLabel.numberOfLines = 1; // 0 - dynamical number of lines
	myLabel.adjustsFontSizeToFitWidth = YES;
	myLabel.minimumScaleFactor = 0.5f;
	[self.view addSubview:myLabel];
	
	UILabel *posLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx-(5*SCALE_IPAD), posy-(20*SCALE_IPAD), 70*SCALE_IPAD, 20*SCALE_IPAD)];
	posLabel.tag = tag;
	posLabel.text = label;
	posLabel.backgroundColor = [UIColor clearColor];
	posLabel.shadowColor = [UIColor grayColor];
	posLabel.shadowOffset = CGSizeMake(1,1);
	posLabel.textColor = [UIColor blackColor];
	posLabel.textAlignment = NSTextAlignmentCenter;
	posLabel.numberOfLines = 1; // 0 - dynamical number of lines
	posLabel.adjustsFontSizeToFitWidth = YES;
	posLabel.minimumScaleFactor = 0.5f;
	[self.view addSubview:posLabel];
}

- (void)launchSquadSelect
{
    if (squadSelecter == nil) 
    {
        squadSelecter = [[SquadSelectView alloc] initWithNibName:@"SquadSelectView" bundle:nil];
        squadSelecter.mainView = self.mainView;
        squadSelecter.delegate = self;
    }
	[squadSelecter updateView];
	[[[[self.view superview] superview] superview] insertSubview:squadSelecter.view atIndex:3];
}

- (void)playerSelected:(NSString *)player
{
	[squadSelecter.view removeFromSuperview];
	
	
	self.nwPlayer = player;
	
	if([player isEqualToString:@"0"] || [player isEqualToString:self.selectedPlayer])
	{
		
	}
	else
	{
		[[Globals i] showLoadingAlert];
		[NSThread detachNewThreadSelector: @selector(animateChangePos) toTarget:self withObject:nil];
	}
}

- (void)swapPos:(NSString *)pos
{
	NSString *oldPlayer = [[[Globals i] getClubData][pos] stringByReplacingOccurrencesOfString:@"," withString:@""];
	
	if([self.nwPlayer isEqualToString:oldPlayer])
	{
		[[Globals i] changePlayerFormation:self.selectedPlayer :pos];
	}
}

@end
