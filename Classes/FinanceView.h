//
//  FinanceView.h
//  FFC
//
//  Created by Shankar Nathan on 5/27/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface FinanceView : UITableViewController
{
	NSArray *finance;
	NSArray *revenue;
	NSArray *expense;
}
@property (nonatomic, strong) NSArray *finance;
@property (nonatomic, strong) NSArray *revenue;
@property (nonatomic, strong) NSArray *expense;
- (void)updateView;
@end