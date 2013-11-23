//
//  MatchReport.h
//  FFC
//
//  Created by Shankar on 7/13/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface MatchReport : UIViewController
{
	MainView *mainView;
	NSString *matchid;
	UIImageView *weatherImage;
	UILabel *headerLabel;
	UILabel *dateLabel;
	UITextView *matchReport;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSString *matchid;
@property (nonatomic, strong) IBOutlet UIImageView *weatherImage;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UITextView *matchReport;
- (void)updateView:(NSString*)MatchID;
- (void)redrawView;
- (void)endMatch;
@end
