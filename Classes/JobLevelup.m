//
//  JobLevelup.m
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "JobLevelup.h"
#import "Globals.h"
#import "MainView.h"

@implementation JobLevelup
@synthesize mainView;
@synthesize moneyLabel;
@synthesize fansLabel;
@synthesize energyLabel;
@synthesize moneyText;
@synthesize fansText;
@synthesize energyText;

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewDidLoad
{

}

-(void)updateView
{
	moneyLabel.text = moneyText;
	fansLabel.text = fansText;
	energyLabel.text = energyText;
	
	[self.view setNeedsDisplay];
}

- (IBAction)ok_tap:(id)sender
{
	[self.view removeFromSuperview];
	
	
	
}

@end
