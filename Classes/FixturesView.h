//
//  FixturesView.h
//  FFC
//
//  Created by Shankar Nathan on 5/29/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "FixtureCell.h"
#import "Globals.h"
#import "MainView.h"

@interface FixturesView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSString *filter;
	NSArray *matches;
	NSUInteger curDivision;
	NSUInteger curSeries;
	NSString *selected_clubid;
	NSInteger totalRound;
	NSInteger curRound;
	BOOL workingLeagueFixtures;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *matches;
@property (nonatomic, strong) NSString *selected_clubid;
@property NSUInteger curDivision;
@property NSUInteger curSeries;
- (void)updateView;
- (void)getTotalRound;
@end
