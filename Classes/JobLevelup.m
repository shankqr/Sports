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


- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

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
    [mainView buttonSound];
	[self.view removeFromSuperview];
	
	[self.mainView showHeader];
	[self.mainView showFooter];
}

@end
