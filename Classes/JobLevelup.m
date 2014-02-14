//
//  JobLevelup.m
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "JobLevelup.h"
#import "Globals.h"

@implementation JobLevelup

-(void)updateView
{
	self.moneyLabel.text = self.moneyText;
	self.fansLabel.text = self.fansText;
	self.energyLabel.text = self.energyText;
	
	[self.view setNeedsDisplay];
}

- (IBAction)ok_tap:(id)sender
{
    [[Globals i] updateClubData];
    
	[[Globals i] closeTemplate];
}

@end
