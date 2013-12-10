//
//  BuyView.m
//  Kingdom Game
//
//  Created by Shankar on 1/15/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

#import "BuyView.h"
#import "Globals.h"

@implementation BuyView
@synthesize rows;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateView];
}

- (void)updateView
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSDictionary *row0 = @{@"h1": @"Diamonds for Sale!"};
    NSDictionary *row1 = @{@"1": @"sc3", @"2": @"com.tapf", @"3": @"6145148", @"r1": @"Provides 60 Diamonds", @"r2": @"USD $4.99 (SALE 20% Extra Value!)", @"i1": @"icon_diamond1", @"i2": @"arrow_right"};
    NSDictionary *row2 = @{@"1": @"sc4", @"2": @"com.tapf", @"3": @"9425144", @"r1": @"Provides 150 Diamonds", @"r2": @"USD $9.99 (SALE 30% Extra Value!)", @"i1": @"icon_diamond1", @"i2": @"arrow_right"};
    NSDictionary *row3 = @{@"1": @"sc5", @"2": @"com.tapf", @"3": @"1736703", @"r1": @"Provides 275 Diamonds", @"r2": @"USD $19.99 (SALE 38% Extra Value!)", @"i1": @"icon_diamond1", @"i2": @"arrow_right"};
    NSDictionary *row4 = @{@"1": @"sc6", @"2": @"com.tapf", @"3": @"6597164", @"r1": @"Provides 800 Diamonds", @"r2": @"USD $49.99 (SALE 45% Extra Value!)", @"r3": @"(Most Popular!)", @"i1": @"icon_diamond1", @"i2": @"arrow_right"};
    NSDictionary *row5 = @{@"1": @"sc7", @"2": @"com.tapf", @"3": @"2792559", @"r1": @"Provides 1700 Diamonds", @"r2": @"USD $99.99 (SALE 58% Extra Value!)", @"r3": @"(Best Value!)", @"i1": @"icon_diamond1", @"i2": @"arrow_right"};
    
    self.rows = @[row0, row1, row2, row3, row4, row5];
    
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell;
    
    cell = [[Globals i] dynamicCell:self.tableView rowData:(self.rows)[indexPath.row] cellWidth:CELL_CONTENT_WIDTH];
    
	return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) //Not Header row
    {
        NSDictionary *rowData = (self.rows)[indexPath.row];
        
        [[Globals i] settPurchasedProduct:rowData[@"3"]];
        NSString *pi = [[Globals i] wsProductIdentifiers][rowData[@"1"]];
        
        [self buyProduct:pi];
        [[Globals i] showLoadingAlert];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[Globals i] dynamicCellHeight:(self.rows)[indexPath.row] cellWidth:CELL_CONTENT_WIDTH];
}

#pragma mark StoreKit Methods
- (void)buyProduct:(NSString *)product
{
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:product]];
	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSArray *products = response.products;
	NSArray *invalidproductIdentifiers = response.invalidProductIdentifiers;
	
	for(SKProduct *currentProduct in products)
	{
		NSLog(@"LocalizedDescription:%@", currentProduct.localizedDescription);
		NSLog(@"LocalizedTitle:%@",currentProduct.localizedTitle);
		
		//Numberformatter
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:currentProduct.priceLocale];
		NSString *formattedString = [numberFormatter stringFromNumber:currentProduct.price];
		NSLog(@"Price:%@",formattedString);
		NSLog(@"ProductIdentifier:%@",currentProduct.productIdentifier);
		
		SKPayment *payment = [SKPayment paymentWithProduct:currentProduct];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	//Are there errors for the request?
	for(NSString *invalidproductIdentifier in invalidproductIdentifiers)
	{
		NSLog(@"InvalidproductIdentifiers:%@",invalidproductIdentifier);
        [[Globals i] removeLoadingAlert];
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	NSLog(@"%@", [transaction.error localizedDescription]);
	NSLog(@"%@", [transaction.error localizedRecoverySuggestion]);
	NSLog(@"%@", [transaction.error localizedFailureReason]);
	
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
        [[Globals i] showDialogError];
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
	[[Globals i] removeLoadingAlert];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[[Globals i] removeLoadingAlert];
	[self doTransaction:transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[[Globals i] removeLoadingAlert];
	[self doTransaction:transaction];
}

- (void)doTransaction:(SKPaymentTransaction *)transaction;
{
    NSString *json = [[Globals i] encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
    NSString *wsurl = [NSString stringWithFormat:@"%@/ReportError/%@/%@/%@",
                       WS_URL, [[Globals i] gettPurchasedProduct], [[Globals i] UID], json];
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             if([[Globals i] updateClubData])
             {
                 [[Globals i] showDialog:@"Purchase Success! Thank you for supporting our Games."];
             }
             else
             {
                 //Update failed
                 [[Globals i] showDialog:@"Purchase Success! Please restart your device to take effect."];
             }
         }
     }];
}

@end
