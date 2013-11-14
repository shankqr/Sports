//
//  TrainingView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "CoachCell.h"
#import "Globals.h"
#import "MainView.h"

@interface TrainingView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSMutableArray *coaches;
	UIImageView *trainingImage;
	UILabel *trainingType;
	UILabel *teamspirit;
	UIImageView *pbteamspirit;
	UILabel *confidence;
	UIImageView *pbconfidence;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) IBOutlet UIImageView *trainingImage;
@property (nonatomic, strong) IBOutlet UILabel *trainingType;
@property (nonatomic, strong) IBOutlet UILabel *teamspirit;
@property (nonatomic, strong) IBOutlet UIImageView *pbteamspirit;
@property (nonatomic, strong) IBOutlet UILabel *confidence;
@property (nonatomic, strong) IBOutlet UIImageView *pbconfidence;
- (void)updateView;
- (IBAction)coachButton_tap:(id)sender;
- (IBAction)trainingButton_tap:(id)sender;
@end