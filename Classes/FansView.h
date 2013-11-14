//
//  FansView.h
//  FFC
//
//  Created by Shankar Nathan on 5/27/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface FansView : UIViewController
{
	MainView *mainView;
	UILabel *membersLabel;
	UILabel *moodLabel;
	UILabel *expectationLabel;
	UILabel *sponsorLabel;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UILabel *membersLabel;
@property (nonatomic, strong) IBOutlet UILabel *moodLabel;
@property (nonatomic, strong) IBOutlet UILabel *expectationLabel;
@property (nonatomic, strong) IBOutlet UILabel *sponsorLabel;
- (IBAction)hireButton_tap:(id)sender;
- (IBAction)addfunds_tap:(id)sender;
- (void)updateView;
- (void)confirmPurchase;
@end
