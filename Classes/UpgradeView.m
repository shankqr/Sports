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
            cashLabel.text = @"Upgrade Hotel Business for $50,000?";
            timeLabel.text = [NSString stringWithFormat:@"Generates $%ld every 24 Hours", ((long)b1+1)*((long)b1+1)+s];
            infoLabel.text = [NSString stringWithFormat:@"Current Level %ld: $%ld every 24 Hours", (long)b1, (long)b1*b1+s];
        }
        else
        {
            cashLabel.text = @"Build Hotel Business for $50,000?";
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
            cashLabel.text = @"Upgrade Food Business for $10,000?";
            timeLabel.text = [NSString stringWithFormat:@"Generates $%ld every 8 Hours", (long)(b2+1)*s];
            infoLabel.text = [NSString stringWithFormat:@"Current Level %ld: $%ld every 8 Hours", (long)b2, (long)b2*s];
        }
        else
        {
            cashLabel.text = @"Build Food Business for $10,000?";
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
            cashLabel.text = @"Upgrade Manager Office for $20,000?";
            timeLabel.text = [NSString stringWithFormat:@"Generates $%ld every 1 Hour", (long)(b3+1)*b1+b2+s];
            infoLabel.text = [NSString stringWithFormat:@"Current Level %ld: $%ld every 1 Hour", (long)b3, (long)b3*b1+b2+s];
        }
        else
        {
            cashLabel.text = @"Build Manager Office for $20,000?";
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

-(IBAction)upgradeButton_tap:(id)sender
{
    NSInteger cost = 0;
    if (buildingType==1) 
    {
        cost = 50000;
    }
    if (buildingType==2) 
    {
        cost = 10000;
    }
    if (buildingType==3) 
    {
        cost = 20000;
    }
    NSInteger bal = [[[Globals i] getClubData][@"balance"] integerValue];
    
    if((bal > cost) && ([Globals i].energy > 9))
    {
        NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/Upgrade/%@/%ld", 
						   WS_URL, [[Globals i] UID], (long)buildingType];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		NSString *returnValue  = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		
		if([returnValue isEqualToString:@"1"])
		{
			if([[Globals i] updateClubData]) //Balance and energy deducted for upgrade
			{
                [Globals i].energy=[Globals i].energy-10;
                [[Globals i] storeEnergy];
                
                [[Globals i].mainView.stadiumMap updateView];
                [[Globals i].mainView.stadiumMap upgradeBuilding:buildingType];
                
                NSString *message = @"I have just build a new building in my city.";
                NSString *extra_desc = @"Buildings generates revenue and fans for your club.";
                NSString *imagename = @"upgrade_building.png";
                [[Globals i] fbPublishStory:message :extra_desc :imagename];
                
                [[Globals i] closeTemplate];
			}
		}
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Accountant"
                              message:@"Insufficient club Funds or less then 10 Energy. Buy more Funds?"
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
        [[Globals i] showBuy];
	}
}

@end
