//
//  JobRefill.m
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//
#import "JobRefill.h"
#import "Globals.h"

@implementation JobRefill
@synthesize titleLabel;
@synthesize promptLabel;
@synthesize titleText;
@synthesize promptText;

- (void)updateView
{
	titleLabel.text = titleText;
	promptLabel.text = promptText;
	
	[self.view setNeedsDisplay];
}

- (IBAction)ok_tap:(id)sender
{
    [[Globals i] settPurchasedProduct:@"14"];
    
    NSString *pi = [[Globals i] getProductIdentifiers][@"refill"];
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:pi forKey:@"pi"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchase"
                                                        object:self
                                                      userInfo:userInfo];
}

@end
