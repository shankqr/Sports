//
//  JobsView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class JobComplete;
@class JobLevelup;
@interface JobsView : UIViewController  <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
	UITableView *table;
	NSMutableArray *jobs;
	UIImageView *bgImage;
    UILabel *unlockLabel;
    NSInteger offset;
    JobComplete *jobComplete;
	JobLevelup *jobLevelup;
}
@property (nonatomic, strong) NSMutableArray *jobs;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UIImageView *bgImage;
@property (nonatomic, strong) IBOutlet UILabel *unlockLabel;
@property (readwrite) NSInteger offset;
@property (nonatomic, strong) JobComplete *jobComplete;
@property (nonatomic, strong) JobLevelup *jobLevelup;
- (void)updateView;
- (IBAction)rookie_tap:(id)sender;
- (IBAction)amateur_tap:(id)sender;
- (IBAction)pro_tap:(id)sender;
@end
