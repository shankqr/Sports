//
//  StoreCoachView.m
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "StoreCoachView.h"
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import "CoachCell.h"
#import "Globals.h"
#import "MainView.h"

@implementation StoreCoachView
@synthesize mainView;
@synthesize table;
@synthesize coaches;
@synthesize filter;
@synthesize sold_coach_id;
@synthesize sel_coach_id;
@synthesize sel_coach_value;
@synthesize sel_coach_star;


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
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
	if([[[Globals i] getCoachData] count] < 1)
	{
		[[Globals i] showLoadingAlert];
		[NSThread detachNewThreadSelector: @selector(getProductCoach) toTarget:self withObject:nil];
	}
}

- (void)forceUpdate
{
	[[Globals i] showLoadingAlert];
	[NSThread detachNewThreadSelector: @selector(getProductCoach) toTarget:self withObject:nil];
}

-(void)getProductCoach
{
	@autoreleasepool {
	
		[[Globals i] updateCoachData];
		self.coaches = [[Globals i] getCoachData];
		if(self.coaches.count > 0)
		{
			NSMutableArray *discardedItems = [NSMutableArray array];
			for(NSDictionary *rowData in self.coaches)
			{
				if([rowData[@"coach_id"] isEqualToString:[[Globals i] getClubData][@"coach_id"]])
				{
					[discardedItems addObject:rowData];
				}
			}
			[self.coaches removeObjectsInArray:discardedItems];
			[discardedItems removeAllObjects];
		
			[table reloadData];
			[[Globals i] removeLoadingAlert];
		}
	
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"CoachCell";
	CoachCell *cell = (CoachCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CoachCell" owner:self options:nil];
		cell = (CoachCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.coaches)[row];
	NSString *coach_id = [rowData[@"coach_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
	NSString *name = rowData[@"coach_name"];
	NSString *age = rowData[@"coach_age"];
	NSString *desc = rowData[@"coach_desc"];
	cell.coachName.text = [NSString stringWithFormat:@"%@ (Age: %@)", name, age];
	
	NSString *salary = [[Globals i] numberFormat:rowData[@"coach_salary"]];
	NSString *mvalue = [[Globals i] numberFormat:rowData[@"coach_value"]]; 
	cell.coachValue.text = [NSString stringWithFormat:@"$%@/week (Value: $%@)", salary, mvalue];
	
	cell.coachDesc.text = desc;
	
	cell.skill.text = [NSString stringWithFormat:@"LEVEL %d", [rowData[@"coach_skill"] intValue]/2];
    [cell.pbskill setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"coach_skill"] intValue]/10]]];
	
	cell.leadership.text = [NSString stringWithFormat:@"LEVEL %d", [rowData[@"coach_leadership"] intValue]/2];
    [cell.pbleadership setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"coach_leadership"] intValue]/10]]];
    
	int f = ([coach_id intValue] % 12) + 1;
	NSString *fname = [NSString stringWithFormat:@"s%d.png", f];
	[cell.faceImage setImage:[UIImage imageNamed:fname]];
	
	int g = [rowData[@"coach_star"] intValue];
	switch(g)
	{
		case 0:
			cell.star5.image = nil;
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 1:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 2:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 3:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 4:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 5:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 6:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 7:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star1.image = nil;
			break;
		case 8:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star1.image = nil;
			break;
		case 9:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star1 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		case 10:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star1 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		default:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;

	}
	
	return cell;
}

#pragma mark Table View Delegate Methods
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"COACHES ON JOB BOARD";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.coaches count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 170*SCALE_IPAD;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[mainView buttonSound];
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.coaches)[row];
	NSString *name = rowData[@"coach_name"];
	self.sel_coach_id = [rowData[@"coach_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
	self.sel_coach_value = [rowData[@"coach_value"] stringByReplacingOccurrencesOfString:@"," withString:@""];
	self.sel_coach_star = rowData[@"coach_star"];
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Confirm Purchase"
						  message:[NSString stringWithFormat:@"Do you want to sign up coach %@ for $%@", name, [[Globals i] numberFormat:rowData[@"coach_value"]]]
						  delegate:self
						  cancelButtonTitle:@"Cancel"
						  otherButtonTitles:@"Use Real Funds", [NSString stringWithFormat:@"$%@", [[Globals i] numberFormat:rowData[@"coach_value"]]], nil];
	[alert show];
	return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
        [mainView addFunds];
	}
	
	if(buttonIndex == 2)
	{
		int pval = [self.sel_coach_value intValue];
		int bal = [[[[Globals i] getClubData][@"balance"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
		
		if(bal > pval)
		{
			[Globals i].purchasedCoachId = self.sel_coach_id;
			[mainView buyCoachSuccess];
			[self forceUpdate];
		}
        else
		{
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Accountant"
								  message:@"Insufficient club funds. Buy more funds?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  otherButtonTitles:@"OK", nil];
			[alert show];
		}
	}
}

@end
