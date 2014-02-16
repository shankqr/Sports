//
//  Globals.m
//  Kingdom Game
//
//  Created by Shankar on 6/9/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"
#import "BuyView.h"
#import "WorldsView.h"
#import "LoadingView.h"
#import "PlayerCell.h"
#import "DAAppsViewController.h"
#import "MMProgressHUD.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterSmokeStyle.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation Globals
@synthesize viewControllerStack;
@synthesize buttonAudio;
@synthesize backAudio;
@synthesize moneyAudio;
@synthesize winAudio;
@synthesize loseAudio;
@synthesize wsClubData;
@synthesize wsClubInfoData;
@synthesize wsReportData;
@synthesize wsMailData;
@synthesize wsMailReply;
@synthesize localReportData;
@synthesize localMailData;
@synthesize localMailReply;
@synthesize wsChatData;
@synthesize wsChatFullData;
@synthesize wsAllianceChatData;
@synthesize wsAllianceChatFullData;
@synthesize wsMyAchievementsData;
@synthesize wsBaseData;
@synthesize wsBasesData;
@synthesize workingUrl;
@synthesize selectedClubId;
@synthesize selectedBaseId;
@synthesize purchasedProductString;
@synthesize loginBonus;
@synthesize latitude;
@synthesize longitude;
@synthesize devicetoken;
@synthesize uid;
@synthesize selectedMapTile;
@synthesize dialogBox;
@synthesize templateView;
@synthesize buyView;
@synthesize wsWorldData;
@synthesize wsWorldsData;
@synthesize worldsView;
@synthesize loginView;
@synthesize lastReportId;
@synthesize lastMailId;
@synthesize mailCompose;
@synthesize loginNotification;
@synthesize loadingView;
@synthesize wsSquadData;
@synthesize wsMySquadData;
@synthesize wsMatchData;
@synthesize wsMatchPlayedData;
@synthesize wsMatchHighlightsData;
@synthesize wsChallengesData;
@synthesize wsChallengedData;
@synthesize wsLeagueData;
@synthesize wsMatchFixturesData;
@synthesize wsNewsData;
@synthesize wsMarqueeData;
@synthesize wsFriendsData;
@synthesize wsCurrentSeasonData;
@synthesize wsPlayerInfoData;
@synthesize wsMatchInfoData;
@synthesize wsLeagueScorersData;
@synthesize wsPromotionData;
@synthesize wsCupScorersData;
@synthesize wsCupFixturesData;
@synthesize wsWallData;
@synthesize wsEventsData;
@synthesize wsDonationsData;
@synthesize wsAppliedData;
@synthesize wsMembersData;
@synthesize wsAllianceCupFixturesData;
@synthesize wsMapClubsData;
@synthesize wsNearClubsData;
@synthesize wsPlayerSaleData;
@synthesize wsCoachData;
@synthesize wsProductsData;
@synthesize wsTrophyData;
@synthesize wsAllianceData;
@synthesize challengeMatchId;
@synthesize selectedPos;
@synthesize selectedPlayer;
@synthesize selectedDivision;
@synthesize selectedSeries;
@synthesize purchasedPlayerId;
@synthesize purchasedCoachId;
@synthesize workingSquad;
@synthesize wsCupRounds;
@synthesize energy;
@synthesize acceptedMatch;
@synthesize mainView;

static Globals *_i;

- (id)init
{
	if (self = [super init])
	{
        self.selectedClubId = @"0";
        self.workingUrl = @"0";
        self.selectedMapTile = @"0";
        self.offsetServerTimeInterval = 0;
	}
	return self;
}

+ (Globals *)i
{
	if (!_i)
	{
		_i = [[Globals alloc] init];
	}
	
	return _i;
}

static dispatch_once_t once;
static NSOperationQueue *connectionQueue;
+ (NSOperationQueue *)connectionQueue
{
    dispatch_once(&once, ^{
        connectionQueue = [[NSOperationQueue alloc] init];
        [connectionQueue setMaxConcurrentOperationCount:2];
        [connectionQueue setName:@"com.tapfantasy.connectionqueue"];
    });
    return connectionQueue;
}

+ (void)getServer:(NSString *)wsurl :(returnBlock)completionBlock
{
    NSURL *url = [NSURL URLWithString:[wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error || !response || !data)
        {
            NSLog(@"Error posting to %@: %@ %@", wsurl, error, [error localizedDescription]);
            completionBlock(NO, nil);
        }
        else
        {
            completionBlock(YES, data);
        }
   }];
}

+ (void)getServerLoading:(NSString *)wsurl :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    //wsurl = [Globals encodeURL:wsurl];
    wsurl = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsurl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] removeLoadingAlert];});
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", wsurl, error, [error localizedDescription]);
             completionBlock(NO, nil);
             dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showDialogError];});
         }
         else
         {
             completionBlock(YES, data);
         }
     }];
}

+ (void)postServer:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock
{
    NSError* error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [[Globals i] world_url], service]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.connectionQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error || !response || !data)
        {
            NSLog(@"Error posting to %@: %@ %@", service, error, [error localizedDescription]);
            completionBlock(NO, nil);
        }
        else
        {
            completionBlock(YES, data);
        }
   }];
}

+ (void)postServerLoading:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    NSError* error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [[Globals i] world_url], service]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.connectionQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] removeLoadingAlert];});
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", service, error, [error localizedDescription]);
             completionBlock(NO, nil);
             dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showDialogError];});
         }
         else
         {
             completionBlock(YES, data);
         }
     }];
}

- (NSString	*)GameId
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GAME_ID"];
}

- (NSString	*)GameType
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GAME_TYPE"];
}

- (NSString	*)GameUrl
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GAME_URL"];
}

- (NSString	*)UID
{
    uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserUID"];
    
    return uid;
}

- (NSString	*)world_url
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GAME_URL"];
}

- (void)setUID:(NSString *)user_uid
{
    uid = user_uid;
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"UserUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (![user_uid isEqualToString:@""])
    {
        //Get Previos UID
        NSString *prev_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"PrevUID"];
        if (prev_uid != nil)
        {
            if (![prev_uid isEqualToString:user_uid])
            {
                [self resetUserDefaults];
            }
        }
        
        //Set Previous UID
        [[NSUserDefaults standardUserDefaults] setObject:user_uid forKey:@"PrevUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)resetUserDefaults
{
    [self settLocalMailReply:[[NSDictionary alloc] init]];
    [self settLastMailId:@"0"];
    [self settLocalMailData:[[NSMutableArray alloc] init]];
    
    [self settLastReportId:@"0"];
    [self settLocalReportData:[[NSMutableArray alloc] init]];
    [self settSelectedBaseId:@"0"];
}

- (NSTimeInterval)updateTime
{
    NSDateFormatter *serverDateFormat = [[NSDateFormatter alloc] init];
    [serverDateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [serverDateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss Z"];
    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/CurrentTime", WS_URL];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    NSString *returnValue  = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    returnValue = [NSString stringWithFormat:@"%@ -0000", returnValue];
    
    NSDate *serverDateTime = [serverDateFormat dateFromString:returnValue];
    NSTimeInterval serverTimeInterval = [serverDateTime timeIntervalSince1970];
    
    NSDate *localdatetime = [NSDate date];
    NSTimeInterval localTimeInterval = [localdatetime timeIntervalSince1970];
    
    self.offsetServerTimeInterval = serverTimeInterval - localTimeInterval;
    
    return serverTimeInterval;
}

- (NSString *)getServerTimeString
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormater setDateFormat:@"HH:mm:ss"];
    
    NSDate *localdatetime = [NSDate date];
    NSDate *serverdatetime = [localdatetime dateByAddingTimeInterval:self.offsetServerTimeInterval];

    return [dateFormater stringFromDate:serverdatetime];
}

- (NSString *)getServerDateTimeString
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //[dateFormater setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [dateFormater setDateFormat:@"EEEE, MMMM d, yyyy HH:mm:ss"];
    
    NSDate *localdatetime = [NSDate date];
    NSDate *serverdatetime = [localdatetime dateByAddingTimeInterval:self.offsetServerTimeInterval];
    
    NSString *datenow = [dateFormater stringFromDate:serverdatetime];
    return datenow;
}

- (NSDateFormatter *)getDateFormat
{
    if (self.dateFormat == nil)
    {
        self.dateFormat = [[NSDateFormatter alloc] init];
        [self.dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [self.dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        //[self.dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss Z"];
        [self.dateFormat setDateFormat:@"EEEE, MMMM d, yyyy HH:mm:ss Z"];
    }
    
    return self.dateFormat;
}

- (NSString *)getTimeAgo:(NSString *)datetimestring
{
    NSString *diff = datetimestring;
    
    if (datetimestring != nil && [datetimestring length] > 0)
    {
        NSDate *date1 = [[self getDateFormat] dateFromString:[NSString stringWithFormat:@"%@ -0000", datetimestring]];
        NSDate *date2 = [NSDate date];
        
        if (self.offsetServerTimeInterval != 0) //Calibrate if local time is adjusted
        {
            date2 = [date2 dateByAddingTimeInterval:self.offsetServerTimeInterval];
        }
        
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        
        // Get conversion to months, days, hours, minutes
        NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
        
        if ([breakdownInfo month] > 0)
        {
            if ([breakdownInfo month] == 1)
            {
                diff = @"1 month ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%ld months ago", (long)[breakdownInfo month]];
            }
        }
        else if ([breakdownInfo day] > 0)
        {
            if ([breakdownInfo day] == 1)
            {
                diff = @"1 day ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%ld days ago", (long)[breakdownInfo day]];
            }
        }
        else if ([breakdownInfo hour] > 0)
        {
            if ([breakdownInfo hour] == 1)
            {
                diff = @"1 hour ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%ld hours ago", (long)[breakdownInfo hour]];
            }
        }
        else if ([breakdownInfo minute] > 0)
        {
            if ([breakdownInfo minute] == 1)
            {
                diff = @"1 min ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%ld mins ago", (long)[breakdownInfo minute]];
            }
        }
        else if ([breakdownInfo second] > 0)
        {
            if ([breakdownInfo second] == 1)
            {
                diff = @"1 sec ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%ld secs ago", (long)[breakdownInfo second]];
            }
        }
        else
        {
            diff = @"1 sec ago";
        }
    }

    return diff;
}

- (void)emailToDeveloper
{
    NSString *mailto = [NSString stringWithFormat:@"mailto://support@tapfantasy.com?subject=%@(Version %@)",
                        GAME_NAME,
                        GAME_VERSION];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mailto stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)showLoadingAlert
{
    NSArray *images = @[[UIImage imageNamed:@"g1_0.png"],
                        [UIImage imageNamed:@"g1_1.png"],
                        [UIImage imageNamed:@"g1_2.png"],
                        [UIImage imageNamed:@"g1_3.png"],
                        [UIImage imageNamed:@"g1_4.png"],
                        [UIImage imageNamed:@"g1_5.png"]];
    
    [[MMProgressHUD sharedHUD] setOverlayMode:MMProgressHUDWindowOverlayModeLinear];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:nil status:nil images:images];
}

- (void)removeLoadingAlert
{
    [MMProgressHUD dismiss];
}

- (void)showToast:(NSString *)message optionalTitle:(NSString *)title optionalImage:(NSString *)imagename
{
    [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterSmokeStyle new];

    [JCNotificationCenter
     enqueueNotificationWithMessage:message
     title:title
     image:imagename
     tapHandler:^{}];
}

- (void)createDialogBox
{
    if (dialogBox == nil)
    {
        dialogBox = [[DialogBoxView alloc] initWithNibName:@"DialogBoxView" bundle:nil];
    }
}

- (void)removeDialogBox
{
	if(dialogBox != nil)
	{
		[dialogBox.view removeFromSuperview];
	}
}

- (void)showDialog:(NSString *)l1
{
    [self createDialogBox];
    
    dialogBox.promptText = l1;
    dialogBox.whiteText = @"";
    dialogBox.dialogType = 1;
    [[self peekViewControllerStack].view addSubview:dialogBox.view];
    dialogBox.dialogBlock = nil;
    
    [dialogBox updateView];
}

- (void)showDialogError
{
    [self showDialog:@"Sorry, there was an internet connection issue or your session has timed out. Please retry."];
}

- (void)showDialogBlock:(NSString *)l1 :(NSInteger)type :(DialogBlock)block
{
    [self createDialogBox];
    
    dialogBox.promptText = @"";
    dialogBox.whiteText = l1;
    dialogBox.dialogType = type;
    [[self peekViewControllerStack].view addSubview:dialogBox.view];
    dialogBox.dialogBlock = block;
    
    [dialogBox updateView];
}

- (void)flushViewControllerStack
{
    if(viewControllerStack == nil)
    {
        viewControllerStack = [[NSMutableArray alloc] init];
    }
    
    [viewControllerStack removeAllObjects];
}

- (void)pushViewControllerStack:(UIViewController *)view
{
    if(viewControllerStack == nil)
    {
        viewControllerStack = [[NSMutableArray alloc] init];
    }
    
    [viewControllerStack addObject:view];
}

- (UIViewController *)popViewControllerStack
{
    UIViewController *view = nil;
    
    if ([viewControllerStack count] != 0)
    {
        view = [viewControllerStack lastObject];
        [viewControllerStack removeLastObject];
    }
    
    return view;
}

- (UIViewController *)peekViewControllerStack
{
    UIViewController *view = nil;
    
    if ([viewControllerStack count] != 0)
    {
        view = [viewControllerStack lastObject];
    }
    
    return view;
}

- (BOOL)isCurrentView:(UIViewController *)view
{
    return ([self peekViewControllerStack] == view);
}

- (NSString *)currentViewTitle
{
    NSString *title = @"";
    
    if([[self peekViewControllerStack] isKindOfClass:[TemplateView class]])
    {
        TemplateView *view = (TemplateView *)[self peekViewControllerStack];
        title = [view peekFromStack].title;
    }
    else
    {
        title = [self peekViewControllerStack].title;
    }
    
    return title;
}

- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType
{
    [Apsalar event:title];
    [Flurry logEvent:title];
    
    templateView = [[TemplateView alloc] init];
    
    templateView.delegate = self;
	templateView.viewControllers = viewControllers;
    templateView.title = title;
    templateView.frameType = frameType;
    
    [[self peekViewControllerStack].view addSubview:templateView.view];
    
    [templateView updateView];
    [self pushViewControllerStack:templateView];
}

- (void)pushTemplateNav:(UIViewController *)view
{
    [(TemplateView *)[self peekViewControllerStack] pushNav:view];
}

- (void)backTemplate
{
    [(TemplateView *)[self peekViewControllerStack] back];
}

- (void)closeTemplate
{
    if ([self peekViewControllerStack] != nil)
    {
        if([[self peekViewControllerStack] isKindOfClass:[TemplateView class]])
        {
            [(TemplateView *)[self peekViewControllerStack] cleanView];
        }
        
        [[self peekViewControllerStack].view removeFromSuperview];
        
        [self popViewControllerStack];
    }
}

- (void)closeAllTemplate
{
    while ([viewControllerStack count] > 1)
    {
        if([[self peekViewControllerStack] isKindOfClass:[TemplateView class]])
        {
            [(TemplateView *)[self peekViewControllerStack] cleanView];
        }
        
        [[self peekViewControllerStack].view removeFromSuperview];
        
        [self popViewControllerStack];
    }
}

- (void)showWorlds
{
    if (worldsView == nil)
    {
        worldsView = [[WorldsView alloc] initWithStyle:UITableViewStylePlain];
        worldsView.title = @"Select World 1";
        [worldsView updateView];
    }
    
    [self showTemplate:@[worldsView] :@"Select World" :1];
    
    //Disable the Buy button
    templateView.buyButton.hidden = YES;
    templateView.currencyLabel.hidden = YES;
}

- (void)showLoading
{
    loadingView = [[LoadingView alloc] init];
    loadingView.title = @"Loading";
    [[self peekViewControllerStack].view addSubview:loadingView.view];
    [loadingView updateView];
}

- (void)removeLoading
{
    if (loadingView != nil)
    {
        [loadingView close];
    }
}

- (void)showBuy
{
    if (buyView == nil)
    {
        buyView = [[BuyView alloc] initWithStyle:UITableViewStylePlain];
        buyView.title = @"Buy Diamonds 1";
        [buyView updateView];
    }
    
    [self showTemplate:@[buyView] :@"Buy Diamonds" :1];
    
    //Disable the Buy button
    templateView.buyButton.hidden = YES;
    templateView.currencyLabel.hidden = YES;
}

- (void)pushChatVC:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid
{
    ChatView *achatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
    achatView.title = @"Alliance Wall";
    
    [self pushTemplateNav:achatView];
    [achatView updateView:ds table:tn a_id:aid];
}

- (void)pushMoreGamesVC
{
    DAAppsViewController *appsViewController = [[DAAppsViewController alloc] init];
    NSArray *values = [self.wsProductIdentifiers[@"promote_apps"] componentsSeparatedByString:@","];
    [appsViewController loadAppsWithAppIds:values completionBlock:nil];
    
    [self pushTemplateNav:appsViewController];
}

- (void)showMoreGames
{
    DAAppsViewController *appsViewController = [[DAAppsViewController alloc] init];
    NSArray *values = [self.wsProductIdentifiers[@"promote_apps"] componentsSeparatedByString:@","];
    [appsViewController loadAppsWithAppIds:values completionBlock:nil];
    
    [self showTemplate:@[appsViewController] :@"More Games" :1];
}

- (void)mailCompose:(NSString *)isAlli toID:(NSString *)toid toName:(NSString *)toname
{
    if(mailCompose == nil)
    {
        mailCompose = [[MailCompose alloc] initWithStyle:UITableViewStylePlain];
    }
    mailCompose.title = @"Mail";
    mailCompose.isAlliance = isAlli;
    mailCompose.toID = toid;
    mailCompose.toName = toname;
    
    [self showTemplate:@[mailCompose] :@"Message" :1];
}

- (BOOL)mh_tabBarController:(TemplateView *)tabBarController
 shouldSelectViewController:(UIViewController *)viewController
                    atIndex:(NSUInteger)index
{
	return YES;
}

- (void)mh_tabBarController:(TemplateView *)tabBarController
    didSelectViewController:(UIViewController *)viewController
                    atIndex:(NSUInteger)index
{
	//NSLog(@"%@ didSelectViewController %@ at index %ld", tabBarController.title, viewController.title, (unsigned long)index);
}

- (double)Random_next:(double)min to:(double)max
{
    return ((double)arc4random() / UINT_MAX) * (max-min) + min;
}

- (void)initSound
{
	//Setup button sound
	NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_button.aif", [[NSBundle mainBundle] resourcePath]]];
	buttonAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
    buttonAudio.numberOfLoops = 0;
    buttonAudio.volume = 1.0;
	
	//Setup back sound
	NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_toaster.aac", [[NSBundle mainBundle] resourcePath]]];
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

- (void)buttonSound
{
	[buttonAudio play];
}

- (void)toasterSound
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

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if(flag)
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

#pragma mark PushNotification
- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo
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

    [self showDialog:alertMsg];
}

- (void)scheduleNotification:(NSDate *)f_date :(NSString *)alert_body
{
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil)
    {
        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSMutableArray *Arr = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication]scheduledLocalNotifications]];
        for (NSInteger k=0; k<[Arr count]; k++)
        {
            UILocalNotification *not = Arr[k];
            NSString *msgString = [not.userInfo valueForKey:@"key"];
            if([msgString isEqualToString:alert_body])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:not];
            }
        }
        
        UILocalNotification *notif = [[cls alloc] init];
        notif.fireDate = f_date;
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = alert_body;
        notif.alertAction = @"Show";
        notif.soundName = UILocalNotificationDefaultSoundName;
        notif.applicationIconBadgeNumber = 1;
		
        NSDictionary *userDict = @{@"key": alert_body};
        notif.userInfo = userDict;
		
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}

- (void)resetLoginReminderNotification
{
    //Remove all future notifications
    NSString *notificationId = @"login_reminder";
    for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[notify.userInfo objectForKey:@"ID"] isEqualToString:notificationId])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
        }
    }
    
    //Create new future notifcations for 3 days, 7 days and 15 days
    if (loginNotification == nil)
    {
        loginNotification = [[UILocalNotification alloc] init];
    }
    loginNotification.timeZone = [NSTimeZone defaultTimeZone];
    loginNotification.soundName = @"sound_toaster.aac";
    NSDictionary *userDict = @{@"ID": @"login_reminder"};
    loginNotification.userInfo = userDict;
    
    loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*3];
    loginNotification.alertBody = @"Your players misses you! It's been 3 days since they last saw you. Login now and catch up with them.";
    [[UIApplication sharedApplication] scheduleLocalNotification:loginNotification];
    
    loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*7];
    loginNotification.alertBody = @"Your players misses you! It's been a week since they last saw you. Login now and catch up with them.";
    [[UIApplication sharedApplication] scheduleLocalNotification:loginNotification];
    
    loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*15];
    loginNotification.alertBody = @"Your players misses you! It's been 2 weeks since they last saw you. Login now and catch up with them.";
    [[UIApplication sharedApplication] scheduleLocalNotification:loginNotification];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

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
        NSString *lati = [NSString stringWithFormat:@"%g", newLocation.coordinate.latitude];
		NSString *longi = [NSString stringWithFormat:@"%g", newLocation.coordinate.longitude];
        
        if (![lati isEqual: @"0"])
        {
            [self setLat:lati];
        }
        
        if (![longi isEqual: @"0"])
        {
            [self setLongi:longi];
        }
    }
    
    //Flurry track geo
    [Flurry setLatitude:newLocation.coordinate.latitude
              longitude:newLocation.coordinate.longitude
     horizontalAccuracy:newLocation.horizontalAccuracy
       verticalAccuracy:newLocation.verticalAccuracy];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"%@", error);
}

- (void)showLogin:(LoginBlock)block
{
    if (loginView == nil)
    {
        loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
        loginView.title = @"Login";
    }
    loginView.loginBlock = block;
    
    [self showTemplate:@[loginView] :@"Login" :0];
    
    //Disable the Buy & Close button
    templateView.buyButton.hidden = YES;
    templateView.currencyLabel.hidden = YES;
    templateView.closeButton.hidden = YES;
    
    [loginView updateView];
}

- (void)fbPublishStory:(NSString *)message :(NSString *)caption :(NSString *)picture
{
    /*
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
        
        [[self peekViewControllerStack] presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    */
}

- (NSDictionary *)gettLocalMailReply
{
    self.localMailReply = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"MailReply"];
    if (self.localMailReply == nil)
    {
        self.localMailReply = [[NSDictionary alloc] init];
    }
    
    return self.localMailReply;
}

- (void)settLocalMailReply:(NSDictionary *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSDictionary alloc] initWithDictionary:rd copyItems:YES] forKey:@"MailReply"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)findMailReply:(NSString *)mail_id
{
    self.localMailReply = [self gettLocalMailReply];
    
    return [self.localMailReply objectForKey:mail_id];
}

- (void)addMailReply:(NSString *)mail_id :(NSArray *)mail_reply
{
    self.localMailReply = [self gettLocalMailReply];
    NSMutableDictionary *mdReply = [[NSMutableDictionary alloc] initWithDictionary:self.localMailReply copyItems:YES];
    [mdReply setObject:mail_reply forKey:mail_id];
    
    [self settLocalMailReply:mdReply];
}

- (void)deleteLocalMail:(NSString *)mail_id
{
    self.localMailReply = [self gettLocalMailReply];
    
    if ([self.localMailReply count] > 0)
    {
        NSMutableDictionary *mdReply = [[NSMutableDictionary alloc] initWithDictionary:self.localMailReply copyItems:YES];
        [mdReply removeObjectForKey:mail_id];
        [self settLocalMailReply:mdReply];
    }
    
    self.localMailData = [self gettLocalMailData];
    NSInteger count = [self.localMailData count];
    NSInteger index_to_remove = -1;
    for (NSUInteger i = 0; i < count; i++)
    {
        if ([localMailData[i][@"mail_id"] isEqualToString:mail_id])
        {
            index_to_remove = i;
        }
    }
    
    if (index_to_remove > -1)
    {
        [self.localMailData removeObjectAtIndex:index_to_remove];
        [self settLocalMailData:self.localMailData];
    }
}

- (void)replyCounterPlus:(NSString *)mail_id
{
    self.localMailData = [self gettLocalMailData];
    NSInteger count = [self.localMailData count];

    for (NSUInteger i = 0; i < count; i++)
    {
        if ([localMailData[i][@"mail_id"] isEqualToString:mail_id])
        {
            NSInteger rcounter = [localMailData[i][@"reply_counter"] integerValue] + 1;
            localMailData[i][@"reply_counter"] = [NSString stringWithFormat:@"%ld", (long)rcounter];
            
            [self settLocalMailData:self.localMailData];
        }
    }
}

- (NSString *)gettLastMailId
{
    lastMailId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Mailid"];
    if (lastMailId == nil)
    {
        lastMailId = @"0";
    }
    
    return lastMailId;
}

- (void)settLastMailId:(NSString *)mid
{
    lastMailId = mid;
    [[NSUserDefaults standardUserDefaults] setObject:lastMailId forKey:@"Mailid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)gettLocalMailData
{
    self.localMailData = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"MailData"];
    if (self.localMailData == nil)
    {
        self.localMailData = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *fullMutable = [[NSMutableArray alloc] init];
    
    for (NSDictionary *obj in localMailData)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:obj copyItems:YES];
        [fullMutable addObject:dic];
    }
    
    return fullMutable;
}

- (void)settLocalMailData:(NSMutableArray *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc] initWithArray:rd copyItems:YES] forKey:@"MailData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addLocalMailData:(NSMutableArray *)rd
{
    self.localMailData = [self gettLocalMailData];
    
    if (self.localMailData == nil)
    {
        self.localMailData = [[NSMutableArray alloc] init];
    }
    
    //Check old mails if there is any replies
    for (NSUInteger i = 0; i < [self.localMailData count]; i++)
    {
        NSString *local_mail_id = self.localMailData[i][@"mail_id"];
        
        //Search newly fetched mail for match with local mail
        for (NSUInteger j = 0; j < [rd count]; j++)
        {
            if ([rd[j][@"mail_id"] isEqualToString:local_mail_id]) //Match found
            {
                //Reply counter is not same
                if (![rd[j][@"reply_counter"] isEqualToString:localMailData[i][@"reply_counter"]])
                {
                    self.localMailData[i][@"open_read"] = @"0";
                    self.localMailData[i][@"reply_counter"] = rd[i][@"reply_counter"];
                }
            }
        }
    }
    
    //Add new mails to localMailData
    for (NSInteger i = [rd count]-1; i > -1; i--)
    {
        if ([rd[i][@"mail_id"] integerValue] > [[self gettLastMailId] integerValue])
        {
            [self.localMailData insertObject:rd[i] atIndex:0];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:localMailData forKey:@"MailData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)gettLastReportId
{
    lastReportId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Reportid"];
    if (lastReportId == nil)
    {
        lastReportId = @"0";
    }
    
    return lastReportId;
}

- (void)settLastReportId:(NSString *)rid
{
    lastReportId = rid;
    [[NSUserDefaults standardUserDefaults] setObject:lastReportId forKey:@"Reportid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)gettLocalReportData
{
    self.localReportData = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"ReportData"];
    if (self.localReportData == nil)
    {
        self.localReportData = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *fullMutable = [[NSMutableArray alloc] init];
    
    for (NSDictionary *obj in localReportData)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:obj copyItems:YES];
        [fullMutable addObject:dic];
    }
    
    return fullMutable;
}

- (void)settLocalReportData:(NSMutableArray *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc] initWithArray:rd copyItems:YES] forKey:@"ReportData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addLocalReportData:(NSMutableArray *)rd
{
    if ([self gettLocalReportData] == nil)
    {
        self.localReportData = [[NSMutableArray alloc] init];
    }
    
    [self.localReportData addObjectsFromArray:rd];
    
    [[NSUserDefaults standardUserDefaults] setObject:localReportData forKey:@"ReportData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)gettSelectedWorldData
{
    self.wsWorldData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WorldData"];
    
    return self.wsWorldData;
}

- (void)refreshSelectedWorldData
{
    [self gettSelectedWorldData];
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetWorld/%@",
					   WS_URL, wsWorldData[@"world_id"]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
    
	self.wsWorldData = [[NSMutableDictionary alloc] initWithContentsOfURL:url];
    
    [[NSUserDefaults standardUserDefaults] setObject:wsWorldData forKey:@"WorldData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)settSelectedWorldData:(NSDictionary *)wd
{
    self.wsWorldData = [[NSDictionary alloc] initWithDictionary:wd copyItems:YES];

    [[NSUserDefaults standardUserDefaults] setObject:wsWorldData forKey:@"WorldData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self.loginView updateWorldLabel];
}

- (NSString *)gettSelectedBaseId
{
    selectedBaseId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Baseid"];
    if (selectedBaseId == nil)
    {
        selectedBaseId = @"0";
    }
    
    return selectedBaseId;
}

- (void)settSelectedBaseId:(NSString *)bid
{
    selectedBaseId = bid;
    [[NSUserDefaults standardUserDefaults] setObject:selectedBaseId forKey:@"Baseid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)gettPurchasedProduct
{
    purchasedProductString = [[NSUserDefaults standardUserDefaults] objectForKey:@"PurchasedProduct"];
    if (purchasedProductString == nil)
    {
        purchasedProductString = @"0";
    }
    
    return purchasedProductString;
}

- (void)settPurchasedProduct:(NSString *)type
{
    purchasedProductString = type;
    [[NSUserDefaults standardUserDefaults] setObject:purchasedProductString forKey:@"PurchasedProduct"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)gettLoginBonus
{
    loginBonus = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginBonus"];
    if (loginBonus == nil)
    {
        loginBonus = @"0";
    }
    
    return loginBonus;
}

- (void)settLoginBonus:(NSString *)amount
{
    loginBonus = amount;
    [[NSUserDefaults standardUserDefaults] setObject:loginBonus forKey:@"LoginBonus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getDevicetoken
{
    devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"Devicetoken"];
    if (devicetoken == nil)
    {
        devicetoken = @"0";
    }
    
    return devicetoken;
}

- (void)setDevicetoken:(NSString *)dt
{
    devicetoken = dt;
    [[NSUserDefaults standardUserDefaults] setObject:devicetoken forKey:@"Devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLat
{
    latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Latitude"];
    if (latitude == nil)
    {
        latitude = @"0";
    }
    
    return latitude;
}

- (void)setLat:(NSString *)lat
{
    latitude = lat;
    [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLongi
{
    longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Longitude"];
    if (longitude == nil)
    {
        longitude = @"0";
    }
    
    return longitude;
}

- (void)setLongi:(NSString *)longi
{
    longitude = longi;
    [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:@"Longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)xpFromLevel:(NSInteger)level
{
    return (level-1)*(level-1)*10;
}

- (NSInteger)levelFromXp:(NSInteger)xp
{
    return sqrt(xp/10) + 1;
}

- (NSInteger)getXp
{
    NSInteger xp = [wsClubData[@"xp"] integerValue];
    return xp;
}

- (NSInteger)getXpMax
{
    return [self xpFromLevel:[self getLevel]+1];
}

- (NSInteger)getXpMaxBefore
{
    return [self xpFromLevel:[self getLevel]];
}

- (NSInteger)getLevel
{
    return [self levelFromXp:[self getXp]];
}

- (NSString *)intString:(NSInteger)val
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = @(val);
    NSString *formattedOutput = [formatter stringFromNumber:number];
    
    return formattedOutput;
}

- (NSString *)numberFormat:(NSString *)val
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:val];
    NSString *formattedOutput = [formatter stringFromNumber:number];
    
    return formattedOutput;
}

- (NSString *)shortNumberFormat:(NSString *)val
{
    double dval = [val doubleValue];
    NSString *shortformNumber = @"1k";
    
    if (dval > 999)
    {
        if (dval > 999999)
        {
            if (dval > 999999999)
            {
                dval = dval / 1000000000;
                if (dval > 99)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.0fb", dval];
                }
                else if (dval > 9)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.1fb", dval];
                }
                else
                {
                    shortformNumber = [NSString stringWithFormat:@"%.2fb", dval];
                }
            }
            else
            {
                dval = dval / 1000000;
                if (dval > 99)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.0fm", dval];
                }
                else if (dval > 9)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.1fm", dval];
                }
                else
                {
                    shortformNumber = [NSString stringWithFormat:@"%.2fm", dval];
                }
            }
        }
        else
        {
            dval = dval / 1000;
            if (dval > 99)
            {
                shortformNumber = [NSString stringWithFormat:@"%.0fk", dval];
            }
            else if (dval > 9)
            {
                shortformNumber = [NSString stringWithFormat:@"%.1fk", dval];
            }
            else
            {
                shortformNumber = [NSString stringWithFormat:@"%.2fk", dval];
            }
        }
    }
    else
    {
        shortformNumber = [NSString stringWithFormat:@"%.0f", dval];
    }
    
    return shortformNumber;
}

- (NSString *)BoolToBit:(NSString *)boolString
{
	if([boolString isEqualToString:@"True"])
		return @"1";
	else
		return @"0";
}

+ (NSString *)encodeURL:(NSString *)urlString
{
    CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, nil, CFSTR(""), kCFStringEncodingUTF8);
    return (NSString *)CFBridgingRelease(newString);
}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length
{
    static char table1[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table1[(value >> 18) & 0x3F];
        output[index + 1] =                    table1[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table1[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table1[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (NSString *)getCountdownString:(NSTimeInterval)differenceSeconds
{
    NSInteger days = (NSInteger)((double)differenceSeconds/(3600.0*24.00));
    NSInteger diffDay = differenceSeconds-(days*3600*24);
    NSInteger hours = (NSInteger)((double)diffDay/3600.00);
    NSInteger diffMin = diffDay-(hours*3600);
    NSInteger minutes = (NSInteger)(diffMin/60.0);
    NSInteger seconds = diffMin-(minutes*60);
    
    NSString *countdown;
    
    if (days > 0)
    {
        countdown = [NSString stringWithFormat:@"%ldd %02ld:%02ld:%02ld",(long)days,(long)hours,(long)minutes,(long)seconds];
    }
    else
    {
        countdown = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours,(long)minutes,(long)seconds];
    }
    
    return countdown;
}

- (void)updateMainView:(NSString *)base_id
{
    [self settSelectedBaseId:base_id];
    [self updateBaseData];
}

- (void)checkVersion
{
    if (self.wsProductIdentifiers != nil)
    {
        float latest_version = [self.wsProductIdentifiers[@"latest_version"] floatValue];
        float this_version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
        
        if (latest_version > this_version)
        {
            [self showDialogBlock:@"New Version Available. Upgrade to latest version?"
                                 :2
                                 :^(NSInteger index, NSString *text)
             {
                 if(index == 1) //YES
                 {
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.wsProductIdentifiers[@"url_app"]]];
                 }
             }];
        }
    }
}

- (void)updateProductIdentifiers
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/ProductIdentifiers/%@", 
					   WS_URL, [self GameId]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	self.wsProductIdentifiers = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *)getProductIdentifiers
{
	return self.wsProductIdentifiers;
}

- (BOOL)updateSalesData
{
    BOOL hasSale = NO;
    
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetSales",
					   WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
    if (wsResponse.count > 0)
    {
        self.wsSalesData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
        hasSale = YES;
    }
    else
    {
        self.wsSalesData = nil;
    }
    
    return hasSale;
}

- (BOOL)updateClubData
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetClub/%@",
                   WS_URL, self.UID];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
    
    if([wsResponse count] > 0)
    {
        wsClubData = [[NSMutableDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"UpdateHeader"
         object:self]; //Update to header
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)getServerClubData:(returnBlock)completionBlock
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetClub/%@",
                       WS_URL, self.UID];
    NSURL *url = [NSURL URLWithString:[wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", wsurl, error, [error localizedDescription]);
             completionBlock(NO, nil);
         }
         else
         {
             NSArray *wsResponse = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
             if([wsResponse count] > 0)
             {
                 wsClubData = [[NSMutableDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
                 completionBlock(YES, data);
             }
             else
             {
                 completionBlock(NO, nil);
             }
         }
     }];
}

- (void)updateClubInfoData: (NSString *) clubId
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetClubInfo/%@", 
					   WS_URL, clubId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsClubInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (void)updateClubInfoFb: (NSString *)fb_id
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetClubFB/%@", 
					   WS_URL, fb_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	if(wsResponse.count > 0)
	{
		wsClubInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
	}
}

- (void)updateMyAchievementsData
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetAchievements/%@", 
					   [self world_url], wsClubData[@"club_id"]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsMyAchievementsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (void)updateBasesData
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetBases/%@",
					   [self world_url], wsClubData[@"club_id"]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsBasesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (void)updateWorldsData
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetAllWorld",
					   WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsWorldsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (void)updateBaseData
{
    NSString *baseid = @"0";
    
    if ([self.gettSelectedBaseId isEqualToString:@"0"])
    {
        [self updateBasesData];
        wsBaseData = [[NSDictionary alloc] initWithDictionary:wsBasesData[0] copyItems:YES];
        
        baseid = [[Globals i] wsBaseData][@"base_id"];
        [self settSelectedBaseId:baseid];
    }
    else
    {
        baseid = self.gettSelectedBaseId;
        
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetBase/%@/%@",
                           [self world_url], baseid, wsClubData[@"club_id"]];
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
        if (wsResponse.count > 0)
        {
            wsBaseData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
        }
        else
        {
            [self updateBasesData];
            wsBaseData = [[NSDictionary alloc] initWithDictionary:wsBasesData[0] copyItems:YES];
            
            baseid = [[Globals i] wsBaseData][@"base_id"];
            [self settSelectedBaseId:baseid];
        }
        
    }
}

- (NSInteger)getMailBadgeNumber
{
	NSInteger count = 0;
	
	if([localMailData count] > 0)
	{
		for(NSDictionary *rowData in localMailData)
		{
			if([rowData[@"open_read"] isEqualToString:@"0"])
			{
                count = count + 1;
			}
		}
	}
	
	return count;
}

- (NSInteger)getReportBadgeNumber
{
	NSInteger count = 0;
	
	if([localReportData count] > 0)
	{
		for(NSDictionary *rowData in localReportData)
		{
			if([rowData[@"open_read"] isEqualToString:@"0"])
			{
                count = count + 1;
			}
		}
	}
	
	return count;
}

- (NSString *)getLastChatString
{
    NSString *message;
    
    NSInteger i = [wsChatFullData count];
    if (i == 0)
    {
        message = @""; //nothing to display
    }
    else if (i == 1)
    {
        NSDictionary *rowData = wsChatFullData[0];
        message = [NSString stringWithFormat:@"%@: %@",
                             rowData[@"club_name"],
                             rowData[@"message"]];
    }
    else
    {
        NSDictionary *rowData = wsChatFullData[i-2];
        message = [NSString stringWithFormat:@"%@: %@",
                             rowData[@"club_name"],
                             rowData[@"message"]];
        
        rowData = wsChatFullData[i-1];
        message = [NSString stringWithFormat:@"%@\n%@: %@",
                   message,
                   rowData[@"club_name"],
                   rowData[@"message"]];
    }
    
    return message;
}

- (NSString *)getLastChatID
{
    NSInteger i = [wsChatFullData count];
    if(i == 0)
    {
        return @"0"; //tells server to fetch most current
    }
    else
    {
        NSDictionary *rowData = wsChatFullData[i-1];
        return rowData[@"chat_id"];
    }
}

- (NSString *)getLastAllianceChatID
{
    NSInteger i = [wsAllianceChatFullData count];
    if(i == 0)
    {
        return @"0"; //tells server to fetch most current
    }
    else
    {
        NSDictionary *rowData = wsAllianceChatFullData[i-1];
        return rowData[@"chat_id"];
    }
}

- (void)updateChatData
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetChat1/%@",
                           [self world_url], [self getLastChatID]];
        
        [Globals getServer:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 self.wsChatData = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
                 if ([wsChatData count] > 0)
                 {
                     if(wsChatFullData == nil)
                     {
                         wsChatFullData = [[NSMutableArray alloc] initWithArray:wsChatData copyItems:YES];
                     }
                     else
                     {
                         [wsChatFullData addObjectsFromArray:wsChatData];
                     }
                     
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"ChatWorld"
                      object:self];
                 }
             }
         }];
}

- (void)updateAllianceChatData
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetAllianceChat/%@/%@",
                           [self world_url], [self getLastAllianceChatID], wsClubData[@"alliance_id"]];
        
        [Globals getServer:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 self.wsAllianceChatData = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
                 
                 if ([wsAllianceChatData count] > 0)
                 {
                     if(wsAllianceChatFullData == nil)
                     {
                         wsAllianceChatFullData = [[NSMutableArray alloc] initWithArray:wsAllianceChatData copyItems:YES];
                     }
                     else
                     {
                         [wsAllianceChatFullData addObjectsFromArray:wsAllianceChatData];
                     }
                     
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"ChatAlliance"
                      object:self];
                 }
             }
         }];
}

- (void)updateReportData
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetReport/%@/%@/%@",
                           [self world_url],
                           [self gettLastReportId],
                           wsClubData[@"club_id"],
                           wsClubData[@"alliance_id"]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsReportData = [[NSMutableArray alloc] initWithContentsOfURL:url];
        
        if (wsReportData.count > 0)
        {
            [self settLastReportId:(wsReportData)[0][@"report_id"]];
            [self addLocalReportData:wsReportData];
        }
}

- (void)updateMailData //Get all mail from mail_id=0 because need to see if there is reply
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetMail/0/%@/%@",
                           [self world_url],
                           wsClubData[@"club_id"],
                           wsClubData[@"alliance_id"]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsMailData = [[NSMutableArray alloc] initWithContentsOfURL:url];
        
        if (wsMailData.count > 0)
        {
            [self addLocalMailData:wsMailData];
            [self settLastMailId:(wsMailData)[0][@"mail_id"]];
        }
}

- (void)updateMailReply:(NSString *)mail_id
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetMailReply/%@",
                           [self world_url],
                           mail_id];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsMailReply = [[NSMutableArray alloc] initWithContentsOfURL:url];
    
    if (wsMailReply.count > 0)
    {
        [self addMailReply:mail_id :wsMailReply];
    }
}

// SPORTS GLOBAL

- (NSString *)PlayerSkill1
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Keeper";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Keeper";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Footwork";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Catching";
    }
    else
    {
        return @"Keeper";
    }
}

- (NSString *)PlayerSkill2
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Defend";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Defend";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Defensive";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Running";
    }
    else
    {
        return @"Defend";
    }
}

- (NSString *)PlayerSkill3
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Playmaking";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Playmaking";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Dribbling";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Pitching";
    }
    else
    {
        return @"Playmaking";
    }
}

- (NSString *)PlayerSkill4
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Attack";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Attack";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Shooting";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Hitting";
    }
    else
    {
        return @"Attack";
    }
}

- (NSString *)PlayerSkill5
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Passing";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Passing";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Passing";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Throwing";
    }
    else
    {
        return @"Passing";
    }
}

- (NSString *)PlayerSkill6
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Condition";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Condition";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Condition";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Condition";
    }
    else
    {
        return @"Condition";
    }
}

- (NSUInteger)getMaxSeries:(NSUInteger)division
{
	if(division == 1)
		return 1;
	if(division == 2)
		return 5;
	if(division == 3)
		return 25;
	if(division == 4)
		return 125;
	if(division > 4)
		return 625;
	
	return 1;
}

- (NSString *)gettAccepted
{
    acceptedMatch = [[NSUserDefaults standardUserDefaults] objectForKey:@"AcceptedMatch"];
    if (acceptedMatch == nil)
    {
        acceptedMatch = @"0";
    }
    
    return acceptedMatch;
}

- (void)settAccepted:(NSString *)match_id
{
    acceptedMatch = match_id;
    [[NSUserDefaults standardUserDefaults] setObject:acceptedMatch forKey:@"AcceptedMatch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeEnergy
{
    NSInteger energy_max = [wsClubData[@"energy"] integerValue];
    NSInteger energy_togo = energy_max - energy;
    if (energy_togo > 0)
    {
        [self scheduleNotification:[[NSDate date] dateByAddingTimeInterval:energy_togo*180] :@"Your energy is full! Train your players and level up now!"];
    }
}

- (NSInteger)retrieveEnergy
{
	self.energy = [wsClubData[@"e"] integerValue];
	[self storeEnergy];
	
	return self.energy;
}

- (PlayerCell *)playerCellHandler:(UITableView *)tableView
						indexPath:(NSIndexPath *)indexPath
					  playerArray:(NSMutableArray *)players
						 checkPos:(BOOL)checkPos
{
	static NSString *CellIdentifier = @"PlayerCell";
	PlayerCell *cell = (PlayerCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlayerCell" owner:self options:nil];
		cell = (PlayerCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = players[row];
	NSString *row_player_id = rowData[@"player_id"];
	NSString *player_id = row_player_id;
	NSString *name = rowData[@"player_name"];
	NSString *age = rowData[@"player_age"];
	cell.playerName.text = [NSString stringWithFormat:@"%@ (Age: %@)", name, age];
	
	NSString *salary = [[Globals i] numberFormat:rowData[@"player_salary"]];
	NSString *mvalue = [[Globals i] numberFormat:rowData[@"player_value"]];
	cell.playerValue.text = [NSString stringWithFormat:@"$%@/week (Value: $%@)", salary, mvalue];
	
	cell.keeper.text = [NSString stringWithFormat:@"%ld", (long)[rowData[@"keeper"] integerValue]/2];
    [cell.pbkeeper setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"keeper"] integerValue]/10]]];
    
	cell.defending.text = [NSString stringWithFormat:@"%ld", (long)[rowData[@"defend"] integerValue]/2];
    [cell.pbdefending setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"defend"] integerValue]/10]]];
    
	cell.playmaking.text = [NSString stringWithFormat:@"%ld", (long)[rowData[@"playmaking"] integerValue]/2];
    [cell.pbplaymaking setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"playmaking"] integerValue]/10]]];
    
	cell.passing.text = [NSString stringWithFormat:@"%ld", (long)[rowData[@"passing"] integerValue]/2];
    [cell.pbpassing setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"passing"] integerValue]/10]]];
    
	cell.scoring.text = [NSString stringWithFormat:@"%ld", (long)[rowData[@"attack"] integerValue]/2];
    [cell.pbscoring setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"attack"] integerValue]/10]]];
    
	cell.stamina.text = [NSString stringWithFormat:@"%ld%%", (long)[rowData[@"fitness"] integerValue]/2];
    
    if ([rowData[@"fitness"] integerValue] < 80)
    {
        cell.stamina.textColor = [UIColor redColor];
    }
    else if ([rowData[@"fitness"] integerValue] < 150)
    {
        cell.stamina.textColor = [UIColor yellowColor];
    }
    else
    {
        cell.stamina.textColor = [UIColor greenColor];
    }
	
	cell.card1.backgroundColor = [UIColor clearColor];
	cell.card2.backgroundColor = [UIColor clearColor];
	
	if([rowData[@"card_red"] integerValue] == 1)
	{
		cell.card1.backgroundColor = [UIColor redColor];
	}
	else if([rowData[@"card_yellow"] integerValue] == 2)
	{
		cell.card1.backgroundColor = [UIColor yellowColor];
		cell.card2.backgroundColor = [UIColor yellowColor];
	}
	else if([rowData[@"card_yellow"] integerValue] == 1)
	{
		cell.card1.backgroundColor = [UIColor yellowColor];
	}
	else
    {
		cell.card1.backgroundColor = [UIColor clearColor];
		cell.card2.backgroundColor = [UIColor clearColor];
	}
	
	switch([rowData[@"player_condition"] integerValue])
	{
		case 1:
            [cell.injuredbruisedImage setImage:[UIImage imageNamed:@"icon_bruised.png"]];
			break;
		case 2:
            [cell.injuredbruisedImage setImage:[UIImage imageNamed:@"icon_injured.png"]];
			break;
		default:
			cell.injuredbruisedImage.image = nil;
			break;
	}
    
    if ([rowData[@"player_condition_days"] integerValue] > 0)
    {
        cell.condition.text = [NSString stringWithFormat:@"%@ Days", rowData[@"player_condition_days"]];
    }
    else
    {
        cell.condition.text = @"";
    }
	
	NSInteger pid = [player_id integerValue];
	NSInteger f = (pid % 1000);
	NSString *fname = [NSString stringWithFormat:@"z%ld.png", (long)f];
	[cell.faceImage setImage:[UIImage imageNamed:fname]];
	
	NSInteger g = [rowData[@"player_goals"] integerValue];
	switch(g)
	{
		case 0:
			cell.star5.image = nil;
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 1:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 2:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 3:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 4:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 5:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 6:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 7:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star1.image = nil;
			break;
		case 8:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star1.image = nil;
			break;
		case 9:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star1 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		case 10:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star1 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		default:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
	}
	
	if(checkPos)
	{
        if ([[[Globals i] GameType] isEqualToString:@"hockey"])
        {
            if([wsClubData[@"gk"] isEqualToString:row_player_id])
                cell.position.text = @"(GK)";
            else if([wsClubData[@"rw"] isEqualToString:row_player_id])
                cell.position.text = @"(WNG1)";
            else if([wsClubData[@"lw"] isEqualToString:row_player_id])
                cell.position.text = @"(WNG2)";
            else if([wsClubData[@"cd1"] isEqualToString:row_player_id])
                cell.position.text = @"(DEF1)";
            else if([wsClubData[@"cd2"] isEqualToString:row_player_id])
                cell.position.text = @"(DEF2)";
            else if([wsClubData[@"im1"] isEqualToString:row_player_id])
                cell.position.text = @"(CTR1)";
            else if([wsClubData[@"im2"] isEqualToString:row_player_id])
                cell.position.text = @"(CTR2)";
            else if([wsClubData[@"fw1"] isEqualToString:row_player_id])
                cell.position.text = @"(FWD1)";
            else if([wsClubData[@"fw2"] isEqualToString:row_player_id])
                cell.position.text = @"(FWD2)";
            else if([wsClubData[@"sgk"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.GK)";
            else if([wsClubData[@"sd"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.DEF)";
            else if([wsClubData[@"sim"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.CTR)";
            else if([wsClubData[@"sfw"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.FWD)";
            else if([wsClubData[@"sw"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.WING)";
            else
                cell.position.text = @" ";
        }
        else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
        {
            if([wsClubData[@"gk"] isEqualToString:row_player_id])
                cell.position.text = @"(PG)";
            else if([wsClubData[@"cd1"] isEqualToString:row_player_id])
                cell.position.text = @"(SG)";
            else if([wsClubData[@"im1"] isEqualToString:row_player_id])
                cell.position.text = @"(CTR)";
            else if([wsClubData[@"fw1"] isEqualToString:row_player_id])
                cell.position.text = @"(PF)";
            else if([wsClubData[@"fw2"] isEqualToString:row_player_id])
                cell.position.text = @"(SF)";
            else if([wsClubData[@"sgk"] isEqualToString:row_player_id])
                cell.position.text = @"(B.PG)";
            else if([wsClubData[@"sd"] isEqualToString:row_player_id])
                cell.position.text = @"(B.SG)";
            else if([wsClubData[@"sim"] isEqualToString:row_player_id])
                cell.position.text = @"(B.CTR)";
            else if([wsClubData[@"sfw"] isEqualToString:row_player_id])
                cell.position.text = @"(B.PF)";
            else if([wsClubData[@"sw"] isEqualToString:row_player_id])
                cell.position.text = @"(B.SF)";
            else
                cell.position.text = @" ";
        }
        else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
        {
            if([[wsClubData objectForKey:@"gk"] isEqualToString:row_player_id])
                cell.position.text = @"(C)";
            else if([[wsClubData objectForKey:@"rb"] isEqualToString:row_player_id])
                cell.position.text = @"(RF)";
            else if([[wsClubData objectForKey:@"lb"] isEqualToString:row_player_id])
                cell.position.text = @"(LF)";
            else if([[wsClubData objectForKey:@"cd1"] isEqualToString:row_player_id])
                cell.position.text = @"(CF)";
            else if([[wsClubData objectForKey:@"cd2"] isEqualToString:row_player_id])
                cell.position.text = @"(SS)";
            else if([[wsClubData objectForKey:@"im1"] isEqualToString:row_player_id])
                cell.position.text = @"(P)";
            else if([[wsClubData objectForKey:@"fw1"] isEqualToString:row_player_id])
                cell.position.text = @"(1B)";
            else if([[wsClubData objectForKey:@"fw2"] isEqualToString:row_player_id])
                cell.position.text = @"(2B)";
            else if([[wsClubData objectForKey:@"fw3"] isEqualToString:row_player_id])
                cell.position.text = @"(3B)";
            else if([[wsClubData objectForKey:@"sgk"] isEqualToString:row_player_id])
                cell.position.text = @"(Bench 1)";
            else if([[wsClubData objectForKey:@"sd"] isEqualToString:row_player_id])
                cell.position.text = @"(Bench 2";
            else if([[wsClubData objectForKey:@"sim"] isEqualToString:row_player_id])
                cell.position.text = @"(Bench 3)";
            else if([[wsClubData objectForKey:@"sfw"] isEqualToString:row_player_id])
                cell.position.text = @"(Bench 4)";
            else if([[wsClubData objectForKey:@"sw"] isEqualToString:row_player_id])
                cell.position.text = @"(Bench 5)";
            else
                cell.position.text = @" ";
        }
        else
        {
            if([wsClubData[@"gk"] isEqualToString:row_player_id])
                cell.position.text = @"(GK)";
            else if([wsClubData[@"rb"] isEqualToString:row_player_id])
                cell.position.text = @"(DR)";
            else if([wsClubData[@"lb"] isEqualToString:row_player_id])
                cell.position.text = @"(DL)";
            else if([wsClubData[@"rw"] isEqualToString:row_player_id])
                cell.position.text = @"(MR)";
            else if([wsClubData[@"lw"] isEqualToString:row_player_id])
                cell.position.text = @"(ML)";
            else if([wsClubData[@"cd1"] isEqualToString:row_player_id])
                cell.position.text = @"(DC1)";
            else if([wsClubData[@"cd2"] isEqualToString:row_player_id])
                cell.position.text = @"(DC2)";
            else if([wsClubData[@"cd3"] isEqualToString:row_player_id])
                cell.position.text = @"(DC3)";
            else if([wsClubData[@"im1"] isEqualToString:row_player_id])
                cell.position.text = @"(MC1)";
            else if([wsClubData[@"im2"] isEqualToString:row_player_id])
                cell.position.text = @"(MC2)";
            else if([wsClubData[@"im3"] isEqualToString:row_player_id])
                cell.position.text = @"(MC3)";
            else if([wsClubData[@"fw1"] isEqualToString:row_player_id])
                cell.position.text = @"(SC1)";
            else if([wsClubData[@"fw2"] isEqualToString:row_player_id])
                cell.position.text = @"(SC2)";
            else if([wsClubData[@"fw3"] isEqualToString:row_player_id])
                cell.position.text = @"(SC3)";
            else if([wsClubData[@"sgk"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.GK)";
            else if([wsClubData[@"sd"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.DCLR)";
            else if([wsClubData[@"sim"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.MC)";
            else if([wsClubData[@"sfw"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.SC)";
            else if([wsClubData[@"sw"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.MLR)";
            else
                cell.position.text = @" ";
        }
	}
	else
	{
		cell.position.text = rowData[@"position"];
	}
    
    cell.skill1.text = [self PlayerSkill1];
    cell.skill2.text = [self PlayerSkill2];
    cell.skill3.text = [self PlayerSkill3];
    cell.skill4.text = [self PlayerSkill4];
    cell.skill5.text = [self PlayerSkill5];
	
	return cell;
}

- (UIButton *)dynamicButtonWithTitle:(NSString *)title
                              target:(id)target
                            selector:(SEL)selector
                               frame:(CGRect)frame
                                type:(NSString *)type
{
    float button_width = frame.size.width;
    float button_height = frame.size.height;
    
    BOOL button_shrink = NO;
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
    if ((button_width > 100.0f) && (button_height > 60.0f))
    {
        button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
    }
    else
    {
        button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SMALL_SIZE];
    }
    
    if (button_height > 80.0f)
    {
        button_shrink = NO;
    }
    else
    {
        button_shrink = YES;
    }
    
	[button setTitle:title forState:UIControlStateNormal];
    
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];

	button.backgroundColor = [UIColor clearColor];
    
    UIImage *img1 = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_1.png", type]];
    UIImage *img2 = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_2.png", type]];
    UIImage *img3 = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_3.png", type]];
    UIImage *img4 = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_4.png", type]];
    UIImage *img5 = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_5.png", type]];
    UIImage *img6 = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_6.png", type]];
    
    UIImage *img1_h = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_1_h.png", type]];
    UIImage *img2_h = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_2_h.png", type]];
    UIImage *img3_h = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_3_h.png", type]];
    UIImage *img4_h = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_4_h.png", type]];
    UIImage *img5_h = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_5_h.png", type]];
    UIImage *img6_h = [UIImage imageNamed:[NSString stringWithFormat:@"btn%@_6_h.png", type]];
    
    CGSize btnSize = CGSizeMake(button_width, button_height);
    UIGraphicsBeginImageContext(btnSize);
    
    CGSize newSize = CGSizeMake(img1.size.width, img1.size.height);
    
    if (button_shrink)
    {
        float shrink_height = img1.size.height - (80.0f - button_height);
        if (shrink_height < 21.0f)
        {
            shrink_height = 21.0f;
        }
        newSize = CGSizeMake(img1.size.width, shrink_height);
    }
    
    [img1 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    [img2 drawInRect:CGRectMake(newSize.width, 0, button_width - (newSize.width*2), newSize.height)];
    [img3 drawInRect:CGRectMake(button_width - newSize.width, 0, newSize.width, newSize.height)];
    
    [[img4 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 27.f, 0)
                          resizingMode:UIImageResizingModeStretch]
    drawInRect:CGRectMake(0, newSize.height, newSize.width, button_height - newSize.height)];
    
    [[img5 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 27.f, 0)
                          resizingMode:UIImageResizingModeStretch]
    drawInRect:CGRectMake(newSize.width, newSize.height, button_width - (newSize.width*2), button_height - newSize.height)];
    
    [[img6 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 27.f, 0)
                         resizingMode:UIImageResizingModeStretch]
    drawInRect:CGRectMake(button_width - newSize.width, newSize.height, newSize.width, button_height - newSize.height)];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
    
    //Draw highlighted image
    UIGraphicsBeginImageContext(btnSize);

    [img1_h drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    [img2_h drawInRect:CGRectMake(newSize.width, 0, button_width - (newSize.width*2), newSize.height)];
    [img3_h drawInRect:CGRectMake(button_width - newSize.width, 0, newSize.width, newSize.height)];
    
    [[img4_h resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 27.f, 0)
                          resizingMode:UIImageResizingModeStretch]
     drawInRect:CGRectMake(0, newSize.height, newSize.width, button_height - newSize.height)];
    
    [[img5_h resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 27.f, 0)
                          resizingMode:UIImageResizingModeStretch]
     drawInRect:CGRectMake(newSize.width, newSize.height, button_width - (newSize.width*2), button_height - newSize.height)];
    
    [[img6_h resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 27.f, 0)
                          resizingMode:UIImageResizingModeStretch]
     drawInRect:CGRectMake(button_width - newSize.width, newSize.height, newSize.width, button_height - newSize.height)];
    
    UIImage *newImage_h = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	[button setBackgroundImage:newImage_h forState:UIControlStateHighlighted];
	
	return button;
}

- (UIButton *)buttonWithTitle:(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
{
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	if (darkTextColor)
	{
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	else
	{
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}

- (NSString *)urlEnc:(NSString *)str
{
	NSString *escaped = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"/" withString:@"="];
	escaped = [escaped stringByReplacingOccurrencesOfString:@":" withString:@";"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"?" withString:@","];
	
	return escaped;
}

- (void)buyProduct:(NSString *)productId :(NSString *)isVirtualMoney :(NSString *)json
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/BuyProductNew/%@/%@/%@/%@",
					   WS_URL, isVirtualMoney, productId, self.UID, json];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
}

- (void)changeTraining:(NSString *)trainingId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangeTraining/%@/%@",
					   WS_URL, self.UID, trainingId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
	[self updateClubData]; //training_id is set
    
    [self showToast:@"Training Changed for the week" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)changeFormation:(NSString *)formationId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangeFormation/%@/%@",
					   WS_URL, self.UID, formationId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
	
    [self updateClubData]; //formation_id is set
    
    [self showToast:@"Formation Changed" optionalTitle:nil optionalImage:@"tick_yes"];

}

- (void)changeTactic:(NSString *)tacticId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangeTactic/%@/%@",
					   WS_URL, self.UID, tacticId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
	[self updateClubData]; //tactic_id is set
    
    [self showToast:@"Tactics Changed" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)changePlayerFormation:(NSString *)player_id :(NSString *)formation_pos
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangePlayerFormation/%@/%@/%@",
					   WS_URL, self.UID, player_id, formation_pos];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
	[self updateClubData]; //player_id at formation set
    
    [self showToast:@"Player is Set" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)challengeClub:(NSString *)home :(NSString *)away :(NSString *)win :(NSString *)lose :(NSString *)draw :(NSString *)note
{
	NSString *encodedNote = [self urlEnc:note];
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/CreateChallenge/%@/%@/%@/%@/%@/%@",
					   WS_URL, self.UID, away, win, lose, draw, encodedNote];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"Club has been challenged" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (NSString *)doPost:(NSString *)message
{
	NSString *encodedMessage = [self urlEnc:message];
    NSString *encodedClubName = [self urlEnc:wsClubData[@"club_name"]];
    NSString *club_id = wsClubData[@"club_id"];
    NSString *a_id = wsClubData[@"alliance_id"];
    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AlliancePost/%@/%@/%@/%@",
                       WS_URL, a_id, club_id, encodedClubName, encodedMessage];
    
    return [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:wsurl] encoding:NSASCIIStringEncoding error:nil];
}

- (NSString *)doBid:(NSString *)player_id :(NSString *)value
{
    [Apsalar event:@"DoBid"];
    [Flurry logEvent:@"DoBid"];
    
	NSString *encodedValue = [self urlEnc:value];
    NSString *encodedClubName = [self urlEnc:wsClubData[@"club_name"]];
    NSString *club_id = wsClubData[@"club_id"];
    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/DoBid/%@/%@/%@/%@/%@",
                       WS_URL, self.UID, club_id, encodedClubName, player_id, encodedValue];
    
    
    [self showToast:@"Bid is successful" optionalTitle:nil optionalImage:@"tick_yes"];

    return [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:wsurl] encoding:NSASCIIStringEncoding error:nil];
}

- (void)challengeAccept:(NSString *)match_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AcceptChallenge/%@/%@",
					   WS_URL, match_id, self.UID];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
}

- (void)sellPlayer:(NSString *)player_value :(NSString *)player_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/SellPlayers/%@/%@/%@",
					   WS_URL, self.UID, player_value, player_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"Player Sold" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)healPlayer:(NSString *)player_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/HealPlayer/%@/%@",
					   WS_URL, self.UID, player_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"Player Healed" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)energizePlayer:(NSString *)player_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/EnergizePlayer/%@/%@",
					   WS_URL, self.UID, player_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"Player Energized" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)buyCoach:(NSString *)coach_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/BuyCoachs/%@/%@",
					   WS_URL, self.UID, coach_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"A new coach has been assigned to your club." optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)resetClub
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ResetClub/%@",
					   WS_URL, self.UID];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"Club Reset Success" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)updateCurrentSeasonData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetCurrentSeason",
					   WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsCurrentSeasonData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *)getCurrentSeasonData
{
	return wsCurrentSeasonData;
}

- (NSDictionary *)getClubData
{
	return wsClubData;
}

- (NSDictionary *)getClubInfoData
{
	return wsClubInfoData;
}

- (void)updateSquadData:(NSString *)clubId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayers/%@",
                       WS_URL, clubId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsSquadData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getSquadData
{
	return wsSquadData;
}

- (void)updateMySquadData
{
	workingSquad = 1;
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayers/%@",
					   WS_URL, wsClubData[@"club_id"]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsMySquadData = [[NSMutableArray alloc] initWithContentsOfURL:url];
	workingSquad = 0;
}

- (NSMutableArray *)getMySquadData
{
	return wsMySquadData;
}

- (NSMutableArray *)getMyAchievementsData
{
	return wsMyAchievementsData;
}

- (void)updateAllianceData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAlliance",
					   WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsAllianceData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getAllianceData
{
	return wsAllianceData;
}

- (NSInteger)getAchievementsBadge
{
	NSInteger count = 0;
	
	if([wsMyAchievementsData count] > 0)
	{
		for(NSDictionary *rowData in wsMyAchievementsData)
		{
			if(![rowData[@"club_id"] isEqualToString:@"0"])
			{
                if([rowData[@"claimed"] isEqualToString:@"False"])
                {
                    count = count + 1;
                }
			}
		}
	}
	
	return count;
}

- (void)updateProducts
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetProducts", WS_URL];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsProductsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getProducts
{
	return wsProductsData;
}

- (void)updatePlayerSaleData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayersBid", WS_URL];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsPlayerSaleData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getPlayerSaleData
{
	return wsPlayerSaleData;
}

- (void)updateCoachData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetCoaches", WS_URL];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsCoachData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getCoachData
{
	return wsCoachData;
}

- (void)updatePlayerInfoData:(NSString *)playerId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayerInfo/%@",
					   WS_URL, playerId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsPlayerInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *)getPlayerInfoData
{
	return wsPlayerInfoData;
}

- (void)updateMatchInfoData:(NSString *)matchId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchInfo/%@",
					   WS_URL, matchId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsMatchInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *)getMatchInfoData
{
	return wsMatchInfoData;
}

- (void)updateMatchData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchUpcomings/%@",
                           WS_URL, self.UID];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsMatchData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMatchData
{
	return wsMatchData;
}

- (void)updateMatchPlayedData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchPlayeds/%@",
                           WS_URL, self.UID];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsMatchPlayedData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMatchPlayedData
{
	return wsMatchPlayedData;
}

- (void)updateMatchHighlightsData:(NSString *)matchId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchHighlights/%@",
					   WS_URL, matchId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsMatchHighlightsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMatchHighlightsData
{
	return wsMatchHighlightsData;
}

- (void)updateChallengesData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetChallenge/%@",
                           WS_URL, self.UID];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsChallengesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getChallengesData
{
	return wsChallengesData;
}

- (void)updateChallengedData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetChallengeds/%@",
                           WS_URL, self.UID];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsChallengedData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getChallengedData
{
	return wsChallengedData;
}

- (void)updateLeagueData:(NSString *)division : (NSString *)series
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetSeries/%@/%@",
                           WS_URL, division, series];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsLeagueData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getLeagueData
{
	return wsLeagueData;
}

- (void)updatePromotionData:(NSString *)division
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetLeaguePromotion/%@",
                           WS_URL, division];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsPromotionData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getPromotionData
{
	return wsPromotionData;
}

- (void)updateLeagueScorersData:(NSString *)division :(NSString *)top
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetLeagueTopScorers/%@/%@",
                           WS_URL, division, top];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsLeagueScorersData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getLeagueScorersData
{
	return wsLeagueScorersData;
}

- (void)updateMatchFixturesData:(NSString *)division :(NSString *)series
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchFixtures/%@/%@",
                           WS_URL, division, series];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsMatchFixturesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMatchFixturesData
{
	return wsMatchFixturesData;
}

- (void)updateAllianceCupFixturesData:(NSString *)a_id round:(NSString *)round
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceCupFixtures/%@/%@",
						   WS_URL, a_id, round];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsAllianceCupFixturesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getAllianceCupFixturesData
{
	return wsAllianceCupFixturesData;
}

- (void)updateTrophyData:(NSString *)clubId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetTrophy/%@",
					   WS_URL, clubId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsTrophyData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getTrophyData
{
	return wsTrophyData;
}

- (void)updateNewsData:(NSString *)division :(NSString *)series :(NSString *)playing_cup
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetNews/%@/%@/%@/%@",
                           WS_URL, wsClubData[@"club_id"], division, series, playing_cup];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsNewsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getNewsData
{
	return wsNewsData;
}

- (void)updateWallData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceWall/%@",
                           WS_URL, wsClubData[@"alliance_id"]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsWallData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getWallData
{
	return wsWallData;
}

- (void)updateEventsData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceEvents/%@",
                           WS_URL, wsClubData[@"alliance_id"]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsEventsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getEventsData
{
	return wsEventsData;
}

- (void)updateDonationsData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceDonations/%@",
                       WS_URL, wsClubData[@"alliance_id"]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsDonationsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getDonationsData
{
	return wsDonationsData;
}

- (void)updateAppliedData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceApply/%@",
                       WS_URL, wsClubData[@"alliance_id"]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsAppliedData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getAppliedData
{
	return wsAppliedData;
}

- (void)updateMembersData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceMembers/%@",
                       WS_URL, wsClubData[@"alliance_id"]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsMembersData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMembersData
{
	return wsMembersData;
}

- (void)updateMarqueeData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMarquee/%@/%@/%@/%@",
                       WS_URL, wsClubData[@"club_id"], wsClubData[@"division"], wsClubData[@"series"], [self BoolToBit:wsClubData[@"playing_cup"]]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsMarqueeData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMarqueeData
{
	return wsMarqueeData;
}

@end
