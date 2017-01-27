//
//  ChallengeView.m
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "ChallengeView.h"
#import "Globals.h"
#import "MainView.h"

@implementation ChallengeView

@synthesize titleLabel;
@synthesize managerNote;
@synthesize selected_matchid;
@synthesize matches;
@synthesize winLabel;
@synthesize loseLabel;

- (void)viewDidLoad
{
	currMatchIndex = 0;
}

- (IBAction)cancelButton_tap:(id)sender
{
    [Globals i].challengeMatchId = selected_matchid;
    [[Globals i].mainView declineChallenge];
    
	currMatchIndex = currMatchIndex+1;
	[self updateView];
}

- (void)updateView //Cycle through all challenges
{
	self.matches = [[Globals i] getChallengesData];
	
	if([self.matches count] > currMatchIndex)
	{
		NSDictionary *rowData = (self.matches)[currMatchIndex];
		self.selected_matchid = [[NSString alloc] initWithString:rowData[@"match_id"]];
		titleLabel.text = rowData[@"club_home_name"];
		if([rowData[@"challenge_note"] isEqualToString:@""])
		{
			
		}
		else
		{
			managerNote.text = rowData[@"challenge_note"];
		}
        
        NSString *win = [[Globals i] numberFormat:rowData[@"challenge_win"]];
        NSString *lose = [[Globals i] numberFormat:rowData[@"challenge_lose"]];
        
        winLabel.text = [NSString stringWithFormat:@"$ %@", win];
        loseLabel.text = [NSString stringWithFormat:@"$ %@", lose];
	}
	else
	{
		currMatchIndex = 0;
        [[Globals i].mainView updateChallenge];
        
		[UIManager.i closeTemplate];
	}
}

- (void)viewChallenge:(NSInteger)selected_row
{
    currMatchIndex = selected_row;
    self.matches = [[Globals i] getChallengesData];
    NSDictionary *rowData = (self.matches)[currMatchIndex];
    self.selected_matchid = [[NSString alloc] initWithString:rowData[@"match_id"]];
    
	titleLabel.text = rowData[@"club_home_name"];
	if([rowData[@"challenge_note"] isEqualToString:@""])
	{
		
	}
	else
	{
		managerNote.text = rowData[@"challenge_note"];
	}
    
	NSString *win = [[Globals i] numberFormat:rowData[@"challenge_win"]];
    NSString *lose = [[Globals i] numberFormat:rowData[@"challenge_lose"]];
    
    winLabel.text = [NSString stringWithFormat:@"$ %@", win];
    loseLabel.text = [NSString stringWithFormat:@"$ %@", lose];
}

- (IBAction)okButton_tap:(id)sender
{
	[self confirmPurchase];
}

- (void)confirmPurchase
{
	NSInteger pval = [(self.matches)[0][@"challenge_lose"] integerValue];
	NSInteger bal = [[[Globals i] getClubData][@"balance"] integerValue];
	if(bal > pval)
	{
		[Globals i].challengeMatchId = selected_matchid;
        [UIManager.i closeTemplate];
		[[Globals i].mainView startLiveMatch];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Accountant"
							  message:@"You do not have enough funds to cover your loss. Convert some Diamonds to Funds?"
							  delegate:self
							  cancelButtonTitle:@"CANCEL"
							  otherButtonTitles:@"OK", nil];
		[alert show];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
		[[NSNotificationCenter defaultCenter]
         postNotificationName:@"BuyFunds"
         object:self];
	}
}

- (IBAction)challengeButton_tap:(id)sender
{
    [UIManager.i closeTemplate];
	[[Globals i].mainView showChallenge:(self.matches)[currMatchIndex][@"club_home"]];

    currMatchIndex = 0;
}

@end
