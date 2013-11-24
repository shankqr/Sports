//
//  ScorersView.h
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface ScorersView : UITableViewController <UIActionSheetDelegate>
{
	MainView *mainView;
	NSString *selected_clubid;
	NSMutableArray *players;
	NSUInteger curDivision;
	NSUInteger curSeries;
	BOOL workingLeagueScorers;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) NSMutableArray *players;
@property NSUInteger curDivision;
@property NSUInteger curSeries;
- (void)updateView;
@end
