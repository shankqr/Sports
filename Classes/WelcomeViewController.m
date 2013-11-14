//
//  WelcomeViewController.m
//  FFC
//
//  Created by Shankar on 6/10/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "WelcomeViewController.h"
#import "MainView.h"
#import "Globals.h"

@implementation WelcomeViewController
@synthesize mainView;
@synthesize promptLabel;
@synthesize promptText;
@synthesize bonusImage;
@synthesize bonusLabel;

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


-(void)updateView
{
	promptLabel.text = promptText;
    
    int bonus = [[[Globals i] gettLoginBonus] intValue];
    if (bonus > 1) 
    {
        bonusImage.hidden = NO;
        bonusLabel.text = [@"+$" stringByAppendingString:[[Globals i] numberFormat:[[Globals i] gettLoginBonus]]];
    }
    else 
    {
        bonusImage.hidden = YES;
        bonusLabel.text = @"";
    }
    
    [self.view setNeedsDisplay];
}

- (IBAction)okButton_tap:(id)sender
{
    [mainView buttonSound];
	[self.mainView removeWelcome];
}

@end
