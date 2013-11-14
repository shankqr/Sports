//
//  StorePlayerView.h
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@class BidView;
@interface StorePlayerView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSString *filter;
	NSMutableArray *players;
	NSString *sold_player_id;
	NSString *sel_player_id;
	NSString *sel_player_value;
	NSString *sel_player_star;
	BOOL workingPlayerSale;
    BidView *bidView;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSString *sold_player_id;
@property (nonatomic, strong) NSString *sel_player_id;
@property (nonatomic, strong) NSString *sel_player_value;
@property (nonatomic, strong) NSString *sel_player_star;
@property (nonatomic, strong) BidView *bidView;
- (void)updateView;
- (void)getProductPlayer;
@end
