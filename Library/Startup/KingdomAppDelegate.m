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

@implementation KingdomAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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