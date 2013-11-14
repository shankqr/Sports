//
//  SquadView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@class PlayerView;
@interface SquadView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	UITableView *table;
	UIToolbar *toolbar;
	NSMutableArray *players;
	NSString *sold_player_id;
	NSString *sel_player_id;
	NSString *sel_player_name;
	NSString *sel_player_value;
    NSString *sel_player_halfvalue;
	NSString *filter;
    PlayerView *playerView;
	NSInteger totalfilter;
    NSInteger selectedRow;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSString *sold_player_id;
@property (nonatomic, strong) NSString *sel_player_id;
@property (nonatomic, strong) NSString *sel_player_name;
@property (nonatomic, strong) NSString *sel_player_value;
@property (nonatomic, strong) NSString *sel_player_halfvalue;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) PlayerView *playerView;
@property NSInteger totalfilter;
@property NSInteger selectedRow;
- (void)updateView;
- (void)forceUpdate;
- (void)normalUpdate;
- (void)applyFilter;
@end
