//
//  LeagueView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface LeagueView : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	UITableView *table;
	UILabel *divisionLabel;
	UILabel *seriesLabel;
	UILabel *maxseriesLabel;
	NSUInteger dialogDivision;
	NSUInteger dialogSeries;
	NSArray *leagues;
	NSString *selected_clubid;
	BOOL workingLeague;
}
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UILabel *divisionLabel;
@property (nonatomic, strong) IBOutlet UILabel *seriesLabel;
@property (nonatomic, strong) IBOutlet UILabel *maxseriesLabel;
@property (nonatomic, strong) NSArray *leagues;
@property (nonatomic, strong) NSString *selected_clubid;
@property NSUInteger dialogDivision;
@property NSUInteger dialogSeries;
- (void)updateView;
- (IBAction)homeButton_tap:(id)sender;
- (IBAction)divisionButton_tap:(id)sender;
@end

