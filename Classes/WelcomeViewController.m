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
@synthesize promptLabel;
@synthesize promptText;
@synthesize bonusImage;
@synthesize bonusLabel;

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

@end
