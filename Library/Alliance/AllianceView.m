//
//  AllianceView.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "AllianceView.h"
#import "Globals.h"
#import "AllianceObject.h"
#import "AllianceDetail.h"
#import "AllianceCreate.h"

@implementation AllianceView
@synthesize searchBar;
@synthesize searchDisplayController;
@synthesize allianceViewer;
@synthesize allianceCreate;
@synthesize allianceArray;
@synthesize selected_id;
@synthesize nameIndexesDictionary;
@synthesize nameIndexArray;
@synthesize allianceDictionary;
@synthesize allListContent;
@synthesize filteredListContent;
@synthesize savedSearchTerm;
@synthesize savedScopeButtonIndex;
@synthesize searchWasActive;
@synthesize selected_name;
@synthesize updateOnWillAppear;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44*SCALE_IPAD)];
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    /*contents controller is the UITableViewController, this let you to reuse
     the same TableViewController Delegate method used for the main table.*/
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    //set the delegate = self. Previously declared in ViewController.h
    
    self.tableView.tableHeaderView = searchBar;
}

- (void)viewDidUnload
{
	// Save the state of the search UI so that it can be restored if the view is re-created.
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
	self.filteredListContent = nil;
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
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetAlliance",
                       [[Globals i] world_url]];
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             self.allianceArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
             [self setupIndexArray];
             [self.tableView reloadData];
         }
     }];
}

- (void)setupIndexArray
{
	self.allianceDictionary = [NSMutableDictionary dictionary];
	self.nameIndexesDictionary = [NSMutableDictionary dictionary];
	self.allListContent = [NSMutableArray array];
	
	for (NSDictionary *eachElement in self.allianceArray)
	{
		AllianceObject *aAlliance = [[AllianceObject alloc] initWithDictionary:eachElement];
		allianceDictionary[aAlliance.name] = aAlliance;
		[allListContent addObject:aAlliance];
        
		NSString *firstLetter = [[aAlliance.name substringToIndex:1] uppercaseString];
		NSMutableArray *existingArray;
        
		if ((existingArray = [nameIndexesDictionary valueForKey:firstLetter]))
		{
			[existingArray addObject:aAlliance];
		}
		else
		{
			NSMutableArray *tempArray = [NSMutableArray array];
			nameIndexesDictionary[firstLetter] = tempArray;
			[tempArray addObject:aAlliance];
		}
		
	}

	[self presortElementInitialLetterIndexes];
    self.nameIndexArray = [[nameIndexesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

	
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.allListContent count]];
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        self.savedSearchTerm = nil;
    }
}

// presort the name index arrays so the elements are in the correct order
- (void)presortElementInitialLetterIndexes
{
	self.nameIndexArray = [[nameIndexesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	for (NSString *eachNameIndex in nameIndexArray)
	{
		[self presortElementNamesForInitialLetter:eachNameIndex];
	}
}

- (void)presortElementNamesForInitialLetter:(NSString *)aKey
{
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"name"
										ascending:YES
										selector:@selector(localizedCaseInsensitiveCompare:)];
	
	NSArray *descriptors = @[nameDescriptor];
	[nameIndexesDictionary[aKey] sortUsingDescriptors:descriptors];
}

#pragma mark UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	for (AllianceObject *aAlliance in allListContent)
	{
		NSComparisonResult result = [aAlliance.name compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
		if (result == NSOrderedSame)
		{
			[self.filteredListContent addObject:aAlliance];
		}
	}
	
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (NSDictionary *)getRowData:(UITableView *)tableView :(NSIndexPath *)indexPath
{
    NSDictionary *rowData = nil;
    AllianceObject *aAlliance = nil;
    
    if (indexPath.row == 0) //Header row
    {
        rowData = @{@"h1": @"", @"n1": @"No.", @"r1": @"Name", @"c1": @"Prestige"};
	}
    else
    {
        NSInteger index = indexPath.row - 1;
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            aAlliance = (self.filteredListContent)[index];
            rowData = @{@"r1": aAlliance.name, @"r2": [NSString stringWithFormat:@"%@ Prestige Points (%@ Members)", [[Globals i] numberFormat:aAlliance.score], [[Globals i] numberFormat:aAlliance.total_members]], @"i2": @"arrow_right"};
        }
        else
        {
            NSString *r1 = (self.allianceArray)[index][@"name"];

            NSString *members = [NSString stringWithFormat:@"(%@/%@0) Members",
                                 (self.allianceArray)[index][@"total_members"],
                                 (self.allianceArray)[index][@"alliance_level"]];
            
            NSString *points = [[Globals i] numberFormat:(self.allianceArray)[index][@"score"]];
            
            rowData = @{@"n1": [NSString stringWithFormat:@"%ld", (long)index+1], @"r1": r1, @"r2": members, @"c1": points, @"i2": @"arrow_right"};
        }
    }
    
    return rowData;
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell dynamicCell:self.tableView rowData:[self getRowData:tableView :indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

#pragma mark Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count] + 1;
    }
	else
	{
		return [self.allianceArray count] + 1;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) //Not Header row
    {
        NSInteger index = indexPath.row - 1;
        
        AllianceObject *aAlliance = nil;
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            aAlliance = (self.filteredListContent)[index];
        }
        else
        {
            aAlliance = [[AllianceObject alloc] initWithDictionary:(self.allianceArray)[index]];
        }
        
        //Show alliance viewer
        if (allianceViewer == nil)
        {
            allianceViewer = [[AllianceDetail alloc] initWithStyle:UITableViewStylePlain];
        }
        allianceViewer.aAlliance = aAlliance;
        [allianceViewer scrollToTop];
        [allianceViewer updateView];
        
        [[Globals i] pushTemplateNav:allianceViewer];
    }
    
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell dynamicCellHeight:[self getRowData:tableView :indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TABLE_HEADER_VIEW_HEIGHT)];
    [headerView setBackgroundColor:[UIColor blackColor]];

    UIButton *button1 = [[Globals i] dynamicButtonWithTitle:@"Create New Alliance"
                                                    target:self
                                                  selector:@selector(button1_tap:)
                                                     frame:CGRectMake(20*SCALE_IPAD, 5*SCALE_IPAD, 280*SCALE_IPAD, 46*SCALE_IPAD)
                                                      type:@"1"];
    
    [headerView addSubview:button1];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_FOOTER_VIEW_HEIGHT;
}

- (void)button1_tap:(id)sender
{
    NSInteger alliance_id = [[[Globals i] wsClubData][@"alliance_id"] integerValue];
    
    if (alliance_id > 0)
    {
        [[Globals i] showDialog:@"Unable to Create! You are currently a member of an existing Alliance, resign from that Alliance first to Create a new one."];
    }
    else
    {
        allianceCreate = [[AllianceCreate alloc] initWithStyle:UITableViewStylePlain];
        [allianceCreate updateView:YES];
        [[Globals i] pushTemplateNav:allianceCreate];
    }
}

@end
