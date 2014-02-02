//
//  MainView.m
//  FFC
//
//  Created by Shankar on 6/3/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MainView.h"
#import "Globals.h"
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
#import "Sparrow.h"
#import "Game.h"
#import "Game_hockey.h"
#import "SlotsView.h"
#import "iRate.h"

@implementation MainView
@synthesize header;
@synthesize jobsView;
@synthesize stadiumMap;
@synthesize fansView;
@synthesize financeView;
@synthesize staffView;
@synthesize matchView;
@synthesize matchPlayedView;
@synthesize matchChallengeView;
@synthesize clubMapView;
@synthesize squadView;
@synthesize trainingView;
@synthesize newsView;
@synthesize friendsView;
@synthesize clubTabBarController;
@synthesize tacticsTabBarController;
@synthesize leagueTabBarController;
@synthesize achievementsView;
@synthesize allianceView;
@synthesize allianceDetail;
@synthesize matchLive;
@synthesize matchReport;
@synthesize welcomeView;
@synthesize challengeBox;
@synthesize challengeCreate;
@synthesize marqueeTimer;
@synthesize chatTimer;
@synthesize lblChat1;
@synthesize marquee;
@synthesize lblMarquee;
@synthesize myclubTabBarController;
@synthesize sparrowView;
@synthesize mainTableView;
@synthesize cell;
@synthesize storePlayer;
@synthesize storeCoach;
@synthesize fundStore;
@synthesize emblemStore;
@synthesize homeStore;
@synthesize awayStore;
@synthesize jobRefill;
@synthesize mailView;
@synthesize clubView;
@synthesize trophyViewer;
@synthesize clubViewer;
@synthesize mapViewer;
@synthesize leagueView;
@synthesize promotionView;
@synthesize scorersView;
@synthesize formationView;
@synthesize subsView;
@synthesize tacticsView;
@synthesize squadViewer;
@synthesize overView;
@synthesize fixturesView;
@synthesize chatView;
@synthesize allianceChatView;
@synthesize rvTopDivision;
@synthesize rvTopLevel;
@synthesize slotsView;

- (void)startUp //Called when app opens for the first time
{
    isShowingLogin = NO;
    
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
                                                 name:@"GotoCup"
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
    [self.view insertSubview:mainTableView atIndex:1];
    [self.mainTableView reloadData];
    
    [self reloadView];
    
    [iRate sharedInstance].eventsUntilPrompt = 20;
    [iRate sharedInstance].daysUntilPrompt = 0;
    [iRate sharedInstance].remindPeriod = 0;
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
    
    if ([[notification name] isEqualToString:@"GotoCup"])
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
        [header updateView];
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

    if (!isShowingLogin)
    {
        isShowingLogin = YES;
        
        [[Globals i] showLogin:^(NSInteger status)
         {
             if(status == 1) //Login Success
             {
                 isShowingLogin = NO;
                 [self loadAllData];
             }
         }];
    }
}

- (void)loadAllData
{
    [[Globals i] showLoading];
    
    [[Globals i] getServerClubData:^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{ //Update UI on main thread
         if (success)
         {
             //This comes first before display dialog if need to upgrade app
             [[Globals i] updateProductIdentifiers];
             
             [[Globals i] updateMarqueeData];
             
             [[Globals i] updateCurrentSeasonData]; //For slides
             
             [[Globals i] updateMatchData];
             
             [[Globals i] updateMatchPlayedData];
             
             [[Globals i] updateChallengesData];
             
             if (self.header == nil)
             {
                 self.header = [[Header alloc] initWithNibName:@"Header" bundle:nil];
                 [self.view addSubview:header.view];
             }
             [[Globals i] retrieveEnergy];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateHeader"
              object:self]; //Update to header
             
             [self createMarquee];
             
             [self createChat];
             if(!chatTimer.isValid)
             {
                 chatTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(onTimerChat) userInfo:nil repeats:YES];
             }
             
             [self showChallengeBox];
             
             [[Globals i] checkVersion];
             
             //Show badges
             [[Globals i] updateMyAchievementsData];
             [self updateAchievementBadges];
             [[Globals i] updateMailData];
             [self updateMailBadges];
             
             //Pre-load products
             [[Globals i] updateProducts];
             
             [[Globals i] removeLoading];
             
             [[iRate sharedInstance] logEvent:NO];
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
    if (matchPlayedView != nil)
    {
        [matchPlayedView updateView];
    }
    
    [[Globals i] updateChallengesData];
    if (matchChallengeView != nil)
    {
        [matchChallengeView updateView];
    }
}

- (void)showClub
{
    if (clubView == nil)
    {
        clubView = [[ClubView alloc] initWithNibName:@"ClubView" bundle:nil];
        clubView.title = @"My Club";
        clubView.tabBarItem.image = [UIImage imageNamed:@"tab_house"];
    }
    
    if (trophyViewer == nil)
    {
        trophyViewer = [[TrophyViewer alloc] initWithStyle:UITableViewStylePlain];
        trophyViewer.title = @"Trophies";
        trophyViewer.tabBarItem.image = [UIImage imageNamed:@"tab_trophy"];
    }
    trophyViewer.selected_trophy = [[Globals i] wsClubData][@"club_id"];
    
    if (myclubTabBarController == nil)
    {
        myclubTabBarController = [[UITabBarController alloc] init];
        myclubTabBarController.delegate = self;
    }
    
    myclubTabBarController.viewControllers = @[clubView, trophyViewer];
    [myclubTabBarController setSelectedIndex:0];
    [[Globals i] showTemplate:@[myclubTabBarController] :@"Club Details" :1];
    [clubView updateView];
}

- (void)resetClubImages
{
    [clubView resetImages];
}

- (void)showClubViewer:(NSString *)club_id
{
    if (trophyViewer == nil)
    {
        trophyViewer = [[TrophyViewer alloc] initWithStyle:UITableViewStylePlain];
        trophyViewer.title = @"Trophies";
        trophyViewer.tabBarItem.image = [UIImage imageNamed:@"tab_trophy"];
    }
    trophyViewer.selected_trophy = club_id;
    
    if (clubViewer == nil)
    {
        clubViewer = [[ClubViewer alloc] initWithNibName:@"ClubViewer" bundle:nil];
        clubViewer.title = @"Club";
        clubViewer.tabBarItem.image = [UIImage imageNamed:@"tab_house"];
    }
    
    if (mapViewer == nil)
    {
        mapViewer = [[MapViewer alloc] initWithNibName:@"MapViewer" bundle:nil];
        mapViewer.title = @"Map";
        mapViewer.tabBarItem.image = [UIImage imageNamed:@"tab_map"];
    }
    
    if (squadViewer == nil)
    {
        squadViewer = [[SquadViewer alloc] initWithStyle:UITableViewStylePlain];
        squadViewer.title = @"Squad";
        squadViewer.tabBarItem.image = [UIImage imageNamed:@"tab_squad"];
    }
    
    if (clubTabBarController == nil)
    {
        clubTabBarController = [[UITabBarController alloc] init];
        clubTabBarController.delegate = self;
    }
    
    clubTabBarController.viewControllers = @[clubViewer, mapViewer, squadViewer, trophyViewer];
    [clubTabBarController setSelectedIndex:0];
    [[Globals i] showTemplate:@[clubTabBarController] :@"Club Details" :1];
    [clubViewer updateViewId:club_id];
}

- (void)showLeague
{
    if (overView == nil)
    {
        overView = [[OverView alloc] initWithStyle:UITableViewStylePlain];
        overView.title = @"Overview";
        overView.tabBarItem.image = [UIImage imageNamed:@"tab_info"];
    }
    
    if (leagueView == nil)
    {
        leagueView = [[LeagueView alloc] initWithNibName:@"LeagueView" bundle:nil];
        leagueView.title = @"Table";
        leagueView.tabBarItem.image = [UIImage imageNamed:@"tab_leaderboard"];
    }
    
    if (fixturesView == nil)
    {
        fixturesView = [[FixturesView alloc] initWithStyle:UITableViewStylePlain];
        fixturesView.title = @"Fixtures";
        fixturesView.tabBarItem.image = [UIImage imageNamed:@"tab_calendar"];
    }
    
    if (promotionView == nil)
    {
        promotionView = [[PromotionView alloc] initWithNibName:@"PromotionView" bundle:nil];
        promotionView.title = @"Promotion";
        promotionView.tabBarItem.image = [UIImage imageNamed:@"tab_promotion"];
    }
    
    if (scorersView == nil)
    {
        scorersView = [[ScorersView alloc] initWithStyle:UITableViewStylePlain];
        scorersView.title = @"Scorers";
        scorersView.tabBarItem.image = [UIImage imageNamed:@"tab_man"];
    }
    
    if (leagueTabBarController == nil)
    {
        leagueTabBarController = [[UITabBarController alloc] init];
        leagueTabBarController.delegate = self;
    }
    
    leagueTabBarController.viewControllers = @[overView, leagueView, fixturesView, promotionView, scorersView];
    [leagueTabBarController setSelectedIndex:0];
    [[Globals i] showTemplate:@[leagueTabBarController] :@"League" :1];
    [overView updateView];
}

- (void)showTactics
{
    if (formationView == nil)
    {
        formationView = [[FormationView alloc] initWithNibName:@"FormationView" bundle:nil];
        formationView.title = @"Formations";
        formationView.tabBarItem.image = [UIImage imageNamed:@"tab_squad"];
    }
    
    if (subsView == nil)
    {
        subsView = [[SubsView alloc] initWithNibName:@"SubsView" bundle:nil];
        subsView.title = @"Substitute";
        subsView.tabBarItem.image = [UIImage imageNamed:@"tab_id"];
    }
    
    if (tacticsView == nil)
    {
        tacticsView = [[TacticsView alloc] initWithNibName:@"TacticsView" bundle:nil];
        tacticsView.title = @"Tactics";
        tacticsView.tabBarItem.image = [UIImage imageNamed:@"tab_tactics"];
    }
    
    if (tacticsTabBarController == nil)
    {
        tacticsTabBarController = [[UITabBarController alloc] init];
        tacticsTabBarController.delegate = self;
    }
    
    tacticsTabBarController.viewControllers = @[formationView, subsView, tacticsView];
    [tacticsTabBarController setSelectedIndex:0];
    [[Globals i] showTemplate:@[tacticsTabBarController] :@"Formations" :1];
    [formationView updateView];
}

- (void)clearAllClubView
{
    [clubView clearView];
    [trophyViewer clearView];
    [clubViewer clearView];
    [squadViewer updateView];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	//MyClub
	if([viewController.tabBarItem.title isEqualToString:@"My Club"])
	{
        [self clearAllClubView];
		[clubView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Trophies"])
	{
        [self clearAllClubView];
		[trophyViewer updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Club"])
	{
        [self clearAllClubView];
		[clubViewer updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Map"])
	{
        [self clearAllClubView];
		[mapViewer updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Squad"])
	{
        [self clearAllClubView];
		[squadViewer updateView];
	}
    
	//Tactics
	else if([viewController.tabBarItem.title isEqualToString:@"Formations"])
	{
		[formationView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Substitute"])
	{
		[subsView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Tactics"])
	{
		[tacticsView updateView];
	}
    
	//League
    else if([viewController.tabBarItem.title isEqualToString:@"Overview"])
	{
		[overView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Table"])
	{
		[leagueView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Fixtures"])
	{
		[fixturesView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Promotion"])
	{
		[promotionView updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Scorers"])
	{
		[scorersView updateView];
	}
}

- (void)updateHeader
{
	[header updateView];
}

#pragma mark StoreKit Methods
- (void)buyProduct:(NSString *)product
{
	[[Globals i] showDialog:@"PROCESSING... Please wait a while."];
	
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
	[[Globals i] removeDialogBox];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[[Globals i] removeDialogBox];
	[self doTransaction:transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[[Globals i] removeDialogBox];
	[self doTransaction:transaction];
}

- (void)doTransaction:(SKPaymentTransaction *)transaction;
{
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
            [[Globals i] showDialog:@"Thank you for supporting our Games!"];
        }
        else
        {
            //Update failed
            [[Globals i] showDialog:@"Please restart device to take effect."];
            
        }
    }
    else
    {
        //Webservice failed
    }
    
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
}

- (void)refillEnergySuccess:(NSString *)virtualMoney :(NSString *)json
{
	[[Globals i] buyProduct:@"14":virtualMoney:json];
    [header refillEnergy];
}

- (void)buyStadiumSuccess:(NSString *)virtualMoney :(NSString *)json
{
	[[Globals i] buyProduct:@"9":virtualMoney:json];
    
    [[Globals i] showDialog:@"You have upgraded your stadium."];
	
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
    
    [[Globals i] showDialog:@"You have just hired a staff."];
	
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
    [matchView updateView];
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
        sparrowView = [[SPViewController alloc] init];
        sparrowView.multitouchEnabled = YES;
        [sparrowView startWithRoot:[Game class] supportHighResolutions:YES doubleOnPad:NO];
        
        [[Globals i] showTemplate:@[sparrowView] :@"Live Match" :2];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        [SPAudioEngine start];
        sparrowView = [[SPViewController alloc] init];
        sparrowView.multitouchEnabled = YES;
        [sparrowView startWithRoot:[Game_hockey class] supportHighResolutions:YES doubleOnPad:NO];
        
        [[Globals i] showTemplate:@[sparrowView] :@"Live Match" :2];
    }
    else
    {
        [self showMatchReport];
    }
    
    [[Globals i] removeDialogBox];
}

- (void)removeLiveMatch
{
	if(sparrowView != nil)
	{
		[sparrowView.view removeFromSuperview];
        [[Globals i] closeTemplate];
        
        [self showMatchReport];
    }
}

- (void)reportMatch
{
    [self showMatchReport];
    
    [matchReport updateView:[Globals i].challengeMatchId];
    [matchReport redrawView];
}

- (void)showMatchReport
{
    if (matchReport == nil)
    {
        matchReport = [[MatchReport alloc] initWithNibName:@"MatchReport" bundle:nil];
    }
    [[Globals i] showTemplate:@[matchReport] :@"Match Report" :1];
    [matchReport redrawView];
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
            
            currMatchIndex = 0;
            
            [self confirmViewMatch:acceptedMatch];
        }
    }
}

- (void)confirmViewMatch:(NSMutableArray *)a
{
    [[Globals i] showDialogBlock:[NSString stringWithFormat:@"%@ has accepted your Challenge. View the match report?", a[currMatchIndex][@"club_away_name"]]
                                :2
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1)
         {
             [Globals i].challengeMatchId = a[currMatchIndex][@"match_id"];
             [self reportMatch];
         }
         
         if (index == 0)
         {
             currMatchIndex = currMatchIndex + 1;
             if([a count] > currMatchIndex)
             {
                 [self confirmViewMatch:a];
             }
         }
     }];
}

- (void)showJobRefill
{
    if (jobRefill == nil)
    {
        jobRefill = [[JobRefill alloc] initWithNibName:@"JobRefill" bundle:nil];
        jobRefill.titleText = @"REFILL ENERGY?";
    }
    [[Globals i] showTemplate:@[jobRefill] :@"Energy Refill" :0];
	[jobRefill updateView];
}

- (void)showStaff
{
    if (staffView == nil)
    {
        staffView = [[StaffView alloc] initWithStyle:UITableViewStylePlain];
    }
    [[Globals i] showTemplate:@[staffView] :@"Staff" :1];
    [self.staffView updateView];
}

- (void)showCoach
{
    if (trainingView == nil)
    {
        trainingView = [[TrainingView alloc] initWithNibName:@"TrainingView" bundle:nil];
    }
    [[Globals i] showTemplate:@[trainingView] :@"Coach" :1];
    [self.trainingView updateView];
}

- (void)showMap
{
    if (clubMapView == nil)
    {
        clubMapView = [[ClubMapView alloc] init];
    }
    [[Globals i] showTemplate:@[clubMapView] :@"Map" :1];
    [self.clubMapView updateView];
}

- (void)showSquad
{
    if (squadView == nil)
    {
        squadView = [[SquadView alloc] initWithStyle:UITableViewStylePlain];
    }
    [[Globals i] showTemplate:@[squadView] :@"Squad" :1];
    [self.squadView updateView];
}

- (void)showMatch
{
    if (matchView == nil)
    {
        matchView = [[MatchView alloc] initWithStyle:UITableViewStylePlain];
        matchView.title = @"Future";
        matchView.filter = @"Future";
    }
    
    if (matchPlayedView == nil)
    {
        matchPlayedView = [[MatchView alloc] initWithStyle:UITableViewStylePlain];
        matchPlayedView.title = @"Played";
        matchPlayedView.filter = @"Played";
    }
    
    if (matchChallengeView == nil)
    {
        matchChallengeView = [[MatchView alloc] initWithStyle:UITableViewStylePlain];
        matchChallengeView.title = @"Challenge";
        matchChallengeView.filter = @"Challenge";
    }
    
    [[Globals i] showTemplate:@[matchView, matchPlayedView, matchChallengeView] :@"Fixtures" :1];
    [self.matchView updateView];
    [self.matchPlayedView updateView];
    [self.matchChallengeView updateView];
}

- (void)showAchievements
{
    if (achievementsView == nil) 
    {
        achievementsView = [[AchievementsView alloc] initWithStyle:UITableViewStylePlain];
    }
    [[Globals i] showTemplate:@[achievementsView] :@"Task" :1];
    [achievementsView updateView];
    
    [self updateAchievementBadges];
}

- (void)showPlayerStore
{
    if (storePlayer == nil)
    {
        storePlayer = [[StorePlayerView alloc] initWithStyle:UITableViewStylePlain];
    }
	[[Globals i] showTemplate:@[storePlayer] :@"Transfers" :1];
    [self.storePlayer updateView];
}

- (void)showRanking
{
    if (rvTopDivision == nil)
    {
        rvTopDivision = [[RankingView alloc] initWithStyle:UITableViewStylePlain];
        rvTopDivision.title = @"Top Division";
        rvTopDivision.serviceName = @"GetClubsTopDivision";
        rvTopLevel.updateOnWillAppear = @"0";
        [rvTopDivision updateView];
    }
    
    if (rvTopLevel == nil)
    {
        rvTopLevel = [[RankingView alloc] initWithStyle:UITableViewStylePlain];
        rvTopLevel.title = @"Top Level";
        rvTopLevel.serviceName = @"GetClubsTopLevel";
        rvTopLevel.updateOnWillAppear = @"1";
    }
    
    if (allianceView == nil)
    {
        allianceView = [[AllianceView alloc] initWithStyle:UITableViewStylePlain];
    }
    allianceView.title = @"Top Cups";
    allianceView.updateOnWillAppear = @"1";
    
    [[Globals i] showTemplate:@[rvTopDivision, rvTopLevel, allianceView] :@"Rankings" :1];
}

- (void)showSearch
{
    if (rvTopDivision == nil)
    {
        rvTopDivision = [[RankingView alloc] initWithStyle:UITableViewStylePlain];
        rvTopDivision.title = @"Top Division";
        rvTopDivision.serviceName = @"GetClubsTopDivision";
        rvTopLevel.updateOnWillAppear = @"0";
        [rvTopDivision updateView];
    }
    
    if (rvTopLevel == nil)
    {
        rvTopLevel = [[RankingView alloc] initWithStyle:UITableViewStylePlain];
        rvTopLevel.title = @"Top Level";
        rvTopLevel.serviceName = @"GetClubsTopLevel";
        rvTopLevel.updateOnWillAppear = @"1";
    }
    
    if (allianceView == nil)
    {
        allianceView = [[AllianceView alloc] initWithStyle:UITableViewStylePlain];
    }
    allianceView.title = @"Top Cups";
    allianceView.updateOnWillAppear = @"1";
    
    [[Globals i] showTemplate:@[rvTopDivision, rvTopLevel, allianceView] :@"Rankings" :1];
}

- (void)showCup
{
    if([[[Globals i] wsClubData][@"alliance_id"] isEqualToString:@"0"]) //Not in any alliance
    {
        if (allianceView == nil)
        {
            allianceView = [[AllianceView alloc] initWithStyle:UITableViewStylePlain];
        }
        allianceView.title = @"Alliance Cup";
        allianceView.updateOnWillAppear = @"1";
        
        [[Globals i] showTemplate:@[allianceView] :@"Alliance Cup" :1];
    }
    else
    {
        if (allianceDetail == nil)
        {
            allianceDetail = [[AllianceDetail alloc] initWithStyle:UITableViewStylePlain];
        }
        allianceDetail.aAlliance = nil;
        [allianceDetail updateView];
        allianceDetail.title = @"My Alliance Cup";
        
        [[Globals i] showTemplate:@[allianceDetail] :@"Alliance Cup" :1];
    }
}

- (void)showChallengeBox
{
    if (challengeBox == nil)
    {
        challengeBox = [[ChallengeView alloc] initWithNibName:@"ChallengeView" bundle:nil];
    }
    
    [[Globals i] showTemplate:@[challengeBox] :@"Challenge" :0];
	[challengeBox updateView];
    
    [self checkAccepted];
}

- (void)updateAchievementBadges
{
    [cell updateAchievementBadges];
    
    [self.view setNeedsDisplay];
    [mainTableView reloadData];
}

- (void)updateMailBadges
{
    [cell updateMailBadges];
    
    [self.view setNeedsDisplay];
    [mainTableView reloadData];
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
    
    [[Globals i] showTemplate:@[controller] :@"Help" :1];
}

- (void)showFinance
{
    if (financeView == nil)
    {
        financeView = [[FinanceView alloc] initWithStyle:UITableViewStylePlain];
    }
	[[Globals i] showTemplate:@[financeView] :@"Finance" :1];
    [self.financeView updateView];
}

- (void)showFans
{
    if (fansView == nil)
    {
        fansView = [[FansView alloc] initWithNibName:@"FansView" bundle:nil];
    }
	[[Globals i] showTemplate:@[fansView] :@"Fans" :1];
    [self.fansView updateView];
}

- (void)showTrain
{
	if (jobsView == nil)
    {
        jobsView = [[JobsView alloc] initWithNibName:@"JobsView" bundle:nil];
    }
    [[Globals i] showTemplate:@[jobsView] :@"Training" :1];
    [self.jobsView updateView];
}

- (void)showCoachStore
{
    if (storeCoach == nil)
    {
        storeCoach = [[StoreCoachView alloc] initWithStyle:UITableViewStylePlain];
    }
	[[Globals i] showTemplate:@[storeCoach] :@"Job Board" :1];
    [self.storeCoach updateView];
}

- (void)showOthersStore
{
    if (emblemStore == nil)
    {
        emblemStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        emblemStore.title = @"Emblems";
        emblemStore.filter = @"Emblem";
    }
    
    if (homeStore == nil)
    {
        homeStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        homeStore.title = @"Home Jerseys";
        homeStore.filter = @"Home";
    }
    
    if (awayStore == nil)
    {
        awayStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        awayStore.title = @"Away Jerseys";
        awayStore.filter = @"Away";
    }
    
    [[Globals i] showTemplate:@[emblemStore, homeStore, awayStore] :@"Club Store" :1];
    [self.emblemStore updateView];
    [self.homeStore updateView];
    [self.awayStore updateView];
}

- (void)showEmblemStore
{
    if (emblemStore == nil)
    {
        emblemStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        emblemStore.title = @"Emblems";
        emblemStore.filter = @"Emblem";
    }

    [[Globals i] showTemplate:@[emblemStore] :@"Emblems" :1];
    [self.emblemStore updateView];
}

- (void)showHomeStore
{
    if (homeStore == nil)
    {
        homeStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        homeStore.title = @"Home Jerseys";
        homeStore.filter = @"Home";
    }

    [[Globals i] showTemplate:@[homeStore] :@"Home Jerseys" :1];
    [self.homeStore updateView];
}

- (void)showAwayStore
{
    if (awayStore == nil)
    {
        awayStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        awayStore.title = @"Away Jerseys";
        awayStore.filter = @"Away";
    }

    [[Globals i] showTemplate:@[awayStore] :@"Away Jerseys" :1];
    [self.awayStore updateView];
}

- (void)showFundStore
{
    if (fundStore == nil)
    {
        fundStore = [[StoreOthersView alloc] initWithStyle:UITableViewStylePlain];
        fundStore.title = @"Get Funds";
        fundStore.filter = @"Funds";
    }

	[[Globals i] showTemplate:@[fundStore] :@"Get Funds" :1];
    [self.fundStore updateView];
}

- (void)showMail
{
    if(mailView == nil)
    {
        mailView = [[MailView alloc] initWithStyle:UITableViewStylePlain];
    }
    mailView.title = @"Mail";
    [mailView updateView];
    
    [[Globals i] showTemplate:@[mailView] :@"Mail" :1];
    
    [self updateMailBadges];
}

- (void)showChallenge:(NSString *)club_id
{
    if(challengeCreate == nil)
    {
        challengeCreate = [[ChallengeCreateView alloc] initWithNibName:@"ChallengeCreateView" bundle:nil];
    }
    [Globals i].selectedClubId = club_id;
    [challengeCreate updateView];

    [[Globals i] showTemplate:@[challengeCreate] :@"Challenge" :0];
}

- (void)showStadiumMap
{
    if (stadiumMap == nil)
    {
        stadiumMap = [[StadiumMap alloc] initWithNibName:@"StadiumMap" bundle:nil];
    }
    [[Globals i] showTemplate:@[stadiumMap] :@"Stadium" :0];
    [self.stadiumMap updateView];
}

- (void)showSlots
{
	if (slotsView == nil)
    {
        slotsView = [[SlotsView alloc] initWithNibName:@"SlotsView" bundle:nil];
    }
    [[Globals i] showTemplate:@[slotsView] :@"Slots" :0];
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
            [[Globals i] emailToDeveloper];
			break;
		}
		case 22:
		{
			[[Globals i] showMoreGames];
			break;
		}
        case 23:
		{
            [self showHelp];
            break;
		}
        case 24:
		{
			[self logoutButton];
            break;
		}
	}
}

- (void)onTimerMarquee
{
	if(self.marquee.count > 0)
	{
		posxMarquee = posxMarquee-speedMarquee;
		if(posxMarquee < -textSizeMarquee.width)
		{
			posxMarquee = SCREEN_WIDTH;
			rowMarquee = rowMarquee - 1;
			if(rowMarquee < 0)
			{
				rowMarquee = self.marquee.count-1;
			}
			NSDictionary *rowData = (self.marquee)[rowMarquee];
			lblMarquee.text = rowData[@"headline"];
			textSizeMarquee = [[lblMarquee text] sizeWithFont:[lblMarquee font]];
		}
		lblMarquee.frame = CGRectMake(posxMarquee, UIScreen.mainScreen.bounds.size.height-Marquee_height, textSizeMarquee.width, Marquee_height);
	}
}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
	UILabel *label = (UILabel *)gesture.view;
	CGPoint translation = [gesture translationInView:label];
    
    speedMarquee = 0;
    posxMarquee = posxMarquee + 1 + translation.x;

	[gesture setTranslation:CGPointZero inView:label];
    speedMarquee = 1;
}

- (void)createMarquee
{
    if (lblMarquee == nil)
    {
        posxMarquee = SCREEN_WIDTH;
        CGRect lblRect = CGRectMake(posxMarquee, UIScreen.mainScreen.bounds.size.height-Marquee_height, SCREEN_WIDTH, Marquee_height);
        lblMarquee = [[UILabel alloc] initWithFrame:lblRect];
        lblMarquee.tag = 99;
        lblMarquee.userInteractionEnabled = YES;
        lblMarquee.text = @"";
        lblMarquee.backgroundColor = [UIColor grayColor];
        lblMarquee.textColor = [UIColor whiteColor];
        lblMarquee.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
        lblMarquee.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(labelDragged:)];
        [lblMarquee addGestureRecognizer:gesture];
        
        [self showMarquee];
    }
}

- (void)showMarquee
{
	speedMarquee = 1;
    self.marquee = [[Globals i] getMarqueeData];
    [self.view addSubview:lblMarquee];
    if((!marqueeTimer.isValid) && (self.marquee.count > 0))
    {
        rowMarquee = [self.marquee count]-1;
        NSDictionary *rowData = [[Globals i] getMarqueeData][rowMarquee];
        lblMarquee.text = rowData[@"headline"];
        textSizeMarquee = [[lblMarquee text] sizeWithFont:[lblMarquee font]];
        
        marqueeTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(onTimerMarquee) userInfo:nil repeats:YES];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:marqueeTimer forMode:NSRunLoopCommonModes];
        [runloop addTimer:marqueeTimer forMode:UITrackingRunLoopMode];
        [[NSRunLoop mainRunLoop] addTimer:marqueeTimer forMode: NSRunLoopCommonModes];
    }
}

- (void)createChat
{
    if (lblChat1 == nil)
    {
        lblChat1 = [[UILabel alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height-Marquee_height-Chatpreview_height, SCREEN_WIDTH, Chatpreview_height)];
        lblChat1.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SMALL_SIZE];
        lblChat1.textAlignment = NSTextAlignmentLeft;
        lblChat1.textColor = [UIColor grayColor];
        lblChat1.backgroundColor = [UIColor whiteColor];
        lblChat1.layer.borderColor = [UIColor blackColor].CGColor;
        lblChat1.layer.borderWidth = 2.0;
        lblChat1.numberOfLines = 0;
        lblChat1.tag = 999;
        lblChat1.userInteractionEnabled = YES;
        [self.view addSubview:lblChat1];
        
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
        if (CGRectContainsPoint([lblChat1 frame], [touch locationInView:self.view]))
        {
            [self showChat];
        }
    }
}

- (void)showChat
{
	if(chatView == nil)
    {
        chatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
    }
    chatView.title = @"World";
    
    if([[Globals i].wsClubData[@"alliance_id"] isEqualToString:@"0"])
    {
        [[Globals i] showTemplate:@[chatView] :@"Chat" :1];
        [chatView updateView:[[Globals i] wsChatFullData] table:@"chat" a_id:@"0"];
    }
    else
    {
        if(allianceChatView == nil)
        {
            allianceChatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
        }
        allianceChatView.title = @"Alliance Cup";
        
        [[Globals i] showTemplate:@[chatView, allianceChatView] :@"Chat" :1];
        
        [chatView updateView:[[Globals i] wsChatFullData] table:@"chat" a_id:@"0"];
        
        [allianceChatView updateView:[[Globals i] wsAllianceChatFullData] table:@"alliance_chat" a_id:[Globals i].wsClubData[@"alliance_id"]];
        allianceChatView.isAllianceChat = @"1";
    }
}

- (void)onTimerChat
{
    [NSThread detachNewThreadSelector:@selector(getChat) toTarget:self withObject:nil];
}

- (void)getChat
{
    [[Globals i] updateChatData];
    lblChat1.text = [[Globals i] getLastChatString];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell = (MainCell *)[tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (cell == nil)
    {
        cell = [[MainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
	return cell;
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
