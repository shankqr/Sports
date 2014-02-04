//
//  AllianceDetail.m
//  Kingdom Game
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "AllianceDetail.h"
#import "Globals.h"
#import "AllianceObject.h"
#import "AllianceCreate.h"
#import "AllianceMembers.h"
#import "AllianceEvents.h"
#import "AllianceDonations.h"
#import "AllianceApplicants.h"
#import "AllianceCup.h"

@implementation AllianceDetail
@synthesize aAlliance;
@synthesize alliance_id;
@synthesize rows;
@synthesize allianceCreate;
@synthesize allianceEvents;
@synthesize allianceDonations;
@synthesize allianceApplicants;
@synthesize allianceMembers;
@synthesize allianceCup0;
@synthesize allianceCup1;
@synthesize allianceCup2;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)scrollToTop
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)updateView
{
    isMyAlliance = NO;
    isLeader = NO;
    
    if (aAlliance != nil)
    {
        [self generateRowData];
	}
    else
    {
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetAllianceDetail/%@",
                           [[Globals i] world_url], self.alliance_id];
        
        [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
                 
                 if ([returnArray count] > 0)
                 {
                     aAlliance = [[AllianceObject alloc] initWithDictionary:returnArray[0]];
                     [self generateRowData];
                 }
             }
         }];
    }
}

- (void)generateRowData
{
    if([aAlliance.alliance_id isEqualToString:[[Globals i] wsClubData][@"alliance_id"]]) //You are in this alliance
    {
        isMyAlliance = YES;
    }
    else
    {
        isMyAlliance = NO;
    }
    
    if([aAlliance.leader_id isEqualToString:[[Globals i] wsClubData][@"club_id"]]) //You are the leader
    {
        isLeader = YES;
    }
    else
    {
        isLeader = NO;
    }
    
    NSArray *rows1 = nil;
    
    if (isMyAlliance)
    {
        if (isLeader)
        {
            NSDictionary *row0 = @{@"h1": @"Options"};
            NSDictionary *row1 = @{@"r1": @"Leave this Alliance Cup", @"i2": @"arrow_right"};
            NSDictionary *row2 = @{@"r1": @"Comments", @"i2": @"arrow_right"};
            NSDictionary *row3 = @{@"r1": @"View Matches", @"i2": @"arrow_right"};
            NSDictionary *row4 = @{@"r1": @"Donate Diamonds", @"i2": @"arrow_right"};
            NSDictionary *row5 = @{@"r1": @"Donate Funds", @"i2": @"arrow_right"};
            NSDictionary *row6 = @{@"r1": @"Message all members", @"i2": @"arrow_right"};
            NSDictionary *row7 = @{@"r1": @"Upgrade Alliance Cup", @"i2": @"arrow_right"};
            NSDictionary *row8 = @{@"r1": @"Edit Alliance Cup", @"i2": @"arrow_right"};
            NSDictionary *row9 = @{@"r1": @"Set 1st Prize", @"i2": @"arrow_right"};
            NSDictionary *row10 = @{@"r1": @"Set 2nd Prize", @"i2": @"arrow_right"};
            rows1 = @[row0, row1, row2, row3, row4, row5, row6, row7, row8, row9, row10];
        }
        else
        {
            NSDictionary *row0 = @{@"h1": @"Options"};
            NSDictionary *row1 = @{@"r1": @"Leave this Alliance Cup", @"i2": @"arrow_right"};
            NSDictionary *row2 = @{@"r1": @"Comments", @"i2": @"arrow_right"};
            NSDictionary *row3 = @{@"r1": @"View Matches", @"i2": @"arrow_right"};
            NSDictionary *row4 = @{@"r1": @"Donate Diamonds", @"i2": @"arrow_right"};
            NSDictionary *row5 = @{@"r1": @"Donate Funds", @"i2": @"arrow_right"};
            rows1 = @[row0, row1, row2, row3, row4, row5];
        }
    }
    else
    {
        NSDictionary *row0 = @{@"h1": @"Options"};
        NSDictionary *row1 = @{@"r1": @"Request to Join", @"i2": @"arrow_right"};
        NSDictionary *row2 = @{@"r1": @"Comments", @"i2": @"arrow_right"};
        NSDictionary *row3 = @{@"r1": @"View Matches", @"i2": @"arrow_right"};
        rows1 = @[row0, row1, row2, row3];
    }
    
    NSDictionary *row30 = @{@"h1": @"Details"};
    NSDictionary *row31 = @{@"r1": @"Alliance Cup Name", @"r2": aAlliance.name};
    NSDictionary *row32;
    if (isLeader)
    {
        row32 = @{@"r1": @"Leader", @"r2": aAlliance.leader_name};
    }
    else
    {
        row32 = @{@"r1": @"Leader", @"r2": aAlliance.leader_name, @"i2": @"arrow_right"};
    }
    
    NSString *cup_begin = @"Cup will begin soon. More then 1 member is needed to begin";
    
    if (![aAlliance.cup_start isEqualToString:@"Monday, January 01, 0001"])
    {
        cup_begin = aAlliance.cup_start;
    }
    
    NSDictionary *row33 = @{@"r1": @"Members", @"r2": [NSString stringWithFormat:@"%@ / %@0", aAlliance.total_members, aAlliance.alliance_level], @"i2": @"arrow_right"};
    NSDictionary *row34 = @{@"r1": @"Applicants", @"r2": @"View list of applicant", @"i2": @"arrow_right"};
    NSDictionary *row35 = @{@"r1": @"Donations", @"r2": @"View donations made", @"i2": @"arrow_right"};
    NSDictionary *row36 = @{@"r1": @"Events", @"r2": @"View events", @"i2": @"arrow_right"};
    NSDictionary *row37 = @{@"r1": @"Founded", @"r2": [[Globals i] getTimeAgo:aAlliance.date_found]};
    NSDictionary *row38 = @{@"r1": @"Alliance Cup Level", @"r2": aAlliance.alliance_level};
    NSDictionary *row39 = @{@"r1": @"Diamonds", @"r2": [[Globals i] numberFormat:aAlliance.currency_second], @"i2": @"arrow_right"};
    NSDictionary *row40 = @{@"r1": @"Funds", @"r2": [[Globals i] numberFormat:aAlliance.currency_first], @"i2": @"arrow_right"};
    NSDictionary *row41 = @{@"r1": @"Prestige Points", @"r2": [[Globals i] numberFormat:aAlliance.score]};
    NSDictionary *row42 = @{@"r1": @"Ranking", @"r2": [[Globals i] numberFormat:aAlliance.rank]};
    //NSDictionary *row43 = @{@"r1": @"Joining Requirements", @"r2": aAlliance.cup_name};
    NSDictionary *row44 = @{@"r1": @"First Prize", @"r2": [[Globals i] numberFormat:aAlliance.cup_first_prize], @"i2": @"arrow_right"};
    NSDictionary *row45 = @{@"r1": @"Second Prize", @"r2": [[Globals i] numberFormat:aAlliance.cup_second_prize], @"i2": @"arrow_right"};
    NSDictionary *row46 = @{@"r1": @"Begin", @"r2": cup_begin};
    NSDictionary *row47 = @{@"r1": @"Current Round", @"r2": aAlliance.cup_round, @"i2": @"arrow_right"};
    NSDictionary *row48 = @{@"r1": @"Previous First Place", @"r2": aAlliance.cup_first_name, @"i2": @"arrow_right"};
    NSDictionary *row49 = @{@"r1": @"Previous Second Place", @"r2": aAlliance.cup_second_name, @"i2": @"arrow_right"};
    NSDictionary *row50 = @{@"r1": @"Alliance Description", @"r2": aAlliance.description};
    NSArray *rows3 = @[row30, row31, row32, row33, row34, row35, row36, row37, row38, row39, row40, row41, row42, row44, row45, row46, row47, row48, row49, row50];
    
    self.rows = @[rows3, rows1];
    
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    return (self.rows)[indexPath.section][indexPath.row];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[Globals i] dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rows count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows[section] count];
}

#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[Globals i] dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) //Options
    {
        if(indexPath.row == 1) //Join or Leave
        {
            if (isMyAlliance)
            {
                [self leaveButton_tap];
            }
            else
            {
                [self joinButton_tap];
            }
        }
        else if(indexPath.row == 2) //Comments
        {
            NSString *wsurl = [NSString stringWithFormat:@"%@/GetAllianceWall/%@",
                               [[Globals i] world_url], self.aAlliance.alliance_id];
            
            [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
             {
                 if (success)
                 {
                     NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
                     [Globals i].wsAllianceChatFullData = returnArray;
                     [[Globals i] pushChatVC:[Globals i].wsAllianceChatFullData table:@"alliance_wall" a_id:aAlliance.alliance_id];
                 }
             }];
        }
        else if(indexPath.row == 3) //View Matches
        {
            [self showCupMatches];
        }
        else if(indexPath.row == 4) //Donate Diamonds
        {
            [self donateDiamonds];
        }
        else if(indexPath.row == 5) //Donate Funds
        {
            [self donateFunds];
        }
        else if(indexPath.row == 6) //Mass Mail
        {
            [[Globals i] mailCompose:@"1" toID:aAlliance.alliance_id toName:aAlliance.name];
        }
        else if(indexPath.row == 7) //Upgrade CUP
        {
            [self upgradeButton_tap];
        }
        else if(indexPath.row == 8) //Edit CUP
        {
            [self editAlliance];
        }
        else if(indexPath.row == 9) //1st Prize
        {
            [self setPrize1];
        }
        else if(indexPath.row == 10) //2nd Prize
        {
            [self setPrize2];
        }
    }
    else if(indexPath.section == 0) //Details
    {
        if(indexPath.row == 2) //Message to Leader
        {
            if (!isLeader)
            {
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:aAlliance.leader_id forKey:@"club_id"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                                    object:self
                                                                  userInfo:userInfo];
            }
        }
        else if(indexPath.row == 3) //Members
        {
            if(allianceMembers == nil)
            {
                allianceMembers = [[AllianceMembers alloc] initWithStyle:UITableViewStylePlain];
            }
            allianceMembers.aAlliance = self.aAlliance;
            [allianceMembers updateView];
            [[Globals i] pushTemplateNav:allianceMembers];
        }
        else if(indexPath.row == 4) //Applicants
        {
            if(allianceApplicants == nil)
            {
                allianceApplicants = [[AllianceApplicants alloc] initWithStyle:UITableViewStylePlain];
            }
            allianceApplicants.aAlliance = self.aAlliance;
            [allianceApplicants updateView];
            [[Globals i] pushTemplateNav:allianceApplicants];
        }
        else if(indexPath.row == 5) //Donations
        {
            if(allianceDonations == nil)
            {
                allianceDonations = [[AllianceDonations alloc] initWithStyle:UITableViewStylePlain];
            }
            allianceDonations.aAlliance = self.aAlliance;
            [allianceDonations updateView];
            [[Globals i] pushTemplateNav:allianceDonations];
        }
        else if(indexPath.row == 6) //Events
        {
            if(allianceEvents == nil)
            {
                allianceEvents = [[AllianceEvents alloc] initWithStyle:UITableViewStylePlain];
            }
            allianceEvents.aAlliance = self.aAlliance;
            [allianceEvents updateView];
            [[Globals i] pushTemplateNav:allianceEvents];
        }
        else if(indexPath.row == 9) //Donate Diamonds
        {
            if (isMyAlliance)
            {
                [self donateDiamonds];
            }
        }
        else if(indexPath.row == 10) //Donate Funds
        {
            if (isMyAlliance)
            {
                [self donateFunds];
            }
        }
        else if(indexPath.row == 13) //1st Prize
        {
            if (isLeader)
            {
                [self setPrize1];
            }
        }
        else if(indexPath.row == 14) //2nd Prize
        {
            if (isLeader)
            {
                [self setPrize2];
            }
        }
        else if(indexPath.row == 16) //Cup Rounds
        {
            [self showCupMatches];
        }
        else if(indexPath.row == 17) //Fist prize winner
        {
            if (![aAlliance.cup_first_id isEqualToString:@"0"] && ![aAlliance.cup_first_id isEqualToString:@""])
            {
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:aAlliance.cup_first_id forKey:@"club_id"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                                    object:self
                                                                  userInfo:userInfo];
            }
        }
        else if(indexPath.row == 18) //Second prize winner
        {
            if (![aAlliance.cup_second_id isEqualToString:@"0"] && ![aAlliance.cup_second_id isEqualToString:@""])
            {
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:aAlliance.cup_second_id forKey:@"club_id"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                                    object:self
                                                                  userInfo:userInfo];
            }
        }
    }
    
	return nil;
}

- (void)setPrize1
{
    [[Globals i] showDialogBlock:@"Please keyin an amount:"
                                :5
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //OK button is clicked
         {
             NSInteger number = [text integerValue];
             NSInteger bal = [aAlliance.currency_first integerValue];
             
             if ((number > 0) && (bal >= number))
             {
                 NSString *a_id = aAlliance.alliance_id;
                 NSString *club_id = [[Globals i] wsClubData][@"club_id"];
                 
                 NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceEditFirstprize/%@/%@/%@",
                                    [[Globals i] world_url], a_id, club_id, text];
                 
                 [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
                  {
                      if (success)
                      {
                          self.aAlliance = nil;
                          [self updateView];
                          
                          [[Globals i] showToast:@"Prize money is set Successfully!"
                                   optionalTitle:nil
                                   optionalImage:@"tick_yes"];
                      }
                  }];
             }
             else
             {
                 [[Globals i] showDialog:@"Insufficient balance in Alliance account, please donate more funds to this Alliance."];
             }
         }
     }];
}

- (void)setPrize2
{
    [[Globals i] showDialogBlock:@"Please keyin an amount:"
                                :5
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //OK button is clicked
         {
             NSInteger number = [text integerValue];
             NSInteger bal = [aAlliance.currency_first integerValue];
             
             if ((number > 0) && (bal >= number))
             {
                 NSString *a_id = aAlliance.alliance_id;
                 NSString *club_id = [[Globals i] wsClubData][@"club_id"];
                 
                 NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceEditSecondprize/%@/%@/%@",
                                    [[Globals i] world_url], a_id, club_id, text];
                 
                 [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
                  {
                      if (success)
                      {
                          self.aAlliance = nil;
                          [self updateView];
                          
                          [[Globals i] showToast:@"Prize money is set Successfully!"
                                   optionalTitle:nil
                                   optionalImage:@"tick_yes"];
                      }
                  }];
             }
             else
             {
                 [[Globals i] showDialog:@"Insufficient balance in Alliance account, please donate more funds to this Alliance."];
             }
         }
     }];
}

- (void)showCupMatches
{
    NSInteger cur_round = [aAlliance.cup_round integerValue];
    
    if (allianceCup0 == nil)
    {
        allianceCup0 = [[AllianceCup alloc] initWithStyle:UITableViewStylePlain];
        allianceCup0.filter = @"minus0";
    }
    allianceCup0.title = [NSString stringWithFormat:@"Round %li (Now)", (long)cur_round];
    allianceCup0.curRound = cur_round;
    
    if (allianceCup1 == nil)
    {
        allianceCup1 = [[AllianceCup alloc] initWithStyle:UITableViewStylePlain];
        allianceCup1.filter = @"minus1";
    }
    allianceCup1.title = [NSString stringWithFormat:@"Round %li", (long)cur_round-1];
    allianceCup1.curRound = cur_round;
    
    if (allianceCup2 == nil)
    {
        allianceCup2 = [[AllianceCup alloc] initWithStyle:UITableViewStylePlain];
        allianceCup2.filter = @"minus2";
    }
    allianceCup2.title = [NSString stringWithFormat:@"Round %li", (long)cur_round-2];
    allianceCup2.curRound = cur_round;
    
    if (cur_round == 0)
    {
        //Show nothing
    }
    else if (cur_round == 1)
    {
        [[Globals i] showTemplate:@[allianceCup0] :@"Cup Matches" :1];
        allianceCup0.alliance_id = aAlliance.alliance_id;
        [self.allianceCup0 updateView];
    }
    else if (cur_round == 2)
    {
        [[Globals i] showTemplate:@[allianceCup0, allianceCup1] :@"Cup Matches" :1];
        allianceCup0.alliance_id = aAlliance.alliance_id;
        [self.allianceCup0 updateView];
        allianceCup1.alliance_id = aAlliance.alliance_id;
        [self.allianceCup1 updateView];
    }
    else if (cur_round > 2)
    {
        [[Globals i] showTemplate:@[allianceCup0, allianceCup1, allianceCup2] :@"Cup Matches" :1];
        allianceCup0.alliance_id = aAlliance.alliance_id;
        [self.allianceCup0 updateView];
        allianceCup1.alliance_id = aAlliance.alliance_id;
        [self.allianceCup1 updateView];
        allianceCup2.alliance_id = aAlliance.alliance_id;
        [self.allianceCup2 updateView];
    }
}

- (void)editAlliance
{
    aAlliance = nil; //Causes this page to reload from server after description is edited
    
    allianceCreate = [[AllianceCreate alloc] initWithStyle:UITableViewStylePlain];
    allianceCreate.descriptionText = aAlliance.description;
    [allianceCreate updateView:NO];
    [[Globals i] pushTemplateNav:allianceCreate];
}

- (void)joinButton_tap
{
    NSInteger a_id = [[[Globals i] wsClubData][@"alliance_id"] integerValue];
    
    if (a_id > 0)
    {
        [[Globals i] showDialog:@"Unable to Join! You are currently a member of another Alliance Cup, resign from that Alliance Cup first to Join this one."];
    }
    else
    {
        NSString *a_id = aAlliance.alliance_id;
        NSString *club_id = [[Globals i] wsClubData][@"club_id"];
        NSString *club_name = [[Globals i] wsClubData][@"club_name"];
        
        NSString *wsurl = [NSString stringWithFormat:@"%@/AllianceApply/%@/%@/%@",
                           [[Globals i] world_url], a_id, club_id, club_name];
        
        [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 [[Globals i] showDialog:@"A request to join has been sent to the Leader. You will be informed once accepted."];
             }
         }];
    }
}

- (void)leaveButton_tap
{
    [[Globals i] showDialogBlock:@"Are you sure you want to leave this Alliance Cup?"
                                :2
                                :^(NSInteger index, NSString *text)
     {
         if(index == 0) //NO
         {
             //Do nothing
         }
         if(index == 1) //YES
         {
             [self leaveAlliance];
         }
     }];
}

- (void)leaveAlliance
{
    NSString *a_id = aAlliance.alliance_id;
    NSString *club_id = [[Globals i] wsClubData][@"club_id"];
    NSString *club_name = [[Globals i] wsClubData][@"club_name"];
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/AllianceResign/%@/%@/%@",
                        [[Globals i] world_url], a_id, club_id, club_name];
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [[Globals i] showDialogBlock:@"You are Out! Now you are free to join other Alliance Cup if you wish."
                                         :1
                                         :^(NSInteger index, NSString *text)
              {
                  if(index == 0) //OK
                  {
                      [[Globals i] updateClubData]; //alliance id = 0 updated
                      
                      [[Globals i] backTemplate];
                      [[Globals i] closeTemplate];
                      
                      [[NSNotificationCenter defaultCenter]
                       postNotificationName:@"GotoAlliance"
                       object:self];
                  }
              }];
         }
     }];
}

- (void)donateDiamonds
{
    [[Globals i] showDialogBlock:@"Please keyin an amount:"
                                :5
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //OK button is clicked
         {
             NSInteger number = [text integerValue];
             NSInteger bal = [[[Globals i] wsClubData][@"currency_second"] integerValue];
             
             if ((number > 0) && (bal >= number))
             {
                 NSString *a_id = aAlliance.alliance_id;
                 NSString *club_id = [[Globals i] wsClubData][@"club_id"];
                 NSString *club_name = [[Globals i] wsClubData][@"club_name"];

                 NSString *wsurl = [NSString stringWithFormat:@"%@/AllianceDonate/%@/%@/%@/0/%ld",
                                    [[Globals i] world_url], a_id, club_id, club_name, (long)number];
                 
                 [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
                  {
                      if (success)
                      {
                          [[Globals i] updateClubData]; //Diamonds - Donation
                          self.aAlliance = nil;
                          [self updateView];
                          
                          [[Globals i] showDialog:@"Thanks. The Alliance Cup members remembers your contribution."];
                      }
                  }];
             }
             else
             {
                 [[Globals i] showBuy];
             }
         }
     }];
}

- (void)donateFunds
{
    [[Globals i] showDialogBlock:@"Please keyin an amount:"
                                :5
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //OK button is clicked
         {
             NSInteger number = [text integerValue];
             NSInteger bal = [[[Globals i] wsClubData][@"balance"] integerValue];
             
             if ((number > 0) && (bal >= number))
             {
                 NSString *a_id = aAlliance.alliance_id;
                 NSString *club_id = [[Globals i] wsClubData][@"club_id"];
                 NSString *club_name = [[Globals i] wsClubData][@"club_name"];
                 
                 NSString *wsurl = [NSString stringWithFormat:@"%@/AllianceDonate/%@/%@/%@/%ld/0",
                                    [[Globals i] world_url], a_id, club_id, club_name, (long)number];
                 
                 [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
                  {
                      if (success)
                      {
                          [[Globals i] updateClubData]; //Funds - Donation
                          self.aAlliance = nil;
                          [self updateView];
                          
                          [[Globals i] showDialog:@"Thanks. The Alliance Cup members remembers your contribution."];
                      }
                  }];
             }
             else
             {
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"BuyFunds"
                  object:self];
             }
         }
     }];
}

- (void)upgradeButton_tap
{
    NSInteger nextLevel = aAlliance.alliance_level.integerValue + 1;
    
    [[Globals i] showDialogBlock:[NSString stringWithFormat:@"Upgrade Alliance Cup to Level %@ for %@ Diamonds. Diamonds will be deducted from Alliance Cup account and not from your own club.", [[Globals i] intString:nextLevel], [[Globals i] intString:nextLevel]]
                                :2
                                :^(NSInteger index, NSString *text)
     {
         if(index == 0) //NO
         {
             //Do nothing
         }
         if(index == 1) //YES
         {
             [self upgradeAlliance];
         }
     }];
}

- (void)upgradeAlliance
{
    NSInteger reqDiamonds = aAlliance.alliance_level.integerValue + 1;
    
    if (aAlliance.currency_second.integerValue >= reqDiamonds)
    {
        NSString *wsurl = [NSString stringWithFormat:@"%@/AllianceUpgrade/%@/%@",
                           [[Globals i] world_url], aAlliance.alliance_id, aAlliance.leader_id];
        
        [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 self.aAlliance = nil;
                 [self updateView];
            
                 [[Globals i] showDialog:@"Upgrade Success! Your Alliance Cup has Leveled UP. Now more members can join to increase the fun and ranking."];
             }
         }];
    }
    else
    {
        [[Globals i] showDialog:@"Insufficient Diamonds to upgrade. Please donate more Diamonds."];
    }
}

@end
