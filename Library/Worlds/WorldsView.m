//
//  WorldsView.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "WorldsView.h"

@implementation WorldsView
@synthesize rows;

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

-(void)updateView
{
    if ([Globals i].wsWorldsData == nil)
    {
        [[Globals i] updateWorldsData];
    }
    
	self.rows = [[Globals i] wsWorldsData];
    
    if ([Globals i].wsWorldData == nil) // Auto select highest row if no world selected before
    {
        [[Globals i] settSelectedWorldData:self.rows[0]];
    }
    
	[self.tableView reloadData];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *row1 = (self.rows)[[indexPath row]];
    NSString *r1;
    if ([row1[@"recomended"] isEqualToString:@"1"])
    {
        r1 = [NSString stringWithFormat:@"%@ (Recomended)", row1[@"world_name"]];
    }
    else
    {
        r1 = [NSString stringWithFormat:@"%@", row1[@"world_name"]];
    }
    
    NSDictionary *rowData = @{@"r1": r1, @"r2": [NSString stringWithFormat:@"%@", row1[@"language"]], @"i1": [NSString stringWithFormat:@"flag_%@", row1[@"flag_id"]]};
    
    return rowData;
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [[Globals i] dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.rows count];
}

#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[Globals i] dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[Globals i] settSelectedWorldData:self.rows[indexPath.row]];
    [[Globals i] settSelectedBaseId:@"0"];
    [[Globals i] closeTemplate];
    
	return indexPath;
}

@end
