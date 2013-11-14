//
//  AllianceView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"
#import "MainView.h"
#import "AllianceCell.h"
#import "AllianceObject.h"
#import "DialogBoxView.h"
#import "AllianceViewer.h"

@interface AllianceView : UIViewController
<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource,
UITableViewDelegate, DialogBoxDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSMutableArray *allianceArray;
    DialogBoxView *dialogBox;
    AllianceViewer *allianceViewer;
    NSString *selected_id;
    NSString *selected_name;
	NSMutableDictionary *allianceDictionary;
	NSMutableDictionary *nameIndexesDictionary;
	NSArray *nameIndexArray;
	NSMutableArray *allListContent;
	NSMutableArray *filteredListContent;
    NSString *savedSearchTerm;
    NSInteger savedScopeButtonIndex;
    BOOL searchWasActive;

}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *allianceArray;
@property (nonatomic, strong) DialogBoxView *dialogBox;
@property (nonatomic, strong) AllianceViewer *allianceViewer;
@property (nonatomic, strong) NSString *selected_id;
@property (nonatomic, strong) NSString *selected_name;
@property (nonatomic, strong) NSMutableDictionary *allianceDictionary;
@property (nonatomic, strong) NSMutableDictionary *nameIndexesDictionary;
@property (nonatomic, strong) NSArray *nameIndexArray;
@property (nonatomic, strong) NSMutableArray *allListContent;
@property (nonatomic, strong) NSMutableArray *filteredListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
- (void)updateView;
- (IBAction)createButton_tap:(id)sender;
- (IBAction)cancelButton_tap:(id)sender;
- (void)createDialogBox;
- (void)removeDialogBox;
@end
