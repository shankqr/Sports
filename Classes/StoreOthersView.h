//
//  StoreOthersView.h
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface StoreOthersView : UITableViewController <UIAlertViewDelegate>
{
	MainView *mainView;
	NSString *filter;
	NSMutableArray *products;
	NSString *sold_product_id;
	NSString *sel_product_id;
	NSString *sel_product_value;
    NSString *sel_product_real;
	NSString *sel_product_star;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) NSString *sold_product_id;
@property (nonatomic, strong) NSString *sel_product_id;
@property (nonatomic, strong) NSString *sel_product_value;
@property (nonatomic, strong) NSString *sel_product_real;
@property (nonatomic, strong) NSString *sel_product_star;
- (void)updateView;
@end
