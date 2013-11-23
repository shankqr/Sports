//
//  FinanceView.h
//  FFC
//
//  Created by Shankar Nathan on 5/27/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface FinanceView : UITableViewController <UIAlertViewDelegate>
{
	MainView *mainView;
	NSArray *finance;
	NSArray *revenue;
	NSArray *expense;
	NSString *alertTitle;
	NSString *alertMessage;
	NSInteger selectedRow;
    UITableView *table;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSArray *finance;
@property (nonatomic, strong) NSArray *revenue;
@property (nonatomic, strong) NSArray *expense;
@property (nonatomic, strong) NSString *alertTitle;
@property (nonatomic, strong) NSString *alertMessage;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property NSInteger selectedRow;
- (void)updateView;
- (IBAction)addfunds_tap:(id)sender;
@end
