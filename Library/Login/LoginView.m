//
//  LoginView.m
//  Kingdom Game
//
//  Created by Shankar on 6/10/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "LoginView.h"
#import "NSString+HMAC.h"
#import "QuartzCore/QuartzCore.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Globals.h"
#define kSecret @"year2000"

NSString *const SCSessionStateChangedNotification = @"com.tapf:SCSessionStateChangedNotification";

@implementation LoginView
@synthesize emailText;
@synthesize passwordText;
@synthesize versionLabel;
@synthesize ivFlag;
@synthesize lblWorld;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
	{
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [[emailText layer] setBorderColor:[[UIColor grayColor] CGColor]]; //border color
    [[emailText layer] setBackgroundColor:[[UIColor whiteColor] CGColor]]; //background color
    [[emailText layer] setBorderWidth:1.5]; // border width
    [[emailText layer] setCornerRadius:5]; // radius of rounded corners
    [emailText setClipsToBounds: YES]; //clip text within the bounds
    
    versionLabel.text = [NSString stringWithFormat:@"Version %@", GAME_VERSION];
    
    launchWithInternet = YES;
}

- (BOOL)updateView
{
    if ([[Globals i] UID] != nil && [[[Globals i] UID] length] > 1) //AutoLogin
    {
        [self LoadMainView];
    }
    else
    {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
    return YES;
}

- (void)updateWorldLabel
{
    NSString *wname = [Globals i].wsWorldData[@"world_name"];
    
    lblWorld.text = wname;
    [ivFlag setImage:[UIImage imageNamed:[NSString stringWithFormat:@"flag_%@.png", [Globals i].wsWorldData[@"flag_id"]]]];
}

- (IBAction)fbLogin:(UIButton *)sender
{
    if (launchWithInternet)
    {
        [self openSessionWithAllowLoginUI:YES];
    }
    else
    {
        if ([self updateView])
        {
            [self openSessionWithAllowLoginUI:YES];
        }
    }
}

- (IBAction)worldSelect:(UIButton *)sender
{
    if (launchWithInternet)
    {
        [[Globals i] showWorlds];
    }
    else
    {
        if ([self updateView])
        {
            [[Globals i] showWorlds];
        }
    }
}

- (IBAction)emailLogin:(UIButton *)sender
{
    if (launchWithInternet)
    {
        [self loginEmail];
    }
    else
    {
        if ([self updateView])
        {
            [self loginEmail];
        }
    }
}

- (IBAction)emailRegister:(UIButton *)sender
{
    if (launchWithInternet)
    {
        [self registerEmail];
    }
    else
    {
        if ([self updateView])
        {
            [self registerEmail];
        }
    }
}

- (IBAction)forgotPassword:(UIButton *)sender
{
    if (launchWithInternet)
    {
        [self passwordReset];
    }
    else
    {
        if ([self updateView])
        {
            [self passwordReset];
        }
    }
}

- (IBAction)contactSupport:(UIButton *)sender
{
    [[Globals i] emailToDeveloper];
}

#pragma mark - FBLoginViewDelegate
- (NSString *)FBErrorCodeDescription:(FBErrorCode) code
{
    switch(code){
        case FBErrorInvalid :{
            return @"FBErrorInvalid";
        }
        case FBErrorOperationCancelled:{
            return @"FBErrorOperationCancelled";
        }
        case FBErrorLoginFailedOrCancelled:{
            return @"FBErrorLoginFailedOrCancelled";
        }
        case FBErrorRequestConnectionApi:{
            return @"FBErrorRequestConnectionApi";
        }case FBErrorProtocolMismatch:{
            return @"FBErrorProtocolMismatch";
        }
        case FBErrorHTTPError:{
            return @"FBErrorHTTPError";
        }
        case FBErrorNonTextMimeTypeReturned:{
            return @"FBErrorNonTextMimeTypeReturned";
        }
        default:
            return @"[Unknown]";
    }
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
    {
        [self sessionStateChanged:session state:state error:error];
    }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            [[Globals i] showLoadingAlert];
            [self tryloginFb];
        }
            break;
        case FBSessionStateClosed:
        {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
            break;
        case FBSessionStateClosedLoginFailed:
        {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification
                                                        object:session];
    
    if (error)
    {
        NSString *errorTitle = [self FBErrorCodeDescription:error.code];
        NSString *errorMessage = error.localizedDescription;
        if (error.code == FBErrorLoginFailedOrCancelled)
        {
            errorTitle = @"Facebook Login Failed";
            errorMessage = @"Make sure you've allowed this App to use Facebook in Settings > Facebook.";
        }
        
        [[Globals i] showDialog:errorMessage];
    }
}

- (void)tryloginFb
{
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
        {
             if (!error)
             {
                 NSString *fid = user[@"id"];
                 NSString *hexHmac = [fid HMACWithSecret:kSecret];
                 NSString *uid = [[[Globals i] GameId] stringByAppendingString:hexHmac];
                 NSString *email = user[@"email"];
                 
                 NSString *wsurl = [NSString stringWithFormat:@"%@/Login/%@/%@/0/%@/%@/%@",
                                    WS_URL, uid, email, [[Globals i] getLat], [[Globals i] getLongi], [[Globals i] getDevicetoken]];
                 NSURL *url = [[NSURL alloc] initWithString:wsurl];
                 NSString *returnValue = [[NSString alloc] initWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
                 
                 int retval = [returnValue intValue];
                 
                 if(retval > -1) //Has an active facebook id registered
                 {
                     [[Globals i] setUID:uid];
                     [[Globals i] settLoginBonus:returnValue];
                     
                     [self performSelectorOnMainThread:@selector(LoadMainView)
                                            withObject:nil
                                         waitUntilDone:YES];
                     
                     [[Globals i] removeLoadingAlert];
                 }
                 else if(retval == -1)
                 {
                     NSString *name = user[@"name"];
                     NSString *username = user[@"username"];
                     NSString *gender = user[@"gender"];
                     NSString *timezone = user[@"timezone"];
                     
                     NSString *wsurlreg = [NSString stringWithFormat:@"%@/Register2/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
                                                              WS_URL, [[Globals i] GameId], uid, @"0", fid, email, name, username, gender, timezone, [[Globals i] getDevicetoken]];
                     NSString *wsurlreg2 = [wsurlreg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                     NSURL *urlreg = [[NSURL alloc] initWithString:wsurlreg2];
                     returnValue = [[NSString alloc] initWithContentsOfURL:urlreg encoding:NSASCIIStringEncoding error:nil];
                     
                     if([returnValue isEqualToString:@"1"]) //Register new uid success
                     {
                         [[Globals i] setUID:uid];
                         
                         [self performSelectorOnMainThread:@selector(LoadMainView)
                                                withObject:nil
                                             waitUntilDone:YES];
                         
                         [[Globals i] removeLoadingAlert];
                     }
                     else
                     {
                         [[Globals i] removeLoadingAlert];
                         
                         [[Globals i] showDialogError];
                     }
                 }
                 else
                 {
                     [[Globals i] removeLoadingAlert];
                     
                     [[Globals i] showDialogError];
                     }
             }
             else
             {
                 [[Globals i] removeLoadingAlert];
                 
                 [[Globals i] showDialogError];
             }
         }];
    }
    else
    {
        [[Globals i] removeLoadingAlert];
        
        [[Globals i] showDialogError];
    }
}

#pragma mark -
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (NSString *)stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    return hexString;
}

- (void)tryLogin
{
	@autoreleasepool {

        NSString *fid = [emailText.text lowercaseString];
        NSString *hexHmac = [fid HMACWithSecret:kSecret];
        NSString *uid = [[[Globals i] GameId] stringByAppendingString:hexHmac];
        NSString *email = emailText.text;
        NSString* hexPassword = [self stringToHex:passwordText.text];
        
        NSString *wsurl = [NSString stringWithFormat:@"%@/Login/%@/%@/%@/%@/%@/%@",
                           WS_URL, uid, email, hexPassword, [[Globals i] getLat], [[Globals i] getLongi], [[Globals i] getDevicetoken]];
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        NSString *returnValue = [[NSString alloc] initWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        
        int retval = [returnValue intValue];
        
        if(retval > -1) //Has an active email id registered
        {
            [[Globals i] setUID:uid];
            [[Globals i] settLoginBonus:returnValue];
            
            [self performSelectorOnMainThread:@selector(LoadMainView)
                                   withObject:nil
                                waitUntilDone:YES];
            
            [[Globals i] removeLoadingAlert];
        }
        else if(retval == -1)
        {
            [[Globals i] removeLoadingAlert];
            
            [[Globals i] showDialog:@"Invalid Email or Password. If have not Registered, please tap on +Register button."];
        }
        else
        {
            [[Globals i] removeLoadingAlert];
            
            [[Globals i] showDialogError];
        }
	
	}
}

- (void)tryRegister
{
	@autoreleasepool {
        
        NSString *fid = [emailText.text lowercaseString];
        NSString *hexHmac = [fid HMACWithSecret:kSecret];
        NSString *uid = [[[Globals i] GameId] stringByAppendingString:hexHmac];
        NSString *email = emailText.text;
        NSString* hexPassword = [self stringToHex:passwordText.text];
        
        NSString *wsurlreg = [NSString stringWithFormat:@"%@/Register2/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
                              WS_URL, [[Globals i] GameId], uid, hexPassword, @"0", email, @"0", @"0", @"0", @"0", [[Globals i] getDevicetoken]];
        NSString *wsurlreg2 = [wsurlreg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *urlreg = [[NSURL alloc] initWithString:wsurlreg2];
        NSString *returnValue = [[NSString alloc] initWithContentsOfURL:urlreg encoding:NSASCIIStringEncoding error:nil];
        
        if([returnValue isEqualToString:@"1"]) //Register new uid success
        {
            [[Globals i] setUID:uid];
            
            [self performSelectorOnMainThread:@selector(LoadMainView)
                                   withObject:nil
                                waitUntilDone:YES];
            
            [[Globals i] removeLoadingAlert];
        }
        else
        {
            [[Globals i] removeLoadingAlert];
            
            [[Globals i] showDialog:@"The email you entered is already registered. Tap on Login instead."];
        }
        
	}
}

- (void)loginEmail
{
    if ([self NSStringIsValidEmail:emailText.text])
    {
        if (passwordText.text.length > 3 && passwordText.text.length < 13)
        {
            [[Globals i] showLoadingAlert];
            [NSThread detachNewThreadSelector:@selector(tryLogin) toTarget:self withObject:nil];
        }
        else
        {
            [[Globals i] showDialog:@"Invalid Password. Password should be at least 4 to 12 characters."];
        }
    }
    else
    {
        [[Globals i] showDialog:@"Invalid Email. Please enter a valid Email (Example: john@gmail.com)"];

    }
}

- (void)registerEmail
{
    if ([self NSStringIsValidEmail:emailText.text])
    {
        if (passwordText.text.length > 3 && passwordText.text.length < 13)
        {
            [[Globals i] showLoadingAlert];
            [NSThread detachNewThreadSelector:@selector(tryRegister) toTarget:self withObject:nil];
        }
        else
        {
            [[Globals i] showDialog:@"Invalid Password. Password should be at least 4 to 12 characters."];
        }
    }
    else
    {
        [[Globals i] showDialog:@"Invalid Email. Please enter a valid Email (Example: john@gmail.com)"];
    }
}

- (void)passwordReset
{
    [[Globals i] showDialogBlock:@"Please enter your login Email"
                                :4
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //OK button is clicked
         {
             NSString *returnValue = @"0";
             
             if([self NSStringIsValidEmail:text])
             {
                 NSString *hexHmac = [text HMACWithSecret:kSecret];
                 NSString *uid = [[[Globals i] GameId] stringByAppendingString:hexHmac];
                 
                 NSString *wsurl = [NSString stringWithFormat:@"%@/PasswordRequest/%@/%@/%@",
                                    WS_URL, [[Globals i] GameId], uid, text];
                 NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 NSURL *url = [[NSURL alloc] initWithString:wsurl2];
                 returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
             }
             else
             {
                 [[Globals i] showDialog:@"Invalid Email. Please enter a valid Email (Example: john@gmail.com)"];
                 
                 return;
             }
             
             if([returnValue isEqualToString:@"1"])
             {
                 [[Globals i] showDialog:@"Please check the Email you sent us. We have sent an email to you with a link to your password. If you can't find it, it might be in your Spam folder."];
             }
             else
             {
                 [[Globals i] showDialog:@"Sorry, the Email you entered does not have an account with us."];
             }
         }
     }];
}

- (void)LoadMainView
{
    [[Globals i] closeTemplate];
    
    if (self.loginBlock != nil)
    {
        self.loginBlock(1);
    }
}

@end
