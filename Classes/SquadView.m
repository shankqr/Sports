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
@synthesize mainView;
@synthesize table;
@synthesize toolbar;
@synthesize players;
@synthesize sold_player_id;
@synthesize sel_player_id;
@synthesize sel_player_name;
@synthesize sel_player_value;
@synthesize sel_player_halfvalue;
@synthesize totalfilter;
@synthesize selectedRow;
@synthesize filter;
@synthesize playerView;

-(void)updateView
{
    [table setFrame:CGRectMake(0, HeaderSquad_height, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height-HeaderSquad_height)];
    
	if([Globals i].workingSquad == 0)
	{	
		[table removeFromSuperview];
		[[Globals i] showLoadingAlert];
		[NSThread detachNewThreadSelector: @selector(getSquadData) toTarget:self withObject:nil];
	}
}

-(void)forceUpdate
{
	[table removeFromSuperview];
	[[Globals i] showLoadingAlert];
	[NSThread detachNewThreadSelector: @selector(getSquadData) toTarget:self withObject:nil];
}

-(void)normalUpdate
{
	[table removeFromSuperview];
    [[Globals i] updateMySquadData];
	self.players = [[Globals i] getMySquadData];
	if(self.players.count > 0)
	{
		[self.view addSubview:table];
		[table reloadData];
	}
}

-(void)getSquadData
{
	@autoreleasepool {

		[[Globals i] updateMySquadData];
		self.players = [[Globals i] getMySquadData];
		if(self.players.count > 0)
		{
			[self.view addSubview:table];
			[table reloadData];
			[[Globals i] removeLoadingAlert];
		}
	
	}
}

- (void)applyFilter
{
	NSMutableArray *discardedItems = [NSMutableArray array];
	if([self.filter isEqualToString:@"Youth"])
	{
		self.filter = @"Senior";
		for(NSDictionary *rowData in self.players)
		{
			if([rowData[@"youth_player"] isEqualToString:@"False"])
			{
				[discardedItems addObject:rowData];
			}
		}
	}
	else
	{
		self.filter = @"Youth";
		for(NSDictionary *rowData in self.players)
		{
			if([rowData[@"youth_player"] isEqualToString:@"True"])
			{
				[discardedItems addObject:rowData];
			}
		}
	}
	[self.players removeObjectsInArray:discardedItems];
	[discardedItems removeAllObjects];
}

- (void)viewDidLoad
{
	self.wantsFullScreenLayout = YES;
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return [[Globals i] playerCellHandler:tableView indexPath:indexPath playerArray:self.players checkPos:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [NSString stringWithFormat:@"Total %d Players", [self.players count]];
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
	self.sel_player_id = [rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
	self.sel_player_value = [rowData[@"player_value"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    if(playerView == nil)
    {
        playerView = [[PlayerView alloc] initWithNibName:@"PlayerView" bundle:nil];
        playerView.mainView = self.mainView;
        playerView.squadView = self;
    }
    
    [[Globals i] showTemplate:@[playerView] :@"" :0];
    [playerView updateView:rowData];
    
	return nil;
}

@end
