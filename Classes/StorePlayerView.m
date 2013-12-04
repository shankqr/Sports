//
//  StorePlayerView.m
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "StorePlayerView.h"
#import "Globals.h"
#import "MainView.h"
#import "BidView.h"
#import "PlayerCell.h"

@implementation StorePlayerView
@synthesize players;
@synthesize sold_player_id;
@synthesize sel_player_id;
@synthesize sel_player_value;
@synthesize sel_player_star;
@synthesize bidView;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
	[super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
	[super didMoveToParentViewController:parent];
}

- (void)updateView
{
	if(!workingPlayerSale)
	{
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
			[self.tableView reloadData];
		}
		workingPlayerSale = NO;
        
        [[Globals i] removeLoadingAlert];
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return [[Globals i] playerCellHandler:tableView indexPath:indexPath playerArray:self.players checkPos:NO];
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
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.players)[row];
	//NSString *name = [rowData objectForKey:@"player_name"];
	self.sel_player_id = rowData[@"player_id"];
	self.sel_player_value = rowData[@"player_value"];
	self.sel_player_star = rowData[@"player_goals"];
    
    if(bidView == nil)
    {
        bidView = [[BidView alloc] initWithNibName:@"BidView" bundle:nil];
    }
    NSMutableArray *bidPlayer = [[NSMutableArray alloc] initWithObjects:rowData, nil];
    [[Globals i] showTemplate:@[bidView] :@"" :0];
    [bidView updateView:bidPlayer];

	return nil;
}

@end
