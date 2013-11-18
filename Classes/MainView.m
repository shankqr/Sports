//
//  MainView.m
//  FFC
//
//  Created by Shankar on 6/3/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MainView.h"
#import "Globals.h"
#import "FFCAppDelegate.h"
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
#import "ChatView.h"
#import "MatchReport.h"
#import "AchievementsView.h"
#import "WelcomeViewController.h"
#import "NSString+HMAC.h"
#import "FriendProtocols.h"
#import "MainCell.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "Sparrow.h"
#import "Game.h"
#import "Game_hockey.h"

@implementation MainView
@synthesize activeView;
@synthesize previousView;
@synthesize superView;
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
@synthesize clubSearchView;
@synthesize clubMapView;
@synthesize squadView;
@synthesize trainingView;
@synthesize newsView;
@synthesize friendsView;
@synthesize clubTabBarController;
@synthesize storeTabBarController;
@synthesize tacticsTabBarController;
@synthesize leagueTabBarController;
@synthesize achievementsView;
@synthesize allianceView;
@synthesize allianceDetail;
@synthesize matchLive;
@synthesize helpView;
@synthesize chatView;
@synthesize matchReport;
@synthesize welcomeView;
@synthesize challengeBox;
@synthesize challengeCreate;
@synthesize aboutBox;
@synthesize animateViewTimer;
@synthesize marqueeTimer;
@synthesize chatTimer;
@synthesize lblChat1;
@synthesize lblChat2;
@synthesize marquee;
@synthesize lblMarquee;
@synthesize alertLoading;
@synthesize myclubTabBarController;
@synthesize buttonAudio;
@synthesize backAudio;
@synthesize moneyAudio;
@synthesize winAudio;
@synthesize loseAudio;
@synthesize backButton;
@synthesize sparrowView;
@synthesize footerView;
@synthesize menu0;
@synthesize mainTableView;
@synthesize cell;

- (void)saveLocation
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // We don't want to be notified of small changes in location, preferring to use our
    // last cached results, if any.
    locationManager.distanceFilter = 50;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!oldLocation ||
        (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
         oldLocation.coordinate.longitude != newLocation.coordinate.longitude &&
         newLocation.horizontalAccuracy <= 100.0))
    {
        NSString *latitude = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.latitude];
		NSString *longitude = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.longitude];
        
        if (![latitude isEqual: @"0"])
        {
            [[Globals i] setLat:latitude];
        }

        if (![longitude isEqual: @"0"])
        {
            [[Globals i] setLongi:longitude];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"%@", error);
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

#pragma mark StoreKit Methods
- (void)buyProduct:(NSString *)product
{
	[self showWaitingBox];
	
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
            [self updateHeader];
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
	[self updateHeader];
	[self.stadiumView updateView];
    [self.stadiumMap updateView];
    
    [self.stadiumView.view removeFromSuperview];
	
	NSString *message = @"I have just upgraded my arena. Come over and play a match with me.";
	NSString *extra_desc = @"A big portion of club revenue comes from ticket sales of matches played at your stadium. Upgrade your stadium to increase seating capacity and average ticket price per match. ";
	NSString *imagename = @"upgrade_stadium.png";
	[self FallbackPublishStory:message:extra_desc:imagename];
}

- (void)buyStaffSuccess:(NSString *)virtualMoney :(NSString *)json
{
	NSString *productId = [[Globals i] gettPurchasedProduct];
	[[Globals i] buyProduct:productId:virtualMoney:json];
    
    [[Globals i] showDialog:@"You have just hired a staff."];
	
	[[Globals i] updateClubData];
	[self updateHeader];
	[self.staffView updateView];
	
	NSString *message = @"I have just hired more staff for my club. Come over and play a match with me.";
	NSString *extra_desc = @"You can hire managers, scouts, assistant coaches, accountant1, spokesperson1, psychologist1, physiotherapist1, doctor1. ";
	NSString *imagename = @"hire_staff.png";
	[self FallbackPublishStory:message:extra_desc:imagename];
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
		[self updateHeader];
        
        [[Globals i] showDialog:@"Your club name has been changed successfully."];
		
		NSString *message = [NSString stringWithFormat:@"I have just renamed my club to %@", text];
		NSString *extra_desc = @"You can rename your club anytime you feel like it, but make sure to inform your friends. ";
		NSString *imagename = @"rename_club.png";
		[self FallbackPublishStory:message:extra_desc:imagename];
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
	[[Globals i] buyCoach: [Globals i].purchasedCoachId];
    
    [[Globals i] showDialog:@"A new coach has been assigned to your club."];
	
	[[Globals i] updateClubData];
	[self updateHeader];
	//[(StoreCoachView*)[[storeTabBarController viewControllers] objectAtIndex:1] updateView];
	[(StoreCoachView*)[storeTabBarController viewControllers][1] forceUpdate];
	
	NSString *message = @"I have just signed up a new Coach.";
	NSString *extra_desc = @"Keep an eye on the job board for new coaches. A good coach improves the training of your team significantly. ";
	NSString *imagename = @"new_coach.png";
	[self FallbackPublishStory:message:extra_desc:imagename];
}

- (void)buyResetClub
{
	[[Globals i] resetClub];
	[[Globals i] updateClubData];
	[self updateHeader];
    
    [[Globals i] showDialog:@"Your club has been reset successfully."];
	
	NSString *message = @"I have just reset my club!";
	NSString *extra_desc = @"You can reset your club if you want to start again from scratch. ";
	NSString *imagename = @"rename_club.png";
	[self FallbackPublishStory:message:extra_desc:imagename];
}

- (void)buyOthersSuccess
{
	NSString *productId = [[Globals i] gettPurchasedProduct];
	[[Globals i] buyProduct:productId:@"1":@"0"];
    
    [[Globals i] showDialog:@"Purchase and upgrades for your club is completed."];
	
	[[Globals i] updateClubData];
	[self updateHeader];
	[self resetClubImages];
}

- (void)buyOthersSuccessWithDiamonds
{
	NSString *productId = [[Globals i] gettPurchasedProduct];
	[[Globals i] buyProduct:productId:@"2":@"0"];
    
    [[Globals i] showDialog:@"Purchase and upgrades for your club is completed."];
	
	[[Globals i] updateClubData];
	[self updateHeader];
	[self resetClubImages];
}

- (void)updateChallenge
{
    [[Globals i] updateChallengesData];
    [matchView updateView];
}

- (void)DeclineChallenge
{
	[NSThread detachNewThreadSelector: @selector(DeclineChallengeServer) toTarget:self withObject:nil];
}

- (void)DeclineChallengeServer
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
    [self removeAchievements];
    [self removeWelcome];
    
	[self showWaitingBox];
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
    
    [self hideHeader];
	[self hideFooter];
    
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        [lblMarquee removeFromSuperview];
        [SPAudioEngine start];
        sparrowView = [[SPViewController alloc] init];
        sparrowView.multitouchEnabled = YES;
        [sparrowView startWithRoot:[Game class] supportHighResolutions:YES doubleOnPad:YES];
        [superView insertSubview:sparrowView.view atIndex:3];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        [lblMarquee removeFromSuperview];
        [SPAudioEngine start];
        sparrowView = [[SPViewController alloc] init];
        sparrowView.multitouchEnabled = YES;
        [sparrowView startWithRoot:[Game_hockey class] supportHighResolutions:YES doubleOnPad:YES];
        [superView insertSubview:sparrowView.view atIndex:3];
    }
    else
    {
        [superView insertSubview:matchReport.view atIndex:3];
        [matchReport redrawView];
    }
}

- (void)removeLiveMatch
{
	if(sparrowView != nil)
	{
		[sparrowView.view removeFromSuperview];
        
        [superView insertSubview:lblMarquee atIndex:2];
        [superView insertSubview:matchReport.view atIndex:3];
        [matchReport redrawView];
    }
}

- (void)reportMatch
{
    [self hideHeader];
	[self hideFooter];
    
	[matchReport updateView:[Globals i].challengeMatchId];
	[superView insertSubview:matchReport.view atIndex:3];
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
    [[Globals i] showDialog:self.view
                           :@""
                           :@"Assistant Manager"
                           :[NSString stringWithFormat:@"%@ has accepted your Challenge. View the match report?", a[currMatchIndex][@"club_away_name"]]
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

- (void)showWaitingBox
{
    /*
    [self createDialogBox];
	dialogBox.titleText = @"PROCESSING...";
	dialogBox.whiteText = @"- Please Wait -";
	dialogBox.dialogType = 0;
	[[activeView superview] insertSubview:dialogBox.view atIndex:5];
	[dialogBox updateView];
     */
}

-(void)showLogin //Back to login view
{
    [FBSession.activeSession closeAndClearTokenInformation];
    
    FFCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate gotoLogin];
}

-(void)showWelcome
{
    if (welcomeView == nil)
    {
        welcomeView = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        welcomeView.mainView = self;
    }

    [superView insertSubview:welcomeView.view atIndex:5];
}

-(void)removeWelcome
{
    if (welcomeView != nil)
    {
        [welcomeView.view removeFromSuperview];
        //welcomeView = nil;
    }
}

-(void)showAchievements
{
    [self hideHeader];
        
    if (achievementsView == nil) 
    {
        achievementsView = [[AchievementsView alloc] initWithNibName:@"AchievementsView" bundle:nil];
        achievementsView.mainView = self;
    }
    [achievementsView updateView];
    [superView insertSubview:achievementsView.view atIndex:4];
}

-(void)showAlliance
{

}

-(void)showAllianceDetail:(int)aid
{

}

-(void)removeAchievements
{
    [self showHeader];
    [achievementsView.view removeFromSuperview];
}

#pragma mark PushNotification
-(void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *alertMsg;
    
    if( userInfo[@"aps"][@"alert"] != nil)
    {
        alertMsg = userInfo[@"aps"][@"alert"]; 
    }
    else
    {    
        alertMsg = @"{no alert message in dictionary}";
    }
    
    [NSThread detachNewThreadSelector:@selector(reloadClub) toTarget:self withObject:nil];
    
    [[Globals i] showDialog:alertMsg];
}

- (void)removeStore
{
    if ((activeView != nil) && (activeView == storeTabBarController.view))
    {
        if (storeTabBarController.selectedIndex == 0)
        {
            [backButton removeFromSuperview];
            [self switchView:self.view go:activeView dir:2];
        }
    }
    else
    {
        if (activeView == nil)
        {
            activeView = self.view;
        }
    }
}

- (void)showChallengeBox
{
    if (challengeBox == nil)
    {
        challengeBox = [[ChallengeView alloc] initWithNibName:@"ChallengeView" bundle:nil];
        challengeBox.mainView = self;
    }
    
    [superView insertSubview:challengeBox.view atIndex:17];
	[challengeBox updateView];
    
    [self checkAccepted];
}

- (void)addFunds
{

}

- (void)addDiamonds
{

}

- (void)initSound
{	
	//Setup button sound
	NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_button.aif", [[NSBundle mainBundle] resourcePath]]];
	buttonAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
    buttonAudio.numberOfLoops = 0;
    buttonAudio.volume = 1.0;
	
	//Setup back sound
	NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_back.aif", [[NSBundle mainBundle] resourcePath]]];
	backAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
	backAudio.numberOfLoops = 0;
    backAudio.volume = 1.0;
    
    //Setup money sound
	NSURL *url4 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_cash.caf", [[NSBundle mainBundle] resourcePath]]];
	moneyAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url4 error:nil];
	moneyAudio.numberOfLoops = 0;
    moneyAudio.volume = 1.0;
    
    //Setup win sound
	NSURL *url5 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_crowd_goal.caf", [[NSBundle mainBundle] resourcePath]]];
	winAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url5 error:nil];
	winAudio.numberOfLoops = 0;
    winAudio.volume = 1.0;
    
    //Setup lose sound
	NSURL *url6 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_crowd0.caf", [[NSBundle mainBundle] resourcePath]]];
	loseAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url6 error:nil];
	loseAudio.numberOfLoops = 0;
    loseAudio.volume = 1.0;
}

- (void)viewDidLoad
{
	activeView = self.view;
	posxView = SCREEN_WIDTH;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeLiveMatch)
                                                 name:@"ExitLiveMatch"
                                               object:nil];
	
	Header *headerViewController = [[Header alloc] initWithNibName:@"Header" bundle:nil];
	headerViewController.mainView = self;
	self.header = headerViewController;
	
	[self initSound];
	
	[Globals i].selectedClubId = @"0";
	[Globals i].workingUrl = @"0";
	[Globals i].challengeMatchId = @"0";
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
	[self createBackButton];
        
    matchReport = [[MatchReport alloc] initWithNibName:@"MatchReport" bundle:nil];
	matchReport.mainView = self;
	
	ClubView *clubViewController = [[ClubView alloc] initWithNibName:@"ClubView" bundle:nil];
	clubViewController.mainView = self;
	self.clubView = clubViewController;
	
	StadiumView *stadiumViewController = [[StadiumView alloc] initWithNibName:@"StadiumView" bundle:nil];
	stadiumViewController.mainView = self;
	self.stadiumView = stadiumViewController;
    
    UpgradeView *upgradeViewController = [[UpgradeView alloc] initWithNibName:@"UpgradeView" bundle:nil];
	upgradeViewController.mainView = self;
	self.upgradeView = upgradeViewController;
    
    StadiumMap *stadiumMapController = [[StadiumMap alloc] initWithNibName:@"StadiumMap" bundle:nil];
	stadiumMapController.mainView = self;
	self.stadiumMap = stadiumMapController;
	
	FansView *fansViewController = [[FansView alloc] initWithNibName:@"FansView" bundle:nil];
	fansViewController.mainView = self;
	self.fansView = fansViewController;
	
	FinanceView *financeViewController = [[FinanceView alloc] initWithNibName:@"FinanceView" bundle:nil];
	financeViewController.mainView = self;
	self.financeView = financeViewController;
	
	StaffView *staffViewController = [[StaffView alloc] initWithNibName:@"StaffView" bundle:nil];
	staffViewController.mainView = self;
	self.staffView = staffViewController;
	
	MatchView *matchViewController = [[MatchView alloc] initWithNibName:@"MatchView" bundle:nil];
	matchViewController.mainView = self;
	self.matchView = matchViewController;
	
	ClubMapView *clubMapViewController = [[ClubMapView alloc] initWithNibName:@"ClubMapView" bundle:nil];
	clubMapViewController.mainView = self;
	self.clubMapView = clubMapViewController;
	
	SquadView *squadViewController = [[SquadView alloc] initWithNibName:@"SquadView" bundle:nil];
	squadViewController.mainView = self;
	self.squadView = squadViewController;
	
	TrainingView *trainingViewController = [[TrainingView alloc] initWithNibName:@"TrainingView" bundle:nil];
	trainingViewController.mainView = self;
	self.trainingView = trainingViewController;
	
	NewsView *newsViewController = [[NewsView alloc] initWithNibName:@"NewsView" bundle:nil];
	newsViewController.mainView = self;
	self.newsView = newsViewController;
	
	((ClubView*)[myclubTabBarController viewControllers][0]).mainView = self;
	
	((ClubViewer*)[clubTabBarController viewControllers][0]).mainView = self;
	((MapViewer*)[clubTabBarController viewControllers][1]).mainView = self;
	((SquadViewer*)[clubTabBarController viewControllers][2]).mainView = self;
	((TrophyViewer*)[clubTabBarController viewControllers][3]).mainView = self;
	
	((StorePlayerView*)[storeTabBarController viewControllers][0]).mainView = self;
	((StoreCoachView*)[storeTabBarController viewControllers][1]).mainView = self;
	((StoreOthersView*)[storeTabBarController viewControllers][2]).mainView = self;

    ((OverView*)[leagueTabBarController viewControllers][0]).mainView = self;
	((LeagueView*)[leagueTabBarController viewControllers][1]).mainView = self;
	((FixturesView*)[leagueTabBarController viewControllers][2]).mainView = self;
	((PromotionView*)[leagueTabBarController viewControllers][3]).mainView = self;
	((ScorersView*)[leagueTabBarController viewControllers][4]).mainView = self;
	
	((FormationView*)[tacticsTabBarController viewControllers][0]).mainView = self;
	((SubsView*)[tacticsTabBarController viewControllers][1]).mainView = self;
	((TacticsView*)[tacticsTabBarController viewControllers][2]).mainView = self;
}

- (void)showFooterMessage
{
    /*
	NSDictionary *wsSeasonData = [[Globals i] getCurrentSeasonData];
	NSString *welcomeFooter = wsSeasonData[@"footer"];

    if (footerView == nil)
    {
        footerView = [[Footer alloc] initWithTitle:@"Welcome Back" message:welcomeFooter];
    }
	[[self.view superview] addSubview:footerView.view];
	[footerView showMsgWithDelay:15];
    */
}

- (void)createFloatings
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
	else
	{
        NSDictionary *wsSeasonData = [[Globals i] getCurrentSeasonData];
		NSString *leagueRound = wsSeasonData[@"league_round"];
		NSDictionary *wsClubData = [[Globals i] getClubData];
		NSString *rank = wsClubData[@"league_ranking"];
		NSString *div = wsClubData[@"division"];
		
		int lr = [leagueRound intValue];
		int balRound = 18-lr;
		leagueRound = [NSString stringWithFormat:@"%d", balRound];
		
		NSString *m = [NSString stringWithFormat:@"Your club is in division %@ and ranked %@ out of 10 in the league. There are %@ weeks still to play. Focus on the game, switch between your tactics, keep your players trained and try to make some transfer offers, in order for your club to reach 1st position", div, rank, leagueRound];
		
        if (welcomeView == nil)
        {
            welcomeView = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
            welcomeView.mainView = self;
        }
        welcomeView.promptText = m;
		[superView insertSubview:welcomeView.view atIndex:5];
		[welcomeView updateView];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    superView = [self.view superview];
	[superView insertSubview:header.view atIndex:2];
    
    [self createFloatings];
    
	[self showMarquee];
    
    //Create Chat
    if(!chatTimer.isValid)
    {
        chatTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(onTimerChat) userInfo:nil repeats:YES];
    }
    
    [self showAchievements];
    
    [self showChallengeBox];
}

- (void)reloadViewFull
{
    if(![[Globals i] updateClubData])
	{
		[self showLogin];
        
		return;
	}
	else
    {
        [[Globals i] retrieveEnergy];
        [header updateView];
        
        [[Globals i] updateProductIdentifiers];
	
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
    
        [self saveLocation]; //causes reload again if NO is selected to share location
    
        [self showFooterMessage];
    }
}

- (void)updateAchievementBadges
{
    [cell updateAchievementBadges];

    [mainTableView reloadData];
}

- (void)reloadClubFromOutside
{
    [NSThread detachNewThreadSelector:@selector(reloadClub) toTarget:self withObject:nil];
}

- (void)reloadClub
{
	@autoreleasepool {
    
        [self performSelectorOnMainThread:@selector(showLoadingAlert)
                               withObject:nil
                            waitUntilDone:YES];
	
	if([[Globals i] updateClubData])
	{
            [[Globals i] retrieveEnergy];
            [header updateView];
            
		[[Globals i] updateProductIdentifiers];
		[[Globals i] updateMatchData];
		[[Globals i] updateMatchPlayedData];
		[[Globals i] updateChallengesData];
		[[Globals i] updateChallengedData];
            
        [[Globals i] updateMyAchievementsData];
        [cell updateAchievementBadges];
		
		[self performSelectorOnMainThread:@selector(showChallengeBox)
							   withObject:nil
							waitUntilDone:YES];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(showLogin)
							   withObject:nil
							waitUntilDone:YES];
	}
        
        [self performSelectorOnMainThread:@selector(removeLoadingAlert)
                               withObject:nil
                            waitUntilDone:YES];
	
	}
}

- (void)onTimerChat
{
    [NSThread detachNewThreadSelector: @selector(getChat) toTarget:self withObject:nil];
}

- (void)getChat
{
    @autoreleasepool {
    
        [[Globals i] updateChatData];
        if(chatView != nil)
        {
            [self performSelectorOnMainThread:@selector(updateChatView)
                                   withObject:nil
                                waitUntilDone:NO];
        }
        
        if ([[[Globals i] getLast3Chat] isEqualToString:@"0"]) 
        {
            if ([[[Globals i] getLast2Chat] isEqualToString:@"0"]) 
            {
                if ([[[Globals i] getLast1Chat] isEqualToString:@"0"]) 
                {
                    lblChat1.text = @" ";
                }
                else
                {
                    lblChat1.text = [[Globals i] getLast1Chat];
                }
            }
            else
            {
                lblChat1.text = [[Globals i] getLast2Chat];
            }
        }
        else
        {
            lblChat1.text = [[Globals i] getLast3Chat];
        }
    
    }
}

- (void)updateChatView
{

}

- (void)updateTacticsView
{
	[(FormationView*)[tacticsTabBarController viewControllers][0] updateView];
}

- (void)updateHeader
{
	[header updateView];
}

- (void)hideHeader
{
	[header.view removeFromSuperview];
}

- (void)showHeader
{
    if ((activeView == self.stadiumMap.view) || (activeView == self.clubMapView.view))
	{
        
    }
    else
    {
        [superView insertSubview:header.view atIndex:2];
        [header updateView];
    }
}

- (void)showMarquee
{
	if(activeView == self.view)
	{
        speedMarquee = 1;
        self.marquee = [[Globals i] getMarqueeData];
        [superView insertSubview:lblMarquee atIndex:2];
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
}

- (void)hideMarquee
{
	if(activeView == self.view)
	{
        [lblMarquee removeFromSuperview];
	}
}

- (void)hideFooter
{
	if(activeView != self.view)
	{
		[backButton removeFromSuperview];
	}
}

- (void)showFooter
{
	if(activeView != self.view)
	{
		[superView addSubview:backButton];
	}
}

- (void)showHelp
{
	if(posxView==SCREEN_WIDTH)
	{
        [self hideFooter];
        [self hideHeader];
        [self hideMarquee];
        if (helpView == nil) 
        {
            helpView = [[HelpView alloc] initWithNibName:@"HelpView" bundle:nil];
            helpView.mainView = self;
        }
        [[activeView superview] insertSubview:helpView.view atIndex:5];
	}
}

- (void)showChat
{

}

- (void)fblogin
{
    [self hideHeader];
    [self hideMarquee];
    
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    
    // Configure the picker ...
    friendPickerController.title = @"Select a Friend";
    // Set this view controller as the friend picker delegate
    friendPickerController.delegate = self;
    // Ask for friend device data
    friendPickerController.fieldsForRequest = [NSSet setWithObjects:@"installed", nil];
    
    friendPickerController.allowsMultipleSelection = NO;
    
    // Fetch the data
    [friendPickerController loadData];
    
    // iOS 5+
    [self presentViewController:friendPickerController
                       animated:YES
                     completion:nil];
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUserExtraFields>)user
{
    if (user.installed)
    {
        return YES;
    }
    
    // Friend is not an iOS user, do not include them
    return NO;
}
 
- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [self backSound];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self showHeader];
	[self showMarquee];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    [self buttonSound];
    
    FBFriendPickerViewController *fpc = (FBFriendPickerViewController *)sender;
    
    for (id<FBGraphUser> user in fpc.selection)
    {
        NSString *strToEncrypt  = user.id;
        NSString *secret        = @"year2000";
        NSString *hexHmac       = [strToEncrypt HMACWithSecret:secret];
        
        [self jumpToFBClubViewer:hexHmac];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self showHeader];
	[self showMarquee];
}

- (void)jumpToFinance
{
	if(activeView != financeView.view && posxView==SCREEN_WIDTH)
	{
        [self switchView:financeView.view go:activeView dir:1];
        [self.financeView updateView];
	}
}

- (void)jumpToFans
{
	if(activeView != fansView.view && posxView==SCREEN_WIDTH)
	{
        [self switchView:fansView.view go:activeView dir:1];
        [self.fansView updateView];
	}
}

- (void)jumpToTrain
{
	if(activeView != jobsView.view && posxView==SCREEN_WIDTH)
	{
        if (jobsView == nil)
        {
            jobsView = [[JobsView alloc] initWithNibName:@"JobsView" bundle:nil];
            jobsView.mainView = self;
            [self.jobsView updateView];
        }
        
		[self switchJobsView:0];
		[self.jobsView updateView];
	}
}

- (void)jumpToNews
{
	if(activeView != newsView.view && posxView==SCREEN_WIDTH)
	{
        [self switchView:newsView.view go:activeView dir:1];
        [self.newsView updateView];
	}
}

- (void)jumpToPlayerStore
{
	if(posxView==SCREEN_WIDTH)
	{
        [self switchView:storeTabBarController.view go:activeView dir:1];
        [(StorePlayerView*)[storeTabBarController viewControllers][0] updateView];
        storeTabBarController.selectedIndex = 0;
	}
}

- (void)jumpToCoachStore
{
	if(posxView==SCREEN_WIDTH)
	{
        [self switchView:storeTabBarController.view go:activeView dir:1];
        [(StoreCoachView*)[storeTabBarController viewControllers][1] updateView];
        storeTabBarController.selectedIndex = 1;
	}
}

- (void)jumpToOthersStore
{
	if(posxView==SCREEN_WIDTH)
	{
        [self switchView:storeTabBarController.view go:activeView dir:1];
        [(StoreOthersView*)[storeTabBarController viewControllers][2] updateView];
        storeTabBarController.selectedIndex = 2;
	}
}

- (void)jumpToClub
{
	if(activeView!=myclubTabBarController.view && posxView==SCREEN_WIDTH)
	{
		[(ClubView*)[myclubTabBarController viewControllers][0] updateView];
		[self switchView:myclubTabBarController.view go:activeView dir:1];
		((TrophyViewer*)[myclubTabBarController viewControllers][1]).selected_trophy = [[[Globals i] wsClubData][@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
		[(ClubView*)[myclubTabBarController viewControllers][0] updateView];
		myclubTabBarController.selectedIndex = 0;
	}
}

- (void)resetClubImages
{
	[self.clubView resetImages];
}

- (void)jumpToChallenge:(NSString *)club_id
{
    if(challengeCreate == nil)
    {
        challengeCreate = [[ChallengeCreateView alloc] initWithNibName:@"ChallengeCreateView" bundle:nil];
    }
    [Globals i].selectedClubId = [club_id stringByReplacingOccurrencesOfString:@"," withString:@""];
	challengeCreate.mainView = self;
    [challengeCreate updateView];
    [superView insertSubview:challengeCreate.view atIndex:7];
}

- (void)jumpToClubViewer:(NSString *)club_id
{
	[self hideHeader];
	[self hideFooter];
	[superView insertSubview:clubTabBarController.view atIndex:6];
	((TrophyViewer*)[clubTabBarController viewControllers][3]).selected_trophy = club_id;
	[(ClubViewer*)[clubTabBarController viewControllers][0] updateViewId:club_id];
	clubTabBarController.selectedIndex = 0;
}

- (void)jumpToFBClubViewer:(NSString *)fb_id
{
	[self hideHeader];
	[self hideFooter];
    
	[superView insertSubview:clubTabBarController.view atIndex:3];
	[(ClubViewer*)[clubTabBarController viewControllers][0] updateViewFb:fb_id];
	clubTabBarController.selectedIndex = 0;
}

- (void)removeClubViewer
{
	[clubTabBarController.view removeFromSuperview];
}

- (void)showStadiumMap
{
    [self hideHeader];
    
    [self switchView:stadiumMap.view go:self.view dir:1];
    [self.stadiumMap updateView];
}

- (void)showStadiumUpgrade
{
    [self.stadiumMap.view addSubview:stadiumView.view];
    [self.stadiumView updateView];
}

- (void)showBuildingUpgrade:(int)type;
{
    [self.stadiumMap.view addSubview:upgradeView.view];
    [self.upgradeView updateView:type];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	[self buttonSound];
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
	[self buttonSound];
	if(posxView==SCREEN_WIDTH)
	{
	switch(sender)
	{
		case 1:
		{
			[self switchView:matchView.view go:self.view dir:1];
			[self.matchView updateView];
			break;
		}		
		case 2:
		{
			[self switchView:leagueTabBarController.view go:self.view dir:1];
			[(LeagueView*)[leagueTabBarController viewControllers][0] updateView];
			break;
		}
		case 3:
		{
			//[self switchView:cupTabBarController.view go:self.view dir:1];
			//[(CupMainView*)[cupTabBarController viewControllers][0] updateView];
			break;
		}
		case 4:
		{
			[self switchView:squadView.view go:self.view dir:1];
			[self.squadView updateView];
			break;
		}
		case 5:
		{
			[self switchView:tacticsTabBarController.view go:self.view dir:1];
			[(FormationView*)[tacticsTabBarController viewControllers][0] updateView];
			break;
		}			
		case 6:
		{
			[self switchView:trainingView.view go:self.view dir:1];
			[self.trainingView updateView];
			break;
		}
		case 7:
		{
			[self switchView:storeTabBarController.view go:self.view dir:1];
			[(StorePlayerView*)[storeTabBarController viewControllers][0] updateView];
			storeTabBarController.selectedIndex = 0;
			break;
		}
        case 8:
		{
			[self switchView:staffView.view go:self.view dir:1];
			[self.staffView updateView];
			break;
		}
		case 9:
		{
			[self switchView:clubMapView.view go:self.view dir:1];
			[self.clubMapView updateView];
			break;
		}
		case 10:
		{
			//[self jumpToSearch];
			break;
		}
        case 11:
		{
            [self fblogin];
			break;
		}
        case 12:
		{
			[self jumpToFinance];
			break;
		}
		case 13:
		{
			[self jumpToFans];
            break;
		}
        case 14:
		{
			[self jumpToOthersStore];
			break;
		}
		case 15:
		{
			[self jumpToNews];
			break;
		}
		case 16:
		{
            [self showAchievements];
			break;
		}
        case 17:
		{
            [self showChat];
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
			[self jumpToClub];
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
			[self jumpToTrain];
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
            int alliance_id = [[[[Globals i] getClubData][@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
            if (alliance_id > 0)
            {
                [self showAllianceDetail:alliance_id];
            }
            else
            {
                [self showAlliance];
            }
			break;
		}
	}
	}
}

- (void)actionBackButton:(id)sender
{
	[self backSound];
    
    [backButton removeFromSuperview];
	if (activeView == self.jobsView.view) 
	{
		[self switchJobsView:1];
        activeView = self.view;
	}
    else if (activeView == self.clubMapView.view)
	{
        self.clubMapView.mapViewer.delegate = nil;
        [self.backButton setFrame:CGRectMake(-1*SCALE_IPAD, BACK_y, 50*SCALE_IPAD, 40*SCALE_IPAD)];
        [self switchView:self.view go:activeView dir:2];
		[self showHeader];
	}
    else if (activeView == self.stadiumMap.view)
	{
        [self switchView:self.view go:activeView dir:2];
		[self showHeader];
	}
	else 
	{
		[self switchView:self.view go:activeView dir:2];
	}
}

- (void)slideView:(UIView *)coming go:(UIView *)going
{
	[self.view addSubview:coming];
	[going removeFromSuperview];
}

- (void)switchView:(UIView *)coming go:(UIView *)going dir:(NSUInteger)direction
{
	[superView insertSubview:coming atIndex:1];
	previousView = going;
	
	if(going == self.view)
	{
		[self hideMarquee];
		animateViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer2) userInfo:nil repeats:YES];
	}
	else 
	{
		if(coming == self.view)
		{
			animateViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer3) userInfo:nil repeats:YES];
		}
		else 
		{
			[self hideMarquee];
			animateViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer2) userInfo:nil repeats:YES];		
		}
	}
	activeView = coming;
}

-(void)onTimer2
{
	posxView = posxView-POSX_DECREASE;
	if(posxView < 0)
	{
		@try {
			[animateViewTimer invalidate];
		}@catch (NSException *exception) { }
		
		[self showFooter];
        //[previousView removeFromSuperview];
		posxView = SCREEN_WIDTH;
	}
	else
	{
		activeView.frame = CGRectMake(posxView, 0.0f, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height);
		previousView.frame = CGRectMake(posxView-SCREEN_WIDTH, 0.0f, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height);
	}
}

-(void)onTimer3
{
	posxView = posxView-POSX_DECREASE;
	if(posxView < 0)
	{
		@try {
			[animateViewTimer invalidate];
		}@catch (NSException *exception) { }
		
		[self showMarquee];
		posxView = SCREEN_WIDTH;
	}
	else
	{
		self.view.frame = CGRectMake(-posxView, 0.0f, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height);
		previousView.frame = CGRectMake(SCREEN_WIDTH-posxView, 0.0f, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height);
	}
}

- (void)switchJobsView:(NSUInteger)direction
{
	if(direction == 0)
	{
		[self hideMarquee];
		[superView insertSubview:self.jobsView.view atIndex:1];
		previousView = self.view;
		activeView = self.jobsView.view;
		animateViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer4) userInfo:nil repeats:YES];
	}
	else 
	{
		[superView insertSubview:self.view atIndex:1];
		previousView = self.jobsView.view;
		activeView = self.view;
		animateViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer5) userInfo:nil repeats:YES];
	}
}

-(void)onTimer4
{
	posxView = posxView-POSX_DECREASE;
	if(posxView < 0)
	{
		@try {
			[animateViewTimer invalidate];
		}@catch (NSException *exception) { }
		
		[self showFooter];
        //[previousView removeFromSuperview];
		posxView = SCREEN_WIDTH;
	}
	else
	{
		activeView.frame = CGRectMake(-posxView, 0.0f, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height);
		previousView.frame = CGRectMake(SCREEN_WIDTH-posxView, 0.0f, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height);
	}
}

-(void)onTimer5
{
	posxView = posxView-POSX_DECREASE;
	if(posxView < 0)
	{
		@try {
			[animateViewTimer invalidate];
		}@catch (NSException *exception) { }
		
		[self showMarquee];
		posxView = SCREEN_WIDTH;
	}
	else
	{
		self.view.frame = CGRectMake(posxView, 0.0f, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height);
		previousView.frame = CGRectMake(posxView-SCREEN_WIDTH, 0.0f, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height);
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
    
	// move label
    speedMarquee = 0;
    posxMarquee = posxMarquee + 1 + translation.x;
	//label.center = CGPointMake(label.center.x + translation.x, label.center.y);
    
	// reset translation
	[gesture setTranslation:CGPointZero inView:label];
    speedMarquee = 1;
}

- (void)createBackButton
{	
	//Back button
	UIImage *buttonBackground = [UIImage imageNamed:@""];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@""];
	CGRect frame = CGRectMake(-1*SCALE_IPAD, BACK_y, 50.0f*SCALE_IPAD, 40.0f*SCALE_IPAD);
	backButton = [[Globals i] buttonWithTitle:@""
													target:self
												  selector:@selector(actionBackButton:)
													 frame:frame
													 image:buttonBackground
											  imagePressed:buttonBackgroundPressed
											 darkTextColor:YES];
    [backButton setImage:[UIImage imageNamed:@"button_back1.png"] forState:UIControlStateNormal];
    //Marquee label
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
    
    //Chat labels
    lblChat1 = [[UILabel alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height-Marquee_height-100, SCREEN_WIDTH, 320)];
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

- (void)buttonSound
{
	[buttonAudio play];
}

- (void)backSound
{
	[backAudio play];
}

- (void)moneySound
{
	[moneyAudio play];
}

- (void)winSound
{
	[winAudio play];
}

- (void)loseSound
{
	[loseAudio play];
}

- (void)trainingSound
{

}

- (void)stopTrainingSound
{

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag 
{
	if (flag) 
    {
		NSLog(@"Did finish playing");
	} 
    else 
    {
		NSLog(@"Did NOT finish playing");
	}
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error 
{
	NSLog(@"%@", [error description]);
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
        [self showChat];
    }
}

- (void)logoutButton
{
    [self buttonSound];
    
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
        [self showLogin];
    }
}

- (void)shareButton
{
    [self buttonSound];
    
    NSString *message = @"Check out this very cool App!";
	NSString *caption = @"Come on and join in the fun.";
	NSString *picture = @"Icon-72.png";
    
    [self FallbackPublishStory:message :caption :picture];
    
    [[Globals i] showDialog:@"Thank you for sharing this App with your friends. Challenge your friends and level up even faster!"];
}

- (void)FallbackPublishStory:(NSString *)message :(NSString *)caption :(NSString *)picture
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [mySLComposerSheet setInitialText:message];
        [mySLComposerSheet addImage:[UIImage imageNamed:picture]];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"https://www.tapfantasy.com"]];
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result)
        {
            switch (result)
            {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}

- (void)showLoadingAlert
{
	[[Globals i] showLoadingAlert];
}

- (void)removeLoadingAlert
{
	[[Globals i] removeLoadingAlert];
}

@end
