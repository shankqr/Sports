//
//  JobComplete.m
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "JobComplete.h"
#import "Globals.h"

@implementation JobComplete
@synthesize mainView;
@synthesize titleLabel;
@synthesize promptLabel;
@synthesize titleText;
@synthesize promptText;


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
	titleLabel.text = titleText;
	promptLabel.text = promptText;
	
	[self.view setNeedsDisplay];
}

- (IBAction)ok_tap:(id)sender
{
    [mainView buttonSound];
	[self.view removeFromSuperview];
	[self.mainView showHeader];
	[self.mainView showFooter];
	[self.mainView updateHeader];
}

@end
