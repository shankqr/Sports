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
@synthesize mainView;
@synthesize titleLabel;
@synthesize managerNote;
@synthesize winButton;
@synthesize loseButton;
@synthesize selected_matchid;
@synthesize matches;

- (void)viewDidLoad
{
	winButton.enabled = NO;
	loseButton.enabled = NO;
	currMatchIndex = 0;
}

- (IBAction)cancelButton_tap:(id)sender
{
    [Globals i].challengeMatchId = selected_matchid;
    [mainView declineChallenge];
    
	currMatchIndex = currMatchIndex+1;
	[self updateView];
}

- (void)updateView //Cycle through all challenges
{
	self.matches = [[Globals i] getChallengesData];
	
	if([self.matches count] > currMatchIndex)
	{
		NSDictionary *rowData = (self.matches)[currMatchIndex];
		self.selected_matchid = [[NSString alloc] initWithString: [rowData[@"match_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
		titleLabel.text = rowData[@"club_home_name"];
		if([rowData[@"challenge_note"] isEqualToString:@""])
		{
			
		}
		else
		{
			managerNote.text = rowData[@"challenge_note"];
		}
		[winButton setTitle:[NSString stringWithFormat:@"$ %@", [[Globals i] numberFormat:rowData[@"challenge_win"]]] forState:UIControlStateNormal];
		[loseButton setTitle:[NSString stringWithFormat:@"$ %@", [[Globals i] numberFormat:rowData[@"challenge_lose"]]] forState:UIControlStateNormal];
		[self.view setNeedsDisplay];
	}
	else
	{
		currMatchIndex = 0;
        [mainView updateChallenge];
        
		[[Globals i] closeTemplate];
	}
}

- (void)viewChallenge:(int)selected_row
{
    currMatchIndex = selected_row;
    self.matches = [[Globals i] getChallengesData];
    NSDictionary *rowData = (self.matches)[currMatchIndex];
    self.selected_matchid = [[NSString alloc] initWithString: [rowData[@"match_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
    
	titleLabel.text = rowData[@"club_home_name"];
	if([rowData[@"challenge_note"] isEqualToString:@""])
	{
		
	}
	else
	{
		managerNote.text = rowData[@"challenge_note"];
	}
	[winButton setTitle:[NSString stringWithFormat:@"$ %@", [[Globals i] numberFormat:rowData[@"challenge_win"]]] forState:UIControlStateNormal];
	[loseButton setTitle:[NSString stringWithFormat:@"$ %@", [[Globals i] numberFormat:rowData[@"challenge_lose"]]] forState:UIControlStateNormal];
    
    [self.view setNeedsDisplay];
}

- (IBAction)winButton_tap:(id)sender
{

}

- (IBAction)loseButton_tap:(id)sender
{

}

- (IBAction)okButton_tap:(id)sender
{
	[self confirmPurchase];
}

- (void)confirmPurchase
{
	int pval = [[(self.matches)[0][@"challenge_lose"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
	int bal = [[[[Globals i] getClubData][@"balance"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
	if(bal > pval)
	{
		[Globals i].challengeMatchId = selected_matchid;
        [[Globals i] closeTemplate];
		[mainView startLiveMatch];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Accountant"
							  message:@"You do not have enough funds to cover your loss. Buy more club funds?"
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
		[[Globals i] showBuy];
	}
}

- (IBAction)challengeButton_tap:(id)sender
{
    [[Globals i] closeTemplate];
	[mainView showChallenge:(self.matches)[currMatchIndex][@"club_home"]];

    currMatchIndex = 0;
}

@end
