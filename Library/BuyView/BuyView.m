//
//  BuyView.m
//  Kingdom Game
//
//  Created by Shankar on 1/15/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

#import "BuyView.h"
#import "Globals.h"

@implementation BuyView

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateView];
}

- (void)updateView
{
    NSDictionary *row0 = @{@"h1": @"Diamonds for Sale!"};
    NSDictionary *row1 = @{@"1": @"sc3", @"2": @"com.tapf", @"3": @"6145148", @"r1": @"Provides 60 Diamonds", @"r2": @"USD $4.99", @"i1": @"icon_diamond1", @"i2": @"arrow_right"};
    NSDictionary *row2 = @{@"1": @"sc4", @"2": @"com.tapf", @"3": @"9425144", @"r1": @"Provides 150 Diamonds", @"r2": @"USD $9.99 (SALE 30% Extra Value!)", @"i1": @"icon_diamond1", @"i2": @"arrow_right"};
    NSDictionary *row3 = @{@"1": @"sc5", @"2": @"com.tapf", @"3": @"1736703", @"r1": @"Provides 275 Diamonds", @"r2": @"USD $19.99 (SALE 38% Extra Value!)", @"i1": @"icon_diamond1", @"i2": @"arrow_right"};
    NSDictionary *row4 = @{@"1": @"sc6", @"2": @"com.tapf", @"3": @"6597164", @"r1": @"Provides 800 Diamonds", @"r2": @"USD $49.99 (SALE 45% Extra Value!)", @"r3": @"(Most Popular!)", @"i1": @"icon_diamond1", @"i2": @"arrow_right"};
    NSDictionary *row5 = @{@"1": @"sc7", @"2": @"com.tapf", @"3": @"2792559", @"r1": @"Provides 1700 Diamonds", @"r2": @"USD $99.99 (SALE 58% Extra Value!)", @"r3": @"(Best Value!)", @"i1": @"icon_diamond1", @"i2": @"arrow_right"};
    
    self.rows = @[row0, row1, row2, row3, row4, row5];
    
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell;
    
    cell = [DynamicCell dynamicCell:self.tableView rowData:(self.rows)[indexPath.row] cellWidth:CELL_CONTENT_WIDTH];
    
	return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) //Not Header row
    {
        NSDictionary *rowData = (self.rows)[indexPath.row];
        
        [[Globals i] settPurchasedProduct:rowData[@"3"]];
        
        NSString *pi = [[Globals i] wsProductIdentifiers][rowData[@"1"]];
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:pi forKey:@"pi"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchase"
                                                            object:self
                                                          userInfo:userInfo];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [DynamicCell dynamicCellHeight:(self.rows)[indexPath.row] cellWidth:CELL_CONTENT_WIDTH];
}

@end
