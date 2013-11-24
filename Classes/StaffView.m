//
//  StaffView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "StaffView.h"
#import "StaffCell.h"
#import "MainView.h"
#import "Globals.h"

@implementation StaffView
@synthesize mainView;
@synthesize staff;
@synthesize iden;
@synthesize hireCost;

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
	NSDictionary *row1 = @{@"Position": @"Manager", @"Employed": wsClubData[@"managers"], @"Desc": @"Increase the effectiveness of all staff working in your club."};
	NSDictionary *row2 = @{@"Position": @"Scout", @"Employed": wsClubData[@"scouts"], @"Desc": @"Increase the chances of getting better player's for your club."};
	NSDictionary *row3 = @{@"Position": @"Assistant Coach", @"Employed": wsClubData[@"coaches"], @"Desc": @"Improves training for your players."};
	NSDictionary *row4 = @{@"Position": @"Accountant", @"Employed": wsClubData[@"accountants"], @"Desc": @"Invest money to grow and reduces interest rates when in debt."};
	NSDictionary *row5 = @{@"Position": @"Spokesperson", @"Employed": wsClubData[@"spokespersons"], @"Desc": @"Improves sponsor and fan relationship with your club."};
	NSDictionary *row6 = @{@"Position": @"Psychologist", @"Employed": wsClubData[@"psychologists"], @"Desc": @"Increase your players confidence and team spirit."};
	NSDictionary *row7 = @{@"Position": @"Physiotherapist", @"Employed": wsClubData[@"physiotherapists"], @"Desc": @"Reduces the risk of player injuries."};
	NSDictionary *row8 = @{@"Position": @"Doctor", @"Employed": wsClubData[@"doctors"], @"Desc": @"Rehabilitate and heal injured players faster."};
	self.staff = @[row1, row2, row3, row4, row5, row6, row7, row8];
    
	[self.tableView reloadData];
	[self.view setNeedsDisplay];
}

- (void)confirmPurchase:(NSString*)staffType :(NSString*)Desc :(NSString*)Price
{
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:[NSString stringWithFormat:@"Hire %@", staffType]
						  message:Desc
						  delegate:self
						  cancelButtonTitle:@"Cancel"
						  otherButtonTitles:@"USD$0.99", Price, @"10 Diamonds", nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
		[mainView buyProduct:self.iden];
	}
	
	if(buttonIndex == 2)
	{
		int bal = [[[[Globals i] getClubData][@"balance"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
		
		if((bal > hireCost) && ([Globals i].energy > 9))
		{
			[Globals i].energy = [Globals i].energy - 10;
			[[Globals i] storeEnergy];
			[mainView buyStaffSuccess:@"1" :@"0"];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Accountant"
								  message:@"Insufficient club funds or Energy. Use real funds USD$0.99?"
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
			[mainView buyStaffSuccess:@"2" :@"0"];
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

-(void)purchaseStaff:(NSInteger)staffId
{
	switch (staffId)
	{
		case 0:
		{
            hireCost = ([[[[Globals i] getClubData][@"managers"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"1"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Manager": @"Increase the effectiveness of all staff working in your club.": price];
			break;
		}
		case 1:
		{
            hireCost = ([[[[Globals i] getClubData][@"scouts"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"2"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Scout": @"Increase the chances of getting better player's for your club.": price];
			break;
		}
		case 2:
		{
            hireCost = ([[[[Globals i] getClubData][@"coaches"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"3"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Assistant Coach": @"Improves training for your players.": price];
			break;
		}
		case 3:
		{
            hireCost = ([[[[Globals i] getClubData][@"accountants"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"4"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Accountant": @"Invest money to grow and reduces interest rates when in debt.": price];
			break;
		}
		case 4:
		{
            hireCost = ([[[[Globals i] getClubData][@"spokespersons"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"5"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Spokesperson": @"Improves sponsor and fan relationship with your club.": price];
			break;
		}
		case 5:
		{
            hireCost = ([[[[Globals i] getClubData][@"psychologists"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"6"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Psychologist": @"Increase your players confidence and team spirit.": price];
			break;
		}
		case 6:
		{
            hireCost = ([[[[Globals i] getClubData][@"physiotherapists"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"7"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Physiotherapist": @"Reduces the risk of player injuries.": price];
			break;
		}
		case 7:
		{
            hireCost = ([[[[Globals i] getClubData][@"doctors"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"8"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Doctor": @"Rehabilitate and heal injured players faster.": price];
			break;
		}
		default:
		{
            hireCost = ([[[[Globals i] getClubData][@"managers"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"1"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Manager": @"Increase the effectiveness of all staff working in your club.": price];
			break;
		}
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"StaffCell";
	
	StaffCell *cell = (StaffCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StaffCell" owner:self options:nil];
		cell = (StaffCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.staff)[row];
	
	cell.staffPos.text = rowData[@"Position"];
	cell.staffEmployed.text = [NSString stringWithFormat:@"Total: %@", rowData[@"Employed"]];
	cell.staffCost.text = rowData[@"Desc"];
	
	cell.staffPos.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
	cell.staffEmployed.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
	
	NSString *fname = [NSString stringWithFormat:@"%@.png", rowData[@"Position"]];
	[cell.faceImage setImage:[UIImage imageNamed:fname]];
	
	return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self purchaseStaff:[indexPath row]];
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.staff count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70*SCALE_IPAD;
}

@end
