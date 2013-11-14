//
//  StoreCoachView.h
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import "CoachCell.h"
#import "Globals.h"
#import "MainView.h"

@interface StoreCoachView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSString *filter;
	NSMutableArray *coaches;
	NSString *sold_coach_id;
	NSString *sel_coach_id;
	NSString *sel_coach_value;
	NSString *sel_coach_star;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) NSString *sold_coach_id;
@property (nonatomic, strong) NSString *sel_coach_id;
@property (nonatomic, strong) NSString *sel_coach_value;
@property (nonatomic, strong) NSString *sel_coach_star;
- (void)updateView;
- (void)forceUpdate;
- (void)getProductCoach;
@end
