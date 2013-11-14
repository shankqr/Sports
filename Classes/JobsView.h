//
//  JobsView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "JobsCell.h"
#import "MainView.h"
#import "Globals.h"
#import "Header.h"

@interface JobsView : UIViewController  <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	UITableView *table;
	NSMutableArray *jobs;
	UIImageView *bgImage;
    UILabel *unlockLabel;
    NSInteger offset;
}
@property (nonatomic, strong) NSMutableArray *jobs;
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UIImageView *bgImage;
@property (nonatomic, strong) IBOutlet UILabel *unlockLabel;
@property (readwrite) NSInteger offset;
- (void)updateView;
- (void)safeRow:(NSInteger)row :(NSInteger)percent;
- (void)buttonPressed:(id)sender;
- (IBAction)rookie_tap:(id)sender;
- (IBAction)amateur_tap:(id)sender;
- (IBAction)pro_tap:(id)sender;
@end
