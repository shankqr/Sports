//
//  TrophyViewer.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"
#import "TrophyCell.h"
#import "MainView.h"

@interface TrophyViewer : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSMutableArray *trophies;
	NSString *selected_trophy;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *trophies;
@property (nonatomic, strong) NSString *selected_trophy;
- (void)updateView;
- (IBAction)closeButton_tap:(id)sender;
@end
