//
//  AchievementsView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "AchievementsView.h"
#import "AchievementsCell.h"
#import "Globals.h"
#import "MainView.h"
#import "DialogBoxView.h"

@implementation AchievementsView
@synthesize mainView;
@synthesize table;
@synthesize tasks;
@synthesize dialogBox;


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)viewDidLoad
{
	self.wantsFullScreenLayout = YES;
    
    if (UIScreen.mainScreen.bounds.size.height != 568 && !iPad)
    {
        [table setFrame:CGRectMake(0, table.frame.origin.y, 320, UIScreen.mainScreen.bounds.size.height-table.frame.origin.y)];
    }
}

-(void)updateView
{
    [[Globals i] updateMyAchievementsData];
	self.tasks = [[Globals i] getMyAchievementsData];
	[table reloadData];
    
    [mainView updateAchievementBadges];
}

- (IBAction)cancelButton_tap:(id)sender
{
	[mainView backSound];
    [mainView showHeader];
    [self.view removeFromSuperview];
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
    [mainView moneySound];
    
    int i = [sender tag];
    NSDictionary *rowData = (self.tasks)[i];
    NSString *achievement_type_id = rowData[@"achievement_type_id"];
    NSString *achievement_id = rowData[@"achievement_id"];
    NSString *club_id = rowData[@"club_id"];
    NSString *name = rowData[@"name"];
    NSString *image_url = rowData[@"image_url"];
    NSString *description = rowData[@"description"];
    NSString *tutorial = rowData[@"tutorial"];
    
    NSString *returnValue = @"0";
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ClaimAchievement/%@/%@/%@",
                       WS_URL, club_id, achievement_id, achievement_type_id];
    NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:wsurl2];
    returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    
    
    if([returnValue isEqualToString:@"0"])
    {
        [self createDialogBox];
        dialogBox.titleText = @"CLAIM NOT VALID";
        dialogBox.whiteText = @"Please try again.";
        dialogBox.promptText = @"";
        dialogBox.dialogType = 1;
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
    else
    {
        [self updateView];
        //Update Header
        [[Globals i] updateClubData];
        [mainView updateHeader];
        
        NSString *message = [[NSString alloc] initWithFormat:@"I have just completed an achievement called %@ - %@.", name, description];
        NSString *extra_desc = tutorial;
        NSString *imagename = [NSString stringWithFormat:@"achievement/%@.png", image_url];
        [mainView FallbackPublishStory:message:extra_desc:imagename];
        
        [self createDialogBox];
        dialogBox.titleText = @"Claim Successful!";
        dialogBox.whiteText = name;
        dialogBox.promptText = [NSString stringWithFormat:@"Congratulations! You have been rewarded $%@ for completing this Achievement.", [[Globals i] numberFormat:returnValue]];
        dialogBox.dialogType = 1;
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
        
        [mainView winSound];
    }

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

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.tasks)[row];
	NSString *task_name = rowData[@"name"];
    NSString *task_desc = rowData[@"description"];
    NSString *task_tutorial = rowData[@"tutorial"];
    NSString *reward = rowData[@"reward"];
    
    [self createDialogBox];
    dialogBox.titleText = task_name;
    dialogBox.whiteText = task_desc;
    dialogBox.promptText = [NSString stringWithFormat:@"%@ Reward: $%@ ", task_tutorial, [[Globals i] numberFormat:reward]];
    dialogBox.dialogType = 1;
    [self.view insertSubview:dialogBox.view atIndex:17];
    [dialogBox updateView];
    
	return nil;
}

- (void)createDialogBox
{
    if (dialogBox == nil)
    {
        dialogBox = [[DialogBoxView alloc] initWithNibName:@"DialogBoxView" bundle:nil];
        //dialogBox.delegate = self;
    }
}

- (void)removeDialogBox
{
	if(dialogBox != nil)
	{
		[dialogBox.view removeFromSuperview];
	}
}

@end
