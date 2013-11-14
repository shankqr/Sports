//
//  StadiumView.m
//  FFC
//
//  Created by Shankar Nathan on 5/26/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//
#import "StadiumView.h"

@implementation StadiumView
@synthesize mainView;
@synthesize stadiumNameLabel;
@synthesize capacityLabel;
@synthesize ticketLabel;
@synthesize levelLabel;
@synthesize rentLabel;
@synthesize upgradeDateLabel;


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
	stadiumNameLabel.text = wsClubData[@"stadium_status"];
	capacityLabel.text = [[Globals i] numberFormat:wsClubData[@"stadium_capacity"]];
	ticketLabel.text = [@"$ " stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"average_ticket"]]];
	levelLabel.text = wsClubData[@"stadium"];
	rentLabel.text = [@"$ " stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_stadium"]]];
	
	[self.view setNeedsDisplay];
}

- (IBAction)cancelButton_tap:(id)sender
{
	[mainView backSound];
    
	[self.view removeFromSuperview];
}

-(IBAction)upgradeButton_tap:(id)sender
{
	[mainView buttonSound];
	int cost = [[levelLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]*5000;
	NSNumber* number = @(cost);
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
	[numberFormatter setGroupingSeparator:@","];
	NSString* commaString = [numberFormatter stringForObjectValue:number];
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Payment Option"
						  message:@"How would you like to cover the stadium upgrade cost?"
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
		int stadiumtype = 1;
		if([[[[Globals i] getClubData][@"stadium"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] > 70)
		{
			stadiumtype = 10;
		}
		else 
		{
			stadiumtype = 1 + (([[[[Globals i] getClubData][@"stadium"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]-1)/8);
		}
		NSString *i = [NSString stringWithFormat:@"upgrade%d", stadiumtype];
		NSString *pi = [[Globals i] getProductIdentifiers][i];
		[mainView buyProduct:pi];
	}
	
	if(buttonIndex == 2)
	{
		int cost = [[[[Globals i] getClubData][@"stadium"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]*5000;
		int bal = [[[[Globals i] getClubData][@"balance"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
		
		if((bal > cost) && ([Globals i].energy > 9))
		{
			[Globals i].energy=[Globals i].energy-10;
			[[Globals i] storeEnergy];
			[mainView buyStadiumSuccess:@"1":@"0"];
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
		int pval = 9;
		int bal = [[[[Globals i] getClubData][@"currency_second"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
		
		if(bal > pval)
		{
			[mainView buyStadiumSuccess:@"2":@"0"];
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
