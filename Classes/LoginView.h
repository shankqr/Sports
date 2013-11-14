//
//  LoginView.h
//  FFC
//
//  Created by Shankar on 6/10/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "Globals.h"

@interface LoginView : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
    UITextField *emailText;
    UITextField *passwordText;
    UILabel *versionLabel;
    UIImageView *ivFlag;
    UILabel *lblWorld;
    BOOL launchWithInternet;
}
@property (nonatomic, strong) IBOutlet UITextField *emailText;
@property (nonatomic, strong) IBOutlet UITextField *passwordText;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *ivFlag;
@property (nonatomic, strong) IBOutlet UILabel *lblWorld;
- (BOOL)updateView;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (NSString *)FBErrorCodeDescription:(FBErrorCode) code;
- (IBAction)fbLogin:(UIButton *)sender;
- (IBAction)emailLogin:(UIButton *)sender;
- (IBAction)emailRegister:(UIButton *)sender;
- (IBAction)forgotPassword:(UIButton *)sender;
- (IBAction)contactSupport:(UIButton *)sender;
- (void)tryLogin;
- (void)tryloginFb;
- (void)tryRegister;
- (void)LoadMainView;
- (void)loginEmail;
- (void)registerEmail;
- (void)passwordReset;
@end
