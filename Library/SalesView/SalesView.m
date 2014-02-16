//
//  SalesView.m
//  Sports
//
//  Created by Shankar on 2/9/14.
//  Copyright (c) 2014 TAPFANTASY. All rights reserved.
//

#import "SalesView.h"
#import "Globals.h"

@implementation SalesView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateView];
}

- (void)updateView
{
    NSDictionary *wsData = [Globals i].wsSalesData;
	
    if (wsData != nil)
    {
        self.lblRow3.text = wsData[@"sale_row3"];
        self.lblRow4.text = wsData[@"sale_row4"];
        self.lblPrice.text = wsData[@"sale_price"];
        self.lblBundle1.text = wsData[@"bundle1_quantity"];
        self.lblBundle2.text = wsData[@"bundle2_quantity"];
        self.lblBundle3.text = wsData[@"bundle3_quantity"];
        self.lblBundle4.text = wsData[@"bundle4_quantity"];
        
        //Update time left in seconds for sale to end
        NSTimeInterval serverTimeInterval = [[Globals i] updateTime];
        NSString *strDate = wsData[@"sale_ending"];
        strDate = [NSString stringWithFormat:@"%@ -0000", strDate];
        NSDate *saleEndDate = [[[Globals i] getDateFormat] dateFromString:strDate];
        NSTimeInterval saleEndTime = [saleEndDate timeIntervalSince1970];
        self.b1s = saleEndTime - serverTimeInterval;
        
        if (!self.gameTimer.isValid)
        {
            self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        }
    }
}

- (void)onTimer
{
    self.b1s = self.b1s-1;
    
    NSString *labelString = [[Globals i] getCountdownString:self.b1s];
    self.lblEnding.text = labelString;
}

- (IBAction)buy_tap:(id)sender
{
    NSString *pi = [[Globals i] wsProductIdentifiers][[Globals i].wsSalesData[@"sale_identifier"]];
    
    [self buyProduct:pi];
}

#pragma mark StoreKit Methods
- (void)buyProduct:(NSString *)product
{
    [[Globals i] showLoadingAlert];
    
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:product]];
	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [[Globals i] showDialog:@"PROCESSING... Please wait a while."];
    
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
        [[Globals i] removeLoadingAlert];
		NSLog(@"InvalidproductIdentifiers:%@",invalidproductIdentifier);
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
	[self doTransaction:transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[self doTransaction:transaction];
}

- (void)doTransaction:(SKPaymentTransaction *)transaction;
{
    [[Globals i] removeLoadingAlert];
    
    NSString *json = [[Globals i] encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
    NSString *wsurl = [NSString stringWithFormat:@"%@/RegisterSale/%@/%@/%@",
                       WS_URL, [Globals i].wsSalesData[@"sale_id"], [[Globals i] UID], json];
    
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             if([[Globals i] updateClubData])
             {
                 [[Globals i] showDialog:@"Purchase Success! This deal has been credited to your account. Thank you for supporting our Games."];
             }
             else
             {
                 //Update failed
                 [[Globals i] showDialog:@"Purchase Success! Please restart your device to take effect."];
             }
             
             [[Globals i] closeTemplate];
         }
     }];
    
    NSString *tracking = [NSString stringWithFormat:@"RegisterSale %@",
                          [Globals i].wsSalesData[@"sale_id"]];
    
    [Apsalar event:tracking];
    [Flurry logEvent:tracking];
}

@end
