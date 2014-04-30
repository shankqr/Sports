//
//  SquadViewer.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "SquadViewer.h"
#import "Globals.h"
#import "PlayerCell.h"

@implementation SquadViewer
@synthesize players;
@synthesize selected_clubid;
@synthesize sold_player_id;
@synthesize sel_player_id;
@synthesize sel_player_name;
@synthesize sel_player_value;

- (void)viewDidLoad
{
	selected_clubid = @"0";
}

- (void)updateView
{
	NSDictionary *wsClubDict = [[Globals i] getClubInfoData];
	if(![selected_clubid isEqualToString:wsClubDict[@"club_id"]]) //Check for redundent page load for same id
	{
        [[Globals i] showLoadingAlert];
        [NSThread detachNewThreadSelector: @selector(getSquadData) toTarget:self withObject:nil];
				
        selected_clubid = wsClubDict[@"club_id"];
	}
}

- (void)clearView
{
    self.players = nil;
    [self.tableView reloadData];
}

- (void)getSquadData
{
	@autoreleasepool {
	
		[[Globals i] updateSquadData:[Globals i].selectedClubId];
		self.players = [[Globals i] getSquadData];
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
	return nil;
}

@end
