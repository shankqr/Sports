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
    [[Globals i] settPurchasedProduct:@"1000"];
    
    NSString *pi = [[Globals i] wsProductIdentifiers][[Globals i].wsSalesData[@"sale_identifier"]];
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:pi forKey:@"pi"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchase"
                                                        object:self
                                                      userInfo:userInfo];
}

@end
