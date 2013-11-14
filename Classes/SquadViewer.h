//
//  SquadViewer.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"
#import "MainView.h"

@interface SquadViewer : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	UITableView *table;
	UIToolbar *toolbar;
	NSMutableArray	*players;
	NSString *selected_clubid;
	NSString *sold_player_id;
	NSString *sel_player_id;
	NSString *sel_player_name;
	NSString *sel_player_value;
	NSString *filter;
	NSInteger totalfilter;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) NSString *sold_player_id;
@property (nonatomic, strong) NSString *sel_player_id;
@property (nonatomic, strong) NSString *sel_player_name;
@property (nonatomic, strong) NSString *sel_player_value;
@property (nonatomic, strong) NSString *filter;
@property NSInteger totalfilter;
- (IBAction)closeButton_tap:(id)sender;
- (void)updateView;
@end
