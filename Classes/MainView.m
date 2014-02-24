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
#import "Sparrow.h"
#import "Game.h"
#import "Game_hockey.h"
#import "SlotsView.h"
#import "SalesView.h"
#import "JobLevelup.h"
#import "MailCompose.h"
#import "iRate.h"

@interface MainView () <SKProductsRequestDelegate, SKPaymentTransactionObserver, UITabBarControllerDelegate,
UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@end

@implementation MainView

- (void)startUp //Called when app opens for the first time
{
    [Apsalar event:@"Main_startUp"];
    [Flurry logEvent:@"Main_startUp"];
    
    self.isShowingLogin = NO;
    
    self.title = @"MainView";
    [Globals i].mainView = self;
    [[Globals i] pushViewControllerStack:self];
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
    
    //[iRate sharedInstance].eventsUntilPrompt = 50;
    //[iRate sharedInstance].daysUntilPrompt = 0;
    //[iRate sharedInstance].remindPeriod = 0;
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
        [[Globals i] showTemplate:@[self.allianceDetail] :@"Alliance" :1];
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
        [Globals i].wsClubData[@"xp"] = [NSString stringWithFormat:@"%ld", (long)[[Globals i] getXp]+[xp_gain integerValue]];
        
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
    [[Globals i] closeAllTemplate];
    
    [[Globals i] showLoading];
    
    [[Globals i] getServerClubData:^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{ //Update UI on main thread
         if (success)
         {
             NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
             
             [userInfo setObject:@"Updating Product Identifiers" forKey:@"status"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateProductIdentifiers]; //This comes first before display dialog if need to upgrade app
             
             [userInfo setObject:@"Updating Marquee Data" forKey:@"status"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateMarqueeData];
             
             [userInfo setObject:@"Updating Current Season Data" forKey:@"status"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateCurrentSeasonData]; //For slides
             
             [userInfo setObject:@"Updating Fixtures Data" forKey:@"status"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateMatchData];
             
             [userInfo setObject:@"Updating Match History Data" forKey:@"status"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateMatchPlayedData];
             
             [userInfo setObject:@"Updating Challenges Data" forKey:@"status"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateChallengesData];
             
             [userInfo setObject:@"Updating Products" forKey:@"status"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateProducts];//Pre-load products
             
             [userInfo setObject:@"Updating Tasks" forKey:@"status"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                 object:self
                                                               userInfo:userInfo];
             [[Globals i] updateMyAchievementsData];
             [self updateAchievementBadges]; //Show badges
             
             [userInfo setObject:@"Finalizing Everything" forKey:@"status"];
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
             if(!self.chatTimer.isValid)
             {
                 self.chatTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(onTimerChat) userInfo:nil repeats:YES];
             }
             
             [self showChallengeBox];
             
             [self showMail];
             
             [self.cell updateEventSoloButton];
             
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
    
    [Apsalar event:@"Main_loadAllData"];
    [Flurry logEvent:@"Main_loadAllData"];
}

- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *alertMsg;
    
    if( userInfo[@"aps"][@"alert"] != nil)
    {
        alertMsg = userInfo[@"aps"][@"alert"];
        [[Globals i] showDialog:alertMsg];
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
    if(self.mailCompose == nil)
    {
        self.mailCompose = [[MailCompose alloc] initWithStyle:UITableViewStylePlain];
    }
    self.mailCompose.title = @"Mail";
    self.mailCompose.isAlliance = isAlli;
    self.mailCompose.toID = toid;
    self.mailCompose.toName = toname;
    
    [[Globals i] showTemplate:@[self.mailCompose] :@"Message" :1];
}

- (void)showBuy
{
    if (self.buyView == nil)
    {
        self.buyView = [[BuyView alloc] initWithStyle:UITableViewStylePlain];
        self.buyView.title = @"Buy Diamonds 1";
        [self.buyView updateView];
    }
    
    [[Globals i] showTemplate:@[self.buyView] :@"Buy Diamonds" :1];
    
    //Disable the Buy button
    [Globals i].templateView.buyButton.hidden = YES;
    [Globals i].templateView.currencyLabel.hidden = YES;
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
    self.trophyViewer.selected_trophy = [[Globals i] wsClubData][@"club_id"];
    
    if (self.myclubTabBarController == nil)
    {
        self.myclubTabBarController = [[UITabBarController alloc] init];
        self.myclubTabBarController.delegate = self;
    }
    
    self.myclubTabBarController.viewControllers = @[self.clubView, self.trophyViewer];
    [self.myclubTabBarController setSelectedIndex:0];
    [[Globals i] showTemplate:@[self.myclubTabBarController] :@"Club Details" :1];
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
    [[Globals i] showTemplate:@[self.clubTabBarController] :@"Club Details" :1];
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
    [[Globals i] showTemplate:@[self.leagueTabBarController] :@"League" :1];
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
    [[Globals i] showTemplate:@[self.tacticsTabBarController] :@"Formations" :1];
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
	//[[Globals i] showDialog:@"PROCESSING... Please wait a while."];
	
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
        [[Globals i] showDialog:@"Please try again now."];
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
    [[Globals i] removeLoadingAlert];
    //[[Globals i] removeDialogBox];
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
    
    NSError *error = nil;
    NSStringEncoding encoding;
    NSString *json = [[Globals i] encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ReportError/%@/%@/%@", 
                       WS_URL, [[Globals i] gettPurchasedProduct], [[Globals i] UID], json];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    NSString *returnValue  = [[NSString alloc] initWithContentsOfURL:url
                                                        usedEncoding:&encoding 
                                                               error:&error];
    if([returnValue isEqualToString:@"1"])
    {
        if([[Globals i] updateClubData]) //After buying effect
        {
            [[Globals i] showDialog:@"Purchase Success! Thank you for supporting our Games!"];
        }
        else
        {
            //Update failed
            [[Globals i] showDialog:@"Purchase Success! Please restart device to take effect."];
        }
    }
    else
    {
        //Webservice failed
    }
    
    [Apsalar event:[[Globals i] gettPurchasedProduct]];
    [Flurry logEvent:[[Globals i] gettPurchasedProduct]];
    
	if([[[Globals i] gettPurchasedProduct] integerValue] < 9)
	{
        if([[[Globals i] gettPurchasedProduct] integerValue] != 0)
        {
            [self buyStaffSuccess:@"0":json];
        }
	}
	else if([[[Globals i] gettPurchasedProduct] integerValue] == 9)
	{
		[self buyStadiumSuccess:@"0":json];
	}
	else if([[[Globals i] gettPurchasedProduct] integerValue] == 10)
	{
		[self renameClubPurchaseSuccess:@"0":json];
	}
	else if([[[Globals i] gettPurchasedProduct] integerValue] == 13)
	{
		[self buyResetClub];
	}
	else if([[[Globals i] gettPurchasedProduct] integerValue] == 14)
	{
        [self refillEnergySuccess:@"0":json];
	}
    else if([[[Globals i] gettPurchasedProduct] integerValue] == 1000) //Sale!
    {
         NSString *wsurl2 = [NSString stringWithFormat:@"%@/RegisterSale/%@/%@/%@",
                                WS_URL, [Globals i].wsSalesData[@"sale_id"], [[Globals i] UID], json];
         
         NSURL *url2 = [[NSURL alloc] initWithString:wsurl2];
         NSString *returnValue2  = [[NSString alloc] initWithContentsOfURL:url2
                                                             usedEncoding:&encoding
                                                                    error:&error];
        if([returnValue2 isEqualToString:@"1"])
        {
            if([[Globals i] updateClubData]) //After buying effect
            {
                [[Globals i] closeAllTemplate];
                [[Globals i] showDialog:@"Purchase Success! Thank you for supporting our Games!"];
            }
            else
            {
                //Update failed
                [[Globals i] showDialog:@"Purchase Success! Please restart device to take effect."];
            }
        }
        else
        {
            //Webservice failed
        }
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
    
    [[Globals i] showDialog:@"You have upgraded your stadium. +5 XP"];
    
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
    
    [self.stadiumMap updateView];
	
	NSString *message = @"I have just upgraded my arena. Come over and play a match with me.";
	NSString *extra_desc = @"A big portion of club revenue comes from ticket sales of matches played at your stadium. Upgrade your stadium to increase seating capacity and average ticket price per match. ";
	NSString *imagename = @"upgrade_stadium.png";
	[[Globals i] fbPublishStory:message :extra_desc :imagename];
}

- (void)buyStaffSuccess:(NSString *)virtualMoney :(NSString *)json
{
	NSString *productId = [[Globals i] gettPurchasedProduct];
	[[Globals i] buyProduct:productId:virtualMoney:json];
    
    [[Globals i] showDialog:@"You have just hired a staff. +5 XP"];
    
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
    [[Globals i] showDialogBlock:@"Please enter a name for your Club"
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
                 [[Globals i] showDialog:@"Your club name has been changed successfully."];
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
    
    [[Globals i] showDialog:@"Your club has been reset successfully."];
	
	NSString *message = @"I have just reset my club!";
	NSString *extra_desc = @"You can reset your club if you want to start again from scratch. ";
	NSString *imagename = @"rename_club.png";
	[[Globals i] fbPublishStory:message:extra_desc:imagename];
}

- (void)buyOthersSuccess
{
	NSString *productId = [[Globals i] gettPurchasedProduct];
	[[Globals i] buyProduct:productId:@"1":@"0"];
    
    [[Globals i] showDialog:@"Purchase and upgrades for your club is completed."];
	
	[[Globals i] updateClubData]; //Something has been updated
	[self resetClubImages];
}

- (void)buyOthersSuccessWithDiamonds
{
	NSString *productId = [[Globals i] gettPurchasedProduct];
	[[Globals i] buyProduct:productId:@"2":@"0"];
    
    [[Globals i] showDialog:@"Purchase and upgrades for your club is completed."];
	
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
	[[Globals i] showDialog:@"PROCESSING... Please wait a while."];
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
                [[Globals i] removeDialogBox];
                
                [[Globals i] showDialog:@"Club is playing a match now, try accept again."];
			}
		}
	}
}

- (void)liveMatch
{
    [[Globals i] updateMatchHighlightsData:[Globals i].challengeMatchId];
    
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        [SPAudioEngine start];
        self.sparrowView = [[SPViewController alloc] init];
        self.sparrowView.multitouchEnabled = YES;
        [self.sparrowView startWithRoot:[Game class] supportHighResolutions:YES doubleOnPad:NO];
        
        [[Globals i] showTemplate:@[self.sparrowView] :@"Live Match" :2];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        [SPAudioEngine start];
        self.sparrowView = [[SPViewController alloc] init];
        self.sparrowView.multitouchEnabled = YES;
        [self.sparrowView startWithRoot:[Game_hockey class] supportHighResolutions:YES doubleOnPad:NO];
        
        [[Globals i] showTemplate:@[self.sparrowView] :@"Live Match" :2];
    }
    else
    {
        [self showMatchReport];
    }
    
    [[Globals i] removeDialogBox];
}

- (void)removeLiveMatch
{
	if(self.sparrowView != nil)
	{
		[self.sparrowView.view removeFromSuperview];
        [[Globals i] closeTemplate];
        
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
    [[Globals i] showTemplate:@[self.matchReport] :@"Match Report" :1];
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
    [[Globals i] showDialogBlock:[NSString stringWithFormat:@"%@ has accepted your Challenge. View the match report?", a[self.currMatchIndex][@"club_away_name"]]
                                :2
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1)
         {
             [Globals i].challengeMatchId = a[self.currMatchIndex][@"match_id"];
             [self reportMatch];
         }
         
         if (index == 0)
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
    
    [[Globals i] showTemplate:@[self.jobLevelup] :@"Level Up" :0];
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
        [[Globals i] showTemplate:@[self.salesView] :@"Promotion" :0];
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
                         [[Globals i] showTemplate:@[self.salesView] :@"Promotion" :0];
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
    [[Globals i] showTemplate:@[self.jobRefill] :@"Energy Refill" :1];
	[self.jobRefill updateView];
}

- (void)showStaff
{
    if (self.staffView == nil)
    {
        self.staffView = [[StaffView alloc] initWithStyle:UITableViewStylePlain];
    }
    [[Globals i] showTemplate:@[self.staffView] :@"Staff" :1];
    [self.staffView updateView];
}

- (void)showCoach
{
    if (self.trainingView == nil)
    {
        self.trainingView = [[TrainingView alloc] initWithNibName:@"TrainingView" bundle:nil];
    }
    [[Globals i] showTemplate:@[self.trainingView] :@"Coach" :1];
    [self.trainingView updateView];
}

- (void)showMap
{
    if (self.clubMapView == nil)
    {
        self.clubMapView = [[ClubMapView alloc] init];
    }
    [[Globals i] showTemplate:@[self.clubMapView] :@"Map" :1];
    [self.clubMapView updateView];
}

- (void)showSquad
{
    if (self.squadView == nil)
    {
        self.squadView = [[SquadView alloc] initWithStyle:UITableViewStylePlain];
    }
    [[Globals i] showTemplate:@[self.squadView] :@"Squad" :1];
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
    
    [[Globals i] showTemplate:@[self.matchView, self.matchPlayedView, self.matchChallengeView] :@"Fixtures" :1];
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
    [[Globals i] showTemplate:@[self.achievementsView] :@"Task" :1];
    [self.achievementsView updateView];
    
    [self updateAchievementBadges];
}

- (void)showPlayerStore
{
    if (self.storePlayer == nil)
    {
        self.storePlayer = [[StorePlayerView alloc] initWithStyle:UITableViewStylePlain];
    }
	[[Globals i] showTemplate:@[self.storePlayer] :@"Transfers" :1];
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
    
    [[Globals i] showTemplate:@[self.rvTopDivision, self.rvTopLevel, self.allianceView] :@"Rankings" :1];
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
    }
    [self.eventSoloView updateView];
    
    [[Globals i] showTemplate:@[self.eventSoloView] :@"Solo Tournament" :1];
}

- (void)showEventAlliance
{
    if (self.eventAllianceView == nil)
    {
        self.eventAllianceView = [[EventsView alloc] initWithStyle:UITableViewStylePlain];
        self.eventAllianceView.title = @"Alliance Event";
        self.eventSoloView.isAlliance = @"1";
        self.eventSoloView.serviceNameDetail = @"GetEventAlliance";
        self.eventSoloView.serviceNameList = @"GetEventAllianceNow";
    }
    [self.eventAllianceView updateView];
    
    [[Globals i] showTemplate:@[self.eventAllianceView] :@"Alliance Tournament" :1];
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
    
    [[Globals i] showTemplate:@[self.svClubs, self.allianceView] :@"Search" :1];
}

- (void)showCup
{
    if([[[Globals i] wsClubData][@"alliance_id"] isEqualToString:@"0"]) //Not in any alliance
    {
        if (self.allianceView == nil)
        {
            self.allianceView = [[AllianceView alloc] initWithStyle:UITableViewStylePlain];
        }
        self.allianceView.title = @"Alliance";
        self.allianceView.updateOnWillAppear = @"1";
        
        [[Globals i] showTemplate:@[self.allianceView] :@"Alliance" :1];
    }
    else
    {
        NSString *aid = [[Globals i] wsClubData][@"alliance_id"];
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
    
    [[Globals i] showTemplate:@[self.challengeBox] :@"Challenge" :0];
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
    
    [[Globals i] showTemplate:@[controller] :@"How To Play" :1];
}

- (void)showFinance
{
    if (self.financeView == nil)
    {
        self.financeView = [[FinanceView alloc] initWithStyle:UITableViewStylePlain];
    }
	[[Globals i] showTemplate:@[self.financeView] :@"Finance" :1];
    [self.financeView updateView];
}

- (void)showFans
{
    if (self.fansView == nil)
    {
        self.fansView = [[FansView alloc] initWithNibName:@"FansView" bundle:nil];
    }
	[[Globals i] showTemplate:@[self.fansView] :@"Fans" :1];
    [self.fansView updateView];
}

- (void)showTrain
{
	if (self.jobsView == nil)
    {
        self.jobsView = [[JobsView alloc] initWithNibName:@"JobsView" bundle:nil];
    }
    [[Globals i] showTemplate:@[self.jobsView] :@"Training" :1];
    [self.jobsView updateView];
}

- (void)showCoachStore
{
    if (self.storeCoach == nil)
    {
        self.storeCoach = [[StoreCoachView alloc] initWithStyle:UITableViewStylePlain];
    }
	[[Globals i] showTemplate:@[self.storeCoach] :@"Job Board" :1];
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
        self.homeStore.title = @"Home Jerseys";
        self.homeStore.filter = @"Home";
    }
    
    if (self.awayStore == nil)
    {
        self.awayStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        self.awayStore.title = @"Away Jerseys";
        self.awayStore.filter = @"Away";
    }
    
    [[Globals i] showTemplate:@[self.emblemStore, self.homeStore, self.awayStore] :@"Club Store" :1];
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

    [[Globals i] showTemplate:@[self.emblemStore] :@"Emblems" :1];
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

    [[Globals i] showTemplate:@[self.homeStore] :@"Home Jerseys" :1];
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

    [[Globals i] showTemplate:@[self.awayStore] :@"Away Jerseys" :1];
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

	[[Globals i] showTemplate:@[self.fundStore] :@"Get Funds" :1];
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
    
    [[Globals i] showTemplate:@[self.mailView] :@"Mail" :1];
    
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

    [[Globals i] showTemplate:@[self.challengeCreate] :@"Challenge" :0];
}

- (void)showStadiumMap
{
    if (self.stadiumMap == nil)
    {
        self.stadiumMap = [[StadiumMap alloc] initWithNibName:@"StadiumMap" bundle:nil];
    }
    [[Globals i] showTemplate:@[self.stadiumMap] :@"Stadium" :0];
    [self.stadiumMap updateView];
}

- (void)showSlots
{
	if (self.slotsView == nil)
    {
        self.slotsView = [[SlotsView alloc] initWithNibName:@"SlotsView" bundle:nil];
    }
    [[Globals i] showTemplate:@[self.slotsView] :@"Slots" :0];
}

- (void)menuButton_tap:(NSInteger)sender
{
    [[iRate sharedInstance] logEvent:NO];
    
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
			[self showSlots];
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
        case 21:
		{
            [self mailFriends];
			break;
		}
		case 22:
		{
            [self mailDeveloper];
			break;
		}
		case 23:
		{
			[[Globals i] showMoreGames];
			break;
		}
        case 24:
		{
            [self showHelp];
            break;
		}
        case 25:
		{
			[self logoutButton];
            break;
		}
	}
}

- (void)mailDeveloper
{
    NSString *subject = [NSString stringWithFormat:@"%@(Version %@)",
                        GAME_NAME,
                        GAME_VERSION];
    
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        [mailCont setToRecipients:[NSArray arrayWithObject:@"support@tapfantasy.com"]];
        [mailCont setSubject:subject];
        [mailCont setMessageBody:@"" isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailFriends
{
    NSString *appUrl = [Globals i].wsProductIdentifiers[@"url_app"];
    NSString *m = [NSString stringWithFormat:@"Play the best sports manager game! Download here: %@ Download now and receive 25 Diamonds FREE!", appUrl];
    
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        //[mailCont setToRecipients:[NSArray arrayWithObject:@"support@tapfantasy.com"]];
        //[mailCont setSubject:@""];
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
            [Apsalar event:@"MailFriendOrDeveloper"];
            [Flurry logEvent:@"MailFriendOrDeveloper"];
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
			self.textSizeMarquee = [[self.lblMarquee text] sizeWithFont:[self.lblMarquee font]];
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
        self.textSizeMarquee = [[self.lblMarquee text] sizeWithFont:[self.lblMarquee font]];
        
        self.marqueeTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(onTimerMarquee) userInfo:nil repeats:YES];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:self.marqueeTimer forMode:NSRunLoopCommonModes];
        [runloop addTimer:self.marqueeTimer forMode:UITrackingRunLoopMode];
        [[NSRunLoop mainRunLoop] addTimer:self.marqueeTimer forMode: NSRunLoopCommonModes];
    }
}

- (void)createChat
{
    if (self.lblChat1 == nil)
    {
        self.lblChat1 = [[UILabel alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height-Marquee_height-Chatpreview_height, SCREEN_WIDTH, Chatpreview_height)];
        self.lblChat1.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SMALL_SIZE];
        self.lblChat1.textAlignment = NSTextAlignmentLeft;
        self.lblChat1.textColor = [UIColor grayColor];
        self.lblChat1.backgroundColor = [UIColor whiteColor];
        self.lblChat1.layer.borderColor = [UIColor blackColor].CGColor;
        self.lblChat1.layer.borderWidth = 2.0;
        self.lblChat1.numberOfLines = 0;
        self.lblChat1.tag = 999;
        self.lblChat1.userInteractionEnabled = YES;
        [self.view addSubview:self.lblChat1];
        
        UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chatButton.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width-(55*SCALE_IPAD), UIScreen.mainScreen.bounds.size.height-Marquee_height-Chatpreview_height, (55*SCALE_IPAD), (55*SCALE_IPAD));
        [chatButton setBackgroundImage:[UIImage imageNamed:@"button_chat"] forState:UIControlStateNormal];
        [chatButton setAlpha:0.5];
        [chatButton addTarget:self action:@selector(showChat) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:chatButton];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[Globals i] isCurrentView:self])
    {
        UITouch *touch = [[event allTouches] anyObject];
        if (CGRectContainsPoint([self.lblChat1 frame], [touch locationInView:self.view]))
        {
            [self showChat];
        }
    }
}

- (void)showChat
{
	if(self.chatView == nil)
    {
        self.chatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
    }
    self.chatView.title = @"World";
    
    if([[Globals i].wsClubData[@"alliance_id"] isEqualToString:@"0"])
    {
        [[Globals i] showTemplate:@[self.chatView] :@"Chat" :1];
        [self.chatView updateView:[[Globals i] wsChatFullData] table:@"chat" a_id:@"0"];
    }
    else
    {
        if(self.allianceChatView == nil)
        {
            self.allianceChatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
        }
        self.allianceChatView.title = @"Alliance Chat";
        
        [[Globals i] showTemplate:@[self.chatView, self.allianceChatView] :@"Chat" :1];
        
        [self.chatView updateView:[[Globals i] wsChatFullData] table:@"chat" a_id:@"0"];
        
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetAllianceWall/%@",
                           [[Globals i] world_url], [Globals i].wsClubData[@"alliance_id"]];
        [Globals getServer:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
                 [Globals i].wsAllianceChatFullData = returnArray;
                 [self.allianceChatView updateView:[Globals i].wsAllianceChatFullData table:@"alliance_wall" a_id:[Globals i].wsClubData[@"alliance_id"]];
             }
         }];
    }
}

- (void)onTimerChat
{
    [NSThread detachNewThreadSelector:@selector(getChat) toTarget:self withObject:nil];
}

- (void)getChat
{
    [[Globals i] updateChatData];
    self.lblChat1.text = [[Globals i] getLastChatString];
    
    //Alliance chat only if the view is open
    if([[[Globals i] currentViewTitle] isEqualToString:@"Alliance Chat"])
    {
        [[Globals i] updateAllianceChatData];
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
