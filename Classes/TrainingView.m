//
//  TrainingView.m
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "TrainingView.h"
#import "CoachCell.h"
#import "Globals.h"
#import "MainView.h"

@implementation TrainingView
@synthesize mainView;
@synthesize table;
@synthesize coaches;
@synthesize trainingImage;
@synthesize teamspirit;
@synthesize confidence;
@synthesize pbteamspirit;
@synthesize pbconfidence;

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
    
    if (wsClubData != nil)
    {
        [trainingImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"training%@.png", wsClubData[@"training"]]]];
        teamspirit.text = [NSString stringWithFormat:@"%ld", (long)[wsClubData[@"teamspirit"] integerValue]/2];
        [pbteamspirit setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[wsClubData[@"teamspirit"] integerValue]/10]]];
        
        confidence.text = [NSString stringWithFormat:@"%ld", (long)[wsClubData[@"confidence"] integerValue]/2];
        [pbconfidence setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[wsClubData[@"confidence"] integerValue]/10]]];
        
        NSDictionary *row1 = @{@"coach_id": wsClubData[@"coach_id"],
                               @"coach_name": wsClubData[@"coach_name"],
                               @"coach_age": wsClubData[@"coach_age"],
                               @"coach_desc": wsClubData[@"coach_desc"],
                               @"coach_salary": wsClubData[@"coach_salary"],
                               @"coach_value": wsClubData[@"coach_value"],
                               @"coach_skill": wsClubData[@"coach_skill"],
                               @"coach_leadership": wsClubData[@"coach_leadership"],
                               @"coach_star": wsClubData[@"coach_star"]};
        
        self.coaches = [[NSMutableArray alloc] initWithObjects:row1, nil];
        
        [table reloadData];
        [self.view setNeedsDisplay];
    }
}

-(IBAction)coachButton_tap:(id)sender
{
	[mainView showCoachStore];
}

-(IBAction)trainingButton_tap:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Training Type"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:[[Globals i] PlayerSkill1], [[Globals i] PlayerSkill2], [[Globals i] PlayerSkill3], [[Globals i] PlayerSkill4], [[Globals i] PlayerSkill5], [[Globals i] PlayerSkill6], nil];
	actionSheet.tag = 0;
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *message = @"I have just changed my team training.";
    NSString *extra_desc = @"Every week you can set what type of training your team should focus on. ";
    NSString *imagename = @"change_training.png";
    
	switch(actionSheet.tag)
	{
		case 0:
		{
			switch(buttonIndex)
			{
				case 0:
				{
                    [trainingImage setImage:[UIImage imageNamed:@"training1.png"]];
                    [[Globals i] changeTraining:@"1"];
                    [[Globals i] fbPublishStory:message :extra_desc :imagename];
					break;
				}
				case 1:
				{
                    [trainingImage setImage:[UIImage imageNamed:@"training2.png"]];
                    [[Globals i] changeTraining:@"2"];
                    [[Globals i] fbPublishStory:message :extra_desc :imagename];
					break;
				}
				case 2:
				{
                    [trainingImage setImage:[UIImage imageNamed:@"training3.png"]];
                    [[Globals i] changeTraining:@"3"];
                    [[Globals i] fbPublishStory:message :extra_desc :imagename];
					break;
				}
				case 3:
				{
                    [trainingImage setImage:[UIImage imageNamed:@"training4.png"]];
                    [[Globals i] changeTraining:@"4"];
                    [[Globals i] fbPublishStory:message :extra_desc :imagename];
					break;
				}
				case 4:
				{
                    [trainingImage setImage:[UIImage imageNamed:@"training5.png"]];
                    [[Globals i] changeTraining:@"5"];
                    [[Globals i] fbPublishStory:message :extra_desc :imagename];
					break;
				}
				case 5:
				{
                    [trainingImage setImage:[UIImage imageNamed:@"training6.png"]];
                    [[Globals i] changeTraining:@"6"];
                    [[Globals i] fbPublishStory:message :extra_desc :imagename];
					break;
				}
			}
			[mainView updateHeader];
			break;
		}
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
	NSString *coach_id = rowData[@"coach_id"];
	NSString *name = rowData[@"coach_name"];
	NSString *age = rowData[@"coach_age"];
	NSString *desc = rowData[@"coach_desc"];
	cell.coachName.text = [NSString stringWithFormat:@"%@ (Age: %@)", name, age];
	
	NSString *salary = [[Globals i] numberFormat:rowData[@"coach_salary"]];
	NSString *mvalue = [[Globals i] numberFormat:rowData[@"coach_value"]]; 
	cell.coachValue.text = [NSString stringWithFormat:@"$%@/week (Value: $%@)", salary, mvalue];
	
	cell.coachDesc.text = desc;
	
	cell.skill.text = [NSString stringWithFormat:@"LEVEL %ld", (long)[rowData[@"coach_skill"] integerValue]/2];
    [cell.pbskill setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"coach_skill"] integerValue]/10]]];
    
	cell.leadership.text = [NSString stringWithFormat:@"LEVEL %ld", (long)[rowData[@"coach_leadership"] integerValue]/2];
    [cell.pbleadership setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"coach_leadership"] integerValue]/10]]];
    
	NSInteger f = ([coach_id integerValue] % 12) + 1;
	NSString *fname = [NSString stringWithFormat:@"s%ld.png", (long)f];
	[cell.faceImage setImage:[UIImage imageNamed:fname]];
	
	NSInteger g = [rowData[@"coach_star"] integerValue];
	switch(g)
	{
		case 1:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			break;
		case 2:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		case 3:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		case 4:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		case 5:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		case 6:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		case 7:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		case 8:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
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
	}
	
	return cell;
}

#pragma mark Table View Delegate Methods
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 170*SCALE_IPAD;
}

@end
