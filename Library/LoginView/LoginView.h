//
//  LoginView.h
//  Kingdom Game
//
//  Created by Shankar on 6/10/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

typedef void (^LoginBlock)(NSInteger status);

@interface LoginView : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) LoginBlock loginBlock;
@property (nonatomic, strong) IBOutlet UITextField *emailText;
@property (nonatomic, strong) IBOutlet UITextField *passwordText;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *ivFlag;
@property (nonatomic, strong) IBOutlet UILabel *lblWorld;
@property (nonatomic, assign) BOOL launchWithInternet;

- (BOOL)updateView;
- (void)updateWorldLabel;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (IBAction)fbLogin:(UIButton *)sender;
- (IBAction)emailLogin:(UIButton *)sender;
- (IBAction)emailRegister:(UIButton *)sender;
- (IBAction)forgotPassword:(UIButton *)sender;
- (IBAction)worldSelect:(UIButton *)sender;
- (IBAction)contactSupport:(UIButton *)sender;
- (void)tryLogin;
- (void)tryloginFb;
- (void)tryRegister;
- (void)LoadMainView;
- (void)loginEmail;
- (void)registerEmail;
- (void)passwordReset;

@end
