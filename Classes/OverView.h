//
//  OverView.h
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"
#import "MainView.h"
#import "OverviewCell.h"
#import "OverfirstCell.h"
#import "LeagueslideCell.h"

@interface OverView : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	MainView *mainView;
	UITableView *table;
    NSUInteger maxDivision;
	NSUInteger curDivision;
	NSUInteger curSeries;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property NSUInteger maxDivision;
@property NSUInteger curDivision;
@property NSUInteger curSeries;
- (void)updateView;
@end
