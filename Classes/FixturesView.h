//
//  FixturesView.h
//  FFC
//
//  Created by Shankar Nathan on 5/29/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface FixturesView : UITableViewController <UIActionSheetDelegate>
{
	NSArray *matches;
	NSUInteger curDivision;
	NSUInteger curSeries;
	NSString *selected_clubid;
	NSInteger totalRound;
	NSInteger curRound;
	BOOL workingLeagueFixtures;
}
@property (nonatomic, strong) NSArray *matches;
@property (nonatomic, strong) NSString *selected_clubid;
@property NSUInteger curDivision;
@property NSUInteger curSeries;
- (void)updateView;
- (void)getTotalRound;
@end
