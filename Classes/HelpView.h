//
//  HelpView.h
//  FFC
//
//  Created by Shankar on 12/17/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MainView.h"
#import "Globals.h"

@interface HelpView : UIViewController <UIWebViewDelegate>
{
	MainView *mainView;
	UIWebView *webView;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
- (void)updateView;
- (void)closeHelp;
- (IBAction)cancelButton_tap:(id)sender;
@end
