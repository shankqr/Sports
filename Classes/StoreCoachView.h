//
//  StoreCoachView.h
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface StoreCoachView : UITableViewController <UIAlertViewDelegate>
{
	MainView *mainView;
	NSString *filter;
	NSMutableArray *coaches;
	NSString *sold_coach_id;
	NSString *sel_coach_id;
	NSString *sel_coach_value;
	NSString *sel_coach_star;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) NSString *sold_coach_id;
@property (nonatomic, strong) NSString *sel_coach_id;
@property (nonatomic, strong) NSString *sel_coach_value;
@property (nonatomic, strong) NSString *sel_coach_star;
- (void)updateView;
- (void)forceUpdate;
@end
