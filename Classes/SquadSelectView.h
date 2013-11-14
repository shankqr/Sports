//
//  SquadSelectView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@protocol SquadSelectDelegate <NSObject>
@optional
- (void)playerSelected:(NSString *)player;
@end

@interface SquadSelectView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
	id<SquadSelectDelegate> __weak delegate;
	MainView *mainView;
	UITableView *table;
	NSMutableArray *players;
	NSString *filter;
	NSInteger totalfilter;
	NSString *sel_player_id;
	NSString *sel_player_name;
}
@property (weak) id<SquadSelectDelegate> delegate;
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSString *sel_player_id;
@property (nonatomic, strong) NSString *sel_player_name;
@property NSInteger totalfilter;
- (void)updateView;
- (IBAction)cancelButton_tap:(id)sender;
@end
