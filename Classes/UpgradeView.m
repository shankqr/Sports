//
//  UpgradeView.m
//  FFC
//
//  Created by Shankar Nathan on 5/26/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//
#import "UpgradeView.h"
#import "Globals.h"
#import "MainView.h"
#import "StadiumMap.h"

@implementation UpgradeView
@synthesize buildingImage;
@synthesize infoLabel;
@synthesize timeLabel;
@synthesize cashLabel;
@synthesize formulaLabel;
@synthesize buildingType;

- (void)updateView:(NSInteger)type
{
    buildingType = type;
    
    NSInteger s = [[[Globals i] getClubData][@"stadium"] integerValue];
    NSInteger b1 = [[[Globals i] getClubData][@"building1"] integerValue];
    NSInteger b2 = [[[Globals i] getClubData][@"building2"] integerValue];
    NSInteger b3 = [[[Globals i] getClubData][@"building3"] integerValue];
    
    if (type==1) 
    {
        if (b1 > 0) 
        {
            cashLabel.text = @"+5XP. Upgrade Hotel for 15 Diamonds?";
            timeLabel.text = [NSString stringWithFormat:@"Generates $%ld every 24 Hours", ((long)b1+1)*((long)b1+1)+s];
            infoLabel.text = [NSString stringWithFormat:@"Current Level %ld: $%ld every 24 Hours", (long)b1, (long)b1*b1+s];
        }
        else
        {
            cashLabel.text = @"+5XP. Build Hotel for 15 Diamonds?";
            timeLabel.text = @"";
            infoLabel.text = @"";
        }
        if (b1 > 10) 
        {
            buildingImage.image = [UIImage imageNamed:@"building_hotel11.png"];
        }
        else
        {
            buildingImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"building_hotel%ld.png", (long)b1+1]];
        }
        formulaLabel.text = @"Income $ formula: Level x Level + StadiumLevel";
    }
    if (type==2) 
    {
        if (b2 > 0) 
        {
            cashLabel.text = @"+5XP. Upgrade Food Business for 5 Diamonds?";
            timeLabel.text = [NSString stringWithFormat:@"Generates $%ld every 8 Hours", (long)(b2+1)*s];
            infoLabel.text = [NSString stringWithFormat:@"Current Level %ld: $%ld every 8 Hours", (long)b2, (long)b2*s];
        }
        else
        {
            cashLabel.text = @"+5XP. Build Food Business for 5 Diamonds?";
            timeLabel.text = @"";
            infoLabel.text = @"";
        }
        if (b2 > 10) 
        {
            buildingImage.image = [UIImage imageNamed:@"building_food11.png"];
        }
        else
        {
            buildingImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"building_food%ld.png", (long)b2+1]];
        }
        formulaLabel.text = @"Income $ formula: Level x StadiumLevel";
    }
    if (type==3) 
    {
        if (b3 > 0) 
        {
            cashLabel.text = @"+5XP. Upgrade Manager Office for 10 Diamonds?";
            timeLabel.text = [NSString stringWithFormat:@"Generates $%ld every 1 Hour", (long)(b3+1)*b1+b2+s];
            infoLabel.text = [NSString stringWithFormat:@"Current Level %ld: $%ld every 1 Hour", (long)b3, (long)b3*b1+b2+s];
        }
        else
        {
            cashLabel.text = @"+5XP. Build Manager Office for 10 Diamonds?";
            timeLabel.text = @"";
            infoLabel.text = @"";
        }
        if (b3 > 10) 
        {
            buildingImage.image = [UIImage imageNamed:@"building_office11.png"];
        }
        else
        {
            buildingImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"building_office%ld.png", (long)b3+1]];
        }
        formulaLabel.text = @"$: Level x HotelLevel + FoodLevel + StadiumLevel";
    }
    
	[self.view setNeedsDisplay];
}

- (IBAction)upgradeButton_tap:(id)sender
{
    NSInteger cost = 0;
    if (buildingType==1)
    {
        cost = 15;
    }
    if (buildingType==2)
    {
        cost = 5;
    }
    if (buildingType==3) 
    {
        cost = 10;
    }
    NSInteger bal = [[[Globals i] getClubData][@"currency_second"] integerValue];
    
    if(bal >= cost)
    {
        NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/Upgrade2/%@/%ld",
						   WS_URL, [[Globals i] UID], (long)buildingType];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		NSString *returnValue  = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		
		if([returnValue isEqualToString:@"1"])
		{
            NSNumber *xp = [NSNumber numberWithInteger:5];
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:xp forKey:@"xp_gain"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateXP"
                                                                object:self
                                                              userInfo:userInfo];
            
            [[Globals i] showToast:@"+5 XP for upgrading a building!"
                     optionalTitle:nil
                     optionalImage:@"tick_yes"];
            
			if([[Globals i] updateClubData]) //Diamonds deducted for upgrade
			{
                [[Globals i].mainView.stadiumMap updateView];
                
                [[Globals i] closeTemplate];
			}
		}
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Accountant"
                              message:@"Insufficient Diamonds. Buy more?"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"GotoBuy"
         object:self];
	}
}

@end
