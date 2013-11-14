//
//  StadiumView.h
//  FFC
//
//  Created by Shankar Nathan on 5/26/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface StadiumView : UIViewController <UIAlertViewDelegate>
{
	MainView *mainView;
	UILabel *stadiumNameLabel;
	UILabel *capacityLabel;
	UILabel *ticketLabel;
	UILabel *levelLabel;
	UILabel *rentLabel;
	UILabel *upgradeDateLabel;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UILabel *stadiumNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *capacityLabel;
@property (nonatomic, strong) IBOutlet UILabel *ticketLabel;
@property (nonatomic, strong) IBOutlet UILabel *levelLabel;
@property (nonatomic, strong) IBOutlet UILabel *rentLabel;
@property (nonatomic, strong) IBOutlet UILabel *upgradeDateLabel;
- (IBAction)upgradeButton_tap:(id)sender;
- (IBAction)cancelButton_tap:(id)sender;
- (void)updateView;
@end
