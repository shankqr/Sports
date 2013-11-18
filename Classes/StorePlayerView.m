//
//  StorePlayerView.m
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "StorePlayerView.h"
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import "Globals.h"
#import "MainView.h"
#import "BidView.h"
#import "PlayerCell.h"

@implementation StorePlayerView
@synthesize mainView;
@synthesize table;
@synthesize players;
@synthesize filter;
@synthesize sold_player_id;
@synthesize sel_player_id;
@synthesize sel_player_value;
@synthesize sel_player_star;
@synthesize bidView;


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)viewDidLoad
{
    self.wantsFullScreenLayout = YES;
    
    if (UIScreen.mainScreen.bounds.size.height != 568 && !iPad)
    {
        [table setFrame:CGRectMake(0, table.frame.origin.y, 320, UIScreen.mainScreen.bounds.size.height-table.frame.origin.y)];
    }
}

- (void)updateView
{
	if(!workingPlayerSale)
	{
		[table removeFromSuperview];
		[[Globals i] showLoadingAlert];
		[NSThread detachNewThreadSelector: @selector(getProductPlayer) toTarget:self withObject:nil];
	}
}

-(void)getProductPlayer
{
	@autoreleasepool {
	
		workingPlayerSale = YES;
		[[Globals i] updatePlayerSaleData];
		self.players = [[Globals i] getPlayerSaleData];
		if(self.players.count > 0)
		{
			[self.view addSubview:table];
			[table reloadData];
			[[Globals i] removeLoadingAlert];
		}
		workingPlayerSale = NO;
	
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return [[Globals i] playerCellHandler:tableView indexPath:indexPath playerArray:self.players checkPos:NO];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"PLAYERS ON TRANSFER LIST";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.players count];
}

#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 170*SCALE_IPAD;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[mainView buttonSound];
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.players)[row];
	//NSString *name = [rowData objectForKey:@"player_name"];
	self.sel_player_id = [rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
	self.sel_player_value = [rowData[@"player_value"] stringByReplacingOccurrencesOfString:@"," withString:@""];
	self.sel_player_star = rowData[@"player_goals"];
    
    [mainView hideFooter];
    [mainView hideHeader];
    [mainView hideMarquee];
    if(bidView == nil)
    {
        bidView = [[BidView alloc] initWithNibName:@"BidView" bundle:nil];
        bidView.mainView = self.mainView;
    }
    NSMutableArray *bidPlayer = [[NSMutableArray alloc] initWithObjects:rowData, nil];
    [[mainView.view superview] insertSubview:bidView.view atIndex:4];
    [bidView updateView:bidPlayer];

	return nil;
}

@end
