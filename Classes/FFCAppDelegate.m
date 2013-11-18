//
//  FFCAppDelegate.mm
//  FFC
//
//  Created by Shankar on 6/26/09.
//  Copyright TapFantasy 2009. All rights reserved.
//

#import "FFCAppDelegate.h"
#import "MainView.h"
#import "LoginView.h"
#import "Globals.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FFCAppDelegate
@synthesize window;
@synthesize mainView;
@synthesize loginView;


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    facebookSwitching = YES;
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
    facebookSwitching = NO;
    logedIn = NO;
    
    [FBFriendPickerViewController class];
    
	// launchOptions has the incoming notification if we're being launched after the user tapped "view"
	NSLog( @"didFinishLaunchingWithOptions:%@", launchOptions );
    [[UIApplication sharedApplication]
	 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
										 UIRemoteNotificationTypeSound |
										 UIRemoteNotificationTypeAlert)];
    application.applicationIconBadgeNumber = 0;
    
    // Override point for customization after application launch.
    [window setRootViewController:loginView];
	[window makeKeyAndVisible];
    
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
	[self.mainView handleDidReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)app
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
	NSString *s1 = [devToken description];
	NSString *s2 = [s1 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"< >"]];
	NSString *s3 = [s2 stringByReplacingOccurrencesOfString:@" " withString:@""];
	[[Globals i] setDevicetoken:s3];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[Globals i] removeDialogBox];
    [[Globals i] removeLoadingAlert];
    
    [FBSession.activeSession handleDidBecomeActive];
    
    if (facebookSwitching)
    {
        facebookSwitching = NO;
    }
    else
    {
        if (logedIn)
        {
            [mainView reloadClubFromOutside];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    
}

-(void)gotoLogin
{
    logedIn = NO;
    
    [mainView.view removeFromSuperview];
	[window setRootViewController:loginView];
	[window makeKeyAndVisible];
    
    //[loginView removeLoadingAlert];
}

-(void)gotoMain
{
	[loginView.view removeFromSuperview];
	[window setRootViewController:mainView];
	[window makeKeyAndVisible];
    
    [mainView reloadViewFull];
    
    logedIn = YES;
}

@end