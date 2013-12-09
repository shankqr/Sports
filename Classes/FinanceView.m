//
//  FinanceView.m
//  FFC
//
//  Created by Shankar Nathan on 5/27/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "FinanceView.h"
#import "Globals.h"

@implementation FinanceView
@synthesize finance;
@synthesize revenue;
@synthesize expense;

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
	
    if (wsClubData != nil)
    {
        NSDictionary *row1 = @{@"Item": @"Ticket Sales", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_stadium"]]]};
        NSDictionary *row2 = @{@"Item": @"Sponsorship", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_sponsors"]]]};
        NSDictionary *row3 = @{@"Item": @"Transfers Out", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_sales"]]]};
        NSDictionary *row4 = @{@"Item": @"Investment", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_investments"]]]};
        NSDictionary *row5 = @{@"Item": @"Competition Prizes", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"revenue_others"]]]};
        
        NSDictionary *row6 = @{@"Item": @"Construction", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_stadium"]]]};
        NSDictionary *row7 = @{@"Item": @"Player Wages", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_salary"]]]};
        NSDictionary *row8 = @{@"Item": @"Transfers In", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_purchases"]]]};
        NSDictionary *row9 = @{@"Item": @"Win Bonuses", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_interest"]]]};
        NSDictionary *row10 = @{@"Item": @"Others", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"expenses_others"]]]};

        NSDictionary *row13 = @{@"Item": @"Current Balance", @"Cost": [@"$" stringByAppendingString:[[Globals i] numberFormat:wsClubData[@"balance"]]]};
        
        self.revenue = @[row1, row2, row3, row4, row5];
        self.expense = @[row6, row7, row8, row9, row10];
        self.finance = @[row13];
        
        [self.view setNeedsDisplay];
        [self.tableView reloadData];
    }
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = @{@"Item": @"Item", @"Cost": @"Cost"};
    
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
    
    return @{@"align_top": @"1", @"r1": rowData[@"Item"], @"c1": rowData[@"Cost"]};
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [[Globals i] dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

#pragma mark Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0)
    {
		return [self.revenue count];
	}
    
	if(section == 1)
    {
		return [self.expense count];
    }
	
	if(section == 2)
    {
		return [self.finance count];
    }
	
	return  0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[Globals i] dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
	{
		return @"Income";
	}
	else if(section == 1)
	{
		return @"Expenses";
	}
	else if(section == 2)
	{
		return @"Balance";
	}
	
	return @"Balance";
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end
