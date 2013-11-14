//
//  AllianceView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "AllianceView.h"

@implementation AllianceView
@synthesize mainView;
@synthesize allianceViewer;
@synthesize table;
@synthesize allianceArray;
@synthesize dialogBox;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)viewDidUnload
{
	// Save the state of the search UI so that it can be restored if the view is re-created.
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
	self.filteredListContent = nil;
}

- (void)viewDidLoad
{
    if (UIScreen.mainScreen.bounds.size.height != 568 && !iPad)
    {
        [table setFrame:CGRectMake(0, table.frame.origin.y, 320, UIScreen.mainScreen.bounds.size.height-table.frame.origin.y)];
    }
}

- (void)updateView
{
	self.allianceArray = [[Globals i] getAllianceData];
	[[Globals i] showLoadingAlert:self.view];
    [NSThread detachNewThreadSelector: @selector(getAllData) toTarget:self withObject:nil];
}

-(void)getAllData
{
	@autoreleasepool
    {
		[[Globals i] updateAllianceData];
		self.allianceArray = [[NSMutableArray alloc] initWithArray:[[Globals i] getAllianceData] copyItems:YES];
		[self setupIndexArray];
		[table reloadData];
		
		[[Globals i] removeLoadingAlert:self.view];
	}
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

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"AllianceCell";
	AllianceCell *cell = (AllianceCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllianceCell" owner:self options:nil];
		cell = (AllianceCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	AllianceObject *aAlliance = nil;
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		aAlliance = (self.filteredListContent)[indexPath.row];
        
        cell.name.text = aAlliance.name;
        cell.members.text = aAlliance.total_members;
        cell.score.text = [[Globals i] numberFormat:aAlliance.score];
    }
	else
	{
        cell.num.text = [[NSString alloc] initWithFormat:@"%d", indexPath.row+1];
		cell.name.text = (self.allianceArray)[indexPath.row][@"name"];
        cell.members.text = [[NSString alloc] initWithFormat:@"%@/%@0",
                             (self.allianceArray)[indexPath.row][@"total_members"],
                             (self.allianceArray)[indexPath.row][@"alliance_level"]];
        cell.score.text = [[Globals i] numberFormat:(self.allianceArray)[indexPath.row][@"score"]];
    }
	
	return cell;
}

#pragma mark Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
		return [self.allianceArray count];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllianceObject *aAlliance = nil;
    
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        aAlliance = (self.filteredListContent)[indexPath.row];
    }
	else
	{
        aAlliance = [[AllianceObject alloc] initWithDictionary:(self.allianceArray)[indexPath.row]];
    }
	
    //Show alliance viewer
    if (allianceViewer == nil)
    {
        allianceViewer = [[AllianceViewer alloc] initWithNibName:@"AllianceViewer" bundle:nil];
    }

    allianceViewer.aAlliance = aAlliance;
    [allianceViewer updateView];
    [self.view insertSubview:allianceViewer.view atIndex:17];
    allianceViewer.aAlliance = aAlliance;
    [allianceViewer updateView];
    
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 25*SCALE_IPAD;
}

- (void)createDialogBox
{
    if (dialogBox == nil)
    {
        dialogBox = [[DialogBoxView alloc] initWithNibName:@"DialogBoxView" bundle:nil];
        dialogBox.delegate = self;
    }
}

- (void)removeDialogBox
{
	if(dialogBox != nil)
	{
		[dialogBox.view removeFromSuperview];
	}
}

- (IBAction)createButton_tap:(id)sender
{
    int alliance_id = [[[[Globals i] getClubData][@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
    
    if (alliance_id > 0)
    {
        [self createDialogBox];
        dialogBox.titleText = @"Assistant Manager";
        dialogBox.whiteText = @"Unable to Create!";
        dialogBox.promptText = @"You are currently a member of a existing Association, resign from that association first to Create a new one.";
        dialogBox.dialogType = 1;
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
    else
    {
        [self createDialogBox];
        dialogBox.titleText = @"Association Name";
        dialogBox.whiteText = @"Please choose a name";
        dialogBox.dialogType = 4;
        dialogBox.view.tag = 4;
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
}

- (IBAction)cancelButton_tap:(id)sender
{
	[mainView backSound];
    [mainView showHeader];
    [self.view removeFromSuperview];
}

- (void)returnText:(NSString *)text
{
    if (dialogBox.view.tag == 4) //Association Name
    {
        if([text isEqualToString:@""])
        {
            
        }
        else 
        {
            self.selected_name = text;
            
            NSDictionary *wsSeasonData = [[Globals i] getCurrentSeasonData];
            NSString *reqFunds = wsSeasonData[@"alliance_require_currency1"];
            NSString *reqDiamonds = wsSeasonData[@"alliance_require_currency2"];
            
            [dialogBox.view removeFromSuperview];
            
            [self createDialogBox];
            dialogBox.titleText = @"Create Association";
            dialogBox.whiteText = @"Be the President!";
            dialogBox.promptText = [NSString stringWithFormat:@"Manage your own private Cup and compete with other Associations. Requires $%@ and %@ Diamonds only.",
                                    [[Globals i] numberFormat:reqFunds], [[Globals i] numberFormat:reqDiamonds]];
            dialogBox.dialogType = 2;
            dialogBox.view.tag = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
}

- (void)returnDialog:(NSInteger)tag
{
    if (dialogBox.view.tag == 1) //Create
    {
        if (tag == 1) //Yes
        {
            NSDictionary *wsSeasonData = [[Globals i] getCurrentSeasonData];
            NSString *reqFunds = wsSeasonData[@"alliance_require_currency1"];
            NSString *reqDiamonds = wsSeasonData[@"alliance_require_currency2"];
            
            int balFunds = [[[[Globals i] getClubData][@"balance"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
            int balDiamonds = [[[[Globals i] getClubData][@"currency_second"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];

            if ((balFunds >= reqFunds.intValue) && (balDiamonds >= reqDiamonds.intValue))
            {
                NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
                NSString *club_name = [[[Globals i] getClubData][@"club_name"] stringByReplacingOccurrencesOfString:@"," withString:@""];
                
                NSString *returnValue = @"0";
                NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceCreate/%@/%@/%@",
                                   WS_URL, club_id, club_name, self.selected_name];
                NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [[NSURL alloc] initWithString:wsurl2];
                returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
                
                if([returnValue isEqualToString:@"1"])
                {
                    [dialogBox.view removeFromSuperview];
                    [[Globals i] updateClubData];
                    
                    [self createDialogBox];
                    dialogBox.titleText = @"President";
                    dialogBox.whiteText = @"Congratulations!";
                    dialogBox.promptText = @"No time to waste, grow your Association by inviting other clubs from the Challenge Club note to manager or from the Chat.";
                    dialogBox.dialogType = 3;
                    dialogBox.view.tag = 2;
                    [self.view insertSubview:dialogBox.view atIndex:17];
                    [dialogBox updateView];
                }
                else
                {
                    [dialogBox.view removeFromSuperview];
                    
                    [self createDialogBox];
                    dialogBox.titleText = @"Unable to Create now!";
                    dialogBox.whiteText = @"Please try again later.";
                    dialogBox.promptText = @"";
                    dialogBox.dialogType = 1;
                    [self.view insertSubview:dialogBox.view atIndex:17];
                    [dialogBox updateView];
                }
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to Create!";
                dialogBox.whiteText = @"Insufficient Funds or Diamonds.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
    }
    
    if (dialogBox.view.tag == 2) //Create Success
    {
        if (tag == 2) //OK
        {
            [dialogBox.view removeFromSuperview];
            [self.view removeFromSuperview];
        
            int alliance_id = [[[[Globals i] getClubData][@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
            [mainView showAllianceDetail:alliance_id];
        }
    }
}

@end
