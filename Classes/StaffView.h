//
//  StaffView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface StaffView : UITableViewController <UIAlertViewDelegate, UIActionSheetDelegate>
{
	MainView *mainView;
	NSArray *staff;
	NSString *iden;
    NSInteger hireCost;
}
@property (nonatomic, strong) NSArray *staff;
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSString *iden;
@property (readwrite) NSInteger hireCost;
- (void)updateView;
@end
