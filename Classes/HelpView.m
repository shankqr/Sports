//
//  HelpView.m
//  FFC
//
//  Created by Shankar on 12/17/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "HelpView.h"
#import "MainView.h"
#import "Globals.h"

@implementation HelpView
@synthesize mainView;
@synthesize webView;

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)viewDidLoad 
{
	[self updateView];
}

- (void)updateView
{
    [webView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height)];
    
	webView.delegate = self;
	NSString *urlAddress = [[NSString alloc] initWithFormat:@"%@_files/help.html", WS_URL];
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
	//[[Globals i] removeLoadingAlert];
}

- (void)closeHelp
{
	[mainView showHeader];
	[mainView showFooter];
	[mainView showMarquee];
	[mainView updateHeader];
	[self.view removeFromSuperview];
}

- (IBAction)cancelButton_tap:(id)sender
{
	[self closeHelp];
}

@end
