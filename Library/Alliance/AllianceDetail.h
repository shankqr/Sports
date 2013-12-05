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
{
    NSArray *rows;
    AllianceObject *aAlliance;
    AllianceCreate *allianceCreate;
    AllianceEvents *allianceEvents;
    AllianceDonations *allianceDonations;
    AllianceApplicants *allianceApplicants;
    AllianceMembers *allianceMembers;
    AllianceCup *allianceCup0;
    AllianceCup *allianceCup1;
    AllianceCup *allianceCup2;
    BOOL isMyAlliance;
    BOOL isLeader;
}
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) AllianceObject *aAlliance;
@property (nonatomic, strong) AllianceCreate *allianceCreate;
@property (nonatomic, strong) AllianceEvents *allianceEvents;
@property (nonatomic, strong) AllianceDonations *allianceDonations;
@property (nonatomic, strong) AllianceApplicants *allianceApplicants;
@property (nonatomic, strong) AllianceMembers *allianceMembers;
@property (nonatomic, strong) AllianceCup *allianceCup0;
@property (nonatomic, strong) AllianceCup *allianceCup1;
@property (nonatomic, strong) AllianceCup *allianceCup2;
- (void)updateView;
- (void)scrollToTop;
@end
