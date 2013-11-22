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
#import "StadiumView.h"
#import "UpgradeView.h"
#import "StadiumMap.h"
#import "FansView.h"
#import "FinanceView.h"
#import "StaffView.h"
#import "MatchView.h"
#import "HelpView.h"
#import "ClubMapView.h"
#import "SquadView.h"
#import "FormationView.h"
#import "SubsView.h"
#import "TacticsView.h"
#import "TrainingView.h"
#import "NewsView.h"
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
#import "WelcomeViewController.h"
#import "MainCell.h"
#import "AllianceView.h"
#import "AllianceDetail.h"
#import "Sparrow.h"
#import "Game.h"
#import "Game_hockey.h"

@implementation MainView
@synthesize header;
@synthesize jobsView;
@synthesize clubView;
@synthesize stadiumView;
@synthesize upgradeView;
@synthesize stadiumMap;
@synthesize fansView;
@synthesize financeView;
@synthesize staffView;
@synthesize matchView;
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
@synthesize helpView;
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
@synthesize storeOthers;

- (void)startUp //Called when app opens for the first time
{
    isShowingLogin = NO;
    [[Globals i] pushViewControllerStack:self];
    [[Globals i] saveLocation]; //causes reload again if NO is selected to share location
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"GotoLogin"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"GotoAlliance"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateClubData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeLiveMatch)
                                                 name:@"ExitLiveMatch"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"GotoLogin"])
    {
        [self gotoLogin:NO];
    }
    
    if ([[notification name] isEqualToString:@"GotoAlliance"])
    {
        [self showAlliance];
    }
    
    if ([[notification name] isEqualToString:@"UpdateClubData"])
    {
        [header updateView];
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
    [[Globals i] showLoadingAlert];
    
    if(![[Globals i] updateClubData])
	{
		[self gotoLogin:NO];
	}
    else
    {
        //Updates product identifiers and display dialog if need to upgrade app
        [[Globals i] checkVersion];
        
        NSDictionary *wsClubData = [[Globals i] getClubData];
        [[Globals i] updateMarqueeData
         :wsClubData[@"division"]
         :wsClubData[@"series"]
         :[[Globals i] BoolToBit:wsClubData[@"playing_cup"]]
         ];
        
        [[Globals i] updateCurrentSeasonData];
        [[Globals i] updateMatchData];
        [[Globals i] updateMatchPlayedData];
        [[Globals i] updateChallengesData];
        [[Globals i] updateChallengedData];
        
        if (self.header == nil)
        {
            self.header = [[Header alloc] initWithNibName:@"Header" bundle:nil];
            self.header.mainView = self;
            [self.view addSubview:header.view];
        }
        [[Globals i] retrieveEnergy];
        [header updateView];
        
        [self showMarquee];
        
        //Create Chat
        if(!chatTimer.isValid)
        {
            chatTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(onTimerChat) userInfo:nil repeats:YES];
        }
        
        [self firstTimeWelcome];
        
        [self showChallengeBox];
    }
    
    [[Globals i] removeLoadingAlert];
}

-(void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *alertMsg;
    
    if( userInfo[@"aps"][@"alert"] != nil)
    {
        alertMsg = userInfo[@"aps"][@"alert"];
        [[Globals i] showDialog:alertMsg];
    }
    else
    {
        alertMsg = @"{no alert message in dictionary}";
    }
    
    [NSThread detachNewThreadSelector:@selector(reloadNotification) toTarget:self withObject:nil];
}

- (void)reloadNotification
{
	@autoreleasepool {
        
        if([[Globals i] updateClubData])
        {
            [[Globals i] updateChallengesData];
            [[Globals i] updateMatchPlayedData];
            
            [self performSelectorOnMainThread:@selector(showChallengeBox)
                                   withObject:nil
                                waitUntilDone:YES];
        }
    }
}

- (void)viewDidLoad
{
	[Globals i].selectedClubId = @"0";
	[Globals i].workingUrl = @"0";
	[Globals i].challengeMatchId = @"0";
    
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [self createChat];
    
	[self createMarquee];
	
	self.clubView = [[ClubView alloc] initWithNibName:@"ClubView" bundle:nil];

	self.clubMapView = [[ClubMapView alloc] initWithNibName:@"ClubMapView" bundle:nil];
	
	self.squadView = [[SquadView alloc] initWithNibName:@"SquadView" bundle:nil];
	
	self.trainingView = [[TrainingView alloc] initWithNibName:@"TrainingView" bundle:nil];
	
	((ClubView*)[myclubTabBarController viewControllers][0]).mainView = self;
	
	((ClubViewer*)[clubTabBarController viewControllers][0]).mainView = self;
	((MapViewer*)[clubTabBarController viewControllers][1]).mainView = self;
	((SquadViewer*)[clubTabBarController viewControllers][2]).mainView = self;
	((TrophyViewer*)[clubTabBarController viewControllers][3]).mainView = self;
    
    ((OverView*)[leagueTabBarController viewControllers][0]).mainView = self;
	((LeagueView*)[leagueTabBarController viewControllers][1]).mainView = self;
	((FixturesView*)[leagueTabBarController viewControllers][2]).mainView = self;
	((PromotionView*)[leagueTabBarController viewControllers][3]).mainView = self;
	((ScorersView*)[leagueTabBarController viewControllers][4]).mainView = self;
	
	((FormationView*)[tacticsTabBarController viewControllers][0]).mainView = self;
	((SubsView*)[tacticsTabBarController viewControllers][1]).mainView = self;
	((TacticsView*)[tacticsTabBarController viewControllers][2]).mainView = self;
}

- (void)showClub
{
	[(ClubView*)[myclubTabBarController viewControllers][0] updateView];
    [[Globals i] showTemplate:@[myclubTabBarController] :@"Club Details" :1];
    ((TrophyViewer*)[myclubTabBarController viewControllers][1]).selected_trophy = [[[Globals i] wsClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    [(ClubView*)[myclubTabBarController viewControllers][0] updateView];
    myclubTabBarController.selectedIndex = 0;
}

- (void)showClubViewer:(NSString *)club_id
{
    [[Globals i] showTemplate:@[clubTabBarController] :@"Club Details" :0];
    
	((TrophyViewer*)[clubTabBarController viewControllers][3]).selected_trophy = club_id;
	[(ClubViewer*)[clubTabBarController viewControllers][0] updateViewId:club_id];
	clubTabBarController.selectedIndex = 0;
}

- (void)showLeague
{
    [[Globals i] showTemplate:@[leagueTabBarController] :@"League" :1];
    [(LeagueView*)[leagueTabBarController viewControllers][0] updateView];
}

- (void)showTactics
{
    [[Globals i] showTemplate:@[tacticsTabBarController] :@"Tactics" :1];
    [(FormationView*)[tacticsTabBarController viewControllers][0] updateView];
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
        if([[Globals i] updateClubData])
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
    
	if([[[Globals i] gettPurchasedProduct] intValue] < 9)
	{
        if([[[Globals i] gettPurchasedProduct] intValue] != 0)
        {
            [self buyStaffSuccess:@"0":json];
        }
	}
	else if([[[Globals i] gettPurchasedProduct] intValue] == 9)
	{
		[self buyStadiumSuccess:@"0":json];
	}
	else if([[[Globals i] gettPurchasedProduct] intValue] == 10)
	{
		[self renameClubPurchaseSuccess:@"0":json];
	}
	else if([[[Globals i] gettPurchasedProduct] intValue] == 13)
	{
		[self buyResetClub];
	}
	else if([[[Globals i] gettPurchasedProduct] intValue] == 14)
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
	
	[[Globals i] updateClubData];
	[self.stadiumView updateView];
    [self.stadiumMap updateView];
    
    [self.stadiumView.view removeFromSuperview];
	
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
	
	[[Globals i] updateClubData];
	[self.staffView updateView];
	
	NSString *message = @"I have just hired more staff for my club. Come over and play a match with me.";
	NSString *extra_desc = @"You can hire managers, scouts, assistant coaches, accountant1, spokesperson1, psychologist1, physiotherapist1, doctor1. ";
	NSString *imagename = @"hire_staff.png";
	[[Globals i] fbPublishStory:message:extra_desc:imagename];
}

- (void)renameClubPurchaseSuccess:(NSString *)virtualMoney :(NSString *)json
{
	[[Globals i] buyProduct:@"10":virtualMoney:json];
    
    /*
    [self createDialogBox];
	dialogBox.titleText = @"RENAME CLUB";
	dialogBox.whiteText = @"Enter a new name for your club.";
	dialogBox.dialogType = 4;
	[[activeView superview] insertSubview:dialogBox.view atIndex:7];
	[dialogBox updateView];
     */
}

- (void)returnText:(NSString *)text
{
	[[Globals i] removeDialogBox];
	
	NSString *returnValue = @"0";
	if([text isEqualToString:@""])
	{
		//returnValue = @"0";
	}
	else 
	{
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/Rename/%@/%@", 
						   WS_URL, [[Globals i] UID], text];
		NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSURL *url = [[NSURL alloc] initWithString:wsurl2];
		returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		
	}
	
	if([returnValue isEqualToString:@"1"])
	{
		[[Globals i] updateClubData];
        
        [[Globals i] showDialog:@"Your club name has been changed successfully."];
		
		NSString *message = [NSString stringWithFormat:@"I have just renamed my club to %@", text];
		NSString *extra_desc = @"You can rename your club anytime you feel like it, but make sure to inform your friends. ";
		NSString *imagename = @"rename_club.png";
		[[Globals i] fbPublishStory:message:extra_desc:imagename];
	}
	else
	{
        /*
        [self createDialogBox];
		dialogBox.titleText = @"NAME EXIST OR NOT VALID";
		dialogBox.whiteText = @"Enter another name.";
		dialogBox.dialogType = 4;
		[[activeView superview] insertSubview:dialogBox.view atIndex:7];
		[dialogBox updateView];
         */
	}
}

- (void)buyCoachSuccess
{
	[[Globals i] buyCoach:[Globals i].purchasedCoachId];
    
    [[Globals i] showDialog:@"A new coach has been assigned to your club."];
	
	[[Globals i] updateClubData];

	[self.storeCoach forceUpdate];
	
	NSString *message = @"I have just signed up a new Coach.";
	NSString *extra_desc = @"Keep an eye on the job board for new coaches. A good coach improves the training of your team significantly. ";
	NSString *imagename = @"new_coach.png";
	[[Globals i] fbPublishStory:message:extra_desc:imagename];
}

- (void)buyResetClub
{
	[[Globals i] resetClub];
	[[Globals i] updateClubData];
    
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
	
	[[Globals i] updateClubData];
	[self resetClubImages];
}

- (void)buyOthersSuccessWithDiamonds
{
	NSString *productId = [[Globals i] gettPurchasedProduct];
	[[Globals i] buyProduct:productId:@"2":@"0"];
    
    [[Globals i] showDialog:@"Purchase and upgrades for your club is completed."];
	
	[[Globals i] updateClubData];
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
			[[Globals i] updateChallengesData];
			[[Globals i] updateMatchPlayedData];
			[matchView updateView];
			
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
				[[Globals i] updateChallengesData];
				[[Globals i] updateMatchPlayedData];
				[matchView updateView];
				
				//Get match results
				[[Globals i] updateMatchInfoData:[Globals i].challengeMatchId];
				
				[self performSelectorOnMainThread:@selector(liveMatch)
									   withObject:nil
									waitUntilDone:NO];
			}
			else 
			{
            [[Globals i] showDialog:@"Club is playing a match now, try accept again."];
			}
		}
		
		[[Globals i] removeDialogBox];
	
	}
}

- (void)liveMatch
{
    [[Globals i] updateMatchHighlightsData:[Globals i].challengeMatchId];
    
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        [lblMarquee removeFromSuperview];
        [SPAudioEngine start];
        sparrowView = [[SPViewController alloc] init];
        sparrowView.multitouchEnabled = YES;
        [sparrowView startWithRoot:[Game class] supportHighResolutions:YES doubleOnPad:YES];
        
        [[Globals i] showTemplate:@[sparrowView] :@"Live Match" :0];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        [lblMarquee removeFromSuperview];
        [SPAudioEngine start];
        sparrowView = [[SPViewController alloc] init];
        sparrowView.multitouchEnabled = YES;
        [sparrowView startWithRoot:[Game_hockey class] supportHighResolutions:YES doubleOnPad:YES];
        
        [[Globals i] showTemplate:@[sparrowView] :@"Live Match" :0];
    }
    else
    {
        [self showMatchReport];
    }
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
        matchReport.mainView = self;
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
            [[Globals i] settAccepted:[NSString stringWithFormat:@"%d", highestMatchID]];
            
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

- (void)showWelcome
{
    if (welcomeView == nil)
    {
        welcomeView = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    }
    
    [[Globals i] showTemplate:@[welcomeView] :@"Welcome" :0];
}

- (void)showStaff
{
    if (staffView == nil)
    {
        staffView = [[StaffView alloc] initWithNibName:@"StaffView" bundle:nil];
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
        clubMapView = [[ClubMapView alloc] initWithNibName:@"ClubMapView" bundle:nil];
    }
    [[Globals i] showTemplate:@[clubMapView] :@"Map" :1];
    [self.clubMapView updateView];
}

- (void)showSquad
{
    if (squadView == nil)
    {
        squadView = [[SquadView alloc] initWithNibName:@"SquadView" bundle:nil];
    }
    [[Globals i] showTemplate:@[squadView] :@"Players" :1];
    [self.squadView updateView];
}

- (void)showMatch
{
    if (matchView == nil)
    {
        matchView = [[MatchView alloc] initWithNibName:@"MatchView" bundle:nil];
    }
    [[Globals i] showTemplate:@[matchView] :@"Match" :1];
    [self.matchView updateView];
}

- (void)showAchievements
{
    if (achievementsView == nil) 
    {
        achievementsView = [[AchievementsView alloc] initWithStyle:UITableViewStylePlain];
    }
    achievementsView.title = @"Achievements 1";
    
    [[Globals i] showTemplate:@[achievementsView] :@"Achievements" :1];
    [achievementsView updateView];
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

- (void)showAlliance
{
    if([[[Globals i] wsWorldClubData][@"alliance_id"] isEqualToString:@"0"]) //Not in any alliance
    {
        if (allianceView == nil)
        {
            allianceView = [[AllianceView alloc] initWithStyle:UITableViewStylePlain];
        }
        [allianceView updateView];
        allianceView.title = @"Alliances";
        
        [[Globals i] showTemplate:@[allianceView] :@"Alliance" :1];
    }
    else
    {
        if (allianceDetail == nil)
        {
            allianceDetail = [[AllianceDetail alloc] initWithStyle:UITableViewStylePlain];
        }
        allianceDetail.aAlliance = nil;
        [allianceDetail updateView];
        allianceDetail.title = @"My Alliance";
        
        [[Globals i] showTemplate:@[allianceDetail] :@"Alliance" :1];
    }
}

- (void)showChallengeBox
{
    if (challengeBox == nil)
    {
        challengeBox = [[ChallengeView alloc] initWithNibName:@"ChallengeView" bundle:nil];
        challengeBox.mainView = self;
    }
    
    [[Globals i] showTemplate:@[challengeBox] :@"Challenge" :0];
	[challengeBox updateView];
    
    [self checkAccepted];
}

- (void)firstTimeWelcome
{
	//Show welcome if first time
	NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSMutableString *savePath = [NSMutableString stringWithString:savePaths[0]];
	[savePath appendString:@"/firsttime.txt"];
	NSString *firsttime = [[NSString alloc] initWithContentsOfFile:savePath encoding:NSUTF8StringEncoding error:Nil];
    
	if(firsttime == nil)
    {
		firsttime = @"1";
		NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSMutableString *savePath = [NSMutableString stringWithString:savePaths[0]];
		[savePath appendString:@"/firsttime.txt"];
		
		[firsttime writeToFile: savePath
					atomically: YES
					  encoding: NSUTF8StringEncoding
						 error: nil];
		
		[self showWelcome];
	}
}

- (void)updateAchievementBadges
{
    [cell updateAchievementBadges];
    [mainTableView reloadData];
}

- (void)onTimerChat
{
    [NSThread detachNewThreadSelector: @selector(getChat) toTarget:self withObject:nil];
}

- (void)getChat
{
    [[Globals i] updateChatData];
    lblChat1.text = [[Globals i] getLastChatString];
}

- (void)updateHeader
{
	[header updateView];
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

- (void)showHelp
{
	if (helpView == nil)
    {
        helpView = [[HelpView alloc] initWithNibName:@"HelpView" bundle:nil];
        helpView.mainView = self;
    }
    [[Globals i] showTemplate:@[helpView] :@"Help" :0];
}

- (void)showFinance
{
    if (financeView == nil)
    {
        financeView = [[FinanceView alloc] initWithNibName:@"FinanceView" bundle:nil];
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
    
    [[Globals i] showTemplate:@[jobsView] :@"Jobs" :1];
    [self.jobsView updateView];
}

- (void)showNews
{
    if (newsView == nil)
    {
        newsView = [[NewsView alloc] initWithNibName:@"NewsView" bundle:nil];
    }
	[[Globals i] showTemplate:@[newsView] :@"News" :1];
    [self.newsView updateView];
}

- (void)showCoachStore
{
    if (storeCoach == nil)
    {
        storeCoach = [[StoreCoachView alloc] initWithNibName:@"StoreCoachView" bundle:nil];
    }
	[[Globals i] showTemplate:@[storeCoach] :@"Job Board" :1];
    [self.storeCoach updateView];
}

- (void)showOthersStore
{
    if (storeOthers == nil)
    {
        storeOthers = [[StoreOthersView alloc] initWithNibName:@"StoreOthersView" bundle:nil];
    }
	[[Globals i] showTemplate:@[storeOthers] :@"Store" :1];
    [self.storeOthers updateView];
}

- (void)resetClubImages
{
	[self.clubView resetImages];
}

- (void)showChallenge:(NSString *)club_id
{
    if(challengeCreate == nil)
    {
        challengeCreate = [[ChallengeCreateView alloc] initWithNibName:@"ChallengeCreateView" bundle:nil];
    }
    [Globals i].selectedClubId = [club_id stringByReplacingOccurrencesOfString:@"," withString:@""];
	challengeCreate.mainView = self;
    [challengeCreate updateView];

    [[Globals i] showTemplate:@[challengeCreate] :@"Challenge" :0];
}

- (void)showStadiumMap
{
    if (stadiumMap == nil)
    {
        stadiumMap = [[StadiumMap alloc] initWithNibName:@"StadiumMap" bundle:nil];
    }
    [[Globals i] showTemplate:@[stadiumMap] :@"Stadium" :1];
    [self.stadiumMap updateView];
}

- (void)showStadiumUpgrade
{
    if (stadiumView == nil)
    {
        stadiumView = [[StadiumView alloc] initWithNibName:@"StadiumView" bundle:nil];
    }
    [self.stadiumMap.view addSubview:stadiumView.view];
    [self.stadiumView updateView];
}

- (void)showBuildingUpgrade:(int)type;
{
    if (upgradeView == nil)
    {
        upgradeView = [[UpgradeView alloc] initWithNibName:@"UpgradeView" bundle:nil];
    }
    [self.stadiumMap.view addSubview:upgradeView.view];
    [self.upgradeView updateView:type];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	//MyClub
	if([viewController.tabBarItem.title isEqualToString:@"My Club"])
	{
		[(ClubView*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Trophies"])
	{
		[(TrophyViewer*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Club"])
	{
		[(ClubViewer*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Map"])
	{
		[(MapViewer*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Squad"])
	{
		[(SquadViewer*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Players"])
	{
		[(StorePlayerView*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Coaches"])
	{
		[(StoreCoachView*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Others"])
	{
		[(StoreOthersView*)viewController updateView];
	}
    
	//Tactics
	else if([viewController.tabBarItem.title isEqualToString:@"Formation"])
	{
		[(FormationView*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Substitute"])
	{
		[(SubsView*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Tactics"])
	{
		[(TacticsView*)viewController updateView];
	}
    
	//League
    else if([viewController.tabBarItem.title isEqualToString:@"Overview"])
	{
		[(OverView*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Table"])
	{
		[(LeagueView*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Fixtures"])
	{
		[(FixturesView*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Promotion"])
	{
		[(PromotionView*)viewController updateView];
	}
	else if([viewController.tabBarItem.title isEqualToString:@"Scorers"])
	{
		[(ScorersView*)viewController updateView];
	}
}

-(void)menuButton_tap:(int)sender
{
	switch(sender)
	{
		case 1:
		{
			[self showMatch];
			break;
		}		
		case 2:
		{
			[self showLeague];
			break;
		}
		case 3:
		{
			break;
		}
		case 4:
		{
			[self showSquad];
			break;
		}
		case 5:
		{
			[self showTactics];
			break;
		}			
		case 6:
		{
			[self showCoach];
			break;
		}
		case 7:
		{
			[self showPlayerStore];
			break;
		}
        case 8:
		{
			[self showStaff];
			break;
		}
		case 9:
		{
			[self showMap];
			break;
		}
		case 10:
		{
			//[self showSearch];
			break;
		}
        case 11:
		{
            [[Globals i] fblogin];
			break;
		}
        case 12:
		{
			[self showFinance];
			break;
		}
		case 13:
		{
			[self showFans];
            break;
		}
        case 14:
		{
			[self showOthersStore];
			break;
		}
		case 15:
		{
			[self showNews];
			break;
		}
		case 16:
		{
            [self showAchievements];
			break;
		}
        case 17:
		{
            [[Globals i] showChat];
			break;
		}
		case 18:
		{
			//[self showAbout];
			break;
		}
		case 19:
		{
			[self showHelp];
			break;
		}
        case 20:
		{
			//[self startPicker];
            break;
		}
        case 21:
		{
			[self showClub];
            break;
		}
        case 22:
		{
			[self showAlliance];
            break;
		}
        case 23:
		{
            [self showStadiumMap];
			break;
		}
		case 24:
		{
			[self showTrain];
			break;
		}
        case 25:
		{
            [self logoutButton];
			break;
		}
		case 26:
		{
			[self shareButton];
			break;
		}
        case 27:
		{
            [self showAlliance];
			break;
		}
	}
}

-(void)onTimerMarquee
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
    }
}

- (void)createChat
{
    if (lblChat1 == nil)
    {
        lblChat1 = [[UILabel alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height-Marquee_height-40, SCREEN_WIDTH, 320)];
        lblChat1.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
        lblChat1.textAlignment = NSTextAlignmentCenter;
        lblChat1.textColor = [UIColor grayColor];
        lblChat1.backgroundColor = [UIColor whiteColor];
        lblChat1.layer.borderColor = [UIColor blackColor].CGColor;
        lblChat1.layer.borderWidth = 2.0;
        lblChat1.numberOfLines = 3;
        lblChat1.tag = 999;
        lblChat1.userInteractionEnabled = YES;
        
        [self.view addSubview:lblChat1];
    }
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"MainCell";
	
	cell = (MainCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCell" owner:self options:nil];
		cell = (MainCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
    cell.mainView = self;
    cell.backgroundColor = [UIColor clearColor];
    
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (CGRectContainsPoint([lblChat1 frame], [touch locationInView:self.view]))
    {
        [[Globals i] showChat];
    }
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

- (void)shareButton
{
    NSString *message = @"Check out this very cool App!";
	NSString *caption = @"Come on and join in the fun.";
	NSString *picture = @"Icon-72.png";
    
    [[Globals i] fbPublishStory:message :caption :picture];
    
    [[Globals i] showDialog:@"Thank you for sharing this App with your friends. Challenge your friends and level up even faster!"];
}

@end
