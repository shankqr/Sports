//
//  AllianceDetail.h
//  Kingdom Game
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@class AllianceObject;
@class AllianceCreate;
@class AllianceEvents;
@class AllianceDonations;
@class AllianceApplicants;
@class AllianceMembers;
@class AllianceCup;

@interface AllianceDetail : UITableViewController

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSString *alliance_id;
@property (nonatomic, strong) AllianceObject *aAlliance;
@property (nonatomic, strong) AllianceCreate *allianceCreate;
@property (nonatomic, strong) AllianceEvents *allianceEvents;
@property (nonatomic, strong) AllianceDonations *allianceDonations;
@property (nonatomic, strong) AllianceApplicants *allianceApplicants;
@property (nonatomic, strong) AllianceMembers *allianceMembers;
@property (nonatomic, strong) AllianceCup *allianceCup0;
@property (nonatomic, strong) AllianceCup *allianceCup1;
@property (nonatomic, strong) AllianceCup *allianceCup2;

@property (nonatomic, assign) BOOL isMyAlliance;
@property (nonatomic, assign) BOOL isLeader;

- (void)updateView;
- (void)scrollToTop;

@end
