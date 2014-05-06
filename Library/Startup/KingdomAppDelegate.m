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
#import <FacebookSDK/FacebookSDK.h>

@implementation KingdomAppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    self.facebookSwitching = YES;
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    [FBSession.activeSession close];
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *api_key = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"FLURRY_KEY"];
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:api_key];
    
    self.facebookSwitching = NO;
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
    [FBSession.activeSession handleDidBecomeActive];
    
    [[Globals i] resetLoginReminderNotification];
    
    if (self.facebookSwitching)
    {
        self.facebookSwitching = NO;
    }
    else if (self.beenSleeping)
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