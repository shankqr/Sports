//
//  NewsView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "NewsCell.h"
#import "Globals.h"
#import "MainView.h"

@interface NewsView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSString *filter;	
	NSArray *news;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *news;
- (void)updateView;
@end
