//
//  SquadView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class PlayerView;
@interface SquadView : UITableViewController <UIAlertViewDelegate>
{
	NSMutableArray *players;
	NSString *sold_player_id;
	NSString *sel_player_id;
	NSString *sel_player_name;
	NSString *sel_player_value;
    NSString *sel_player_halfvalue;
    PlayerView *playerView;
    NSInteger selectedRow;
}
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSString *sold_player_id;
@property (nonatomic, strong) NSString *sel_player_id;
@property (nonatomic, strong) NSString *sel_player_name;
@property (nonatomic, strong) NSString *sel_player_value;
@property (nonatomic, strong) NSString *sel_player_halfvalue;
@property (nonatomic, strong) PlayerView *playerView;
@property NSInteger selectedRow;
- (void)updateView;
- (void)forceUpdate;
- (void)normalUpdate;
@end
