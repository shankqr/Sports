//
//  SquadSelectView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@protocol SquadSelectDelegate <NSObject>
@optional
- (void)playerSelected:(NSString *)player;
@end

@interface SquadSelectView : UITableViewController <UIAlertViewDelegate>
{
	id<SquadSelectDelegate> __weak delegate;
	NSMutableArray *players;
	NSString *sel_player_id;
	NSString *sel_player_name;
}
@property (weak) id<SquadSelectDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSString *sel_player_id;
@property (nonatomic, strong) NSString *sel_player_name;
- (void)updateView;
@end
