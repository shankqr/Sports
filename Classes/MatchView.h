//
//  Match.h
//  FFC
//
//  Created by Shankar on 4/2/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@class MatchLive;
@class ChallengeView;
@interface MatchView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSString *filter;
	NSArray *matches;
	NSString *selected_clubid;
	NSString *selected_matchid;
	MatchLive *matchLive;
	BOOL workingChallenged;
	ChallengeView *challengeBox;
    int selected_row;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) NSString *selected_matchid;
@property (nonatomic, strong) NSArray *matches;
@property (nonatomic, strong) MatchLive *matchLive;
@property (nonatomic, strong) ChallengeView *challengeBox;
- (void)updateView;
- (IBAction)segmentTap:(id)sender;
@end
