//
//  SquadViewer.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface SquadViewer : UITableViewController
{
	NSMutableArray	*players;
	NSString *selected_clubid;
	NSString *sold_player_id;
	NSString *sel_player_id;
	NSString *sel_player_name;
	NSString *sel_player_value;
}
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) NSString *sold_player_id;
@property (nonatomic, strong) NSString *sel_player_id;
@property (nonatomic, strong) NSString *sel_player_name;
@property (nonatomic, strong) NSString *sel_player_value;
- (void)updateView;
- (void)clearView;
@end
