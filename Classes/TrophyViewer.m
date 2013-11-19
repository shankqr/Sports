//
//  TrophyViewer.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "TrophyViewer.h"
#import "Globals.h"
#import "TrophyCell.h"
#import "MainView.h"

@implementation TrophyViewer
@synthesize mainView;
@synthesize table;
@synthesize trophies;
@synthesize selected_trophy;


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

}

-(void)updateView
{
	[[Globals i] showLoadingAlert];
	[NSThread detachNewThreadSelector: @selector(getTrophyData) toTarget:self withObject:nil];
}

-(void)getTrophyData
{
	@autoreleasepool {
	
		[[Globals i] updateTrophyData:selected_trophy];
		self.trophies = [[Globals i] getTrophyData];
		if(self.trophies.count > 0)
		{
			//[self.view addSubview:table];
			[table reloadData];
		}
    else
    {
        self.trophies = nil;
        [table reloadData];
    }
		[[Globals i] removeLoadingAlert];
	
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"TrophyCell";
	TrophyCell *cell = (TrophyCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TrophyCell" owner:self options:nil];
		cell = (TrophyCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.trophies)[row];
	cell.productValue.text = rowData[@"name"];
	cell.productDesc.text = rowData[@"title"];
	[cell.productImage setImage:[UIImage imageNamed:[[NSString alloc] initWithFormat:@"t%d.png", [rowData[@"type"] intValue]]]];
	cell.backgroundColor = [UIColor clearColor];
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.trophies count];
}

#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 77*SCALE_IPAD;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end
