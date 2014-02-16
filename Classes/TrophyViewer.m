//
//  TrophyViewer.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "TrophyViewer.h"
#import "Globals.h"

@implementation TrophyViewer
@synthesize trophies;
@synthesize selected_trophy;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateView
{
	[[Globals i] showLoadingAlert];
	[NSThread detachNewThreadSelector: @selector(getTrophyData) toTarget:self withObject:nil];
}

- (void)clearView
{
    self.trophies = nil;
    [self.tableView reloadData];
}

- (void)getTrophyData
{
	@autoreleasepool {
	
		[[Globals i] updateTrophyData:selected_trophy];
		self.trophies = [[Globals i] getTrophyData];
		if(self.trophies.count < 1)
        {
            self.trophies = nil;
        }
        [self.tableView reloadData];
		[[Globals i] removeLoadingAlert];
	
	}
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *row1 = (self.trophies)[[indexPath row]];
    
    return @{@"align_top": @"1", @"r1": row1[@"name"], @"r2": row1[@"title"], @"i1": [NSString stringWithFormat:@"t%ld.png", (long)[row1[@"type"] integerValue]]};
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.trophies count];
}

#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end
