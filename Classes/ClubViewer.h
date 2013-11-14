//
//  ClubViewer.h
//  FFC
//
//  Created by Shankar on 7/13/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface ClubViewer : UIViewController 
{
	MainView *mainView;
	NSString* clubid;
	NSString* fb_name;
	NSString* fb_url;
	UIImageView *logoImage;
	UIImageView *homeImage;
	UIImageView *awayImage;
	UILabel *foundedLabel;
	UILabel *clubNameLabel;
	UILabel *stadiumLabel;
	UILabel *fansLabel;
	UILabel *financeLabel;
	UILabel *sponsorLabel;
	UILabel *levelLabel;
	UILabel *divisionLabel;
	UILabel *seriesLabel;
	UILabel *positionLabel;
	UILabel *coachLabel;
	NSString *logo_url;
	NSString *home_url;
	NSString *away_url;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSString* clubid;
@property (nonatomic, strong) NSString* fb_name;
@property (nonatomic, strong) NSString* fb_url;
@property (nonatomic, strong) IBOutlet UIImageView *logoImage;
@property (nonatomic, strong) IBOutlet UIImageView *homeImage;
@property (nonatomic, strong) IBOutlet UIImageView *awayImage;
@property (nonatomic, strong) IBOutlet UILabel *foundedLabel;
@property (nonatomic, strong) IBOutlet UILabel *clubNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *stadiumLabel;
@property (nonatomic, strong) IBOutlet UILabel *fansLabel;
@property (nonatomic, strong) IBOutlet UILabel *financeLabel;
@property (nonatomic, strong) IBOutlet UILabel *sponsorLabel;
@property (nonatomic, strong) IBOutlet UILabel *levelLabel;
@property (nonatomic, strong) IBOutlet UILabel *divisionLabel;
@property (nonatomic, strong) IBOutlet UILabel *seriesLabel;
@property (nonatomic, strong) IBOutlet UILabel *positionLabel;
@property (nonatomic, strong) IBOutlet UILabel *coachLabel;
@property (nonatomic, strong) NSString *logo_url;
@property (nonatomic, strong) NSString *home_url;
@property (nonatomic, strong) NSString *away_url;
- (void)updateView;
- (void)updateViewId:(NSString*)ClubID;
- (void)updateViewFb:(NSString*)fb_id;
- (void)getClubInfoData;
- (void)drawView;
- (void)loadLogo;
- (void)loadHome;
- (void)loadAway;
- (IBAction)closeButton_tap:(id)sender;
@end
