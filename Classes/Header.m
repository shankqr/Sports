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
@synthesize lblDiamond;
@synthesize lblName;
@synthesize lblGold;
@synthesize lblLevel;
@synthesize lblExpCounter;
@synthesize lblEnergyCounter;
@synthesize lblEnergyTimer;
@synthesize iLogo;
@synthesize pvExp;
@synthesize energyTimer;
@synthesize btnDiamond;
@synthesize btnEnergy;
@synthesize btnGold;

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
	[[Globals i] showBuy];
}

- (IBAction)energy_tap:(id)sender
{
	[[NSNotificationCenter defaultCenter]
     postNotificationName:@"GotoRefillEnergy"
     object:self];
}

- (void)viewDidLoad
{
	energy_seconds = 180;
}

- (void)refillEnergy
{
	[Globals i].energy = energy_max;
	[[Globals i] storeEnergy];
	[self updateView];
}

- (void)updateView
{
    if (!energyTimer.isValid)
    {
        energyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    
	[self drawView];
}

- (void)onTimer
{
	if ([Globals i].energy >= energy_max)
	{
		lblEnergyTimer.text = @"Energy";
	}
	else
	{
		if(energy_seconds == 0)
		{
			[Globals i].energy = [Globals i].energy + 1;
			energy_seconds = 180;
			lblEnergyCounter.text = [NSString stringWithFormat:@"%ld / %ld", (long)[Globals i].energy, (long)energy_max];
			[[Globals i] storeEnergy];
		}
		else
		{
			energy_seconds = energy_seconds-1;
		}
	}
    [self drawView];
}

- (void)drawView
{
    NSDictionary *wsClubData = [[Globals i] getClubData];
	
	gold = [wsClubData[@"balance"] integerValue];
	diamond = [wsClubData[@"currency_second"] integerValue];
	level = [[Globals i] getLevel];
	xp = [[Globals i] getXp];
	xp_max = [[Globals i] getXpMax];
	lblGold.text = [[Globals i] shortNumberFormat:wsClubData[@"balance"]];
	if(gold > 0)
	{
		lblGold.textColor = [UIColor blackColor];
	}
	else
	{
		lblGold.textColor = [UIColor whiteColor];
	}
	lblName.text = wsClubData[@"club_name"];
	lblDiamond.text = [[Globals i] numberFormat:wsClubData[@"currency_second"]];
	lblLevel.text = [NSString stringWithFormat:@"%ld", (long)[[Globals i] getLevel]];
	lblExpCounter.text = [NSString stringWithFormat:@"%ld more", (long)xp_max-(long)xp];
	
	float bar = ((float)xp-[[Globals i] getXpMaxBefore]) / ((float)xp_max-[[Globals i] getXpMaxBefore]);
	pvExp.progress = bar;
	NSString *logo_url = wsClubData[@"logo_pic"];
	if([logo_url length] > 5)
	{
        NSURL *url = [NSURL URLWithString:logo_url];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        [iLogo setImage:img];
	}
	else
	{
		NSString *fname = [NSString stringWithFormat:@"c%@.png", logo_url];
		[iLogo setImage:[UIImage imageNamed:fname]];
	}
	
	energy_max = [wsClubData[@"energy"] integerValue];
	lblEnergyCounter.text = [NSString stringWithFormat:@"%ld / %ld", (long)[Globals i].energy, (long)energy_max];
	if([Globals i].energy != energy_max)
	{
		lblEnergyTimer.text = [NSString stringWithFormat:@"%ld", (long)energy_seconds];
	}
	else
	{
		lblEnergyTimer.text = @"Energy";
	}
}

@end
