//
//  ChallengeCreateView.m
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "ChallengeCreateView.h"
#import "Globals.h"
#import "MainView.h"

@implementation ChallengeCreateView
@synthesize mainView;
@synthesize titleLabel;
@synthesize managerNote;
@synthesize winButton;
@synthesize loseButton;
@synthesize selected_matchid;
@synthesize win;
@synthesize lose;
@synthesize draw;
@synthesize matches;


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
	managerNote.delegate = self;
	[winButton setTitle:@"$5,000" forState:UIControlStateNormal];
	[loseButton setTitle:@"$5,000" forState:UIControlStateNormal];
	win = @"5000";
	lose = @"5000";
	draw = @"0";
}

-(void)updateView
{
    managerNote.delegate = self;
	[winButton setTitle:@"$5,000" forState:UIControlStateNormal];
	[loseButton setTitle:@"$5,000" forState:UIControlStateNormal];
	win = @"5000";
	lose = @"5000";
	draw = @"0";
    managerNote.text = @"";
    
	[self.view setNeedsDisplay];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text 
{
    if([text isEqualToString:@"\n"])
	{
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)winButton_tap:(id)sender
{
    [mainView buttonSound];
    
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Select Amount"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"$5,000", @"$10,000", @"$20,000", @"$50,000", @"$75,000", @"$100,000", nil];
	actionSheet.tag = 1;
	[actionSheet showInView:self.view];
}

- (IBAction)loseButton_tap:(id)sender
{
    [mainView buttonSound];
    
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Select Amount"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"$5,000", @"$10,000", @"$20,000", @"$50,000", @"$75,000", @"$100,000", nil];
	actionSheet.tag = 2;
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch(actionSheet.tag)
	{
		case 1:
		{
			switch(buttonIndex)
			{
                case 0:
				{
					[winButton setTitle:@"$5,000" forState:UIControlStateNormal];
					win = @"5000";
					break;
				}
				case 1:
				{
					[winButton setTitle:@"$10,000" forState:UIControlStateNormal];
					win = @"10000";
					break;
				}
				case 2:
				{
					[winButton setTitle:@"$20,000" forState:UIControlStateNormal];
					win = @"20000";
					break;
				}
				case 3:
				{
					[winButton setTitle:@"$50,000" forState:UIControlStateNormal];
					win = @"50000";
					break;
				}
				case 4:
				{
					[winButton setTitle:@"$75,000" forState:UIControlStateNormal];
					win = @"75000";
					break;
				}
				case 5:
				{
					[winButton setTitle:@"$100,000" forState:UIControlStateNormal];
					win = @"100000";
					break;
				}
			}
			break;
		}
		case 2:
		{
			switch(buttonIndex)
			{
                case 0:
				{
					[loseButton setTitle:@"$5,000" forState:UIControlStateNormal];
					lose = @"5000";
					break;
				}
				case 1:
				{
					[loseButton setTitle:@"$10,000" forState:UIControlStateNormal];
					lose = @"10000";
					break;
				}
				case 2:
				{
					[loseButton setTitle:@"$20,000" forState:UIControlStateNormal];
					lose = @"20000";
					break;
				}
				case 3:
				{
					[loseButton setTitle:@"$50,000" forState:UIControlStateNormal];
					lose = @"50000";
					break;
				}
				case 4:
				{
					[loseButton setTitle:@"$75,000" forState:UIControlStateNormal];
					lose = @"75000";
					break;
				}
				case 5:
				{
					[loseButton setTitle:@"$100,000" forState:UIControlStateNormal];
					lose = @"100000";
					break;
				}
			}
			break;
		}
	}
	[self.view setNeedsDisplay];
}

- (IBAction)cancelButton_tap:(id)sender
{
	[mainView buttonSound];
	[self.view removeFromSuperview];
}

- (IBAction)okButton_tap:(id)sender
{
	[mainView buttonSound];
    
	[self confirmPurchase];
}

- (void)confirmPurchase
{
	int pval = [win intValue];
	int bal = [[[[Globals i] getClubData][@"balance"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
	if(bal > pval*2)
	{
        [NSThread detachNewThreadSelector:@selector(challengeClub) toTarget:self withObject:nil];
        [self.view removeFromSuperview];
    }
	else
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Accountant"
							  message:@"We can't afford this bet. You must have more then twice of the win money you have selected, in your club funds. Buy more club funds?"
							  delegate:self
							  cancelButtonTitle:@"CANCEL"
							  otherButtonTitles:@"OK", nil];
        alert.tag = 1;
		[alert show];
	}
}

- (void)challengeClub
{
    @autoreleasepool {
    
        NSString *enemy_club_id = [Globals i].selectedClubId;
        NSString *my_club_id = [[[Globals i] getClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString *note = managerNote.text;
        if([note length]<1)
        {
            note = @"hi";
        }
        [[Globals i] challengeClub:my_club_id:enemy_club_id:win:lose:draw:note];
        
        [self performSelectorOnMainThread:@selector(challengeSuccess)
						   withObject:nil
						waitUntilDone:NO];
    
    }
}

- (void)challengeSuccess
{
    //Refresh invites list
    [[Globals i] updateChallengedData];
    //Refresh challenge list
    [mainView updateChallenge];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Assistant Manager"
                          message:@"Your challenge request has been sent to the club manager."
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    alert.tag = 2;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (alertView.tag == 1) 
    {
        if(buttonIndex == 1)
        {
            [mainView addFunds];
        }
    }
}

@end
