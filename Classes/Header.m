//
//  Header.m
//  FFC
//
//  Created by Shankar on 8/12/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Header.h"

@implementation Header
@synthesize mainView;
@synthesize jobComplete;
@synthesize jobLevelup;
@synthesize jobRefill;
@synthesize animation1View;
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


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (IBAction)club_tap:(id)sender
{
	[mainView jumpToClub];
}

- (IBAction)gold_tap:(id)sender
{
	[[Globals i] showBuy];
}

- (IBAction)diamond_tap:(id)sender
{
	[[Globals i] showBuy];
}

- (IBAction)energy_tap:(id)sender
{
	[self showJobRefill];
}

- (void)viewDidLoad
{
	energy_seconds = 180;
	
	//Prepare animation 1
	animation1View = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-Animation_x1)/2, (UIScreen.mainScreen.bounds.size.height-Animation_y1)/2, Animation_x1, Animation_y1)];
	NSMutableArray *image1Array  = [[NSMutableArray alloc] init];
	for(NSInteger i = 0; i < 6; i++)
	{
        NSString *fileName = [[NSString alloc] initWithFormat:@"g1_%d.png", i];
        UIImage *img = [UIImage imageNamed:fileName];
        [image1Array addObject:img];
    }
	animation1View.animationImages = image1Array;
	animation1View.animationDuration = 1.0;
	animation1View.animationRepeatCount = 50;
}

- (void)showJobAnimation
{
	@autoreleasepool {
	
        [[mainView.view superview] insertSubview:animation1View atIndex:7];
        [animation1View startAnimating];
    
	}
}

- (void)removeJobAnimation
{
	[animation1View removeFromSuperview];
	[animation1View stopAnimating];
}

- (void)showJobRefill
{
    if (jobRefill == nil) 
    {
        jobRefill = [[JobRefill alloc] initWithNibName:@"JobRefill" bundle:nil];
        jobRefill.mainView = self.mainView;
        jobRefill.titleText = @"REFILL ENERGY?";
    }
	[[mainView.view superview] insertSubview:jobRefill.view atIndex:5];
	[jobRefill updateView];
}

- (void)showJobComplete:(NSInteger)xp_gain
{
    if (jobComplete == nil) 
    {
        jobComplete = [[JobComplete alloc] initWithNibName:@"JobComplete" bundle:nil];
        jobComplete.mainView = self.mainView;
    }
	jobComplete.titleText = [NSString stringWithFormat:@"+ %d XP", xp_gain];
	[[mainView.view superview] insertSubview:jobComplete.view atIndex:5];
	[jobComplete updateView];
}

- (void)showLevelUp
{
    if (jobLevelup == nil)
    {
        jobLevelup = [[JobLevelup alloc] initWithNibName:@"JobLevelup" bundle:nil];
        jobLevelup.mainView = self.mainView;
    }
	jobLevelup.moneyText = [[NSString alloc] initWithFormat:@"+$%d", level*1000];
	jobLevelup.fansText = [[NSString alloc] initWithFormat:@"+%d", level*10];
	jobLevelup.energyText = [[NSString alloc] initWithFormat:@"+%d", 3];
	[[mainView.view superview] insertSubview:jobLevelup.view atIndex:4];
	[jobLevelup updateView];
}

- (BOOL)doJob:(NSInteger)energy_used :(NSInteger)xp_gain
{
	if([Globals i].energy >= energy_used)
	{
		[NSThread detachNewThreadSelector:@selector(showJobAnimation) toTarget:self withObject:nil];
		
		NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/DoJobNew/%@/%d/%.0f", 
						   WS_URL, [[Globals i] UID], xp_gain, timeInterval];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		NSString *returnValue  = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		
		if([returnValue isEqualToString:@"1"])
		{
			if([[Globals i] updateClubData])
			{
				[mainView hideHeader];
				[mainView hideFooter];
				
				[Globals i].energy = [Globals i].energy - energy_used;
				[[Globals i] storeEnergy];
				xp = xp + xp_gain;
				
				[self removeJobAnimation];
				
				if(xp >= xp_max)
				{
					level = level + 1;
					[self showLevelUp];
                    [[Globals i] winSound];
				}
				else 
				{
					[self showJobComplete:xp_gain];
				}
				
				return YES;
			}
			else
			{
				//[mainView showLogin];
				
				return NO;
			}
		}
		else
		{
			//Webservice failed
			//[mainView showLogin];
			
			return NO;
		}
	}
	else 
	{
		[self showJobRefill];
		return NO;
	}

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
			lblEnergyCounter.text = [NSString stringWithFormat:@"%d / %d", [Globals i].energy, energy_max];
			[[Globals i] storeEnergy];
		}
		else
		{
			energy_seconds = energy_seconds-1;
		}
		//lblEnergyTimer.text = [NSString stringWithFormat:@"%ds", energy_seconds];
	}
    [self drawView];
}

- (void)drawView
{
    NSDictionary *wsClubData = [[Globals i] getClubData];
	
	gold = [[wsClubData[@"balance"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
	diamond = [[wsClubData[@"currency_second"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
	level = [[Globals i] getLevel];
	xp = [[Globals i] getXp];
	xp_max = [[Globals i] getXpMax];
	lblGold.text = [[Globals i] numberFormat:wsClubData[@"balance"]];
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
	lblLevel.text = [NSString stringWithFormat:@"%d", [[Globals i] getLevel]];
	lblExpCounter.text = [NSString stringWithFormat:@"%d more", xp_max-xp];
	
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
	
	energy_max = [[wsClubData[@"energy"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
	lblEnergyCounter.text = [NSString stringWithFormat:@"%d / %d", [Globals i].energy, energy_max];
	if([Globals i].energy != energy_max)
	{
		lblEnergyTimer.text = [NSString stringWithFormat:@"%ds", energy_seconds];
	}
	else
	{
		lblEnergyTimer.text = @"Energy";
	}
}

@end
