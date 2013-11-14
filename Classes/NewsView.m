//
//  NewsView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "NewsView.h"
#import "NewsCell.h"
#import "Globals.h"
#import "MainView.h"

@implementation NewsView
@synthesize mainView;
@synthesize table;
@synthesize filter;
@synthesize news;

- (void)viewDidLoad
{
    self.wantsFullScreenLayout = YES;
	filter = @"No";
}

-(void)updateView
{
	if([[[Globals i] getNewsData] count] < 1)
	{
		[[Globals i] showLoadingAlert:self.view];
		[NSThread detachNewThreadSelector: @selector(getNewsData) toTarget:self withObject:nil];
	}
}

-(void)getNewsData
{
	@autoreleasepool {

		NSDictionary *wsClubData = [[Globals i] getClubData];
		[[Globals i] updateNewsData
			 :wsClubData[@"division"]
			 :wsClubData[@"series"]
			 :[[Globals i] BoolToBit:wsClubData[@"playing_cup"]]];
		self.news = [[Globals i] getNewsData];
		[table reloadData];
		
		[[Globals i] removeLoadingAlert:self.view];
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"NewsCell";
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.news)[row];

	NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil) 
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
		cell = (NewsCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	cell.newsHeader.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
	cell.newsHeader.text = rowData[@"headline"];

	NSArray *chunks = [rowData[@"news_datetime"] componentsSeparatedByString: @", "];
	NSString *dayweek = chunks[0];
	NSArray *chunks2 = [chunks[1] componentsSeparatedByString: @" "];
	NSString *monthfull = chunks2[0];
	NSString *monthshort = [monthfull substringWithRange:NSMakeRange(0,3)];
	NSString *daymonth = chunks2[1];
	cell.newsDay.text = dayweek;
	cell.newsDate.text = daymonth;
	cell.newsMonth.text = [monthshort uppercaseString];
	
	return cell;
}

#pragma mark Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.news count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60*SCALE_IPAD;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = (self.news)[indexPath.row];
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:rowData[@"headline"]
						  message:rowData[@"news"]
						  delegate:self
						  cancelButtonTitle:nil
						  otherButtonTitles:@"OK", nil];
	[alert show];
	return nil;
}

@end
