//
//  AllianceViewer.m
//  FFC
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "AllianceViewer.h"

@implementation AllianceViewer
@synthesize mainView;
@synthesize table;
@synthesize dialogBox;
@synthesize aAlliance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    aAlliance = nil;
    
    if (UIScreen.mainScreen.bounds.size.height != 568 && !iPad)
    {
        [table setFrame:CGRectMake(0, table.frame.origin.y, 320, UIScreen.mainScreen.bounds.size.height-table.frame.origin.y)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView
{
    [table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [table reloadData];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"AllianceViewerCell";
	AllianceViewerCell *cell = (AllianceViewerCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllianceViewerCell" owner:self options:nil];
		cell = (AllianceViewerCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
    
    if (aAlliance != nil)
    {
        cell.name.text = aAlliance.name;
        cell.leader.text = [[NSString alloc] initWithFormat:@"%@ %@", aAlliance.leader_firstname, aAlliance.leader_secondname];
        cell.leader_name.text = aAlliance.leader_name;
        cell.date_found.text = aAlliance.date_found;
		cell.total_members.text = [[NSString alloc] initWithFormat:@"Members: %@/%@0", aAlliance.total_members, aAlliance.alliance_level];
        cell.alliance_level.text = [[NSString alloc] initWithFormat:@"Level: %@", aAlliance.alliance_level];
        cell.currency_first.text = [[NSString alloc] initWithFormat:@"Funds: $%@", [[Globals i] numberFormat:aAlliance.currency_first]];
        cell.currency_second.text = [[NSString alloc] initWithFormat:@"Diamonds: %@", [[Globals i] numberFormat:aAlliance.currency_second]];
        cell.rank.text = [[NSString alloc] initWithFormat:@"Rank: %@", [[Globals i] numberFormat:aAlliance.rank]];
		cell.score.text = [[NSString alloc] initWithFormat:@"Score: %@", [[Globals i] numberFormat:aAlliance.score]];
        cell.fanpage_url.text = [[NSString alloc] initWithFormat:@"URL: %@", aAlliance.fanpage_url];
        cell.introduction_text.text = aAlliance.introduction_text;
        cell.cup_name.text = [[NSString alloc] initWithFormat:@"Cup Name: %@", aAlliance.cup_name];
        cell.cup_first_prize.text = [[NSString alloc] initWithFormat:@"First Prize: $%@", [[Globals i] numberFormat:aAlliance.cup_first_prize]];
        cell.cup_second_prize.text = [[NSString alloc] initWithFormat:@"Second Prize: $%@", [[Globals i] numberFormat:aAlliance.cup_second_prize]];
        cell.cup_start.text = [[NSString alloc] initWithFormat:@"Begin: %@", aAlliance.cup_start];
        cell.cup_round.text = [[NSString alloc] initWithFormat:@"Current Round: %@", aAlliance.cup_round];
        cell.cup_first_name.text = aAlliance.cup_first_name;
        cell.cup_second_name.text = aAlliance.cup_second_name;
    }

	return cell;
}

#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 900*SCALE_IPAD;
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

- (IBAction)joinButton_tap:(id)sender
{
    int alliance_id = [[[[Globals i] getClubData][@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
    
    if (alliance_id > 0)
    {
        [self createDialogBox];
        dialogBox.titleText = @"Assistant Manager";
        dialogBox.whiteText = @"Unable to Join!";
        dialogBox.promptText = @"You are currently a member of another Association, resign from that association first to Join this one.";
        dialogBox.dialogType = 1;
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
    else
    {
        NSString *alliance_id = aAlliance.alliance_id;
        NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString *club_name = [[[Globals i] getClubData][@"club_name"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSString *returnValue = @"0";
        NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceApply/%@/%@/%@",
                           WS_URL, alliance_id, club_id, club_name];
        NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc] initWithString:wsurl2];
        returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        
        if([returnValue isEqualToString:@"0"])
        {
            [self createDialogBox];
            dialogBox.titleText = @"Unable to Join!";
            dialogBox.whiteText = @"Please try again.";
            dialogBox.promptText = @"";
            dialogBox.dialogType = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
        else
        {
            [[Globals i] updateClubData];
            
            [self createDialogBox];
            dialogBox.titleText = @"Assistant Manager";
            dialogBox.whiteText = @"Request Sent!";
            dialogBox.promptText = @"A request to join has been sent to the President. You will be informed in the News if you are accepted.";
            dialogBox.dialogType = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
}

- (IBAction)cancelButton_tap:(id)sender
{
    [self.view removeFromSuperview];
}

@end
