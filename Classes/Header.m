//
//  Header.m
//  FFC
//
//  Created by Shankar on 8/12/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Header.h"
#import "Globals.h"

@implementation Header

- (IBAction)club_tap:(id)sender
{
	[[NSNotificationCenter defaultCenter]
     postNotificationName:@"GotoClub"
     object:self];
}

- (IBAction)gold_tap:(id)sender
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"BuyFunds"
     object:self];
}

- (IBAction)diamond_tap:(id)sender
{
	[[NSNotificationCenter defaultCenter]
     postNotificationName:@"GotoBuy"
     object:self];
}

- (IBAction)energy_tap:(id)sender
{
	[[NSNotificationCenter defaultCenter]
     postNotificationName:@"GotoRefillEnergy"
     object:self];
}

- (void)viewDidLoad
{
	self.energy_seconds = 180;
}

- (void)refillEnergy
{
	[Globals i].energy = self.energy_max;
	[[Globals i] storeEnergy];
	[self updateView];
}

- (void)updateView
{
    if (!self.energyTimer.isValid)
    {
        self.energyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    
	[self drawView];
}

- (void)onTimer
{
	if ([Globals i].energy >= self.energy_max)
	{
		self.lblEnergyTimer.text = @"Energy";
	}
	else
	{
		if(self.energy_seconds == 0)
		{
			[Globals i].energy = [Globals i].energy + 1;
			self.energy_seconds = 180;
			self.lblEnergyCounter.text = [NSString stringWithFormat:@"%ld / %ld", (long)[Globals i].energy, (long)self.energy_max];
			[[Globals i] storeEnergy];
		}
		else
		{
			self.energy_seconds = self.energy_seconds-1;
		}
	}
    [self drawView];
}

- (void)drawView
{
    NSDictionary *wsClubDict = [[Globals i] getClubData];
	
	self.gold = [wsClubDict[@"balance"] integerValue];
	self.diamond = [wsClubDict[@"currency_second"] integerValue];
	self.level = [[Globals i] getLevel];
	self.xp = [[Globals i] getXp];
	self.xp_max = [[Globals i] getXpMax];
	self.lblGold.text = [[Globals i] shortNumberFormat:wsClubDict[@"balance"]];
	if(self.gold > 0)
	{
		self.lblGold.textColor = [UIColor blackColor];
	}
	else
	{
		self.lblGold.textColor = [UIColor whiteColor];
	}
	self.lblName.text = wsClubDict[@"club_name"];
	self.lblDiamond.text = [[Globals i] numberFormat:wsClubDict[@"currency_second"]];
	self.lblLevel.text = [NSString stringWithFormat:@"%ld", (long)[[Globals i] getLevel]];
	self.lblExpCounter.text = [NSString stringWithFormat:@"%ld more", (long)self.xp_max-(long)self.xp];
	
	float bar = ((float)self.xp-[[Globals i] getXpMaxBefore]) / ((float)self.xp_max-[[Globals i] getXpMaxBefore]);
	self.pvExp.progress = bar;
	NSString *logo_url = wsClubDict[@"logo_pic"];
	if([logo_url length] > 5)
	{
        NSURL *url = [NSURL URLWithString:logo_url];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        [self.iLogo setImage:img];
	}
	else
	{
		NSString *fname = [NSString stringWithFormat:@"c%@.png", logo_url];
		[self.iLogo setImage:[UIImage imageNamed:fname]];
	}
	
	self.energy_max = [wsClubDict[@"energy"] integerValue];
	self.lblEnergyCounter.text = [NSString stringWithFormat:@"%ld / %ld", (long)[Globals i].energy, (long)self.energy_max];
	if([Globals i].energy != self.energy_max)
	{
		self.lblEnergyTimer.text = [NSString stringWithFormat:@"%ld", (long)self.energy_seconds];
	}
	else
	{
		self.lblEnergyTimer.text = @"Energy";
	}
}

@end
