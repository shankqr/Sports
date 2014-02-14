//
//  StaffView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "StaffView.h"
#import "MainView.h"
#import "Globals.h"

@implementation StaffView
@synthesize staff;
@synthesize iden;
@synthesize hireCost;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
    
    if (wsClubData != nil)
    {
        NSDictionary *row1 = @{@"Position": @"Manager", @"Image": @"staff_manager", @"Employed": wsClubData[@"managers"], @"Desc": @"Increase the effectiveness of all staff working in your club.+5XP"};
        NSDictionary *row2 = @{@"Position": @"Scout", @"Image": @"staff_scout", @"Employed": wsClubData[@"scouts"], @"Desc": @"Increase the chances of getting better player's for your club.+5XP"};
        NSDictionary *row3 = @{@"Position": @"Assistant Coach", @"Image": @"staff_coach", @"Employed": wsClubData[@"coaches"], @"Desc": @"Improves training for your players.+5XP"};
        NSDictionary *row4 = @{@"Position": @"Accountant", @"Image": @"staff_accountant", @"Employed": wsClubData[@"accountants"], @"Desc": @"Invest money to grow and reduces interest rates when in debt.+5XP"};
        NSDictionary *row5 = @{@"Position": @"Spokesperson", @"Image": @"staff_spokesperson", @"Employed": wsClubData[@"spokespersons"], @"Desc": @"Improves sponsor and fan relationship with your club.+5XP"};
        NSDictionary *row6 = @{@"Position": @"Psychologist", @"Image": @"staff_psychologist", @"Employed": wsClubData[@"psychologists"], @"Desc": @"Increase your players confidence and team spirit.+5XP"};
        NSDictionary *row7 = @{@"Position": @"Physiotherapist", @"Image": @"staff_physiotherapist", @"Employed": wsClubData[@"physiotherapists"], @"Desc": @"Reduces the risk of player injuries.+5XP"};
        NSDictionary *row8 = @{@"Position": @"Doctor", @"Image": @"staff_doctor", @"Employed": wsClubData[@"doctors"], @"Desc": @"Rehabilitate and heal injured players faster.+5XP"};
        self.staff = @[row1, row2, row3, row4, row5, row6, row7, row8];
        
        [self.tableView reloadData];
        [self.view setNeedsDisplay];
    }
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
		[[Globals i].mainView buyProduct:self.iden];
	}
	
	if(buttonIndex == 2)
	{
		NSInteger bal = [[[Globals i] getClubData][@"balance"] integerValue];
		
		if((bal > hireCost) && ([Globals i].energy > 9))
		{
			[Globals i].energy = [Globals i].energy - 10;
			[[Globals i] storeEnergy];
			[[Globals i].mainView buyStaffSuccess:@"1" :@"0"];
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
		NSInteger pval = 9;
		NSInteger bal = [[[Globals i] getClubData][@"currency_second"] integerValue];
		
		if(bal > pval)
		{
			[[Globals i].mainView buyStaffSuccess:@"2" :@"0"];
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

- (void)purchaseStaff:(NSInteger)staffId
{
	switch (staffId)
	{
		case 0:
		{
            hireCost = ([[[Globals i] getClubData][@"managers"] integerValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"1"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Manager": @"Increase the effectiveness of all staff working in your club.": price];
			break;
		}
		case 1:
		{
            hireCost = ([[[Globals i] getClubData][@"scouts"] integerValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"2"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Scout": @"Increase the chances of getting better player's for your club.": price];
			break;
		}
		case 2:
		{
            hireCost = ([[[Globals i] getClubData][@"coaches"] integerValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"3"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Assistant Coach": @"Improves training for your players.": price];
			break;
		}
		case 3:
		{
            hireCost = ([[[Globals i] getClubData][@"accountants"] integerValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"4"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Accountant": @"Invest money to grow and reduces interest rates when in debt.": price];
			break;
		}
		case 4:
		{
            hireCost = ([[[Globals i] getClubData][@"spokespersons"] integerValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"5"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Spokesperson": @"Improves sponsor and fan relationship with your club.": price];
			break;
		}
		case 5:
		{
            hireCost = ([[[Globals i] getClubData][@"psychologists"] integerValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"6"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Psychologist": @"Increase your players confidence and team spirit.": price];
			break;
		}
		case 6:
		{
            hireCost = ([[[Globals i] getClubData][@"physiotherapists"] integerValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"7"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Physiotherapist": @"Reduces the risk of player injuries.": price];
			break;
		}
		case 7:
		{
            hireCost = ([[[Globals i] getClubData][@"doctors"] integerValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"8"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Doctor": @"Rehabilitate and heal injured players faster.": price];
			break;
		}
		default:
		{
            hireCost = ([[[Globals i] getClubData][@"managers"] integerValue]+1)*10000;
            NSString *price = [NSString stringWithFormat:@"$%@ + 10 Energy", [[Globals i] intString:hireCost]];
            [[Globals i] settPurchasedProduct:@"1"];
			self.iden = [[Globals i] getProductIdentifiers][@"staff"];
			[self confirmPurchase: @"Manager": @"Increase the effectiveness of all staff working in your club.": price];
			break;
		}
	}
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *row1 = (self.staff)[[indexPath row]];
    
    return @{@"align_top": @"1", @"r1": row1[@"Position"], @"r2": row1[@"Desc"], @"c1": [NSString stringWithFormat:@"Total: %@", row1[@"Employed"]], @"i1": row1[@"Image"]};
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
    return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

@end
