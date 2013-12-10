//
//  SquadView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "SquadView.h"
#import "Globals.h"
#import "MainView.h"
#import "PlayerView.h"
#import "PlayerCell.h"

@implementation SquadView
@synthesize players;
@synthesize sold_player_id;
@synthesize sel_player_id;
@synthesize sel_player_name;
@synthesize sel_player_value;
@synthesize sel_player_halfvalue;
@synthesize selectedRow;
@synthesize playerView;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateView
{
	if([Globals i].workingSquad == 0)
	{
		[[Globals i] showLoadingAlert];
		[NSThread detachNewThreadSelector: @selector(getSquadData) toTarget:self withObject:nil];
	}
}

- (void)forceUpdate
{
	[[Globals i] showLoadingAlert];
	[NSThread detachNewThreadSelector: @selector(getSquadData) toTarget:self withObject:nil];
}

- (void)normalUpdate
{
    [[Globals i] updateMySquadData];
	self.players = [[Globals i] getMySquadData];
	if(self.players.count > 0)
	{
		[self.tableView reloadData];
	}
}

- (void)getSquadData
{
	@autoreleasepool {

		[[Globals i] updateMySquadData];
		self.players = [[Globals i] getMySquadData];
		if(self.players.count > 0)
		{
			[self.tableView reloadData];
		}
	
        [[Globals i] removeLoadingAlert];
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return [[Globals i] playerCellHandler:tableView indexPath:indexPath playerArray:self.players checkPos:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [NSString stringWithFormat:@"Total %lu Players", (unsigned long)[self.players count]];
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
	self.selectedRow = [indexPath row];
	NSDictionary *rowData = (self.players)[self.selectedRow];
	self.sel_player_name = rowData[@"player_name"];
	self.sel_player_id = rowData[@"player_id"];
	self.sel_player_value = rowData[@"player_value"];
    
    if(playerView == nil)
    {
        playerView = [[PlayerView alloc] initWithNibName:@"PlayerView" bundle:nil];
        playerView.squadView = self;
    }
    
    [[Globals i] showTemplate:@[playerView] :@"" :1];
    [playerView updateView:rowData];
    
	return nil;
}

@end
