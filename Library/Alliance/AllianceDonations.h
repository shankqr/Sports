//
//  AllianceDonations.h
//  Kingdom
//
//  Created by Shankar on 10/23/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@class AllianceObject;
@interface AllianceDonations : UITableViewController

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) AllianceObject *aAlliance;
@property (nonatomic, strong) NSString *selected_clubid;

- (void)updateView;

@end
