//
//  KingdomAppDelegate.h
//  Kingdom Game
//
//  Created by Shankar on 6/26/09.
//  Copyright Shankar Nathan 2010. All rights reserved.
//

@class MainView;

@interface KingdomAppDelegate : UIResponder <UIApplicationDelegate> 
{
    UIWindow *window;
	MainView *mainView;
    BOOL facebookSwitching;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet MainView *mainView;
@end

