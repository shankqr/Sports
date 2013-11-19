//
//  SquadViewer.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "SquadViewer.h"
#import "Globals.h"
#import "MainView.h"
#import "PlayerCell.h"

@implementation SquadViewer
@synthesize mainView;
@synthesize table;
@synthesize toolbar;
@synthesize players;
@synthesize selected_clubid;
@synthesize sold_player_id;
@synthesize sel_player_id;
@synthesize sel_player_name;
@synthesize sel_player_value;
@synthesize totalfilter;
@synthesize filter;


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (IBAction)closeButton_tap:(id)sender
{
	[mainView showHeader];
	[mainView showFooter];
	[mainView removeClubViewer];
}

- (void)viewDidLoad
{
	selected_clubid = @"0";
    
    if (UIScreen.mainScreen.bounds.size.height != 568 && !iPad)
    {
        [table setFrame:CGRectMake(0, table.frame.origin.y, 320, UIScreen.mainScreen.bounds.size.height-table.frame.origin.y)];
    }
}

-(void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubInfoData];
	if(![selected_clubid isEqualToString:wsClubData[@"club_id"]]) //Check for redundent page load for same id
	{
        [[Globals i] showLoadingAlert];
        [NSThread detachNewThreadSelector: @selector(getSquadData) toTarget:self withObject:nil];
				
        selected_clubid = wsClubData[@"club_id"];
	}
	else 
	{
		
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
        [[Globals i] settPurchasedProduct:@"14"];
		[mainView buyProduct:[[Globals i] getProductIdentifiers][@"refill"]];
	}
}

-(void)getSquadData
{
	@autoreleasepool {
	
		[[Globals i] updateSquadData:[Globals i].selectedClubId];
		self.players = [[Globals i] getSquadData];
		if(self.players.count > 0)
		{
			[self.view addSubview:table];
			[table reloadData];
			[[Globals i] removeLoadingAlert];
		}
	
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

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end
