//
//  JobsView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class JobComplete;

@interface JobsView : UIViewController  <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *jobs;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UIImageView *bgImage;
@property (nonatomic, strong) IBOutlet UILabel *unlockLabel;
@property (readwrite) NSInteger offset;
@property (nonatomic, strong) JobComplete *jobComplete;

- (void)updateView;
- (IBAction)rookie_tap:(id)sender;
- (IBAction)amateur_tap:(id)sender;
- (IBAction)pro_tap:(id)sender;

@end
