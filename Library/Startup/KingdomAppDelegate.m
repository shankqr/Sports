//
//  KingdomAppDelegate.mm
//  Kingdom Game
//
//  Created by Shankar on 6/26/09.
//  Copyright TapFantasy 2009. All rights reserved.
//

#import "KingdomAppDelegate.h"
#import "MainView.h"
#import "Globals.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Chartboost/Chartboost.h>
#import "HelpshiftCore.h"
#import "HelpshiftSupport.h"

@implementation KingdomAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    
    // Helpshift
    [HelpshiftCore initializeWithProvider:[HelpshiftSupport sharedInstance]];
    [HelpshiftCore installForApiKey:@"53313a53f1f7ec35f7ceb6d518db3a02"
                         domainName:@"tapfantasy.helpshift.com"
                              appID:@"tapfantasy_platform_20170126042011891-c22c552fb240d45"];
    
    // Initialize the Chartboost library
    [Chartboost startWithAppId:@"58897dfc43150f3e9caf1b8b"
                  appSignature:@"0f753289525659aa013e0f6fa032de9fec920fcd"
                      delegate:self];
    
    self.beenSleeping = NO;
    
	// launchOptions has the incoming notification if we're being launched after the user tapped "view"
	NSLog( @"didFinishLaunchingWithOptions:%@", launchOptions );
    [[UIApplication sharedApplication]
	 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
										 UIRemoteNotificationTypeSound |
										 UIRemoteNotificationTypeAlert)];
    application.applicationIconBadgeNumber = 0;
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainView = [[MainView alloc] init];
    [self.window setRootViewController:self.mainView];
	[self.window makeKeyAndVisible];
    
    [self.mainView startUp]; //Called one time only
    
	return YES;
}

- (void)application:(UIApplication *)app
didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Failed to register, error: %@", err);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	//NSLog( @"didReceiveRemoteNotification:%@", userInfo );
	[[Globals i] handleDidReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)app
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
	NSString *s1 = [devToken description];
	NSString *s2 = [s1 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"< >"]];
	NSString *s3 = [s2 stringByReplacingOccurrencesOfString:@" " withString:@""];
	[[Globals i] setDtoken:s3];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[Globals i] resetLoginReminderNotification];
    
    if (self.beenSleeping)
    {
        self.beenSleeping = NO;
        
        [self.mainView reloadView];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.beenSleeping = YES;
}

@end
