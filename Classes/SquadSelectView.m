//
//  SquadSelectView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "SquadSelectView.h"
#import "Globals.h"
#import "MainView.h"
#import "PlayerCell.h"

@implementation SquadSelectView
@synthesize delegate;
@synthesize mainView;
@synthesize players;
@synthesize sel_player_id;
@synthesize sel_player_name;

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(playerSelected:)])
	{
		[delegate playerSelected:@"0"];
	}
}

-(void)updateView
{
	[Globals i].selectedPlayer = @"0";
	self.players = [[Globals i] getMySquadData];
	[self.tableView reloadData];
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

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.players)[row];
	self.sel_player_id = [rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
	self.sel_player_name = rowData[@"player_name"];
	
	if(([rowData[@"card_red"] intValue] == 1) || ([rowData[@"player_condition"] intValue] == 2))
	{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Manager"
                              message:@"This player is injured or has a red card, and can't be asigned for this position"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Confirm Player"
						  message:[NSString stringWithFormat:@"Confirm %@ for this position?", self.sel_player_name]
						  delegate:self
						  cancelButtonTitle:@"Cancel"
						  otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
	return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
        [[Globals i] closeTemplate];
        
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(playerSelected:)])
		{
			[delegate playerSelected:self.sel_player_id];
		}
	}
}

@end
