//
//  BuyView.h
//  Kingdom Game
//
//  Created by Shankar on 1/15/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>

@interface BuyView : UITableViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSArray *rows;
}
@property (nonatomic, strong) NSArray *rows;
- (void)updateView;
@end
