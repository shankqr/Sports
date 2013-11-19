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

@interface AllianceDetail : UITableViewController
{
    NSArray *rows;
    AllianceObject *aAlliance;
    AllianceCreate *allianceCreate;
    AllianceEvents *allianceEvents;
    AllianceDonations *allianceDonations;
    AllianceApplicants *allianceApplicants;
    AllianceMembers *allianceMembers;
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
- (void)updateView;
- (void)scrollToTop;
@end
