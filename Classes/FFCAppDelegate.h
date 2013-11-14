//
//  FFCAppDelegate.h
//  FFC
//
//  Created by Shankar on 6/26/09.
//  Copyright Shankar Nathan 2010. All rights reserved.
//

@class MainView;
@class LoginView;

@interface FFCAppDelegate : UIResponder <UIApplicationDelegate> 
{
    UIWindow *window;
	MainView *mainView;
	LoginView *loginView;
    BOOL facebookSwitching;
    BOOL logedIn;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet MainView *mainView;
@property (nonatomic, strong) IBOutlet LoginView *loginView;
-(void)gotoLogin;
-(void)gotoMain;
@end

