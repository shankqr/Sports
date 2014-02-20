//
//  AllianceView.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class AllianceDetail;
@class AllianceCreate;
@interface AllianceView : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController1;
@property (nonatomic, strong) NSMutableArray *allianceArray;
@property (nonatomic, strong) AllianceDetail *allianceViewer;
@property (nonatomic, strong) AllianceCreate *allianceCreate;
@property (nonatomic, strong) NSString *selected_id;
@property (nonatomic, strong) NSString *selected_name;
@property (nonatomic, strong) NSString *updateOnWillAppear;
@property (nonatomic, strong) NSMutableDictionary *allianceDictionary;
@property (nonatomic, strong) NSMutableDictionary *nameIndexesDictionary;
@property (nonatomic, strong) NSArray *nameIndexArray;
@property (nonatomic, strong) NSMutableArray *allListContent;
@property (nonatomic, strong) NSMutableArray *filteredListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;

@property (nonatomic, assign) NSInteger savedScopeButtonIndex;
@property (nonatomic, assign) BOOL searchWasActive;

- (void)updateView;

@end
