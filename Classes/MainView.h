//
//  MainView.h
//  FFC
//
//  Created by Shankar on 6/3/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import <AVFoundation/AVFoundation.h>
#import <FacebookSDK/FacebookSDK.h>

@class ChallengeView;
@class ChallengeCreateView;
@class Header;
@class JobsView;
@class ClubView;
@class StadiumView;
@class UpgradeView;
@class StadiumMap;
@class FansView;
@class FinanceView;
@class StaffView;
@class MatchView;
@class FriendsView;
@class ClubMapView;
@class SquadView;
@class TrainingView;
@class NewsView;
@class MatchLive;
@class HelpView;
@class MatchReport;
@class WelcomeViewController;
@class AchievementsView;
@class AllianceView;
@class AllianceDetail;
@class MainCell;
@class SPViewController;

@interface MainView : UIViewController 
<SKProductsRequestDelegate, SKPaymentTransactionObserver, UITabBarControllerDelegate,
UIAlertViewDelegate, CLLocationManagerDelegate,AVAudioPlayerDelegate,
UITableViewDataSource, UITableViewDelegate, FBFriendPickerDelegate>
{
	UIButton *imageButton;
	UIButton *backButton;
	UIView *activeView;
	UIView *previousView;
	UIView *superView;
	Header *header;
	JobsView *jobsView;
	ClubView *clubView;
	StadiumView *stadiumView;
    UpgradeView *upgradeView;
    StadiumMap *stadiumMap;
	FansView *fansView;
	FinanceView *financeView;
	StaffView *staffView;
	MatchView *matchView;
	ClubMapView *clubMapView;
	SquadView *squadView;
	TrainingView *trainingView;
	NewsView *newsView;
	FriendsView *friendsView;
	MatchLive *matchLive;
	HelpView *helpView;
	MatchReport *matchReport;
	WelcomeViewController *welcomeView;
	ChallengeView *challengeBox;
    ChallengeCreateView *challengeCreate;
    SPViewController *sparrowView;
    AchievementsView *achievementsView;
    AllianceView *allianceView;
    AllianceDetail *allianceDetail;
    MainCell *cell;
	UITabBarController *storeTabBarController;
	UITabBarController *tacticsTabBarController;
	UITabBarController *cupTabBarController;
	UITabBarController *leagueTabBarController;
	UITabBarController *clubTabBarController;
	UITabBarController *myclubTabBarController;
	UITextField *tf;
	CGFloat posxView;
	NSTimer *animateViewTimer;
	NSTimer *marqueeTimer;
    NSTimer *chatTimer;
    UILabel* lblChat1;
    UILabel* lblChat2;
	NSMutableArray *marquee;
	UILabel *lblMarquee;
	CGFloat posxMarquee;
	NSInteger rowMarquee;
    NSInteger speedMarquee;
	CGSize textSizeMarquee;
    UIButton *loginButton;
    UITableView *mainTableView;
    NSInteger currMatchIndex;
    BOOL showedFooter;
	BOOL showedChallenge;
}
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) UIView *activeView;
@property (nonatomic, strong) UIView *previousView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) Header *header;
@property (nonatomic, strong) JobsView *jobsView;
@property (nonatomic, strong) ClubView *clubView;
@property (nonatomic, strong) StadiumView *stadiumView;
@property (nonatomic, strong) UpgradeView *upgradeView;
@property (nonatomic, strong) StadiumMap *stadiumMap;
@property (nonatomic, strong) FansView *fansView;
@property (nonatomic, strong) FinanceView *financeView;
@property (nonatomic, strong) StaffView *staffView;
@property (nonatomic, strong) MatchView *matchView;
@property (nonatomic, strong) ClubMapView *clubMapView;
@property (nonatomic, strong) SquadView *squadView;
@property (nonatomic, strong) TrainingView *trainingView;
@property (nonatomic, strong) NewsView *newsView;
@property (nonatomic, strong) FriendsView *friendsView;
@property (nonatomic, strong) MatchLive *matchLive;
@property (nonatomic, strong) HelpView *helpView;
@property (nonatomic, strong) MatchReport *matchReport;
@property (nonatomic, strong) WelcomeViewController *welcomeView;
@property (nonatomic, strong) ChallengeView *challengeBox;
@property (nonatomic, strong) ChallengeCreateView *challengeCreate;
@property (nonatomic, strong) AchievementsView *achievementsView;
@property (nonatomic, strong) AllianceView *allianceView;
@property (nonatomic, strong) AllianceDetail *allianceDetail;
@property (nonatomic, strong) NSTimer *animateViewTimer;
@property (nonatomic, strong) NSTimer *marqueeTimer;
@property (nonatomic, strong) NSTimer *chatTimer;
@property (nonatomic, strong) NSMutableArray *marquee;
@property (nonatomic, strong) UILabel* lblMarquee;
@property (nonatomic, strong) UILabel* lblChat1;
@property (nonatomic, strong) UILabel* lblChat2;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) MainCell *cell;
@property (nonatomic, strong) SPViewController *sparrowView;
@property (nonatomic, strong) IBOutlet UITabBarController *storeTabBarController;
@property (nonatomic, strong) IBOutlet UITabBarController *tacticsTabBarController;
@property (nonatomic, strong) IBOutlet UITabBarController *leagueTabBarController;
@property (nonatomic, strong) IBOutlet UITabBarController *clubTabBarController;
@property (nonatomic, strong) IBOutlet UITabBarController *myclubTabBarController;

- (void)buyProduct:(NSString *)product;
- (void)buyStadiumSuccess:(NSString *)virtualMoney :(NSString *)json;
- (void)buyStaffSuccess:(NSString *)virtualMoney :(NSString *)json;
- (void)renameClubPurchaseSuccess:(NSString *)virtualMoney :(NSString *)json;
- (void)buyCoachSuccess;
- (void)buyOthersSuccess;
- (void)buyOthersSuccessWithDiamonds;
- (void)jumpToChallenge:(NSString *)club_id;
- (void)jumpToClubViewer:(NSString *)club_id;
- (void)jumpToPlayerStore;
- (void)jumpToCoachStore;
- (void)jumpToOthersStore;
- (void)jumpToClub;
- (void)reportMatch;
- (void)removeClubViewer;
- (void)removeWelcome;
- (void)updateHeader;
- (void)hideHeader;
- (void)hideFooter;
- (void)showHeader;
- (void)showFooter;
- (void)showMarquee;
- (void)hideMarquee;
- (void)updateAchievementBadges;
- (void)updateChallenge;
- (void)DeclineChallenge;
- (void)startLiveMatch;
- (void)showStadiumUpgrade;
- (void)showBuildingUpgrade:(int)type;

- (void)menuButton_tap:(int)sender;
- (void)reloadView;
- (void)startUp;

@end
