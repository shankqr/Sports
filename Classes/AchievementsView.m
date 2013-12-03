//
//  AchievementsView.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "AchievementsView.h"
#import "Globals.h"
#import "AchievementsCell.h"

@implementation AchievementsView
@synthesize tasks;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateView
{
    [[Globals i] updateMyAchievementsData];
	self.tasks = [[Globals i] wsMyAchievementsData];
	[self.tableView reloadData];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"AchievementsCell";
	AchievementsCell *cell = (AchievementsCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AchievementsCell" owner:self options:nil];
		cell = (AchievementsCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.tasks)[row];
    
	cell.name.text = rowData[@"name"];
	
	cell.reward.text = [NSString stringWithFormat:@"$%@", [[Globals i] numberFormat:rowData[@"reward"]]];
	
	cell.desc.text = rowData[@"description"];
	
	if([rowData[@"image_url"] length] > 9)
	{
		NSURL *url = [NSURL URLWithString:rowData[@"image_url"]];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [[UIImage alloc] initWithData:data];
		[cell.taskImage setImage:img];
	}
    else
    {
        NSString *fname = [NSString stringWithFormat:@"%@.png", rowData[@"image_url"]];
        [cell.taskImage setImage:[UIImage imageNamed:fname]];
    }
    
    if([rowData[@"club_id"] isEqualToString:@"0"])
	{
        [cell.doneImage setImage:[UIImage imageNamed:@"tick_no.png"]];
        [cell.taskImage setAlpha:0.3f];
        
        [cell.reward setEnabled:YES];
        [cell.claimLabel setEnabled:NO];
        [cell.claimButton setEnabled:NO];
        
        [cell.reward setHidden:NO];
        [cell.claimLabel setHidden:YES];
        [cell.claimButton setHidden:YES];
    }
    else
    {
        if([rowData[@"claimed"] isEqualToString:@"True"])
        {
            [cell.doneImage setImage:[UIImage imageNamed:@"tick_yes.png"]];
            [cell.taskImage setAlpha:1.0f];
            
            [cell.reward setEnabled:YES];
            [cell.claimLabel setEnabled:NO];
            [cell.claimButton setEnabled:NO];
            
            [cell.reward setHidden:NO];
            [cell.claimLabel setHidden:YES];
            [cell.claimButton setHidden:YES];
        }
        else
        {
            [cell.doneImage setImage:nil];
            [cell.taskImage setAlpha:1.0f];
            
            [cell.reward setEnabled:NO];
            [cell.claimLabel setEnabled:YES];
            [cell.claimButton setEnabled:YES];
            
            [cell.reward setHidden:YES];
            [cell.claimLabel setHidden:NO];
            [cell.claimButton setHidden:NO];
            
            [cell.claimButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.claimButton.tag = row;

        }
    }
    
	return cell;
}

- (void)buttonPressed:(id)sender
{
    [[Globals i] moneySound];
    
    NSInteger i = [sender tag];
    NSDictionary *rowData = (self.tasks)[i];
    NSString *achievement_type_id = rowData[@"achievement_type_id"];
    NSString *achievement_id = rowData[@"achievement_id"];
    NSString *club_id = rowData[@"club_id"];
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/ClaimAchievement/%@/%@/%@",
                       [[Globals i] world_url], club_id, achievement_id, achievement_type_id];
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [self updateView];
             
             [[Globals i] updateClubData]; //Balance + Reward
             [[Globals i] winSound];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateBadges"
              object:self];
             
             [[Globals i] showToast:[NSString stringWithFormat:@"Rewarded + $%@", rowData[@"reward"]]
                      optionalTitle:@"Congratulations!"
                      optionalImage:@"tick_yes"];
         }
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.tasks count];
}

#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55*SCALE_IPAD;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.tasks)[row];
	//NSString *task_name = rowData[@"name"];
    //NSString *task_desc = rowData[@"description"];
    NSString *task_tutorial = rowData[@"tutorial"];
    NSString *reward = rowData[@"reward"];
    
    [[Globals i] showDialog:[NSString stringWithFormat:@"%@ Reward: $%@ ", task_tutorial, [[Globals i] numberFormat:reward]]];
    
	return nil;
}

@end
