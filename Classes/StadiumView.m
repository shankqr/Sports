//
//  StadiumView.m
//  FFC
//
//  Created by Shankar Nathan on 5/26/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//
#import "StadiumView.h"
#import "Globals.h"
#import "MainView.h"

@implementation StadiumView
@synthesize stadiumNameLabel;
@synthesize capacityLabel;
@synthesize ticketLabel;
@synthesize levelLabel;
@synthesize rentLabel;

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
	stadiumNameLabel.text = @"Good Condition";
	capacityLabel.text = [[Globals i] numberFormat:wsClubData[@"stadium_capacity"]];
	ticketLabel.text = [@"$ " stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"average_ticket"]]];
	levelLabel.text = wsClubData[@"stadium"];
	rentLabel.text = [@"$ " stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_stadium"]]];
	
	[self.view setNeedsDisplay];
}

- (IBAction)upgradeButton_tap:(id)sender
{
	NSInteger cost = [levelLabel.text integerValue]*5000;
	NSNumber* number = @(cost);
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
	[numberFormatter setGroupingSeparator:@","];
	NSString* commaString = [numberFormatter stringForObjectValue:number];
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Payment Option"
						  message:@"You will get +5XP. How would you like to cover the stadium upgrade cost?"
						  delegate:self
						  cancelButtonTitle:@"Cancel"
						  otherButtonTitles:@"Real Funds", [NSString stringWithFormat:@"$%@ + 10 Energy",commaString], @"10 Diamonds", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
        [[Globals i] settPurchasedProduct:@"9"];
		NSInteger stadiumtype = 1;
		if([[[Globals i] getClubData][@"stadium"] integerValue] > 70)
		{
			stadiumtype = 10;
		}
		else 
		{
			stadiumtype = 1 + (([[[Globals i] getClubData][@"stadium"] integerValue]-1)/8);
		}
		NSString *i = [NSString stringWithFormat:@"upgrade%ld", (long)stadiumtype];
		NSString *pi = [[Globals i] getProductIdentifiers][i];

        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:pi forKey:@"pi"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchase"
                                                            object:self
                                                          userInfo:userInfo];
	}
	
	if(buttonIndex == 2)
	{
		NSInteger cost = [[[Globals i] getClubData][@"stadium"] integerValue]*5000;
		NSInteger bal = [[[Globals i] getClubData][@"balance"] integerValue];
		
		if((bal > cost) && ([Globals i].energy > 9))
		{
			[Globals i].energy=[Globals i].energy-10;
			[[Globals i] storeEnergy];
			[[Globals i].mainView buyStadiumSuccess:@"1":@"0"];
            
            [[Globals i] closeTemplate];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Accountant"
								  message:@"Insufficient club funds or Energy. Use real funds?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  otherButtonTitles:@"OK", nil];
			[alert show];
		}
	}
    
    if(buttonIndex == 3)
	{
		NSInteger pval = 9;
		NSInteger bal = [[[Globals i] getClubData][@"currency_second"] integerValue];
		
		if(bal > pval)
		{
			[[Globals i].mainView buyStadiumSuccess:@"2":@"0"];
            
            [[Globals i] closeTemplate];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Accountant"
								  message:@"Insufficient Diamonds. Use real funds USD$0.99?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  otherButtonTitles:@"OK", nil];
			[alert show];
		}
	}
}

@end
