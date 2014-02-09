//
//  MainView.h
//  FFC
//
//  Created by Shankar on 6/3/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>

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
@class ClubView;
@class TrophyViewer;
@class ClubViewer;
@class MapViewer;
@class SquadViewer;
@class OverView;
@class FixturesView;
@class LeagueView;
@class PromotionView;
@class ScorersView;
@class FormationView;
@class SubsView;
@class TacticsView;
@class ChatView;
@class RankingView;
@class SearchView;
@class SlotsView;

@interface MainView : UIViewController 
<SKProductsRequestDelegate, SKPaymentTransactionObserver, UITabBarControllerDelegate,
UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Header *header;
@property (nonatomic, strong) JobsView *jobsView;
@property (nonatomic, strong) StadiumMap *stadiumMap;
@property (nonatomic, strong) FansView *fansView;
@property (nonatomic, strong) FinanceView *financeView;
@property (nonatomic, strong) StaffView *staffView;
@property (nonatomic, strong) MatchView *matchView;
@property (nonatomic, strong) MatchView *matchPlayedView;
@property (nonatomic, strong) MatchView *matchChallengeView;
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
@property (nonatomic, strong) MainCell *cell;
@property (nonatomic, strong) SPViewController *sparrowView;
@property (nonatomic, strong) StorePlayerView *storePlayer;
@property (nonatomic, strong) StoreCoachView *storeCoach;
@property (nonatomic, strong) StoreOthersView *fundStore;
@property (nonatomic, strong) StoreOthersView *emblemStore;
@property (nonatomic, strong) StoreOthersView *homeStore;
@property (nonatomic, strong) StoreOthersView *awayStore;
@property (nonatomic, strong) JobRefill *jobRefill;
@property (nonatomic, strong) MailView *mailView;
@property (nonatomic, strong) ClubView *clubView;
@property (nonatomic, strong) TrophyViewer *trophyViewer;
@property (nonatomic, strong) ClubViewer *clubViewer;
@property (nonatomic, strong) MapViewer *mapViewer;
@property (nonatomic, strong) LeagueView *leagueView;
@property (nonatomic, strong) PromotionView *promotionView;
@property (nonatomic, strong) ScorersView *scorersView;
@property (nonatomic, strong) FormationView *formationView;
@property (nonatomic, strong) SubsView *subsView;
@property (nonatomic, strong) TacticsView *tacticsView;
@property (nonatomic, strong) SquadViewer *squadViewer;
@property (nonatomic, strong) OverView *overView;
@property (nonatomic, strong) FixturesView *fixturesView;
@property (nonatomic, strong) ChatView *chatView;
@property (nonatomic, strong) ChatView *allianceChatView;
@property (nonatomic, strong) RankingView *rvTopDivision;
@property (nonatomic, strong) RankingView *rvTopLevel;
@property (nonatomic, strong) SearchView *svClubs;
@property (nonatomic, strong) SlotsView *slotsView;
@property (nonatomic, strong) NSTimer *marqueeTimer;
@property (nonatomic, strong) NSTimer *chatTimer;
@property (nonatomic, strong) NSMutableArray *marquee;
@property (nonatomic, strong) UILabel* lblMarquee;
@property (nonatomic, strong) UILabel* lblChat1;
@property (nonatomic, strong) UITabBarController *tacticsTabBarController;
@property (nonatomic, strong) UITabBarController *leagueTabBarController;
@property (nonatomic, strong) UITabBarController *clubTabBarController;
@property (nonatomic, strong) UITabBarController *myclubTabBarController;
@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, assign) NSInteger rowMarquee;
@property (nonatomic, assign) NSInteger speedMarquee;
@property (nonatomic, assign) NSInteger currMatchIndex;
@property (nonatomic, assign) CGFloat posxMarquee;
@property (nonatomic, assign) CGSize textSizeMarquee;
@property (nonatomic, assign) BOOL isShowingLogin;

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
- (void)updateMailBadges;
- (void)updateChallenge;
- (void)declineChallenge;
- (void)startLiveMatch;
- (void)showJobRefill;
- (void)showFundStore;
- (void)showEmblemStore;
- (void)showHomeStore;
- (void)showAwayStore;
- (void)menuButton_tap:(NSInteger)sender;

@end
