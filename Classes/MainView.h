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
@class MatchReport;
@class WelcomeViewController;
@class AchievementsView;
@class AllianceView;
@class AllianceDetail;
@class MainCell;
@class SPViewController;
@class StorePlayerView;
@class StoreCoachView;
@class StoreOthersView;
@class JobRefill;
@class MailView;

@interface MainView : UIViewController 
<SKProductsRequestDelegate, SKPaymentTransactionObserver, UITabBarControllerDelegate,
UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
	Header *header;
	JobsView *jobsView;
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
	MatchReport *matchReport;
	WelcomeViewController *welcomeView;
	ChallengeView *challengeBox;
    ChallengeCreateView *challengeCreate;
    SPViewController *sparrowView;
    AchievementsView *achievementsView;
    AllianceView *allianceView;
    AllianceDetail *allianceDetail;
    MainCell *cell;
    StorePlayerView *storePlayer;
    StoreCoachView *storeCoach;
    StoreOthersView *storeOthers;
    JobRefill *jobRefill;
    MailView *mailView;
	UITabBarController *tacticsTabBarController;
	UITabBarController *leagueTabBarController;
	UITabBarController *clubTabBarController;
	UITabBarController *myclubTabBarController;
    UITableView *mainTableView;
    NSInteger currMatchIndex;
	NSTimer *marqueeTimer;
    NSMutableArray *marquee;
	UILabel *lblMarquee;
	CGFloat posxMarquee;
	NSInteger rowMarquee;
    NSInteger speedMarquee;
	CGSize textSizeMarquee;
    NSTimer *chatTimer;
    UILabel* lblChat1;
    BOOL isShowingLogin;
}
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) Header *header;
@property (nonatomic, strong) JobsView *jobsView;
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
@property (nonatomic, strong) MatchReport *matchReport;
@property (nonatomic, strong) WelcomeViewController *welcomeView;
@property (nonatomic, strong) ChallengeView *challengeBox;
@property (nonatomic, strong) ChallengeCreateView *challengeCreate;
@property (nonatomic, strong) AchievementsView *achievementsView;
@property (nonatomic, strong) AllianceView *allianceView;
@property (nonatomic, strong) AllianceDetail *allianceDetail;
@property (nonatomic, strong) NSTimer *marqueeTimer;
@property (nonatomic, strong) NSTimer *chatTimer;
@property (nonatomic, strong) NSMutableArray *marquee;
@property (nonatomic, strong) UILabel* lblMarquee;
@property (nonatomic, strong) UILabel* lblChat1;
@property (nonatomic, strong) MainCell *cell;
@property (nonatomic, strong) SPViewController *sparrowView;
@property (nonatomic, strong) StorePlayerView *storePlayer;
@property (nonatomic, strong) StoreCoachView *storeCoach;
@property (nonatomic, strong) StoreOthersView *storeOthers;
@property (nonatomic, strong) JobRefill *jobRefill;
@property (nonatomic, strong) MailView *mailView;
@property (nonatomic, strong) IBOutlet UITabBarController *tacticsTabBarController;
@property (nonatomic, strong) IBOutlet UITabBarController *leagueTabBarController;
@property (nonatomic, strong) IBOutlet UITabBarController *clubTabBarController;
@property (nonatomic, strong) IBOutlet UITabBarController *myclubTabBarController;
- (void)startUp;
- (void)reloadView;
- (void)buyProduct:(NSString *)product;
- (void)buyStadiumSuccess:(NSString *)virtualMoney :(NSString *)json;
- (void)buyStaffSuccess:(NSString *)virtualMoney :(NSString *)json;
- (void)renameClubPurchaseSuccess:(NSString *)virtualMoney :(NSString *)json;
- (void)buyCoachSuccess;
- (void)buyOthersSuccess;
- (void)buyOthersSuccessWithDiamonds;
- (void)showChallenge:(NSString *)club_id;
- (void)showClubViewer:(NSString *)club_id;
- (void)showPlayerStore;
- (void)showCoachStore;
- (void)showOthersStore;
- (void)showClub;
- (void)reportMatch;
- (void)updateHeader;
- (void)updateAchievementBadges;
- (void)updateChallenge;
- (void)declineChallenge;
- (void)startLiveMatch;
- (void)showJobRefill;
- (void)menuButton_tap:(int)sender;
@end
