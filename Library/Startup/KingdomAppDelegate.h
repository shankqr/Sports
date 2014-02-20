//
//  KingdomAppDelegate.h
//  Kingdom Game
//
//  Created by Shankar on 6/26/09.
//  Copyright Shankar Nathan 2010. All rights reserved.
//

@class MainView;
@interface KingdomAppDelegate : UIResponder <UIApplicationDelegate> 

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, assign) BOOL facebookSwitching;
@property (nonatomic, assign) BOOL beenSleeping;

@end

