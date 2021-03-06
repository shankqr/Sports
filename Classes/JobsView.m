//
//  JobsView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "JobsView.h"
#import "JobsCell.h"
#import "Globals.h"

@implementation JobsView
@synthesize table;
@synthesize jobs;
@synthesize bgImage;
@synthesize unlockLabel;
@synthesize offset;
@synthesize jobComplete;

- (void)viewDidLoad
{
	offset = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self.table setFrame:CGRectMake(0, 40.0f*SCALE_IPAD, UIScreen.mainScreen.bounds.size.width, self.view.frame.size.height-(40.0f*SCALE_IPAD))];
}

- (IBAction)rookie_tap:(id)sender
{
    [bgImage setImage:[UIImage imageNamed:@"job_rookie.png"]];
	table.hidden = NO;
    offset = 0;
    unlockLabel.text = @"";
	[self updateView];
}

- (IBAction)amateur_tap:(id)sender
{
    NSInteger level = [[Globals i] getLevel];
    if(level > 49)
    {
        [bgImage setImage:[UIImage imageNamed:@"job_amateur.png"]];
        table.hidden = NO;
        offset = 8;
        unlockLabel.text = @"";
        [self updateView];
    }
    else
    {
        [bgImage setImage:[UIImage imageNamed:@"job_amateur_locked.png"]];
        table.hidden = YES;
        unlockLabel.text = @"UNLOCK AT LEVEL 50";
        [self.view setNeedsDisplay];
    }
}

- (IBAction)pro_tap:(id)sender
{
    NSInteger level = [[Globals i] getLevel];
    if(level > 99)
    {
        [bgImage setImage:[UIImage imageNamed:@"job_pro.png"]];
        table.hidden = NO;
        offset = 16;
        unlockLabel.text = @"";
        [self updateView];
    }
    else
    {
        [bgImage setImage:[UIImage imageNamed:@"job_pro_locked.png"]];
        table.hidden = YES;
        unlockLabel.text = @"UNLOCK AT LEVEL 100";
        [self.view setNeedsDisplay];
    }
}

- (void)doJob:(NSInteger)energy_used :(NSInteger)xp_gain :(NSInteger)row
{
	if([Globals i].energy >= energy_used)
	{
		NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/DoJobNew/%@/%ld/%.0f",
						   WS_URL, [[Globals i] UID], (long)xp_gain, timeInterval];
		
        [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 NSNumber *xp = [NSNumber numberWithInteger:xp_gain];
                 NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                 [userInfo setObject:xp forKey:@"xp_gain"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateXP"
                                                                     object:self
                                                                   userInfo:userInfo];
                 
                 [Globals i].energy = [Globals i].energy - energy_used;
                 [[Globals i] storeEnergy];
                 
                 [[Globals i] showToast:[NSString stringWithFormat:@"-%ld Energy, +%ld XP", (long)energy_used, (long)xp_gain]
                              optionalTitle:[NSString stringWithFormat:@"%ld Energy Remaining", (long)[Globals i].energy]
                              optionalImage:@"tick_yes"];
                 
                 NSInteger lvl = [(self.jobs)[row][@"Level"] integerValue];
                 NSInteger percentincrease = 40 - (lvl*5);
                 if (percentincrease < 5)
                 {
                     percentincrease = 5;
                 }
                 [self safeRow:row:percentincrease];
                 
                 [self.view setNeedsDisplay];
                 [table reloadData];
             }
         }];
	}
	else
	{
		[[NSNotificationCenter defaultCenter]
         postNotificationName:@"GotoRefillEnergy"
         object:self];
	}
}

- (NSInteger)getTotalFriendlyMatch
{
	NSInteger count = 0;
    NSMutableArray *friendlyClubs = [[NSMutableArray alloc] init];
	
	if([[[Globals i] getMatchPlayedData] count] > 0)
	{
		for(NSDictionary *rowData in [[Globals i] getMatchPlayedData]) 
		{
			if([rowData[@"match_type_id"] isEqualToString:@"3"]) 
			{
                if([rowData[@"club_home"] isEqualToString:[[Globals i] getClubData][@"club_id"]]) 
                {
                    [friendlyClubs addObject:rowData[@"club_away"]];
                }
                else
                {
                    [friendlyClubs addObject:rowData[@"club_home"]];
                }
			}
		}
        
        NSSet *uniqueElements = [NSSet setWithArray:friendlyClubs];
        count = [uniqueElements count];
	}
    
    if (count==0) //Let gamers at least get to do the first job without a challenge
    {
        count = 1;
    }
	
	return count;
}

- (void)updateView
{
	NSArray *jobs_array = [[NSUserDefaults standardUserDefaults] objectForKey:@"jobs1"];
	if (jobs_array.count > 0)
	{
		if (self.jobs.count < 1)
		{
			self.jobs = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in jobs_array)
            {
                [self.jobs addObject:[dict mutableCopy]];
            }
		}
	}
	else
	{
		NSMutableDictionary *row0 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1", @"Reward", @"1", @"Energy", @"1", @"Friendly", @"training_01", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"3", @"Reward", @"2", @"Energy", @"2", @"Friendly", @"training_02", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"5", @"Reward", @"3", @"Energy", @"3", @"Friendly", @"training_03", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"7", @"Reward", @"4", @"Energy", @"4", @"Friendly", @"training_04", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"9", @"Reward", @"5", @"Energy", @"5", @"Friendly", @"training_05", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row5 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"11", @"Reward", @"6", @"Energy", @"6", @"Friendly", @"training_06", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row6 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"13", @"Reward", @"7", @"Energy", @"7", @"Friendly", @"training_07", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row7 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"15", @"Reward", @"8", @"Energy", @"8", @"Friendly", @"training_08", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row8 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"10", @"Reward", @"5", @"Energy", @"3", @"Friendly", @"training_09", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row9 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"12", @"Reward", @"6", @"Energy", @"4", @"Friendly", @"training_10", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row10 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"14", @"Reward", @"7", @"Energy", @"5", @"Friendly", @"training_11", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row11 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"16", @"Reward", @"8", @"Energy", @"6", @"Friendly", @"training_12", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row12 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"18", @"Reward", @"9", @"Energy", @"7", @"Friendly", @"training_13", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row13 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"20", @"Reward", @"10", @"Energy", @"8", @"Friendly", @"training_14", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row14 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"22", @"Reward", @"11", @"Energy", @"9", @"Friendly", @"training_15", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row15 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"24", @"Reward", @"12", @"Energy", @"10", @"Friendly", @"training_16", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row16 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"19", @"Reward", @"9", @"Energy", @"5", @"Friendly", @"training_17", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row17 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"21", @"Reward", @"10", @"Energy", @"6", @"Friendly", @"training_18", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row18 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"23", @"Reward", @"11", @"Energy", @"7", @"Friendly", @"training_19", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row19 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"25", @"Reward", @"12", @"Energy", @"8", @"Friendly", @"training_20", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row20 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"27", @"Reward", @"13", @"Energy", @"9", @"Friendly", @"training_21", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row21 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"29", @"Reward", @"14", @"Energy", @"10", @"Friendly", @"training_22", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row22 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"31", @"Reward", @"15", @"Energy", @"11", @"Friendly", @"training_23", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
		NSMutableDictionary *row23 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"33", @"Reward", @"16", @"Energy", @"12", @"Friendly", @"training_24", @"Pos", @"1", @"Level", @"0", @"Percent", nil];
        
		self.jobs = [[NSMutableArray alloc] initWithObjects:row0, row1, row2, row3, row4, row5, row6, row7, row8, row9, row10, row11, row12, row13, row14, row15, row16, row17, row18, row19, row20, row21, row22, row23, nil];

	}

    [table reloadData];
    [self.view setNeedsDisplay];
}

- (void)safeRow:(NSInteger)row :(NSInteger)percent
{
	NSMutableDictionary *rowData = (self.jobs)[row];
	NSInteger job_level = [rowData[@"Level"] integerValue];
	NSInteger job_percent = [rowData[@"Percent"] integerValue] + percent;
	
    if (job_percent > 99)
	{
		job_level = job_level + 1;
		[rowData setValue:@(job_level) forKey:@"Level"];
		job_percent = 0;
	}
    
	[rowData setValue:@(job_percent) forKey:@"Percent"];
	
	[[NSUserDefaults standardUserDefaults] setObject:self.jobs forKey:@"jobs1"];
}

- (void)buttonPressed:(id)sender
{
    NSInteger row = [sender tag];
	NSInteger reqmatch = [(self.jobs)[row][@"Friendly"] integerValue];
	
	if(reqmatch > self.getTotalFriendlyMatch)
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Unique Friendly Matches Required"
							  message:[NSString stringWithFormat:@"Your team has played only %ld unique friendly matches this week, you require %ld unique friendly matches to be able to do this training. Get more clubs to challenge you by giving us a 5 star and posting your club name on the reviews?", (long)self.getTotalFriendlyMatch, (long)reqmatch]
							  delegate:self
							  cancelButtonTitle:@"Cancel"
							  otherButtonTitles:@"OK", nil];
		[alert show];
	}
	else
	{
		[self doJob:[(self.jobs)[row][@"Energy"] integerValue] :[(self.jobs)[row][@"Reward"] integerValue] :row];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
		NSString *url = [[Globals i] getProductIdentifiers][@"reviews"];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"JobsCell";
	
	JobsCell *cell = (JobsCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JobsCell" owner:self options:nil];
		cell = (JobsCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	NSUInteger row = [indexPath row] + offset;
	NSDictionary *rowData = (self.jobs)[row];
	
	cell.rewardLabel.text = [NSString stringWithFormat:@"+%@ XP", rowData[@"Reward"]];
	cell.energyLabel.text = rowData[@"Energy"];
	cell.friendlyLabel.text = rowData[@"Friendly"];
	cell.rankLabel.text = [NSString stringWithFormat:@"Level %@: %@%%", rowData[@"Level"], rowData[@"Percent"]];
	cell.rankProgress.progress = [rowData[@"Percent"] floatValue]/100;
    
    [cell.trainImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", rowData[@"Pos"]]]];
    [cell.descImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_word.png", rowData[@"Pos"]]]];
	
    if (row > 0) 
    {
        if ([(self.jobs)[row-1][@"Level"] integerValue] > 9) 
        {
            cell.unlockLabel.text = @"";
            [cell.trainImage setAlpha:1.0f];
            [cell.descImage setAlpha:1.0f];
            
            cell.jobButton.tag = row;
            [cell.jobButton setEnabled:YES];
            [cell.jobButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.unlockLabel.text = @"UNLOCK AT LEVEL 10 TRAINING ABOVE";
            [cell.trainImage setAlpha:0.3f];
            [cell.descImage setAlpha:0.3f];
            cell.jobButton.tag = -1;
            [cell.jobButton setEnabled:NO];
        }
    }
    else //The 1st Row of jobs
    {
        cell.unlockLabel.text = @"";
        [cell.trainImage setAlpha:1.0f];
        [cell.descImage setAlpha:1.0f];
        
        cell.jobButton.tag = row;
        [cell.jobButton setEnabled:YES];
        [cell.jobButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
	
    cell.backgroundColor = [UIColor clearColor];
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 140*SCALE_IPAD;
}

@end
