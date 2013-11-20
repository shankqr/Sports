//
//  FinanceView.m
//  FFC
//
//  Created by Shankar Nathan on 5/27/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "FinanceView.h"
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import "MainView.h"
#import "Globals.h"
#import "FinanceCell.h"

@implementation FinanceView
@synthesize mainView;
@synthesize finance;
@synthesize revenue;
@synthesize expense;
@synthesize alertTitle;
@synthesize alertMessage;
@synthesize selectedRow;
@synthesize table;

- (IBAction)addfunds_tap:(id)sender
{
    [[Globals i] showBuy];
}

- (void)viewDidLoad
{

}

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
	
	NSDictionary *row1 = @{@"Item": @"Stadium", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_stadium"]]]};
	NSDictionary *row2 = @{@"Item": @"Sponsors", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_sponsors"]]]};
	NSDictionary *row3 = @{@"Item": @"Sales", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_sales"]]]};
	NSDictionary *row4 = @{@"Item": @"Investments", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_investments"]]]};
	NSDictionary *row5 = @{@"Item": @"Others", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_others"]]]};
	
	NSDictionary *row6 = @{@"Item": @"Stadium", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_stadium"]]]};
	NSDictionary *row7 = @{@"Item": @"Salary", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_salary"]]]};
	NSDictionary *row8 = @{@"Item": @"Purchase", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_purchases"]]]};
	NSDictionary *row9 = @{@"Item": @"Interest", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_interest"]]]};
	NSDictionary *row10 = @{@"Item": @"Others", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_others"]]]};

	NSDictionary *row11 = @{@"Item": @"Total Revenue", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_total"]]]};	
	NSDictionary *row12 = @{@"Item": @"Total Expenses", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_total"]]]};
	NSDictionary *row13 = @{@"Item": @"Current Balance", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"balance"]]]};
	
	self.revenue = @[row1, row2, row3, row4, row5];
	self.expense = @[row6, row7, row8, row9, row10];
	self.finance = @[row11, row12, row13];
    
    //[table setFrame:CGRectMake(0, HeaderFinance_height, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height-HeaderFinance_height)];
	[table reloadData];
	[self.view setNeedsDisplay];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"FinanceCell";
	NSDictionary *rowData = @{@"Item": @"Item", @"Cost": @"Cost"};
	
	FinanceCell *cell = (FinanceCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FinanceCell" owner:self options:nil];
		cell = (FinanceCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	if(indexPath.section == 0)
	{
		rowData = (self.revenue)[indexPath.row];
	}
	else if(indexPath.section == 1)
	{
		rowData = (self.expense)[indexPath.row];
	}
	else if(indexPath.section == 2)
	{
		rowData = (self.finance)[indexPath.row];
	}
	
	cell.item.text = rowData[@"Item"];
	cell.cost1.text = rowData[@"Cost"];
	cell.item.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
	cell.cost1.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];

	return cell;
}

#pragma mark Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0)
		return [self.revenue count];
	
	if(section == 1)
		return [self.expense count];
	
	if(section == 2)
		return [self.finance count];
	
	return  0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 33*SCALE_IPAD;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
	{
		return @"Revenue";
	}
	else if(section == 1)
	{
		return @"Expense";
	}
	else if(section == 2)
	{
		return @"Summary";
	}
	
	return @"Summary";
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	selectedRow = indexPath.section*10 + indexPath.row;
	BOOL requireAction = YES;
	switch(selectedRow)
	{
		case 0:
		{
			requireAction = YES;
			alertTitle = @"Stadium Revenue";
			alertMessage = @"Revenue from stadium comes from ticket sales of all matches played at your stadium. Upgrade stadium to increase ticket sales?";
			break;
		}
		case 1:
		{
			requireAction = YES;
			alertTitle = @"Sponsors Revenue";
			alertMessage = @"The more fans your club have the more revenue you get from sponsors. Hire more spokesperson to improve sponsor and fan relationship with your club?";
			break;
		}
		case 2:
		{
			requireAction = YES;
			alertTitle = @"Sales Revenue";
			alertMessage = @"Players you sell off will contribute to your sales revenue. The more training your player gets, the higher it's selling value. Hire more coaches?";
			break;
		}
		case 3:
		{
			requireAction = YES;
			alertTitle = @"Investments Revenue";
			alertMessage = @"Accountants invest your club money to earn extra revenue. Hire more accountants?";
			break;
		}
		case 4:
		{
			requireAction = YES;
			alertTitle = @"Others Revenue";
			alertMessage = @"This is revenue your club earns from winning the league or cup. Increase your chances of winning by buying more new players?";
			break;
		}
		case 10:
		{
			requireAction = NO;
			alertTitle = @"Stadium Expenses";
			alertMessage = @"Renting or maintenance fee of your stadium.";
			break;
		}
		case 11:
		{
			requireAction = NO;
			alertTitle = @"Salary Expenses";
			alertMessage = @"Salary paid to your players and coaches.";
			break;
		}
		case 12:
		{
			requireAction = YES;
			alertTitle = @"Purchase Expenses";
			alertMessage = @"Any purchase of new players, coaches or other products. Visit the online store?";
			break;
		}
		case 13:
		{
			requireAction = YES;
			alertTitle = @"Interest Expenses";
			alertMessage = @"Accountants reduces your interest rates when your club is in debt. Hire more accountants?";
			break;
		}
		case 14:
		{
			requireAction = NO;
			alertTitle = @"Others Expenses";
			alertMessage = @"Expenses such as rename fee, match fee and other fees will fall under here.";
			break;
		}
		case 20:
		{
			requireAction = NO;
			alertTitle = @"Total Revenue";
			alertMessage = @"This is the total revenue for the week.";
			break;
		}
		case 21:
		{
			requireAction = NO;
			alertTitle = @"Total Expenses";
			alertMessage = @"This is the total expenses for the week.";
			break;
		}
		case 22:
		{
			requireAction = NO;
			alertTitle = @"Current Balance";
			alertMessage = @"This is the available funds in your club account.";
			break;
		}
	}
	
	if(requireAction)
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:alertTitle
							  message:alertMessage
							  delegate:self
							  cancelButtonTitle:@"Cancel"
							  otherButtonTitles:@"OK", nil];
		[alert show];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:alertTitle
							  message:alertMessage
							  delegate:self
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
	}
	
	return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
		switch(selectedRow)
		{
			case 0:
			{
                [[Globals i] settPurchasedProduct:@"9"];
				int stadiumtype = 1;
				if([[[[Globals i] getClubData][@"stadium"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] > 88)
				{
					stadiumtype = 10;
				}
				else 
				{
					stadiumtype = 1 + (([[[[Globals i] getClubData][@"stadium"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]+1)/10);
				}
				NSString *i = [NSString stringWithFormat:@"upgrade%d", stadiumtype];
				NSString *pi = [[Globals i] getProductIdentifiers][i];
				[mainView buyProduct:pi];
				break;
			}
			case 1:
			{
                [[Globals i] settPurchasedProduct:@"5"];
				[mainView buyProduct:[[Globals i] getProductIdentifiers][@"staff"]];
				break;
			}
			case 2:
			{
                [[Globals i] settPurchasedProduct:@"3"];
				[mainView buyProduct:[[Globals i] getProductIdentifiers][@"staff"]];
				break;
			}
			case 3:
			{
                [[Globals i] settPurchasedProduct:@"4"];
				[mainView buyProduct:[[Globals i] getProductIdentifiers][@"staff"]];
				break;
			}
			case 4:
			{
				[mainView showPlayerStore];
				break;
			}
			case 12:
			{
				[mainView showCoachStore];
				break;
			}
			case 13:
			{
                [[Globals i] settPurchasedProduct:@"4"];
				[mainView buyProduct:[[Globals i] getProductIdentifiers][@"staff"]];
				break;
			}
		}
		
	}
}

@end
