//
//  SubsView.m
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "SubsView.h"

@implementation SubsView
@synthesize mainView;
@synthesize fid;
@synthesize squadSelecter;
@synthesize selectedPlayer;
@synthesize nwPlayer;
@synthesize selectedPos;

- (void)createSub
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

- (void)animateChangePos
{
	@autoreleasepool {
	/*
	if ([self.selectedPos isEqualToString:@"sgk"] || 
		[self.selectedPos isEqualToString:@"sd"] || 
		[self.selectedPos isEqualToString:@"sim"] || 
		[self.selectedPos isEqualToString:@"sfw"] || 
		[self.selectedPos isEqualToString:@"sw"])
	{
		[self swapPos:@"gk"];
		[self swapPos:@"rb"];
		[self swapPos:@"cd1"];
		[self swapPos:@"cd2"];
		[self swapPos:@"cd3"];
		[self swapPos:@"lb"];
		[self swapPos:@"rw"];
		[self swapPos:@"im1"];
		[self swapPos:@"im2"];
		[self swapPos:@"im3"];
		[self swapPos:@"lw"];
		[self swapPos:@"fw1"];
		[self swapPos:@"fw2"];
		[self swapPos:@"fw3"];
		[self swapPos:@"sgk"];
		[self swapPos:@"sd"];
		[self swapPos:@"sim"];
		[self swapPos:@"sfw"];
		[self swapPos:@"sw"];
	}
	*/
		[[Globals i] changePlayerFormation:self.nwPlayer :self.selectedPos];
		[self updateView];
		[[Globals i] removeLoadingAlert:self.view];
	}
}

-(IBAction)posButton_tap:(id)sender
{
    [mainView buttonSound];
    
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


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
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
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [button setImage:[UIImage imageNamed:@"jerseypos.png"] forState:UIControlStateNormal];
	}
    else
    {
        [button setImage:[UIImage imageNamed:@"jerseypos.png"] forState:UIControlStateNormal];
    }
    
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
	[self.mainView hideHeader];
	[self.mainView hideFooter];
    if (squadSelecter == NULL) 
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
	[self.mainView showHeader];
	[self.mainView showFooter];
	self.nwPlayer = player;
	
	if([player isEqualToString:@"0"] || [player isEqualToString:self.selectedPlayer])
	{
		
	}
	else
	{
		[[Globals i] showLoadingAlert:self.view];
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
