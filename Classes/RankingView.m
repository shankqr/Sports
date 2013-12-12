//
//  RankingView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "RankingView.h"
#import "Globals.h"
#import "MainView.h"

@implementation RankingView
@synthesize rows;
@synthesize serviceName;
@synthesize updateOnWillAppear;

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
    
    if ([updateOnWillAppear isEqualToString:@"1"])
    {
        [self updateView];
    }
}

- (void)updateView
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@",
                       [[Globals i] world_url], self.serviceName];
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
             
             if ([returnArray count] > 0)
             {
                 //NSDictionary *row0 = @{@"h1": @"", @"n1": @"No.", @"r1": @"Club", @"c1": @"Diamonds"};
                 //[returnArray insertObject:row0 atIndex:0];
                 
                 self.rows = [@[returnArray] mutableCopy];
             }
             
             [self.tableView reloadData];
             [self.view setNeedsDisplay];
         }
     }];
}

- (void)clearView
{
    self.rows = nil;
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *row1 = (self.rows)[indexPath.section][indexPath.row];
    
    return @{@"align_top": @"1", @"r1": row1[@"club_name"], @"r2": row1[@"division"], @"i1": [NSString stringWithFormat:@"c%@.png", row1[@"logo_pic"]]};
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [[Globals i] dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rows count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows[section] count];
}

#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[Globals i] dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end
