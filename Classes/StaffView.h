//
//  StaffView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface StaffView : UITableViewController <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *staff;
@property (nonatomic, strong) NSString *iden;
@property (readwrite) NSInteger hireCost;

- (void)updateView;

@end
