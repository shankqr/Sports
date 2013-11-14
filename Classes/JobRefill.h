//
//  JobRefill.h
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MainView.h"

@class MainView;

@interface JobRefill : UIViewController
{
	MainView *mainView;
	UILabel *titleLabel;
	UILabel *promptLabel;
	NSString *titleText;
	NSString *promptText;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *promptLabel;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *promptText;
- (void)updateView;
- (IBAction)ok_tap:(id)sender;
- (IBAction)close_tap:(id)sender;
@end
