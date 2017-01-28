//
//  MainView.m
//  FFC
//
//  Created by Shankar on 6/3/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MainView.h"
#import "Globals.h"
#import "BuyView.h"
#import "Header.h"
#import "JobsView.h"
#import "ClubView.h"
#import "TrophyViewer.h"
#import "StadiumMap.h"
#import "FansView.h"
#import "FinanceView.h"
#import "StaffView.h"
#import "MatchView.h"
#import "ClubMapView.h"
#import "SquadView.h"
#import "FormationView.h"
#import "SubsView.h"
#import "TacticsView.h"
#import "TrainingView.h"
#import "LeagueView.h"
#import "ScorersView.h"
#import "OverView.h"
#import "PromotionView.h"
#import "FixturesView.h"
#import "StorePlayerView.h"
#import "StoreCoachView.h"
#import "StoreOthersView.h"
#import "ChallengeView.h"
#import "ChallengeCreateView.h"
#import "ClubViewer.h"
#import "SquadViewer.h"
#import "MapViewer.h"
#import "MatchReport.h"
#import "AchievementsView.h"
#import "MainCell.h"
#import "AllianceView.h"
#import "AllianceDetail.h"
#import "JobRefill.h"
#import "RankingView.h"
#import "EventsView.h"
#import "SearchView.h"
#import "SlotsView.h"
#import "SalesView.h"
#import "JobLevelup.h"
#import "MailCompose.h"
#import "HelpshiftCore.h"
#import "HelpshiftSupport.h"

//Sparrow shit (comment out for baseball & basketball)
#import <Sparrow/Sparrow.h>
#import "Game.h"
//#import "Game_hockey.h"

@interface MainView () <SKProductsRequestDelegate, SKPaymentTransactionObserver, UITabBarControllerDelegate,
UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate>
@end

@implementation MainView

- (void)startUp //Called when app opens for the first time
{
    self.isShowingLogin = NO;
    
    self.title = @"MainView";
    [Globals i].mainView = self;
    [UIManager.i pushViewControllerStack:self];
    [Globals i].selectedClubId = @"0";
	[Globals i].workingUrl = @"0";
	[Globals i].challengeMatchId = @"0";
    
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"GotoLogin"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"GotoRanking"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"GotoAlliance"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"GotoClub"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"GotoRefillEnergy"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHeader"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ExitLiveMatch"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateBadges"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"BuyFunds"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"MatchReport"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ViewProfile"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ViewAlliance"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ViewSales"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateXP"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"InAppPurchase"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"GotoBuy"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"MailCompose"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"EventSolo"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"EventAlliance"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ChatWorld"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ChatAlliance"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TabWorld Chat"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TabAlliance Chat"
                                               object:nil];
    
    [[Globals i] saveLocation]; //causes reload again if NO is selected to share location
    
    [[Globals i] initSound];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    UIImage *imgBkg = [UIImage imageNamed:@"skin_menu.png"];
    [backgroundImage setImage:imgBkg];
    [self.view insertSubview:backgroundImage atIndex:0];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height-Header_height) style:UITableViewStylePlain];
    [self.mainTableView setBackgroundColor:[UIColor clearColor]];
    self.mainTableView.backgroundView = nil;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view insertSubview:self.mainTableView atIndex:1];
    [self.mainTableView reloadData];
    
    [self reloadView];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"GotoLogin"])
    {
        [self gotoLogin:NO];
    }
    
    if ([[notification name] isEqualToString:@"GotoRanking"])
    {
        [self showRanking];
    }
    
    if ([[notification name] isEqualToString:@"GotoAlliance"])
    {
        [self showCup];
    }
    
    if ([[notification name] isEqualToString:@"GotoClub"])
    {
        [self showClub];
    }
    
    if ([[notification name] isEqualToString:@"GotoRefillEnergy"])
    {
        [self showJobRefill];
    }
    
    if ([[notification name] isEqualToString:@"UpdateHeader"])
    {
        [self.header updateView];
    }
    
    if ([[notification name] isEqualToString:@"UpdateBadges"])
    {
        [self updateAchievementBadges];
        [self updateMailBadges];
    }
    
    if ([[notification name] isEqualToString:@"BuyFunds"])
    {
        [self showFundStore];
    }
    
    if ([[notification name] isEqualToString:@"GotoBuy"])
    {
        [self showBuy];
    }
    
    if ([[notification name] isEqualToString:@"MatchReport"])
    {
        [self reportMatch];
    }
    
    if ([[notification name] isEqualToString:@"ExitLiveMatch"])
    {
        [self removeLiveMatch];
    }
    
    if ([[notification name] isEqualToString:@"ViewProfile"])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSString *cid = [userInfo objectForKey:@"club_id"];
        
        [self showClubViewer:cid];
    }
    
    if ([[notification name] isEqualToString:@"ViewAlliance"])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSString *aid = [userInfo objectForKey:@"alliance_id"];
        
        if (self.allianceDetail == nil)
        {
            self.allianceDetail = [[AllianceDetail alloc] initWithStyle:UITableViewStylePlain];
        }
        self.allianceDetail.aAlliance = nil;
        self.allianceDetail.alliance_id = aid;
        [self.allianceDetail updateView];
        self.allianceDetail.title = @"Alliance";
        [UIManager.i showTemplate:@[self.allianceDetail] :@"Alliance" :10];
    }
    
    if ([[notification name] isEqualToString:@"ViewSales"])
    {
        [self showSalesLoading];
    }
    
    if ([[notification name] isEqualToString:@"EventSolo"])
    {
        [self showEventSolo];
    }
    
    if ([[notification name] isEqualToString:@"EventAlliance"])
    {
        [self showEventAlliance];
    }
    
    if ([[notification name] isEqualToString:@"UpdateXP"])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSNumber *xp_gain = [userInfo objectForKey:@"xp_gain"];
        
        NSInteger xp_max = [[Globals i] getXpMax];
        
        // + XP to clubData
        [Globals i].wsClubDict[@"xp"] = [NSString stringWithFormat:@"%ld", (long)[[Globals i] getXp]+[xp_gain integerValue]];
        [Globals i].wsClubDict[@"xp_gain"] = [NSString stringWithFormat:@"%ld", (long)[[Globals i].wsClubDict[@"xp_gain"] integerValue]+[xp_gain integerValue]];
        
        NSInteger xp = [[Globals i] getXp];
        
        if(xp >= xp_max)
        {
            [self showLevelUp];
            
            [[Globals i] showToast:@"Congratulations. You Leveled UP and received all the rewards!"
                     optionalTitle:nil
                     optionalImage:@"tick_yes"];
            
            [[Globals i] winSound];
        }
    }
    
    if ([[notification name] isEqualToString:@"InAppPurchase"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *pi = [userInfo objectForKey:@"pi"];
        
        [self buyProduct:pi];
    }
    
    if ([[notification name] isEqualToString:@"MailCompose"])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSString *isAlli = [userInfo objectForKey:@"is_alli"];
        NSString *toID = [userInfo objectForKey:@"to_id"];
        NSString *toName = [userInfo objectForKey:@"to_name"];
        
        [self mailCompose:isAlli toID:toID toName:toName];
    }
    
    if ([[notification name] isEqualToString:@"ChatWorld"])
    {
        self.lblChatWorld1.text = [[Globals i] getFirstChatString];
        self.lblChatWorld2.text = [[Globals i] getSecondChatString];
        
        void (^animationLabel) (void) = ^{
            self.lblChatWorld2.alpha = 0;
        };
        void (^completionLabel) (BOOL) = ^(BOOL f) {
            self.lblChatWorld2.alpha = 1;
        };
        
        NSUInteger opts =  UIViewAnimationOptionAutoreverse;
        
        [UIView animateWithDuration:0.5f delay:0 options:opts
                         animations:animationLabel completion:completionLabel];
    }
    
    if ([[notification name] isEqualToString:@"ChatAlliance"])
    {
        self.lblChatAlliance1.text = [[Globals i] getFirstAllianceChatString];
        self.lblChatAlliance2.text = [[Globals i] getSecondAllianceChatString];
        
        void (^animationLabel) (void) = ^{
            self.lblChatAlliance2.alpha = 0;
        };
        void (^completionLabel) (BOOL) = ^(BOOL f) {
            self.lblChatAlliance2.alpha = 1;
        };
        
        NSUInteger opts =  UIViewAnimationOptionAutoreverse;
        
        [UIView animateWithDuration:0.5f delay:0 options:opts
                         animations:animationLabel completion:completionLabel];
    }
    
    if ([[notification name] isEqualToString:@"TabWorld Chat"])
    {
        self.svChat.contentOffset = CGPointMake(0,0);
    }
    
    if ([[notification name] isEqualToString:@"TabAlliance Chat"])
    {
        self.svChat.contentOffset = CGPointMake(UIScreen.mainScreen.bounds.size.width,0);
    }
}

- (void)reloadView //Called after login and when app becomes active from background
{
    [self gotoLogin:YES];
}

- (void)gotoLogin:(BOOL)autoLogin //Open the Login View
{
    if (!autoLogin)
    {
        [[Globals i] setUID:@""];
    }

    if (!self.isShowingLogin)
    {
        self.isShowingLogin = YES;
        
        [[Globals i] showLogin:^(NSInteger status)
         {
             if(status == 1) //Login Success
             {
                 self.isShowingLogin = NO;
                 [self loadAllData];
             }
         }];
    }
}

- (void)loadAllData
{
    [UIManager.i closeAllTemplate];
    
    [[Globals i] showLoading];
    
    [[Globals i] getServerClubData:^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{ //Update UI on main thread
         if (success)
         {
             NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
             
             [userInfo setObject:@"Updating Identifiers" forKey:@"status"];
             [userInfo setObject:[NSNumber numberWithFloat:0.1f] forKey:@"percent"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateProductIdentifiers]; //This comes first before display dialog if need to upgrade app
             
             [userInfo setObject:@"Updating Marquee" forKey:@"status"];
             [userInfo setObject:[NSNumber numberWithFloat:0.2f] forKey:@"percent"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateMarqueeData];
             
             [userInfo setObject:@"Updating Current Season" forKey:@"status"];
             [userInfo setObject:[NSNumber numberWithFloat:0.3f] forKey:@"percent"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateCurrentSeasonData]; //For slides
             
             [userInfo setObject:@"Updating Fixtures" forKey:@"status"];
             [userInfo setObject:[NSNumber numberWithFloat:0.4f] forKey:@"percent"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateMatchData];
             
             [userInfo setObject:@"Updating Match History" forKey:@"status"];
             [userInfo setObject:[NSNumber numberWithFloat:0.5f] forKey:@"percent"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateMatchPlayedData];
             
             [userInfo setObject:@"Updating Challenges" forKey:@"status"];
             [userInfo setObject:[NSNumber numberWithFloat:0.6f] forKey:@"percent"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateChallengesData];
             
             [userInfo setObject:@"Updating Products" forKey:@"status"];
             [userInfo setObject:[NSNumber numberWithFloat:0.7f] forKey:@"percent"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateProducts];//Pre-load products
             
             [userInfo setObject:@"Updating Tasks" forKey:@"status"];
             [userInfo setObject:[NSNumber numberWithFloat:0.8f] forKey:@"percent"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateMyAchievementsData];
             [self updateAchievementBadges]; //Show badges
             
             [userInfo setObject:@"Updating Tournaments" forKey:@"status"];
             [userInfo setObject:[NSNumber numberWithFloat:0.9f] forKey:@"percent"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             
             [self.cell updateEventSoloButton];
             
             [self.cell updateEventAllianceButton];
             
             [userInfo setObject:@"Finalizing (may take a while)" forKey:@"status"];
             [userInfo setObject:[NSNumber numberWithFloat:1.0f] forKey:@"percent"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             
             if (self.header == nil)
             {
                 self.header = [[Header alloc] initWithNibName:@"Header" bundle:nil];
                 [self.view addSubview:self.header.view];
             }
             [[Globals i] retrieveEnergy];
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateHeader"
              object:self]; //Update to header
             
             [self createMarquee];
             
             [self createChat];
             
             [self showChallengeBox];
             
             [self showMail];
             
             //Show sales if available
             [self showSales];
             
             [[Globals i] checkVersion];
             
             [[Globals i] removeLoading];
         }
         else
         {
             [[Globals i] removeLoading];
             
             [self gotoLogin:NO];
             
             [[Globals i] showDialogError];
         }
         });
     }];
}

- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *alertMsg;
    
    if( userInfo[@"aps"][@"alert"] != nil)
    {
        alertMsg = userInfo[@"aps"][@"alert"];
        [UIManager.i showDialog:alertMsg];
    }
    
    [NSThread detachNewThreadSelector:@selector(reloadNotification) toTarget:self withObject:nil];
}

- (void)reloadNotification
{
	@autoreleasepool {
        
        if([[Globals i] updateClubData]) //After challenge accepted maybe balance and xp + or -
        {
            [self updateMatchViews];
            
            [self performSelectorOnMainThread:@selector(showChallengeBox)
                                   withObject:nil
                                waitUntilDone:YES];
        }
    }
}

- (void)updateMatchViews
{
    [[Globals i] updateMatchPlayedData];
    if (self.matchPlayedView != nil)
    {
        [self.matchPlayedView updateView];
    }
    
    [[Globals i] updateChallengesData];
    if (self.matchChallengeView != nil)
    {
        [self.matchChallengeView updateView];
    }
}

- (void)mailCompose:(NSString *)isAlli toID:(NSString *)toid toName:(NSString *)toname
{
    if (self.mailCompose == nil)
    {
        self.mailCompose = [[MailCompose alloc] initWithStyle:UITableViewStylePlain];
    }
    self.mailCompose.title = @"Message";
    self.mailCompose.isAlliance = isAlli;
    self.mailCompose.toID = toid;
    self.mailCompose.toName = toname;
    
    [UIManager.i showTemplate:@[self.mailCompose] :@"Message" :10];
    [self.mailCompose updateView];
}

- (void)showBuy
{
    if (self.buyView == nil)
    {
        self.buyView = [[BuyView alloc] initWithStyle:UITableViewStylePlain];
        self.buyView.title = @"Buy Diamonds 1";
        [self.buyView updateView];
    }
    
    [UIManager.i showTemplate:@[self.buyView] :@"Buy Diamonds" :10];
}

- (void)showClub
{
    if (self.clubView == nil)
    {
        self.clubView = [[ClubView alloc] initWithNibName:@"ClubView" bundle:nil];
        self.clubView.title = @"My Club";
        self.clubView.tabBarItem.image = [UIImage imageNamed:@"tab_house"];
    }
    
    if (self.trophyViewer == nil)
    {
        self.trophyViewer = [[TrophyViewer alloc] initWithStyle:UITableViewStylePlain];
        self.trophyViewer.title = @"Trophies";
        self.trophyViewer.tabBarItem.image = [UIImage imageNamed:@"tab_trophy"];
    }
    self.trophyViewer.selected_trophy = [[Globals i] wsClubDict][@"club_id"];
    
    if (self.myclubTabBarController == nil)
    {
        self.myclubTabBarController = [[UITabBarController alloc] init];
        self.myclubTabBarController.delegate = self;
    }
    
    self.myclubTabBarController.viewControllers = @[self.clubView, self.trophyViewer];
    [self.myclubTabBarController setSelectedIndex:0];
    [UIManager.i showTemplate:@[self.myclubTabBarController] :@"Club Details" :10];
    [self.clubView updateView];
}

- (void)resetClubImages
{
    [self.clubView resetImages];
}

- (void)showClubViewer:(NSString *)club_id
{
    if (self.trophyViewer == nil)
    {
        self.trophyViewer = [[TrophyViewer alloc] initWithStyle:UITableViewStylePlain];
        self.trophyViewer.title = @"Trophies";
        self.trophyViewer.tabBarItem.image = [UIImage imageNamed:@"tab_trophy"];
    }
    self.trophyViewer.selected_trophy = club_id;
    
    if (self.clubViewer == nil)
    {
        self.clubViewer = [[ClubViewer alloc] initWithNibName:@"ClubViewer" bundle:nil];
        self.clubViewer.title = @"Club";
        self.clubViewer.tabBarItem.image = [UIImage imageNamed:@"tab_house"];
    }
    
    if (self.mapViewer == nil)
    {
        self.mapViewer = [[MapViewer alloc] initWithNibName:@"MapViewer" bundle:nil];
        self.mapViewer.title = @"Map";
        self.mapViewer.tabBarItem.image = [UIImage imageNamed:@"tab_map"];
    }
    
    if (self.squadViewer == nil)
    {
        self.squadViewer = [[SquadViewer alloc] initWithStyle:UITableViewStylePlain];
        self.squadViewer.title = @"Squad";
        self.squadViewer.tabBarItem.image = [UIImage imageNamed:@"tab_squad"];
    }
    
    if (self.clubTabBarController == nil)
    {
        self.clubTabBarController = [[UITabBarController alloc] init];
        self.clubTabBarController.delegate = self;
    }
    
    self.clubTabBarController.viewControllers = @[self.clubViewer, self.mapViewer, self.squadViewer, self.trophyViewer];
    [self.clubTabBarController setSelectedIndex:0];
    [UIManager.i showTemplate:@[self.clubTabBarController] :@"Club Details" :10];
    [self.clubViewer updateViewId:club_id];
}

- (void)showLeague
{
    if (self.overView == nil)
    {
        self.overView = [[OverView alloc] initWithStyle:UITableViewStylePlain];
        self.overView.title = @"Overview";
        self.overView.tabBarItem.image = [UIImage imageNamed:@"tab_info"];
    }
    
    if (self.leagueView == nil)
    {
        self.leagueView = [[LeagueView alloc] initWithNibName:@"LeagueView" bundle:nil];
        self.leagueView.title = @"Table";
        self.leagueView.tabBarItem.image = [UIImage imageNamed:@"tab_leaderboard"];
    }
    
    if (self.fixturesView == nil)
    {
        self.fixturesView = [[FixturesView alloc] initWithStyle:UITableViewStylePlain];
        self.fixturesView.title = @"Fixtures";
        self.fixturesView.tabBarItem.image = [UIImage imageNamed:@"tab_calendar"];
    }
    
    if (self.promotionView == nil)
    {
        self.promotionView = [[PromotionView alloc] initWithNibName:@"PromotionView" bundle:nil];
        self.promotionView.title = @"Promotion";
        self.promotionView.tabBarItem.image = [UIImage imageNamed:@"tab_promotion"];
    }
    
    if (self.scorersView == nil)
    {
        self.scorersView = [[ScorersView alloc] initWithStyle:UITableViewStylePlain];
        self.scorersView.title = @"Scorers";
        self.scorersView.tabBarItem.image = [UIImage imageNamed:@"tab_man"];
    }
    
    if (self.leagueTabBarController == nil)
    {
        self.leagueTabBarController = [[UITabBarController alloc] init];
        self.leagueTabBarController.delegate = self;
    }
    
    self.leagueTabBarController.viewControllers = @[self.overView, self.leagueView, self.fixturesView, self.promotionView, self.scorersView];
    [self.leagueTabBarController setSelectedIndex:0];
    [UIManager.i showTemplate:@[self.leagueTabBarController] :@"League" :10];
    [self.overView updateView];
}

- (void)showTactics
{
    if (self.formationView == nil)
    {
        self.formationView = [[FormationView alloc] initWithNibName:@"FormationView" bundle:nil];
        self.formationView.title = @"Formations";
        self.formationView.tabBarItem.image = [UIImage imageNamed:@"tab_squad"];
    }
    
    if (self.subsView == nil)
    {
        self.subsView = [[SubsView alloc] initWithNibName:@"SubsView" bundle:nil];
        self.subsView.title = @"Substitute";
        self.subsView.tabBarItem.image = [UIImage imageNamed:@"tab_id"];
    }
    
    if (self.tacticsView == nil)
    {
        self.tacticsView = [[TacticsView alloc] initWithNibName:@"TacticsView" bundle:nil];
        self.tacticsView.title = @"Tactics";
        self.tacticsView.tabBarItem.image = [UIImage imageNamed:@"tab_tactics"];
    }
    
    if (self.tacticsTabBarController == nil)
    {
        self.tacticsTabBarController = [[UITabBarController alloc] init];
        self.tacticsTabBarController.delegate = self;
    }
    
    self.tacticsTabBarController.viewControllers = @[self.formationView, self.subsView, self.tacticsView];
    [self.tacticsTabBarController setSelectedIndex:0];
    [UIManager.i showTemplate:@[self.tacticsTabBarController] :@"Formations" :10];
    [self.formationView updateView];
}

- (void)clearAllClubView
{
    [self.clubView clearView];
    [self.trophyViewer clearView];
    [self.clubViewer clearView];
    [self.squadViewer updateView];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	//MyClub
	if([viewController.tabBarItem.title isEqualToString:@"My Club"])
	{
        [self clearAllClubView];
		[self.clubView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Trophies"])
	{
        [self clearAllClubView];
		[self.trophyViewer updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Club"])
	{
        [self clearAllClubView];
		[self.clubViewer updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Map"])
	{
        [self clearAllClubView];
		[self.mapViewer updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Squad"])
	{
        [self clearAllClubView];
		[self.squadViewer updateView];
	}
    
	//Tactics
	else if([viewController.tabBarItem.title isEqualToString:@"Formations"])
	{
		[self.formationView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Substitute"])
	{
		[self.subsView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Tactics"])
	{
		[self.tacticsView updateView];
	}
    
	//League
    else if([viewController.tabBarItem.title isEqualToString:@"Overview"])
	{
		[self.overView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Table"])
	{
		[self.leagueView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Fixtures"])
	{
		[self.fixturesView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Promotion"])
	{
		[self.promotionView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Scorers"])
	{
		[self.scorersView updateView];
	}
}

- (void)updateHeader
{
	[self.header updateView];
}

#pragma mark StoreKit Methods
- (void)buyProduct:(NSString *)product
{
    [[Globals i] showLoadingAlert];
	
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:product]];
	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSArray *products = response.products;
	NSArray *invalidproductIdentifiers = response.invalidProductIdentifiers;
	
	for(SKProduct *currentProduct in products)
	{
		NSLog(@"LocalizedDescription:%@", currentProduct.localizedDescription);
		NSLog(@"LocalizedTitle:%@",currentProduct.localizedTitle);
		
		//Numberformatter
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:currentProduct.priceLocale];
		NSString *formattedString = [numberFormatter stringFromNumber:currentProduct.price];
		NSLog(@"Price:%@",formattedString);
		NSLog(@"ProductIdentifier:%@",currentProduct.productIdentifier);
		
		SKPayment *payment = [SKPayment paymentWithProduct:currentProduct];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	//Are there errors for the request?
	for(NSString *invalidproductIdentifier in invalidproductIdentifiers)
	{
        [[Globals i] removeLoadingAlert];
		NSLog(@"InvalidproductIdentifiers:%@",invalidproductIdentifier);
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	NSLog(@"%@", [transaction.error localizedDescription]);
	NSLog(@"%@", [transaction.error localizedRecoverySuggestion]);
	NSLog(@"%@", [transaction.error localizedFailureReason]);
	
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
        [UIManager.i showDialog:@"Please try again now."];
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
    [[Globals i] removeLoadingAlert];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[self doTransaction:transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[self doTransaction:transaction];
}

- (void)doTransaction:(SKPaymentTransaction *)transaction;
{
    [[Globals i] removeLoadingAlert];
    
    
    NSString *json = @"0";
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[receiptUrl path]])
    {
        NSData *receipt = [NSData dataWithContentsOfURL:receiptUrl];
        json = [receipt base64EncodedStringWithOptions:0];
    }

    
    //NSString *json = [[Globals i] encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [[Globals i] gettPurchasedProduct],
                          @"error_id",
                          [Globals i].UID,
                          @"uid",
                          json,
                          @"json",
                          nil];
    
    NSString *service_name = @"PostReportError";
    [Globals postServerLoading:dict :service_name :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{// IMPORTANT - Only update the UI on the main thread
             
             if (success)
             {
                 NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 if ([returnValue isEqualToString:@"1"]) //Receipt Success
                 {
                     if ([[Globals i] updateClubData]) //After buying effect
                     {
                         [UIManager.i showDialog:@"Purchase Success! Thank you for supporting our Games!"];
                     }
                     else
                     {
                         //Update failed
                         [UIManager.i showDialog:@"Purchase Success! Please restart device to take effect."];
                     }
                 }
                 
             }
         });
     }];
    
	if ([[[Globals i] gettPurchasedProduct] integerValue] < 9)
	{
        if ([[[Globals i] gettPurchasedProduct] integerValue] != 0)
        {
            [self buyStaffSuccess:@"0":json];
        }
	}
	else if ([[[Globals i] gettPurchasedProduct] integerValue] == 9)
	{
		[self buyStadiumSuccess:@"0":json];
	}
	else if ([[[Globals i] gettPurchasedProduct] integerValue] == 10)
	{
		[self renameClubPurchaseSuccess:@"0":json];
	}
	else if ([[[Globals i] gettPurchasedProduct] integerValue] == 13)
	{
		[self buyResetClub];
	}
	else if ([[[Globals i] gettPurchasedProduct] integerValue] == 14)
	{
        [self refillEnergySuccess:@"0":json];
	}
    else if ([[[Globals i] gettPurchasedProduct] integerValue] == 1000) //Sale!
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [Globals i].wsSalesData[@"sale_id"],
                              @"error_id",
                              [Globals i].UID,
                              @"uid",
                              json,
                              @"json",
                              nil];
        
        NSString *service_name = @"PostRegisterSale";
        [Globals postServerLoading:dict :service_name :^(BOOL success, NSData *data)
         {
             dispatch_async(dispatch_get_main_queue(), ^{// IMPORTANT - Only update the UI on the main thread
                 
                 if (success)
                 {
                     NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     if ([returnValue isEqualToString:@"1"]) //Receipt Success
                     {
                         if ([[Globals i] updateClubData]) //After buying effect
                         {
                             [UIManager.i closeAllTemplate];
                             [UIManager.i showDialog:@"Purchase Success! Thank you for supporting our Games!"];
                         }
                         else
                         {
                             //Update failed
                             [UIManager.i showDialog:@"Purchase Success! Please restart device to take effect."];
                         }
                     }
                     
                 }
             });
         }];
    }
}

- (void)refillEnergySuccess:(NSString *)virtualMoney :(NSString *)json
{
	[[Globals i] buyProduct:@"14":virtualMoney:json];
    [self.header refillEnergy];
}

- (void)buyStadiumSuccess:(NSString *)virtualMoney :(NSString *)json
{
	[[Globals i] buyProduct:@"9":virtualMoney:json];
    
    [UIManager.i showDialog:@"You have upgraded your stadium. +5 XP"];
    
    NSNumber *xp = [NSNumber numberWithInteger:5];
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:xp forKey:@"xp_gain"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateXP"
                                                        object:self
                                                      userInfo:userInfo];
    
    [[Globals i] showToast:@"+5 XP for upgrading Stadium!"
             optionalTitle:nil
             optionalImage:@"tick_yes"];
	
	[[Globals i] updateClubData]; //Stadium data updated
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateStadium"
                                                        object:self
                                                      userInfo:nil];
	
	NSString *message = @"I have just upgraded my arena. Come over and play a match with me.";
	NSString *extra_desc = @"A big portion of club revenue comes from ticket sales of matches played at your stadium. Upgrade your stadium to increase seating capacity and average ticket price per match. ";
	NSString *imagename = @"upgrade_stadium.png";
	[[Globals i] fbPublishStory:message :extra_desc :imagename];
}

- (void)buyStaffSuccess:(NSString *)virtualMoney :(NSString *)json
{
	NSString *productId = [[Globals i] gettPurchasedProduct];
	[[Globals i] buyProduct:productId:virtualMoney:json];
    
    [UIManager.i showDialog:@"You have just hired a staff. +5 XP"];
    
    NSNumber *xp = [NSNumber numberWithInteger:5];
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:xp forKey:@"xp_gain"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateXP"
                                                        object:self
                                                      userInfo:userInfo];
    
    [[Globals i] showToast:@"+5 XP for hiring a staff!"
             optionalTitle:nil
             optionalImage:@"tick_yes"];
	
	[[Globals i] updateClubData]; //Staff data updated
    
	[self.staffView updateView];
	
	NSString *message = @"I have just hired more staff for my club. Come over and play a match with me.";
	NSString *extra_desc = @"You can hire managers, scouts, assistant coaches, accountant1, spokesperson1, psychologist1, physiotherapist1, doctor1. ";
	NSString *imagename = @"hire_staff.png";
	[[Globals i] fbPublishStory:message:extra_desc:imagename];
}

- (void)renameClubPurchaseSuccess:(NSString *)virtualMoney :(NSString *)json
{
	[[Globals i] buyProduct:@"10":virtualMoney:json];
    
    [self renameDialog];
}

- (void)renameDialog
{
    [UIManager.i showDialogBlock:@"Please enter a name for your Club"
                                :6
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //OK button is clicked
         {
             NSString *returnValue = @"0";
             
             NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/Rename/%@/%@",
                                WS_URL, [[Globals i] UID], text];
             NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             NSURL *url = [[NSURL alloc] initWithString:wsurl2];
             returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
             
             if([returnValue isEqualToString:@"1"])
             {
                 [[Globals i] updateClubData]; //club_name changed and money or diamonds deducted
                 [UIManager.i showDialog:@"Your club name has been changed successfully."];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc]
                                       initWithTitle:@"Invalid Input"
                                       message:@"Sorry, name already exist or not valid."
                                       delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
                 [alert show];
                 
                 [self renameDialog];
             }
         }
     }];
}

- (void)buyCoachSuccess
{
	[[Globals i] buyCoach:[Globals i].purchasedCoachId];
	
	[[Globals i] updateClubData]; //coach_id updated

	[self.storeCoach forceUpdate];
    
    [self.trainingView updateView];
	
	NSString *message = @"I have just signed up a new Coach.";
	NSString *extra_desc = @"Keep an eye on the job board for new coaches. A good coach improves the training of your team significantly. ";
	NSString *imagename = @"new_coach.png";
	[[Globals i] fbPublishStory:message:extra_desc:imagename];
}

- (void)buyResetClub
{
	[[Globals i] resetClub];
	[[Globals i] updateClubData]; //Club have been reseted
    
    [UIManager.i showDialog:@"Your club has been reset successfully."];
	
	NSString *message = @"I have just reset my club!";
	NSString *extra_desc = @"You can reset your club if you want to start again from scratch. ";
	NSString *imagename = @"rename_club.png";
	[[Globals i] fbPublishStory:message:extra_desc:imagename];
}

- (void)buyOthersSuccess
{
	NSString *productId = [[Globals i] gettPurchasedProduct];
	[[Globals i] buyProduct:productId:@"1":@"0"];
    
    [UIManager.i showDialog:@"Purchase and upgrades for your club is completed."];
	
	[[Globals i] updateClubData]; //Something has been updated
	[self resetClubImages];
}

- (void)buyOthersSuccessWithDiamonds
{
	NSString *productId = [[Globals i] gettPurchasedProduct];
	[[Globals i] buyProduct:productId:@"2":@"0"];
    
    [UIManager.i showDialog:@"Purchase and upgrades for your club is completed."];
	
	[[Globals i] updateClubData]; //Something has been updated
	[self resetClubImages];
}

- (void)updateChallenge
{
    [[Globals i] updateChallengesData];
    [self.matchView updateView];
}

- (void)declineChallenge
{
	[NSThread detachNewThreadSelector: @selector(declineChallengeServer) toTarget:self withObject:nil];
}

- (void)declineChallengeServer
{
	@autoreleasepool {
	
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/DeclineChallenge/%@/%@",
						   WS_URL, [Globals i].challengeMatchId, [[Globals i] UID]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		NSString *returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		if([returnValue isEqualToString:@"1"])
		{
			//Delete success
		}
	
	}
}

- (void)startLiveMatch
{
	[[Globals i] showLoadingAlert];
	[NSThread detachNewThreadSelector: @selector(liveMatchServer) toTarget:self withObject:nil];
}

- (void)liveMatchServer
{
	@autoreleasepool {
	
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AcceptChallenge/%@/%@", 
						   WS_URL, [Globals i].challengeMatchId, [[Globals i] UID]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		NSString *returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		if([returnValue isEqualToString:@"1"])
		{
			//UPDATE match list
			[self updateMatchViews];
			
			//Get match results
			[[Globals i] updateMatchInfoData:[Globals i].challengeMatchId];
			
			[self performSelectorOnMainThread:@selector(liveMatch)
								   withObject:nil
								waitUntilDone:NO];
		}
		else 
		{
			returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
			if([returnValue isEqualToString:@"1"])
			{
				//UPDATE match list
				[self updateMatchViews];
				
				//Get match results
				[[Globals i] updateMatchInfoData:[Globals i].challengeMatchId];
				
				[self performSelectorOnMainThread:@selector(liveMatch)
									   withObject:nil
									waitUntilDone:NO];
			}
			else 
			{
                [[Globals i] removeLoadingAlert];
                
                [UIManager.i showDialog:@"Club is playing a match now, try accept again."];
			}
		}
	}
}

- (void)liveMatch
{
    [[Globals i] updateMatchHighlightsData:[Globals i].challengeMatchId];
    
    //(comment out for baseball & basketball)
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        [SPAudioEngine start];
        self.sparrowView = [[SPViewController alloc] init];
        self.sparrowView.multitouchEnabled = YES;
        [self.sparrowView startWithRoot:[Game class] supportHighResolutions:YES doubleOnPad:NO];
        
        [UIManager.i showTemplate:@[self.sparrowView] :@"Live Match" :2];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        /*
        [SPAudioEngine start];
        self.sparrowView = [[SPViewController alloc] init];
        self.sparrowView.multitouchEnabled = YES;
        [self.sparrowView startWithRoot:[Game_hockey class] supportHighResolutions:YES doubleOnPad:NO];
        
        [UIManager.i showTemplate:@[self.sparrowView] :@"Live Match" :2];
        */
    }
    else
    {
        [self showMatchReport];
    }
    
    [[Globals i] removeLoadingAlert];
}

- (void)removeLiveMatch
{
    //(comment out for baseball & basketball)
    if (self.sparrowView != nil)
    {
        [self.sparrowView.view removeFromSuperview];
        
        [UIManager.i closeTemplate];
        
        [self showMatchReport];
    }
}

- (void)reportMatch
{
    [self showMatchReport];
    
    [self.matchReport updateView:[Globals i].challengeMatchId];
    [self.matchReport redrawView];
}

- (void)showMatchReport
{
    if (self.matchReport == nil)
    {
        self.matchReport = [[MatchReport alloc] initWithNibName:@"MatchReport" bundle:nil];
    }
    [UIManager.i showTemplate:@[self.matchReport] :@"Match Report" :10];
    [self.matchReport redrawView];
}

- (void)checkAccepted
{
    NSMutableArray *acceptedMatch = [[NSMutableArray alloc] init];
    NSInteger highestMatchID = 0;
    
    if([[[Globals i] getMatchPlayedData] count] > 0)
	{
		for(NSDictionary *rowData in [[Globals i] getMatchPlayedData])
		{
			if([rowData[@"match_type_id"] isEqualToString:@"3"])
			{
                if([rowData[@"club_home"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
                {
                    if ([rowData[@"match_id"] integerValue] > [[[Globals i] gettAccepted] integerValue])
                    {
                        [acceptedMatch addObject:rowData];
                        
                        if ([rowData[@"match_id"] integerValue] > highestMatchID)
                        {
                            highestMatchID = [rowData[@"match_id"] integerValue];
                        }
                        
                    }
                }
			}
		}
        
        if (highestMatchID > 0)
        {
            [[Globals i] settAccepted:[NSString stringWithFormat:@"%ld", (long)highestMatchID]];
            
            self.currMatchIndex = 0;
            
            [self confirmViewMatch:acceptedMatch];
        }
    }
}

- (void)confirmViewMatch:(NSMutableArray *)a
{
    [UIManager.i showDialogBlock:[NSString stringWithFormat:@"%@ has accepted your Challenge. View the match report?", a[self.currMatchIndex][@"club_away_name"]]
                                :2
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //YES
         {
             [Globals i].challengeMatchId = a[self.currMatchIndex][@"match_id"];
             [self reportMatch];
         }
         
         if (index == 2) //NO
         {
             self.currMatchIndex = self.currMatchIndex + 1;
             if([a count] > self.currMatchIndex)
             {
                 [self confirmViewMatch:a];
             }
         }
     }];
}

- (void)showLevelUp
{
    if (self.jobLevelup == nil)
    {
        self.jobLevelup = [[JobLevelup alloc] initWithNibName:@"JobLevelup" bundle:nil];
    }
    
	self.jobLevelup.moneyText = [[NSString alloc] initWithFormat:@"+$%ld", (long)[[Globals i] getLevel]*1000];
	self.jobLevelup.fansText = [[NSString alloc] initWithFormat:@"+%ld", (long)[[Globals i] getLevel]*10];
	self.jobLevelup.energyText = [[NSString alloc] initWithFormat:@"+%d", 5];
    
    [UIManager.i showTemplate:@[self.jobLevelup] :@"Level Up" :0];
	[self.jobLevelup updateView];
}

- (void)showSales
{
    if ([[Globals i] updateSalesData])
    {
        if (self.salesView == nil)
        {
            self.salesView = [[SalesView alloc] initWithNibName:@"SalesView" bundle:nil];
        }
        [UIManager.i showTemplate:@[self.salesView] :@"Promotion" :0];
        [self.salesView updateView];
        
        [self.cell updateSalesButton];
        //[self.mainTableView reloadData];
    }
}

- (void)showSalesLoading
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetSales", WS_URL];
    [Globals getServerLoading:wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             dispatch_async(dispatch_get_main_queue(), ^{ //Update UI on main thread
                 NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];

                 if (returnArray != nil)
                 {
                     if ([returnArray count] > 0)
                     {
                         [Globals i].wsSalesData = returnArray[0];
                     
                         if (self.salesView == nil)
                         {
                             self.salesView = [[SalesView alloc] initWithNibName:@"SalesView" bundle:nil];
                         }
                         [UIManager.i showTemplate:@[self.salesView] :@"Promotion" :0];
                         [self.salesView updateView];
                 
                         [self.cell updateSalesButton];
                         [self.mainTableView reloadData];
                     }
                 }
             });
         }
     }];
}

- (void)showJobRefill
{
    if (self.jobRefill == nil)
    {
        self.jobRefill = [[JobRefill alloc] initWithNibName:@"JobRefill" bundle:nil];
        self.jobRefill.titleText = @"REFILL ENERGY?";
    }
    [UIManager.i showTemplate:@[self.jobRefill] :@"Energy Refill" :10];
	[self.jobRefill updateView];
}

- (void)showStaff
{
    if (self.staffView == nil)
    {
        self.staffView = [[StaffView alloc] initWithStyle:UITableViewStylePlain];
    }
    [UIManager.i showTemplate:@[self.staffView] :@"Staff" :10];
    [self.staffView updateView];
}

- (void)showCoach
{
    if (self.trainingView == nil)
    {
        self.trainingView = [[TrainingView alloc] initWithNibName:@"TrainingView" bundle:nil];
    }
    [UIManager.i showTemplate:@[self.trainingView] :@"Coach" :10];
    [self.trainingView updateView];
}

- (void)showMap
{
    if (self.clubMapView == nil)
    {
        self.clubMapView = [[ClubMapView alloc] init];
    }
    [UIManager.i showTemplate:@[self.clubMapView] :@"Map" :10];
    [self.clubMapView updateView];
}

- (void)showSquad
{
    if (self.squadView == nil)
    {
        self.squadView = [[SquadView alloc] initWithStyle:UITableViewStylePlain];
    }
    [UIManager.i showTemplate:@[self.squadView] :@"Squad" :10];
    [self.squadView updateView];
}

- (void)showMatch
{
    if (self.matchView == nil)
    {
        self.matchView = [[MatchView alloc] initWithStyle:UITableViewStylePlain];
        self.matchView.title = @"Future";
        self.matchView.filter = @"Future";
    }
    
    if (self.matchPlayedView == nil)
    {
        self.matchPlayedView = [[MatchView alloc] initWithStyle:UITableViewStylePlain];
        self.matchPlayedView.title = @"Played";
        self.matchPlayedView.filter = @"Played";
    }
    
    if (self.matchChallengeView == nil)
    {
        self.matchChallengeView = [[MatchView alloc] initWithStyle:UITableViewStylePlain];
        self.matchChallengeView.title = @"Challenge";
        self.matchChallengeView.filter = @"Challenge";
    }
    
    [UIManager.i showTemplate:@[self.matchView, self.matchPlayedView, self.matchChallengeView] :@"Fixtures" :10];
    [self.matchView updateView];
    [self.matchPlayedView updateView];
    [self.matchChallengeView updateView];
}

- (void)showAchievements
{
    if (self.achievementsView == nil)
    {
        self.achievementsView = [[AchievementsView alloc] initWithStyle:UITableViewStylePlain];
    }
    [UIManager.i showTemplate:@[self.achievementsView] :@"Task" :10];
    [self.achievementsView updateView];
    
    [self updateAchievementBadges];
}

- (void)showPlayerStore
{
    if (self.storePlayer == nil)
    {
        self.storePlayer = [[StorePlayerView alloc] initWithStyle:UITableViewStylePlain];
    }
	[UIManager.i showTemplate:@[self.storePlayer] :@"Transfers" :10];
    [self.storePlayer updateView];
}

- (void)showRanking
{
    if (self.rvTopDivision == nil)
    {
        self.rvTopDivision = [[RankingView alloc] initWithStyle:UITableViewStylePlain];
        self.rvTopDivision.title = @"Top Division";
        self.rvTopDivision.serviceName = @"GetClubsTopDivision";
        self.rvTopLevel.updateOnWillAppear = @"0";
        [self.rvTopDivision updateView];
    }
    
    if (self.rvTopLevel == nil)
    {
        self.rvTopLevel = [[RankingView alloc] initWithStyle:UITableViewStylePlain];
        self.rvTopLevel.title = @"Top Level";
        self.rvTopLevel.serviceName = @"GetClubsTopLevel";
        self.rvTopLevel.updateOnWillAppear = @"1";
    }
    
    if (self.allianceView == nil)
    {
        self.allianceView = [[AllianceView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.allianceView.title = @"Top Alliance";
    self.allianceView.updateOnWillAppear = @"1";
    
    [UIManager.i showTemplate:@[self.rvTopDivision, self.rvTopLevel, self.allianceView] :@"Rankings" :10];
}

- (void)showEventSolo
{
    if (self.eventSoloView == nil)
    {
        self.eventSoloView = [[EventsView alloc] initWithStyle:UITableViewStylePlain];
        self.eventSoloView.title = @"Solo Event";
        self.eventSoloView.isAlliance = @"0";
        self.eventSoloView.serviceNameDetail = @"GetEventSolo";
        self.eventSoloView.serviceNameList = @"GetEventSoloNow";
        self.eventSoloView.serviceNameResult = @"GetEventSoloResult";
    }
    [self.eventSoloView updateView];
    
    [UIManager.i showTemplate:@[self.eventSoloView] :@"Solo Tournament" :10];
}

- (void)showEventAlliance
{
    if (self.eventAllianceView == nil)
    {
        self.eventAllianceView = [[EventsView alloc] initWithStyle:UITableViewStylePlain];
        self.eventAllianceView.title = @"Alliance Event";
        self.eventAllianceView.isAlliance = @"1";
        self.eventAllianceView.serviceNameDetail = @"GetEventAlliance";
        self.eventAllianceView.serviceNameList = @"GetEventAllianceNow";
        self.eventAllianceView.serviceNameResult = @"GetEventAllianceResult";
    }
    [self.eventAllianceView updateView];
    
    [UIManager.i showTemplate:@[self.eventAllianceView] :@"Alliance Tournament" :10];
}

- (void)showSearch
{
    if (self.svClubs == nil)
    {
        self.svClubs = [[SearchView alloc] initWithStyle:UITableViewStylePlain];
        self.svClubs.title = @"Profiles";
        self.svClubs.serviceName = @"GetSearch";
    }
    
    if (self.allianceView == nil)
    {
        self.allianceView = [[AllianceView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.allianceView.title = @"Alliance";
    self.allianceView.updateOnWillAppear = @"1";
    
    [UIManager.i showTemplate:@[self.svClubs, self.allianceView] :@"Search" :10];
}

- (void)showCup
{
    if([[[Globals i] wsClubDict][@"alliance_id"] isEqualToString:@"0"]) //Not in any alliance
    {
        if (self.allianceView == nil)
        {
            self.allianceView = [[AllianceView alloc] initWithStyle:UITableViewStylePlain];
        }
        self.allianceView.title = @"Alliance";
        self.allianceView.updateOnWillAppear = @"1";
        
        [UIManager.i showTemplate:@[self.allianceView] :@"Alliance" :10];
    }
    else
    {
        NSString *aid = [[Globals i] wsClubDict][@"alliance_id"];
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:aid forKey:@"alliance_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewAlliance"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)showChallengeBox
{
    if (self.challengeBox == nil)
    {
        self.challengeBox = [[ChallengeView alloc] initWithNibName:@"ChallengeView" bundle:nil];
    }
    
    [UIManager.i showTemplate:@[self.challengeBox] :@"Challenge" :0];
	[self.challengeBox updateView];
    
    [self checkAccepted];
}

- (void)updateAchievementBadges
{
    [self.cell updateAchievementBadges];
    
    [self.view setNeedsDisplay];
    [self.mainTableView reloadData];
}

- (void)updateMailBadges
{
    [self.cell updateMailBadges];
    
    [self.view setNeedsDisplay];
    [self.mainTableView reloadData];
}

- (void)showHelp
{
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
	NSString *urlAddress = [[NSString alloc] initWithFormat:@"%@_files/help.html", WS_URL];
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
    
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view = webView;
    
    [UIManager.i showTemplate:@[controller] :@"How To Play" :10];
}

- (void)showFinance
{
    if (self.financeView == nil)
    {
        self.financeView = [[FinanceView alloc] initWithStyle:UITableViewStylePlain];
    }
	[UIManager.i showTemplate:@[self.financeView] :@"Finance" :10];
    [self.financeView updateView];
}

- (void)showFans
{
    if (self.fansView == nil)
    {
        self.fansView = [[FansView alloc] initWithNibName:@"FansView" bundle:nil];
    }
	[UIManager.i showTemplate:@[self.fansView] :@"Fans" :10];
    [self.fansView updateView];
}

- (void)showTrain
{
	if (self.jobsView == nil)
    {
        self.jobsView = [[JobsView alloc] initWithNibName:@"JobsView" bundle:nil];
    }
    [UIManager.i showTemplate:@[self.jobsView] :@"Training" :10];
    [self.jobsView updateView];
}

- (void)showCoachStore
{
    if (self.storeCoach == nil)
    {
        self.storeCoach = [[StoreCoachView alloc] initWithStyle:UITableViewStylePlain];
    }
	[UIManager.i showTemplate:@[self.storeCoach] :@"Job Board" :10];
    [self.storeCoach updateView];
}

- (void)showOthersStore
{
    if (self.emblemStore == nil)
    {
        self.emblemStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        self.emblemStore.title = @"Emblems";
        self.emblemStore.filter = @"Emblem";
    }
    
    if (self.homeStore == nil)
    {
        self.homeStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        self.homeStore.title = @"Home";
        self.homeStore.filter = @"Home";
    }
    
    if (self.awayStore == nil)
    {
        self.awayStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        self.awayStore.title = @"Away";
        self.awayStore.filter = @"Away";
    }
    
    [UIManager.i showTemplate:@[self.emblemStore, self.homeStore, self.awayStore] :@"Club Store" :10];
    [self.emblemStore updateView];
    [self.homeStore updateView];
    [self.awayStore updateView];
}

- (void)showEmblemStore
{
    if (self.emblemStore == nil)
    {
        self.emblemStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        self.emblemStore.title = @"Emblems";
        self.emblemStore.filter = @"Emblem";
    }

    [UIManager.i showTemplate:@[self.emblemStore] :@"Emblems" :10];
    [self.emblemStore updateView];
}

- (void)showHomeStore
{
    if (self.homeStore == nil)
    {
        self.homeStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        self.homeStore.title = @"Home Jerseys";
        self.homeStore.filter = @"Home";
    }

    [UIManager.i showTemplate:@[self.homeStore] :@"Home Jerseys" :10];
    [self.homeStore updateView];
}

- (void)showAwayStore
{
    if (self.awayStore == nil)
    {
        self.awayStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        self.awayStore.title = @"Away Jerseys";
        self.awayStore.filter = @"Away";
    }

    [UIManager.i showTemplate:@[self.awayStore] :@"Away Jerseys" :10];
    [self.awayStore updateView];
}

- (void)showFundStore
{
    if (self.fundStore == nil)
    {
        self.fundStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        self.fundStore.title = @"Get Funds";
        self.fundStore.filter = @"Funds";
    }

	[UIManager.i showTemplate:@[self.fundStore] :@"Get Funds" :10];
    [self.fundStore updateView];
}

- (void)showMail
{
    if(self.mailView == nil)
    {
        self.mailView = [[MailView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.mailView.title = @"Mail";
    [self.mailView updateView];
    
    [UIManager.i showTemplate:@[self.mailView] :@"Mail" :10];
    
    [self updateMailBadges];
}

- (void)showChallenge:(NSString *)club_id
{
    if(self.challengeCreate == nil)
    {
        self.challengeCreate = [[ChallengeCreateView alloc] initWithNibName:@"ChallengeCreateView" bundle:nil];
    }
    [Globals i].selectedClubId = club_id;
    [self.challengeCreate updateView];

    [UIManager.i showTemplate:@[self.challengeCreate] :@"Challenge" :0];
}

- (void)showStadiumMap
{
    if (self.stadiumMap == nil)
    {
        self.stadiumMap = [[StadiumMap alloc] initWithNibName:@"StadiumMap" bundle:nil];
    }
    [UIManager.i showTemplate:@[self.stadiumMap] :@"Stadium" :0];
    [self.stadiumMap updateView];
}

- (void)showSlots
{
	if (self.slotsView == nil)
    {
        self.slotsView = [[SlotsView alloc] initWithNibName:@"SlotsView" bundle:nil];
    }
    [UIManager.i showTemplate:@[self.slotsView] :@"Slots" :0];
}

- (void)menuButton_tap:(NSInteger)sender
{
	switch(sender)
	{
		case 1:
		{
			[self showMail];
			break;
		}
        case 2:
		{
			[self showAchievements];
			break;
		}
        case 3:
		{
			[self showHelp];
            break;
		}
        case 4:
		{
			[self showTrain];
			break;
		}
        case 5:
		{
			[self showPlayerStore];
			break;
		}
		case 6:
		{
			[self showSquad];
			break;
		}
		case 7:
		{
            [self showTactics];
			break;
		}
		case 8:
		{
			[self showMatch];
			break;
		}			
		case 9:
		{
			[self showLeague];
			break;
		}
		case 10:
		{
			[self showCup];
			break;
		}
		case 11:
		{
			[self showFinance];
			break;
		}
		case 12:
		{
            [self showStadiumMap];
			break;
		}
        case 13:
		{
            [self showClub];
			break;
		}
		case 14:
		{
			[self showOthersStore];
            break;
		}
        case 15:
		{
			[self showCoach];
			break;
		}
		case 16:
		{
            [self showStaff];
			break;
		}
		case 17:
		{
            [self showFans];
			break;
		}
        case 18:
		{
            [self showRanking];
			break;
		}
        case 19:
		{
            [self showSearch];
			break;
		}
        case 20:
		{
            [self showMap];
			break;
		}
        case 22:
		{
            [self inviteFriends];
			break;
		}
		case 23:
		{
            [self emailToDeveloper];
			break;
		}
		case 24:
		{
			[self showMoreGames];
			break;
		}
        case 25:
		{
			[self logoutButton];
            break;
		}
        case 21:
        {
            [self showSlots];
            break;
        }
	}
}

- (void)emailToDeveloper
{
    [HelpshiftSupport showConversation:self withOptions:nil];
}

- (void)showMoreGames
{
    NSString *simple = @"itms-apps://itunes.apple.com/app/id968999539";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:simple]];
}

- (void)inviteFriends
{
    NSString *appUrl = [Globals i].wsProductIdentifiers[@"url_app"];
    NSString *m = [NSString stringWithFormat:@"Play the best sports manager game! Download here: %@ Download now and receive 25 Diamonds FREE!", appUrl];
    NSString *m_encoded = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                NULL,
                                                                                                (CFStringRef)m,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8 ));
    
    NSString *str_twitter = [NSString stringWithFormat:@"twitter://post?message=%@", m_encoded];
    NSURL *twitterURL = [NSURL URLWithString:str_twitter];
    
    
    
    NSString *str_whatsapp = [NSString stringWithFormat:@"whatsapp://send?text=%@", m_encoded];
    NSURL *whatsappURL = [NSURL URLWithString:str_whatsapp];

    if ([[UIApplication sharedApplication] canOpenURL:whatsappURL])
    {
        [[UIApplication sharedApplication] openURL:whatsappURL];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:twitterURL])
    {
        [[UIApplication sharedApplication] openURL:twitterURL];
    }
    else if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        [mailCont setMessageBody:m isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTimerMarquee
{
	if(self.marquee.count > 0)
	{
		self.posxMarquee = self.posxMarquee-self.speedMarquee;
		if(self.posxMarquee < -self.textSizeMarquee.width)
		{
			self.posxMarquee = SCREEN_WIDTH;
			self.rowMarquee = self.rowMarquee - 1;
			if(self.rowMarquee < 0)
			{
				self.rowMarquee = self.marquee.count-1;
			}
			NSDictionary *rowData = (self.marquee)[self.rowMarquee];
			self.lblMarquee.text = rowData[@"headline"];
			self.textSizeMarquee = [[self.lblMarquee text] sizeWithAttributes:@{NSFontAttributeName: [self.lblMarquee font]}];
		}
		self.lblMarquee.frame = CGRectMake(self.posxMarquee, UIScreen.mainScreen.bounds.size.height-Marquee_height, self.textSizeMarquee.width, Marquee_height);
	}
}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
	UILabel *label = (UILabel *)gesture.view;
	CGPoint translation = [gesture translationInView:label];
    
    self.speedMarquee = 0;
    self.posxMarquee = self.posxMarquee + 1 + translation.x;

	[gesture setTranslation:CGPointZero inView:label];
    self.speedMarquee = 1;
}

- (void)createMarquee
{
    if (self.lblMarquee == nil)
    {
        self.posxMarquee = SCREEN_WIDTH;
        CGRect lblRect = CGRectMake(self.posxMarquee, UIScreen.mainScreen.bounds.size.height-Marquee_height, SCREEN_WIDTH, Marquee_height);
        self.lblMarquee = [[UILabel alloc] initWithFrame:lblRect];
        self.lblMarquee.tag = 99;
        self.lblMarquee.userInteractionEnabled = YES;
        self.lblMarquee.text = @"";
        self.lblMarquee.backgroundColor = [UIColor grayColor];
        self.lblMarquee.textColor = [UIColor whiteColor];
        self.lblMarquee.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
        self.lblMarquee.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(labelDragged:)];
        [self.lblMarquee addGestureRecognizer:gesture];
        
        [self showMarquee];
    }
}

- (void)showMarquee
{
	self.speedMarquee = 1;
    self.marquee = [[Globals i] getMarqueeData];
    [self.view addSubview:self.lblMarquee];
    if((!self.marqueeTimer.isValid) && (self.marquee.count > 0))
    {
        self.rowMarquee = [self.marquee count]-1;
        NSDictionary *rowData = [[Globals i] getMarqueeData][self.rowMarquee];
        self.lblMarquee.text = rowData[@"headline"];
        self.textSizeMarquee = [[self.lblMarquee text] sizeWithAttributes:@{NSFontAttributeName: [self.lblMarquee font]}];
        
        self.marqueeTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(onTimerMarquee) userInfo:nil repeats:YES];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:self.marqueeTimer forMode:NSRunLoopCommonModes];
        [runloop addTimer:self.marqueeTimer forMode:UITrackingRunLoopMode];
        [[NSRunLoop mainRunLoop] addTimer:self.marqueeTimer forMode: NSRunLoopCommonModes];
    }
}

- (void)createChat
{
    if (self.bkgChat == nil)
    {
        self.bkgChat = [[UIImageView alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height-Marquee_height-Chatpreview_height, SCREEN_WIDTH, Chatpreview_height)];
        [self.bkgChat setImage:[UIImage imageNamed:@"bkg_chat"]];
        [self.view addSubview:self.bkgChat];
    }
    
    if (self.svChat == nil)
    {
        self.svChat = [[UIScrollView alloc] init];
        self.svChat.frame = self.bkgChat.frame;
        self.svChat.backgroundColor = [UIColor clearColor];
        self.svChat.pagingEnabled = YES;
        self.svChat.contentSize = CGSizeMake(self.svChat.frame.size.width*2, self.svChat.frame.size.height);
        self.svChat.showsHorizontalScrollIndicator = NO;
        self.svChat.showsVerticalScrollIndicator = NO;
        self.svChat.scrollsToTop = NO;
        self.svChat.delegate = self;
        [self.view addSubview:self.svChat];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchChat)];
        [recognizer setNumberOfTapsRequired:1];
        [recognizer setNumberOfTouchesRequired:1];
        [self.svChat addGestureRecognizer:recognizer];
    }
    
    if (self.pcChat == nil)
    {
        float pagecontrol_width = 30.0f*SCALE_IPAD;
        float pagecontrol_height = 8.0f*SCALE_IPAD;
        self.pcChat = [[UIPageControl alloc] init];
        self.pcChat.frame = CGRectMake(self.bkgChat.frame.size.width/2 - pagecontrol_width/2, self.bkgChat.frame.origin.y, pagecontrol_width, pagecontrol_height);
        self.pcChat.backgroundColor = [UIColor clearColor];
        self.pcChat.numberOfPages = 2;
        self.pcChat.currentPage = 0;
        [self.view addSubview:self.pcChat];
    }
    
    [self loadScrollViewWithPage:0];
    
    [self updateChat];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.svChat.frame.size.width;
    NSInteger page = floor((self.svChat.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    self.pcChat.currentPage = page;
	
    [self loadScrollViewWithPage:page];
}

- (void)loadScrollViewWithPage:(NSInteger)page
{
    float icon_size = 30.0f*SCALE_IPAD;
    float chat_font_size = 12.0f*SCALE_IPAD;
    float page_control_height = 5.0f*SCALE_IPAD;
    
    if (page == 0)
    {
        if (self.ivChatWorldIcon == nil)
        {
            self.ivChatWorldIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_chat_world"]];
            [self.ivChatWorldIcon setFrame:CGRectMake(0, page_control_height, icon_size, icon_size)];
            [self.svChat addSubview:self.ivChatWorldIcon];
        }
        
        if (self.lblChatWorld1 == nil)
        {
            self.lblChatWorld1 = [[UILabel alloc] init];
            self.lblChatWorld1.frame = CGRectMake(icon_size, page_control_height, UIScreen.mainScreen.bounds.size.width-icon_size, icon_size/2);
            self.lblChatWorld1.font = [UIFont fontWithName:DEFAULT_FONT size:chat_font_size];
            self.lblChatWorld1.backgroundColor = [UIColor clearColor];
            self.lblChatWorld1.textColor = [UIColor whiteColor];
            self.lblChatWorld1.textAlignment = NSTextAlignmentLeft;
            self.lblChatWorld1.numberOfLines = 1;
            self.lblChatWorld1.minimumScaleFactor = 1.0f;
            [self.svChat addSubview:self.lblChatWorld1];
        }
        
        if (self.lblChatWorld2 == nil)
        {
            self.lblChatWorld2 = [[UILabel alloc] init];
            self.lblChatWorld2.frame = CGRectMake(icon_size, page_control_height+(icon_size/2), UIScreen.mainScreen.bounds.size.width-icon_size, icon_size/2);
            self.lblChatWorld2.font = [UIFont fontWithName:DEFAULT_FONT size:chat_font_size];
            self.lblChatWorld2.backgroundColor = [UIColor clearColor];
            self.lblChatWorld2.textColor = [UIColor whiteColor];
            self.lblChatWorld2.textAlignment = NSTextAlignmentLeft;
            self.lblChatWorld2.numberOfLines = 1;
            self.lblChatWorld2.minimumScaleFactor = 1.0f;
            [self.svChat addSubview:self.lblChatWorld2];
        }
        
        self.chatState = 1;
        [self getChat];
    }
    else if (page == 1)
    {
        if (self.ivChatAllianceIcon == nil)
        {
            self.ivChatAllianceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_chat_alliance"]];
            [self.ivChatAllianceIcon setFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width, page_control_height, icon_size, icon_size)];
            [self.svChat addSubview:self.ivChatAllianceIcon];
        }
        
        if (self.lblChatAlliance1 == nil)
        {
            self.lblChatAlliance1 = [[UILabel alloc] init];
            self.lblChatAlliance1.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width+icon_size, page_control_height, UIScreen.mainScreen.bounds.size.width-icon_size, icon_size/2);
            self.lblChatAlliance1.font = [UIFont fontWithName:DEFAULT_FONT size:chat_font_size];
            self.lblChatAlliance1.backgroundColor = [UIColor clearColor];
            self.lblChatAlliance1.textColor = [UIColor whiteColor];
            self.lblChatAlliance1.textAlignment = NSTextAlignmentLeft;
            self.lblChatAlliance1.numberOfLines = 1;
            self.lblChatAlliance1.minimumScaleFactor = 1.0f;
            [self.svChat addSubview:self.lblChatAlliance1];
        }
        
        if (self.lblChatAlliance2 == nil)
        {
            self.lblChatAlliance2 = [[UILabel alloc] init];
            self.lblChatAlliance2.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width+icon_size, page_control_height+(icon_size/2), UIScreen.mainScreen.bounds.size.width-icon_size, icon_size/2);
            self.lblChatAlliance2.font = [UIFont fontWithName:DEFAULT_FONT size:chat_font_size];
            self.lblChatAlliance2.backgroundColor = [UIColor clearColor];
            self.lblChatAlliance2.textColor = [UIColor whiteColor];
            self.lblChatAlliance2.textAlignment = NSTextAlignmentLeft;
            self.lblChatAlliance2.numberOfLines = 1;
            self.lblChatAlliance2.minimumScaleFactor = 1.0f;
            [self.svChat addSubview:self.lblChatAlliance2];
        }
        
        self.chatState = 2;
        [self getChat];
    }
}

- (void)touchChat
{
    if (self.chatState == 2)
    {
        [self showChat:YES];
    }
    else
    {
        [self showChat:NO];
    }
}

- (void)updateChat
{
    if(!self.chatTimer.isValid)
    {
        self.chatTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getChat) userInfo:nil repeats:YES];
    }
    [self getChat];
}

- (void)showChat:(BOOL)goto_alliance_tab
{
	if(self.chatView == nil)
    {
        self.chatView = [[ChatView alloc] init];
    }
    self.chatView.title = @"World Chat";
    
    if([[Globals i].wsClubDict[@"alliance_id"] isEqualToString:@"0"])
    {
        [UIManager.i showTemplate:@[self.chatView] :@"Chat" :10];
        [self.chatView updateView:[Globals i].wsChatFullArray table:@"chat" a_id:@"0"];
    }
    else
    {
        if(self.allianceChatView == nil)
        {
            self.allianceChatView = [[ChatView alloc] init];
        }
        self.allianceChatView.title = @"Alliance Chat";
        
        if (goto_alliance_tab)
        {
            [UIManager.i showTemplate:@[self.chatView, self.allianceChatView] :@"Chat" :10 :1];
        }
        else
        {
            [UIManager.i showTemplate:@[self.chatView, self.allianceChatView] :@"Chat" :10 :0];
        }
        
        [self.chatView updateView:[Globals i].wsChatFullArray table:@"chat" a_id:@"0"];
        
        [self.allianceChatView updateView:[Globals i].wsAllianceChatFullArray table:@"alliance_chat" a_id:[Globals i].wsClubDict[@"alliance_id"]];
    }
}

- (void)getChat
{
    if (self.chatState == 1)
    {
        [[Globals i] updateChatData];
    }
    else if (self.chatState == 2)
    {
        if([[[Globals i] wsClubDict][@"alliance_id"] isEqualToString:@"0"]) //Not in an alliance
        {
            self.lblChatAlliance1.text = @"Join an Alliance to chat here";
        }
        else
        {
            [[Globals i] updateAllianceChatData];
        }
    }
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.cell = (MainCell *)[tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (self.cell == nil)
    {
        self.cell = [[MainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
        [self.cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
	return self.cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return Maintable_height;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)logoutButton
{
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Assistant Manager"
						  message:@"Do you want to logout?"
						  delegate:self
						  cancelButtonTitle:@"Cancel"
						  otherButtonTitles:@"Logout", nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
       //Do nothing
	}
	
	if(buttonIndex == 1)
	{
        [self gotoLogin:NO];
    }
}

@end
