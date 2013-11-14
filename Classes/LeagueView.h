//
//  LeagueView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "DialogBoxView.h"

@class MainView;
@class DialogBoxView;
@interface LeagueView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, DialogBoxDelegate>
{
	MainView *mainView;
	UITableView *table;
	UILabel *divisionLabel;
	UILabel *seriesLabel;
	UILabel *maxseriesLabel;
	NSString *filter;
	NSUInteger dialogDivision;
	NSUInteger dialogSeries;
	NSArray *leagues;
	NSString *selected_clubid;
	DialogBoxView *dialogBox;
	BOOL workingLeague;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UILabel *divisionLabel;
@property (nonatomic, strong) IBOutlet UILabel *seriesLabel;
@property (nonatomic, strong) IBOutlet UILabel *maxseriesLabel;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *leagues;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) DialogBoxView *dialogBox;
@property NSUInteger dialogDivision;
@property NSUInteger dialogSeries;
- (void)updateView;
- (IBAction)homeButton_tap:(id)sender;
- (IBAction)divisionButton_tap:(id)sender;
- (void)createDialogBox;
- (void)removeDialogBox;
@end

