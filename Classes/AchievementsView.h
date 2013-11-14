//
//  AchievementsView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"
#import "MainView.h"
#import "AchievementsCell.h"
#import "DialogBoxView.h"

@interface AchievementsView : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSMutableArray *tasks;
    DialogBoxView *dialogBox;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic,strong) DialogBoxView *dialogBox;
- (void)updateView;
- (IBAction)cancelButton_tap:(id)sender;
-(void)createDialogBox;
-(void)removeDialogBox;
@end
