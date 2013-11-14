//
//  AllianceDetail.h
//  FFC
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//
#import "Globals.h"
#import "MainView.h"
#import "AllianceDetailCell.h"
#import "AllianceObject.h"
#import "DialogBoxView.h"

@class WallView;
@class EventsView;
@class DonationsView;
@class AllianceCup;
@class ApplyView;
@class MembersView;

@interface AllianceDetail : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,
UIAlertViewDelegate, DialogBoxDelegate>
{
    MainView *mainView;
	UITableView *table;
    DialogBoxView *dialogBox;
    AllianceObject *aAlliance;
    WallView *wallView;
    EventsView *eventsView;
    DonationsView *donationsView;
    AllianceCup *allianceCup;
    ApplyView *applyView;
    MembersView *membersView;
    NSInteger a_id;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) DialogBoxView *dialogBox;
@property (nonatomic, strong) AllianceObject *aAlliance;
@property (nonatomic, strong) WallView *wallView;
@property (nonatomic, strong) EventsView *eventsView;
@property (nonatomic, strong) DonationsView *donationsView;
@property (nonatomic, strong) AllianceCup *allianceCup;
@property (nonatomic, strong) ApplyView *applyView;
@property (nonatomic, strong) MembersView *membersView;
@property (readwrite) NSInteger a_id;
- (void)updateView;
- (void)drawView;
- (void)resignAlliance;
- (IBAction)cancelButton_tap:(id)sender;
- (void)createDialogBox;
- (void)removeDialogBox;
@end
