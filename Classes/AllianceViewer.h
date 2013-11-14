//
//  AllianceViewer.h
//  FFC
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//
#import "Globals.h"
#import "MainView.h"
#import "AllianceViewerCell.h"
#import "AllianceObject.h"
#import "DialogBoxView.h"

@interface AllianceViewer : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    MainView *mainView;
	UITableView *table;
    DialogBoxView *dialogBox;
    AllianceObject *aAlliance;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) DialogBoxView *dialogBox;
@property (nonatomic, strong) AllianceObject *aAlliance;
- (void)updateView;
- (IBAction)joinButton_tap:(id)sender;
- (IBAction)cancelButton_tap:(id)sender;
- (void)createDialogBox;
- (void)removeDialogBox;
@end
