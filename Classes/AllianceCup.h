//
//  AllianceCup.h
//  FFC
//
//  Created by Shankar Nathan on 5/29/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MainView.h"
#import "FixtureCell.h"
#import "Globals.h"

@interface AllianceCup : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSString *filter;
	NSArray *matches;
	NSString *selected_clubid;
	NSInteger curRound;
	NSInteger totalRound;
	BOOL workingCupFixtures;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *matches;
@property (nonatomic, strong) NSString *selected_clubid;
@property (readwrite) NSInteger curRound;
- (void)updateView;
- (IBAction)cancelButton_tap:(id)sender;
@end
