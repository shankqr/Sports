//
//  FormationView.m
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "FormationView.h"

@implementation FormationView
@synthesize mainView;
@synthesize segment;
@synthesize fid;
@synthesize squadSelecter;
@synthesize selectedPlayer;
@synthesize nwPlayer;
@synthesize selectedPos;


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

-(void)updateView
{
	[Globals i].selectedPos = @"0";
	
	[self removeAllPos];
	
	if([[[Globals i] getMySquadData] count] < 1)
	{
		[[Globals i] updateMySquadData];
	}
	
	[self showFormation];
}

- (void)showFormation
{
	if([[[Globals i] getClubData][@"formation"] isEqualToString:@"1"])
	{
		//formation = @"2-1-2";
		[self createPos1];
		segment.selectedSegmentIndex = 0;
	}
	else if([[[Globals i] getClubData][@"formation"] isEqualToString:@"2"])
	{
		//formation = @"1-2-2";
		[self createPos2];
		segment.selectedSegmentIndex = 1;
	}
	else if([[[Globals i] getClubData][@"formation"] isEqualToString:@"3"])
	{
		//formation = @"1-4";
		[self createPos3];
		segment.selectedSegmentIndex = 2;
	}
    else if([[[Globals i] getClubData][@"formation"] isEqualToString:@"4"])
	{
		//formation = @"5-4-1";
		[self createPos4];
		segment.selectedSegmentIndex = 3;
	}
	else if([[[Globals i] getClubData][@"formation"] isEqualToString:@"5"])
	{
		//formation = @"5-3-2";
		[self createPos5];
		segment.selectedSegmentIndex = 4;
	}
	else if([[[Globals i] getClubData][@"formation"] isEqualToString:@"6"])
	{
		//formation = @"3-5-2";
		[self createPos6];
		segment.selectedSegmentIndex = 5;
	}
	else if([[[Globals i] getClubData][@"formation"] isEqualToString:@"7"])
	{
		//formation = @"4-5-1";
		[self createPos7];
		segment.selectedSegmentIndex = 6;
	}
}

- (IBAction)segmentTap:(id)sender
{
    [mainView buttonSound];
    
	[self removeAllPos];
	switch([sender selectedSegmentIndex])
	{
		case 0: //2-1-2
		{
			[self createPos1];
			[self ChangeFormationConfirm:@"1"];
			break;
		}
		case 1: //1-2-2
		{
			[self createPos2];
			[self ChangeFormationConfirm:@"2"];
			break;
		}
		case 2: //1-4
		{
			[self createPos3];
			[self ChangeFormationConfirm:@"3"];
			break;
		}
        case 3:
		{
			[self createPos4];
			[self ChangeFormationConfirm:@"4"];
			break;
		}
		case 4:
		{
			[self createPos5];
			[self ChangeFormationConfirm:@"5"];
			break;
		}
		case 5:
		{
			[self createPos6];
			[self ChangeFormationConfirm:@"6"];
			break;
		}
		case 6:
		{
			[self createPos7];
			[self ChangeFormationConfirm:@"7"];
			break;
		}
	}
}

- (void)ChangeFormationConfirm:	(NSString *)formationId
{
	if(![formationId isEqualToString:[[Globals i] getClubData][@"formation"]])
	{
		fid = formationId;
		UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Set Formation"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Confirm", nil];
		actionSheet.tag = 0;
		[actionSheet showFromTabBar:[[self.mainView tacticsTabBarController] tabBar]];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch(actionSheet.tag)
	{
		case 0:
		{
			switch(buttonIndex)
			{
				case 0:
				{
                    [[Globals i] changeFormation:fid];
				}
				case 1:
				{
					[self updateView];
					break;
				}
			}
			break;
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
        [[Globals i] settPurchasedProduct:@"14"];
		[mainView buyProduct:[[Globals i] getProductIdentifiers][@"refill"]];
	}
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
	
	UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx-(5*SCALE_IPAD), posy+(35*SCALE_IPAD), 70*SCALE_IPAD, 20*SCALE_IPAD)];
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

- (void)createPos1 //4-4-2
{
	[self addPosButton:@"gk" label:@"GK" tag:1 posx:Subs_x1 posy:Pos_y1];
    
    [self addPosButton:@"rb" label:@"DR" tag:2 posx:Subs_x2 posy:Pos_y2];
	[self addPosButton:@"cd1" label:@"DC1" tag:3 posx:Subs_x3 posy:Pos_y2];
	[self addPosButton:@"cd2" label:@"DC2" tag:4 posx:Subs_x4 posy:Pos_y2];
	[self addPosButton:@"lb" label:@"DL" tag:6 posx:Subs_x5 posy:Pos_y2];
    
    [self addPosButton:@"rw" label:@"MR" tag:7 posx:Subs_x2 posy:Pos_y3];
	[self addPosButton:@"im1" label:@"MC1" tag:8 posx:Subs_x3 posy:Pos_y3];
	[self addPosButton:@"im2" label:@"MC2" tag:9 posx:Subs_x4 posy:Pos_y3];
	[self addPosButton:@"lw" label:@"ML" tag:11 posx:Subs_x5 posy:Pos_y3];
	
	[self addPosButton:@"fw1" label:@"SC1" tag:12 posx:Subs_x3 posy:Pos_y4];
	[self addPosButton:@"fw2" label:@"SC2" tag:13 posx:Subs_x4 posy:Pos_y4];
}

- (void)createPos2 //4-3-3
{
	[self addPosButton:@"gk" label:@"GK" tag:1 posx:Subs_x1 posy:Pos_y1];
	
    [self addPosButton:@"rb" label:@"DR" tag:2 posx:Subs_x2 posy:Pos_y2];
	[self addPosButton:@"cd1" label:@"DC1" tag:3 posx:Subs_x3 posy:Pos_y2];
	[self addPosButton:@"cd2" label:@"DC2" tag:4 posx:Subs_x4 posy:Pos_y2];
	[self addPosButton:@"lb" label:@"DL" tag:6 posx:Subs_x5 posy:Pos_y2];
	
	[self addPosButton:@"rw" label:@"MR" tag:7 posx:Pos_x1 posy:Pos_y3];
	[self addPosButton:@"im1" label:@"MC1" tag:8 posx:Subs_x1 posy:Pos_y3];
	[self addPosButton:@"lw" label:@"ML" tag:11 posx:Pos_x2 posy:Pos_y3];
	
	[self addPosButton:@"fw1" label:@"SC1" tag:12 posx:Pos_x1 posy:Pos_y4];
	[self addPosButton:@"fw2" label:@"SC2" tag:13 posx:Subs_x1 posy:Pos_y4];
	[self addPosButton:@"fw3" label:@"SC3" tag:14 posx:Pos_x2 posy:Pos_y4];
}

- (void)createPos3 //3-4-3
{
	[self addPosButton:@"gk" label:@"GK" tag:1 posx:Subs_x1 posy:Pos_y1];
	
	[self addPosButton:@"rb" label:@"DR" tag:2 posx:Pos_x1 posy:Pos_y2];
	[self addPosButton:@"cd1" label:@"DC1" tag:3 posx:Subs_x1 posy:Pos_y2];
	[self addPosButton:@"lb" label:@"DL" tag:6 posx:Pos_x2 posy:Pos_y2];
	
    [self addPosButton:@"rw" label:@"MR" tag:7 posx:Subs_x2 posy:Pos_y3];
	[self addPosButton:@"im1" label:@"MC1" tag:8 posx:Subs_x3 posy:Pos_y3];
	[self addPosButton:@"im2" label:@"MC2" tag:9 posx:Subs_x4 posy:Pos_y3];
	[self addPosButton:@"lw" label:@"ML" tag:11 posx:Subs_x5 posy:Pos_y3];
	
	[self addPosButton:@"fw1" label:@"SC1" tag:12 posx:Pos_x1 posy:Pos_y4];
	[self addPosButton:@"fw2" label:@"SC2" tag:13 posx:Subs_x1 posy:Pos_y4];
	[self addPosButton:@"fw3" label:@"SC3" tag:14 posx:Pos_x2 posy:Pos_y4];
}

- (void)createPos4 //5-4-1
{
	[self addPosButton:@"gk" label:@"GK" tag:1 posx:Subs_x1 posy:Pos_y1];
	
	[self addPosButton:@"rb" label:@"DR" tag:2 posx:Pos_x3 posy:Pos_y2];
	[self addPosButton:@"cd1" label:@"DC1" tag:3 posx:Pos_x4 posy:Pos_y2];
	[self addPosButton:@"cd2" label:@"DC2" tag:4 posx:Subs_x1 posy:Pos_y2];
	[self addPosButton:@"cd3" label:@"DC3" tag:5 posx:Pos_x5 posy:Pos_y2];
	[self addPosButton:@"lb" label:@"DL" tag:6 posx:Pos_x6 posy:Pos_y2];
	
    [self addPosButton:@"rw" label:@"MR" tag:7 posx:Subs_x2 posy:Pos_y3];
	[self addPosButton:@"im1" label:@"MC1" tag:8 posx:Subs_x3 posy:Pos_y3];
	[self addPosButton:@"im2" label:@"MC2" tag:9 posx:Subs_x4 posy:Pos_y3];
	[self addPosButton:@"lw" label:@"ML" tag:11 posx:Subs_x5 posy:Pos_y3];
	
	[self addPosButton:@"fw1" label:@"SC1" tag:12 posx:Subs_x1 posy:Pos_y4];
}

- (void)createPos5 //5-3-2
{
	[self addPosButton:@"gk" label:@"GK" tag:1 posx:Subs_x1 posy:Pos_y1];
	
	[self addPosButton:@"rb" label:@"DR" tag:2 posx:Pos_x3 posy:Pos_y2];
	[self addPosButton:@"cd1" label:@"DC1" tag:3 posx:Pos_x4 posy:Pos_y2];
	[self addPosButton:@"cd2" label:@"DC2" tag:4 posx:Subs_x1 posy:Pos_y2];
	[self addPosButton:@"cd3" label:@"DC3" tag:5 posx:Pos_x5 posy:Pos_y2];
	[self addPosButton:@"lb" label:@"DL" tag:6 posx:Pos_x6 posy:Pos_y2];
	
	[self addPosButton:@"rw" label:@"MR" tag:7 posx:Pos_x1 posy:Pos_y3];
	[self addPosButton:@"im1" label:@"MC1" tag:8 posx:Subs_x1 posy:Pos_y3];
	[self addPosButton:@"lw" label:@"ML" tag:11 posx:Pos_x2 posy:Pos_y3];
	
	[self addPosButton:@"fw1" label:@"SC1" tag:12 posx:Subs_x3 posy:Pos_y4];
	[self addPosButton:@"fw2" label:@"SC2" tag:13 posx:Subs_x4 posy:Pos_y4];
}

- (void)createPos6 //3-5-2
{
	[self addPosButton:@"gk" label:@"GK" tag:1 posx:Subs_x1 posy:Pos_y1];
	
	[self addPosButton:@"rb" label:@"DR" tag:2 posx:Pos_x1 posy:Pos_y2];
	[self addPosButton:@"cd1" label:@"DC1" tag:3 posx:Subs_x1 posy:Pos_y2];
	[self addPosButton:@"lb" label:@"DL" tag:6 posx:Pos_x2 posy:Pos_y2];
	
	[self addPosButton:@"rw" label:@"MR" tag:7 posx:Pos_x3 posy:Pos_y3];
	[self addPosButton:@"im1" label:@"MC1" tag:8 posx:Pos_x4 posy:Pos_y3];
	[self addPosButton:@"im2" label:@"MC2" tag:9 posx:Subs_x1 posy:Pos_y3];
	[self addPosButton:@"im3" label:@"MC3" tag:10 posx:Pos_x5 posy:Pos_y3];
	[self addPosButton:@"lw" label:@"ML" tag:11 posx:Pos_x6 posy:Pos_y3];
	
	[self addPosButton:@"fw1" label:@"SC1" tag:12 posx:Subs_x3 posy:Pos_y4];
	[self addPosButton:@"fw2" label:@"SC2" tag:13 posx:Subs_x4 posy:Pos_y4];
}

- (void)createPos7 //4-5-1
{
	[self addPosButton:@"gk" label:@"GK" tag:1 posx:Subs_x1 posy:Pos_y1];
	
    [self addPosButton:@"rb" label:@"DR" tag:2 posx:Subs_x2 posy:Pos_y2];
	[self addPosButton:@"cd1" label:@"DC1" tag:3 posx:Subs_x3 posy:Pos_y2];
	[self addPosButton:@"cd2" label:@"DC2" tag:4 posx:Subs_x4 posy:Pos_y2];
	[self addPosButton:@"lb" label:@"DL" tag:6 posx:Subs_x5 posy:Pos_y2];
	
	[self addPosButton:@"rw" label:@"MR" tag:7 posx:Pos_x3 posy:Pos_y3];
	[self addPosButton:@"im1" label:@"MC1" tag:8 posx:Pos_x4 posy:Pos_y3];
	[self addPosButton:@"im2" label:@"MC2" tag:9 posx:Subs_x1 posy:Pos_y3];
	[self addPosButton:@"im3" label:@"MC3" tag:10 posx:Pos_x5 posy:Pos_y3];
	[self addPosButton:@"lw" label:@"ML" tag:11 posx:Pos_x6 posy:Pos_y3];
	
	[self addPosButton:@"fw1" label:@"SC1" tag:12 posx:Subs_x1 posy:Pos_y4];
}

-(IBAction)posButton_tap:(id)sender
{
    [mainView buttonSound];
    
	int theTag = [sender tag];//( ( UIControl * )sender ).tag;
	
	switch(theTag)
	{
		case 1:
			self.selectedPos = @"gk";
			self.selectedPlayer = [[Globals i] getClubData][@"gk"];
			break;
		case 2:
			self.selectedPos = @"rb";
			self.selectedPlayer = [[Globals i] getClubData][@"rb"];
			break;
		case 3:
			self.selectedPos = @"cd1";
			self.selectedPlayer = [[Globals i] getClubData][@"cd1"];
			break;
		case 4:
			self.selectedPos = @"cd2";
			self.selectedPlayer = [[Globals i] getClubData][@"cd2"];
			break;
		case 5:
			self.selectedPos = @"cd3";
			self.selectedPlayer = [[Globals i] getClubData][@"cd3"];
			break;
		case 6:
			self.selectedPos = @"lb";
			self.selectedPlayer = [[Globals i] getClubData][@"lb"];
			break;
		case 7:
			self.selectedPos = @"rw";
			self.selectedPlayer = [[Globals i] getClubData][@"rw"];
			break;
		case 8:
			self.selectedPos = @"im1";
			self.selectedPlayer = [[Globals i] getClubData][@"im1"];
			break;
		case 9:
			self.selectedPos = @"im2";
			self.selectedPlayer = [[Globals i] getClubData][@"im2"];
			break;
		case 10:
			self.selectedPos = @"im3";
			self.selectedPlayer = [[Globals i] getClubData][@"im3"];
			break;
		case 11:
			self.selectedPos = @"lw";
			self.selectedPlayer = [[Globals i] getClubData][@"lw"];
			break;
		case 12:
			self.selectedPos = @"fw1";
			self.selectedPlayer = [[Globals i] getClubData][@"fw1"];
			break;
		case 13:
			self.selectedPos = @"fw2";
			self.selectedPlayer = [[Globals i] getClubData][@"fw2"];
			break;
		case 14:
			self.selectedPos = @"fw3";
			self.selectedPlayer = [[Globals i] getClubData][@"fw3"];
			break;
	}
	
	self.selectedPlayer = [self.selectedPlayer stringByReplacingOccurrencesOfString:@"," withString:@""];
	
	[self launchSquadSelect];
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

- (void)animateChangePos
{
	@autoreleasepool {
     
		[[Globals i] changePlayerFormation:self.nwPlayer :self.selectedPos];
		[self updateView];
		[[Globals i] removeLoadingAlert:self.view];
	
	}
}


@end
