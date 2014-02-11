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
        
        //self.lblEnding.text = wsData[@"sale_row3"];
    }
}

- (IBAction)buy_tap:(id)sender
{
	[[Globals i] showBuy];
}

@end
