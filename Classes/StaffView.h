//
//  StaffView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import "StaffCell.h"
#import "MainView.h"
#import "Globals.h"

@interface StaffView : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
	MainView *mainView;
	UITableView *table;
	UILabel *staffDesc;
	NSArray *staff;
	NSString *iden;
    NSInteger hireCost;
}
@property (nonatomic, strong) NSArray *staff;
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSString *iden;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UILabel *staffDesc;
@property (readwrite) NSInteger hireCost;
- (void)updateView;
- (void)confirmPurchase:(NSString*)staffType :(NSString*)Desc :(NSString*)Price;
- (void)purchaseStaff:(NSInteger)staffId;
@end
