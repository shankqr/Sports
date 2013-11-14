//
//  Menu0.h
//  Mafia Tower
//
//  Created by Shankar on 1/15/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import "Menu0Cell.h"
#import "Globals.h"
#import "MainView.h"

@interface Menu0 : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    MainView *mainView;
	UITableView *table;
    UILabel *titleLabel;
    NSMutableArray *firstCurrency;
    NSMutableArray *secondCurrency;
    NSMutableArray *productTypes;
    BOOL currencyType;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *firstCurrency;
@property (nonatomic, strong) NSMutableArray *secondCurrency;
@property (nonatomic, strong) NSMutableArray *productTypes;
@property (readwrite) BOOL currencyType;
- (void)updateView;
- (IBAction)closeButton_tap:(id)sender;
- (void)buttonPressed:(id)sender;
@end
