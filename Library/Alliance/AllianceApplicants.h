//
//  AllianceApplicants.h
//  Kingdom
//
//  Created by Shankar on 10/23/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@class AllianceObject;

@interface AllianceApplicants : UITableViewController <UIAlertViewDelegate>
{
	NSArray *rows;
    AllianceObject *aAlliance;
    NSString *selected_clubid;
    NSString *selected_aid;
    NSString *selected_clubname;
}
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) AllianceObject *aAlliance;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) NSString *selected_aid;
@property (nonatomic, strong) NSString *selected_clubname;
- (void)updateView;
@end
