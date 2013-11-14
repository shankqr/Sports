//
//  JobLevelup.h
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface JobLevelup : UIViewController
{
	MainView *mainView;
	UILabel *moneyLabel;
	UILabel *fansLabel;
	UILabel *energyLabel;
	NSString *moneyText;
	NSString *fansText;
	NSString *energyText;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel *fansLabel;
@property (nonatomic, strong) IBOutlet UILabel *energyLabel;
@property (nonatomic, strong) NSString *moneyText;
@property (nonatomic, strong) NSString *fansText;
@property (nonatomic, strong) NSString *energyText;
- (void)updateView;
- (IBAction)ok_tap:(id)sender;
@end
