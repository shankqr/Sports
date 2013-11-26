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
@interface MatchView : UITableViewController <UIActionSheetDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	NSString *filter;
	NSArray *matches;
	NSString *selected_clubid;
	NSString *selected_matchid;
	MatchLive *matchLive;
	BOOL workingChallenged;
	ChallengeView *challengeBox;
    NSInteger selected_row;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) NSString *selected_matchid;
@property (nonatomic, strong) NSArray *matches;
@property (nonatomic, strong) MatchLive *matchLive;
@property (nonatomic, strong) ChallengeView *challengeBox;
- (void)updateView;
@end
