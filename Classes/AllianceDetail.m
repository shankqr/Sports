//
//  AllianceDetail.m
//  FFC
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "AllianceDetail.h"
#import "WallView.h"
#import "EventsView.h"
#import "DonationsView.h"
#import "AllianceCup.h"
#import "ApplyView.h"
#import "MembersView.h"

@implementation AllianceDetail
@synthesize mainView;
@synthesize table;
@synthesize dialogBox;
@synthesize aAlliance;
@synthesize wallView;
@synthesize eventsView;
@synthesize donationsView;
@synthesize allianceCup;
@synthesize applyView;
@synthesize membersView;
@synthesize a_id;

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
    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceDetail/%d",
					   WS_URL, a_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
    
    if (wsResponse.count > 0)
    {
        aAlliance = [[AllianceObject alloc] initWithDictionary:wsResponse[0]];
        [table reloadData];
    }
    else
    {
        [self.view removeFromSuperview];
        
        [mainView showAlliance];
    }
}

- (void)drawView
{
    [table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [table reloadData];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"AllianceDetailCell";
	AllianceDetailCell *cell = (AllianceDetailCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllianceDetailCell" owner:self options:nil];
		cell = (AllianceDetailCell *)nib[0];
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
        
        [cell.buttonEvents addTarget:self action:@selector(buttonEvents_tap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonDonations addTarget:self action:@selector(buttonDonations_tap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonDonate addTarget:self action:@selector(buttonDonate_tap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonMembers addTarget:self action:@selector(buttonMembers_tap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonDonations addTarget:self action:@selector(buttonDonations_tap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonWall addTarget:self action:@selector(buttonWall_tap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonApplied addTarget:self action:@selector(buttonApplied_tap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonUpgrade addTarget:self action:@selector(buttonUpgrade_tap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonResign addTarget:self action:@selector(buttonResign_tap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonCup addTarget:self action:@selector(buttonCup_tap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonEdit addTarget:self action:@selector(buttonEdit_tap:) forControlEvents:UIControlEventTouchUpInside];
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
	return 1100*SCALE_IPAD;
}

- (void)createDialogBox
{
    if (dialogBox == NULL)
    {
        dialogBox = [[DialogBoxView alloc] initWithNibName:@"DialogBoxView" bundle:nil];
        dialogBox.delegate = self;
    }
}

- (void)removeDialogBox
{
	if(dialogBox != NULL)
	{
		[dialogBox.view removeFromSuperview];
	}
}

- (void)resignAlliance
{
    int alliance_id = [[[[Globals i] getClubData][@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
    
    if (alliance_id < 1)
    {
        [self createDialogBox];
        dialogBox.titleText = @"Assistant Manager";
        dialogBox.whiteText = @"Unable to Resign!";
        dialogBox.promptText = @"You are currently not a member of this Association.";
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
        NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceResign/%@/%@/%@",
                           WS_URL, alliance_id, club_id, club_name];
        NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc] initWithString:wsurl2];
        returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
        
        if([returnValue isEqualToString:@"0"])
        {
            [self createDialogBox];
            dialogBox.titleText = @"Unable to Resign!";
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
            dialogBox.whiteText = @"You are Out!";
            dialogBox.promptText = @"Now you are free to join other Association if you wish.";
            dialogBox.dialogType = 3;
            dialogBox.view.tag = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
}

- (IBAction)cancelButton_tap:(id)sender
{
    [mainView showHeader];
    [self.view removeFromSuperview];
}

- (IBAction)buttonEvents_tap:(id)sender
{
    [mainView buttonSound];
    if(eventsView == nil)
    {
        eventsView = [[EventsView alloc] initWithNibName:@"EventsView" bundle:nil];
        eventsView.mainView = self.mainView;
    }
    [eventsView updateView];
    [self.view insertSubview:eventsView.view atIndex:17];
}

- (IBAction)buttonDonations_tap:(id)sender
{
    [mainView buttonSound];
    if(donationsView == nil)
    {
        donationsView = [[DonationsView alloc] initWithNibName:@"DonationsView" bundle:nil];
        donationsView.mainView = self.mainView;
    }
    [donationsView updateView];
    [self.view insertSubview:donationsView.view atIndex:17];
}

- (IBAction)buttonDonate_tap:(id)sender
{
    [mainView buttonSound];
    
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"President"
						  message:@"What would you like to donate to this Association?"
						  delegate:self
						  cancelButtonTitle:@"Nothing"
						  otherButtonTitles:@"Funds", @"Diamonds", nil];
    alert.tag = 2;
	[alert show];
}

- (IBAction)buttonMembers_tap:(id)sender
{
    [mainView buttonSound];
    if(membersView == nil)
    {
        membersView = [[MembersView alloc] initWithNibName:@"MembersView" bundle:nil];
        membersView.mainView = self.mainView;
    }
    membersView.alliance_leader_id = aAlliance.leader_id;
    [membersView updateView];
    [self.view insertSubview:membersView.view atIndex:17];
}

- (IBAction)buttonWall_tap:(id)sender
{
    [mainView buttonSound];
    if(wallView == nil)
    {
        wallView = [[WallView alloc] initWithNibName:@"WallView" bundle:nil];
        wallView.mainView = self.mainView;
    }
    [wallView updateView];
    [self.view insertSubview:wallView.view atIndex:17];
}

- (IBAction)buttonApplied_tap:(id)sender
{
    [mainView buttonSound];
    if(applyView == nil)
    {
        applyView = [[ApplyView alloc] initWithNibName:@"ApplyView" bundle:nil];
        applyView.mainView = self.mainView;
    }
    applyView.alliance_leader_id = aAlliance.leader_id;
    [applyView updateView];
    [self.view insertSubview:applyView.view atIndex:17];
}

- (IBAction)buttonUpgrade_tap:(id)sender
{
    [mainView buttonSound];
    
    if([aAlliance.leader_id isEqualToString:[[Globals i] getClubData][@"club_id"]]) //You are the leader
    {
        int nowLevel = aAlliance.alliance_level.intValue;
        int nextLevel = nowLevel + 1;
        int reqFunds = 1000*(nowLevel*nowLevel);
        int reqDiamonds = 2*(nowLevel*nowLevel);
    
        [self createDialogBox];
        dialogBox.titleText = @"Level UP Association";
        dialogBox.whiteText = @"More members can join!";
        dialogBox.promptText = [NSString stringWithFormat:@"Upgrade to Level %d for $%@ and %@ Diamonds. Funds and Diamonds will be deducted from Association and not from your personal club.",
                            nextLevel, [[Globals i] intString:reqFunds], [[Globals i] intString:reqDiamonds]];
        dialogBox.dialogType = 2;
        dialogBox.view.tag = 2;
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
    else
    {
        [self createDialogBox];
        dialogBox.titleText = @"Access Denied!";
        dialogBox.whiteText = @"You are not the President.";
        dialogBox.promptText = @"Only the President can Upgrade this Association";
        dialogBox.dialogType = 1;
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
}

- (IBAction)buttonEdit_tap:(id)sender
{
    [mainView buttonSound];
    
    if([aAlliance.leader_id isEqualToString:[[Globals i] getClubData][@"club_id"]]) //You are the leader
    {        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Edit"
                                      delegate:self
                                      cancelButtonTitle:@"Nothing"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Association Name", @"My First Name", @"My Second Name", @"Website", @"Cup Name", @"First Prize", @"Second Prize", @"Introduction Text", nil];
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
    }
    else
    {
        [self createDialogBox];
        dialogBox.titleText = @"Access Denied!";
        dialogBox.whiteText = @"You are not the President.";
        dialogBox.promptText = @"Only the President can Edit this Association";
        dialogBox.dialogType = 1;
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
}

- (IBAction)buttonCup_tap:(id)sender
{
    [mainView buttonSound];
    if(allianceCup == nil)
    {
        allianceCup = [[AllianceCup alloc] initWithNibName:@"AllianceCup" bundle:nil];
        allianceCup.mainView = self.mainView;
    }
    allianceCup.curRound = aAlliance.cup_round.intValue;
    [allianceCup updateView];
    [self.view insertSubview:allianceCup.view atIndex:17];
}

- (IBAction)buttonResign_tap:(id)sender
{
    [mainView buttonSound];
    
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"President"
						  message:@"Are you sure you want to resign from this Association?"
						  delegate:self
						  cancelButtonTitle:@"No"
						  otherButtonTitles:@"Yes", nil];
    alert.tag = 1;
	[alert show];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch(buttonIndex)
    {
        case 0: //Association Name
        {
            [self createDialogBox];
            dialogBox.titleText = @"Association Name";
            dialogBox.whiteText = @"Please keyin a new name";
            dialogBox.dialogType = 4;
            dialogBox.view.tag = 5;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
            
            break;
        }
        case 1: //First Name
        {
            [self createDialogBox];
            dialogBox.titleText = @"First Name";
            dialogBox.whiteText = @"Please keyin a name";
            dialogBox.dialogType = 4;
            dialogBox.view.tag = 6;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
            
            break;
        }
        case 2: //Second Name
        {
            [self createDialogBox];
            dialogBox.titleText = @"Second Name";
            dialogBox.whiteText = @"Please keyin a name";
            dialogBox.dialogType = 4;
            dialogBox.view.tag = 7;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
            
            break;
        }
        case 3: //Website
        {
            [self createDialogBox];
            dialogBox.titleText = @"Website";
            dialogBox.whiteText = @"Please keyin a url";
            dialogBox.dialogType = 6;
            dialogBox.view.tag = 8;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
            
            break;
        }
        case 4: //Cup Name
        {
            [self createDialogBox];
            dialogBox.titleText = @"Cup Name";
            dialogBox.whiteText = @"Please keyin a name";
            dialogBox.dialogType = 4;
            dialogBox.view.tag = 9;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
            
            break;
        }
        case 5: //First Prize
        {
            [self createDialogBox];
            dialogBox.titleText = @"Cup First Prize";
            dialogBox.whiteText = @"Please keyin a number";
            dialogBox.dialogType = 5;
            dialogBox.view.tag = 10;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
            
            break;
        }
        case 6: //Second Prize
        {
            [self createDialogBox];
            dialogBox.titleText = @"Cup Second Prize";
            dialogBox.whiteText = @"Please keyin a number";
            dialogBox.dialogType = 5;
            dialogBox.view.tag = 11;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
            
            break;
        }
        case 7: //Intro Text
        {
            [self createDialogBox];
            dialogBox.titleText = @"Introduction";
            dialogBox.whiteText = @"Please keyin some text";
            dialogBox.dialogType = 4;
            dialogBox.view.tag = 12;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
            
            break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) //Resign
    {
        if(buttonIndex == 0)
        {
            //Do nothing
        }
        
        if(buttonIndex == 1)
        {
            [self resignAlliance];
        }
    }
    if (alertView.tag == 2) //Donate
    {
        if(buttonIndex == 0)
        {
            //Do nothing
        }
        
        if(buttonIndex == 1) //Funds
        {
            [mainView buttonSound];
            
            [self createDialogBox];
            dialogBox.titleText = @"Donate Funds";
            dialogBox.whiteText = @"Please keyin a number";
            dialogBox.dialogType = 5;
            dialogBox.view.tag = 3;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
        
        if(buttonIndex == 2) //Diamonds
        {
            [mainView buttonSound];
            
            [self createDialogBox];
            dialogBox.titleText = @"Donate Diamonds";
            dialogBox.whiteText = @"Please keyin a number";
            dialogBox.dialogType = 5;
            dialogBox.view.tag = 4;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
}

- (void)returnText:(NSString *)text
{
    if (dialogBox.view.tag == 3) //Donate Funds
    {
        int number = [text intValue];
        int bal = [[[[Globals i] getClubData][@"balance"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];

        if ((number > 0) && (bal >= number))
        {
            NSString *alliance_id = aAlliance.alliance_id;
            NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSString *club_name = [[[Globals i] getClubData][@"club_name"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceDonate/%@/%@/%@/%d/0",
                               WS_URL, alliance_id, club_id, club_name, number];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
            
            if([returnValue isEqualToString:@"0"])
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to Donate now!";
                dialogBox.whiteText = @"Please try again.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                [[Globals i] updateClubData];
                [self updateView];
                
                [self createDialogBox];
                dialogBox.titleText = @"President";
                dialogBox.whiteText = @"Thank You!";
                dialogBox.promptText = @"The Association remembers your contribution.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
        else
        {
            [dialogBox.view removeFromSuperview];
            
            [self createDialogBox];
            dialogBox.titleText = @"Unable to Donate!";
            dialogBox.whiteText = @"Insufficient Funds or Diamonds.";
            dialogBox.promptText = @"";
            dialogBox.dialogType = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
    
    if (dialogBox.view.tag == 4) //Donate Diamonds
    {
        int number = [text intValue];
        int bal = [[[[Globals i] getClubData][@"currency_second"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
        
        if ((number > 0) && (bal >= number))
        {
            NSString *alliance_id = aAlliance.alliance_id;
            NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSString *club_name = [[[Globals i] getClubData][@"club_name"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceDonate/%@/%@/%@/0/%d",
                               WS_URL, alliance_id, club_id, club_name, number];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
            
            if([returnValue isEqualToString:@"0"])
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to Donate now!";
                dialogBox.whiteText = @"Please try again.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                [[Globals i] updateClubData];
                [self updateView];
                
                [self createDialogBox];
                dialogBox.titleText = @"President";
                dialogBox.whiteText = @"Thank You!";
                dialogBox.promptText = @"The Association remembers your contribution.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
        else
        {
            [dialogBox.view removeFromSuperview];
            
            [self createDialogBox];
            dialogBox.titleText = @"Unable to Donate!";
            dialogBox.whiteText = @"Insufficient Funds or Diamonds.";
            dialogBox.promptText = @"";
            dialogBox.dialogType = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
    
    if (dialogBox.view.tag == 5) //Association Name
    {
        if([text isEqualToString:@""])
        {
            
        }
        else
        {
            NSString *alliance_id = aAlliance.alliance_id;
            NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceEditName/%@/%@/%@",
                               WS_URL, alliance_id, club_id, text];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
            
            if([returnValue isEqualToString:@"1"])
            {
                [dialogBox.view removeFromSuperview];
                [self updateView];
                
                [self createDialogBox];
                dialogBox.titleText = @"Success!";
                dialogBox.whiteText = @"Congratulations!";
                dialogBox.promptText = @"You have changed the name of this Association.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to proceed now!";
                dialogBox.whiteText = @"Please try again later.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
    }
    
    if (dialogBox.view.tag == 6) //First Name
    {
        if([text isEqualToString:@""])
        {
            
        }
        else
        {
            NSString *alliance_id = aAlliance.alliance_id;
            NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceEditFirstname/%@/%@/%@",
                               WS_URL, alliance_id, club_id, text];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
            
            if([returnValue isEqualToString:@"1"])
            {
                [dialogBox.view removeFromSuperview];
                [self updateView];
                
                [self createDialogBox];
                dialogBox.titleText = @"Success!";
                dialogBox.whiteText = @"Congratulations!";
                dialogBox.promptText = @"You have changed your first name.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to proceed now!";
                dialogBox.whiteText = @"Please try again later.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
    }
    
    if (dialogBox.view.tag == 7) //Second Name
    {
        if([text isEqualToString:@""])
        {
            
        }
        else
        {
            NSString *alliance_id = aAlliance.alliance_id;
            NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceEditSecondname/%@/%@/%@",
                               WS_URL, alliance_id, club_id, text];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
            
            if([returnValue isEqualToString:@"1"])
            {
                [dialogBox.view removeFromSuperview];
                [self updateView];
                
                [self createDialogBox];
                dialogBox.titleText = @"Success!";
                dialogBox.whiteText = @"Congratulations!";
                dialogBox.promptText = @"You have changed your Second name.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to proceed now!";
                dialogBox.whiteText = @"Please try again later.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
    }
    
    if (dialogBox.view.tag == 8) //Website
    {
        if([text isEqualToString:@""])
        {
            
        }
        else
        {
            text = [[Globals i] urlEnc:text];
            
            NSString *alliance_id = aAlliance.alliance_id;
            NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceEditWebsite/%@/%@/%@",
                               WS_URL, alliance_id, club_id, text];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
            
            if([returnValue isEqualToString:@"1"])
            {
                [dialogBox.view removeFromSuperview];
                [self updateView];
                
                [self createDialogBox];
                dialogBox.titleText = @"Success!";
                dialogBox.whiteText = @"Congratulations!";
                dialogBox.promptText = @"You have changed your Website.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to proceed now!";
                dialogBox.whiteText = @"Please try again later.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
    }
    
    if (dialogBox.view.tag == 9) //Cup Name
    {
        if([text isEqualToString:@""])
        {
            
        }
        else
        {
            NSString *alliance_id = aAlliance.alliance_id;
            NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceEditCup/%@/%@/%@",
                               WS_URL, alliance_id, club_id, text];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
            
            if([returnValue isEqualToString:@"1"])
            {
                [dialogBox.view removeFromSuperview];
                [self updateView];
                
                [self createDialogBox];
                dialogBox.titleText = @"Success!";
                dialogBox.whiteText = @"Congratulations!";
                dialogBox.promptText = @"You have changed your Cup name.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to proceed now!";
                dialogBox.whiteText = @"Please try again later.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
    }
    
    if (dialogBox.view.tag == 10) //First Prize
    {
        int number = [text intValue];
        int bal = [aAlliance.currency_first intValue];
        
        if ((number > 0) && (bal >= number))
        {
            NSString *alliance_id = aAlliance.alliance_id;
            NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceEditFirstprize/%@/%@/%@",
                               WS_URL, alliance_id, club_id, text];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
            
            if([returnValue isEqualToString:@"1"])
            {
                [dialogBox.view removeFromSuperview];
                [self updateView];
                
                [self createDialogBox];
                dialogBox.titleText = @"Success!";
                dialogBox.whiteText = @"Congratulations!";
                dialogBox.promptText = @"You have changed your Cup First Prize.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to proceed now!";
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
            dialogBox.titleText = @"Unable to Set!";
            dialogBox.whiteText = @"Insufficient Funds in Association.";
            dialogBox.promptText = @"Convince members to donate more.";
            dialogBox.dialogType = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
    
    if (dialogBox.view.tag == 11) //Second Prize
    {
        int number = [text intValue];
        int bal = [aAlliance.currency_first intValue];
        
        if ((number > 0) && (bal >= number))
        {
            NSString *alliance_id = aAlliance.alliance_id;
            NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceEditSecondprize/%@/%@/%@",
                               WS_URL, alliance_id, club_id, text];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
            
            if([returnValue isEqualToString:@"1"])
            {
                [dialogBox.view removeFromSuperview];
                [self updateView];
                
                [self createDialogBox];
                dialogBox.titleText = @"Success!";
                dialogBox.whiteText = @"Congratulations!";
                dialogBox.promptText = @"You have changed your Cup Second Prize.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to proceed now!";
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
            dialogBox.titleText = @"Unable to Set!";
            dialogBox.whiteText = @"Insufficient Funds in Association.";
            dialogBox.promptText = @"Convince members to donate more.";
            dialogBox.dialogType = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
    
    if (dialogBox.view.tag == 12) //Introduction
    {
        if([text isEqualToString:@""])
        {
            
        }
        else
        {
            NSString *alliance_id = aAlliance.alliance_id;
            NSString *club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceEditIntro/%@/%@/%@",
                               WS_URL, alliance_id, club_id, text];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
            
            if([returnValue isEqualToString:@"1"])
            {
                [dialogBox.view removeFromSuperview];
                [self updateView];
                
                [self createDialogBox];
                dialogBox.titleText = @"Success!";
                dialogBox.whiteText = @"Congratulations!";
                dialogBox.promptText = @"You have changed your Introduction text.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Unable to proceed now!";
                dialogBox.whiteText = @"Please try again later.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
    }
}

- (void)returnDialog:(NSInteger)tag
{
    if (dialogBox.view.tag == 1) //Resigned
    {
        [dialogBox.view removeFromSuperview];
        
        [mainView showHeader];
        [self.view removeFromSuperview];
    }
    if (dialogBox.view.tag == 2) //Upgrade
    {
        if (tag == 2) //Yes
        {
            int nowLevel = aAlliance.alliance_level.intValue;
            int reqFunds = 1000*(nowLevel*nowLevel);
            int reqDiamonds = 2*(nowLevel*nowLevel);
            
            if ((aAlliance.currency_first.intValue >= reqFunds) && (aAlliance.currency_second.intValue >= reqDiamonds))
            {
                NSString *returnValue = @"0";
                NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceUpgrade/%@/%@",
                                   WS_URL, aAlliance.alliance_id, aAlliance.leader_id];
                NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [[NSURL alloc] initWithString:wsurl2];
                returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
                
                if([returnValue isEqualToString:@"0"])
                {
                    [dialogBox.view removeFromSuperview];
                    
                    [self createDialogBox];
                    dialogBox.titleText = @"Unable to Upgrade!";
                    dialogBox.whiteText = @"Please try again.";
                    dialogBox.promptText = @"";
                    dialogBox.dialogType = 1;
                    [self.view insertSubview:dialogBox.view atIndex:17];
                    [dialogBox updateView];
                }
                else
                {
                    [self updateView];
                    [[Globals i] updateClubData];
                    [dialogBox.view removeFromSuperview];
                    
                    [self createDialogBox];
                    dialogBox.titleText = @"Upgrade Success!";
                    dialogBox.whiteText = @"Congratulations!";
                    dialogBox.promptText = @"Your Association has Leveled UP. Now more members can join to increase the fun and ranking.";
                    dialogBox.dialogType = 1;
                    [self.view insertSubview:dialogBox.view atIndex:17];
                    [dialogBox updateView];
                }
            }
            else
            {
                [dialogBox.view removeFromSuperview];
                
                [self createDialogBox];
                dialogBox.titleText = @"Upgrade Failed!";
                dialogBox.whiteText = @"Insufficient Funds or Diamonds.";
                dialogBox.promptText = @"Donate more funds and diamonds to this Association. You should ask member's to donate and do their part in making this the best Association.";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
    }
}

@end
