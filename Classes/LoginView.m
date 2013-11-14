//
//  LoginView.m
//  FFC
//
//  Created by Shankar on 6/10/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "LoginView.h"
#import "FFCAppDelegate.h"
#import "NSString+HMAC.h"
#import "QuartzCore/QuartzCore.h"
#define kSecret @"year2000"

NSString *const SCSessionStateChangedNotification = @"com.tapf:SCSessionStateChangedNotification";

@implementation LoginView
@synthesize emailText;
@synthesize passwordText;
@synthesize versionLabel;
@synthesize ivFlag;
@synthesize lblWorld;

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

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
    
    versionLabel.text = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    launchWithInternet = YES;
}

- (void)showLoadingAlert
{
	[[Globals i] showLoadingAlert:self.view];
}

- (void)removeLoadingAlert
{
    [[Globals i] removeLoadingAlert:self.view];
}

#pragma mark - FBLoginViewDelegate

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
            [self showLoadingAlert];
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
        
        [[Globals i] showDialog:self.view
                               :@"Login"
                               :errorTitle
                               :errorMessage
                               :1
                               :nil];
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
                 
                 NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/Login/%@/%@/%@/%@/%@/%@",
                                    WS_URL, uid, email, @"0", [[Globals i] getLat], [[Globals i] getLongi], [[Globals i] getDevicetoken]];
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
                     
                     [self removeLoadingAlert];
                 }
                 else if(retval == -1)
                 {
                     NSString *name = user[@"name"];
                     NSString *username = user[@"username"];
                     NSString *gender = user[@"gender"];
                     NSString *timezone = user[@"timezone"];
                     
                     NSString *wsurlreg = [[NSString alloc] initWithFormat:@"%@/Register2/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
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
                         
                         [self removeLoadingAlert];
                     }
                     else
                     {
                         [self removeLoadingAlert];
                         
                         [[Globals i] showDialog:self.view
                                                :@"Login"
                                                :@"Unable to Connect"
                                                :@"No internet connection was found or game server busy. Please check your network settings and try again."
                                                :1
                                                :nil];
                     }
                 }
                 else
                 {
                     [self removeLoadingAlert];
                     
                     [[Globals i] showDialog:self.view
                                            :@"Login"
                                            :@"Unable to Connect"
                                            :@"No internet connection was found or game server busy. Please check your network settings and try again."
                                            :1
                                            :nil];
                     }
             }
             else
             {
                 [self removeLoadingAlert];
                 
                 [[Globals i] showDialog:self.view
                                        :@"Login"
                                        :@"Unable to Connect"
                                        :@"No internet connection was found or game server busy. Please check your network settings and try again."
                                        :1
                                        :nil];
             }
         }];
    }
    else
    {
        [self removeLoadingAlert];
        
        [[Globals i] showDialog:self.view
                               :@"Login"
                               :@"Server was busy"
                               :@"Please try to login again."
                               :1
                               :nil];
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
        NSString *hexPassword = [self stringToHex:passwordText.text];
        
        NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/Login/%@/%@/%@/%@/%@/%@",
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
            
            [self removeLoadingAlert];
        }
        else if(retval == -1)
        {
            [self removeLoadingAlert];
            
            [[Globals i] showDialog:self.view
                                   :@"Login"
                                   :@"Invalid Email or Password"
                                   :@"Please enter a valid Email (Example: john@gmail.com) or Password. If have not Registered, please tap on +Register button."
                                   :1
                                   :nil];
        }
        else
        {
            [self removeLoadingAlert];
            
            [[Globals i] showDialog:self.view
                                   :@"Login"
                                   :@"Unable to Connect"
                                   :@"No internet connection was found or game server busy. Please check your network settings and try again."
                                   :1
                                   :nil];
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
        
        NSString *wsurlreg = [[NSString alloc] initWithFormat:@"%@/Register2/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
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
            
            [self removeLoadingAlert];
        }
        else
        {
            [self removeLoadingAlert];
            
            [[Globals i] showDialog:self.view
                                   :@"Register"
                                   :@"Email already exist."
                                   :@"The email you entered is already registered. Tap on Login instead."
                                   :1
                                   :nil];
        }
        
	}
}

- (void)loginEmail
{
    if ([self NSStringIsValidEmail:emailText.text])
    {
        if (passwordText.text.length > 3 && passwordText.text.length < 13)
        {
            [self showLoadingAlert];
            [NSThread detachNewThreadSelector:@selector(tryLogin) toTarget:self withObject:nil];
        }
        else
        {
            [[Globals i] showDialog:self.view
                                   :@"Login"
                                   :@"Invalid Password"
                                   :@"Password should be at least 4 to 12 characters."
                                   :1
                                   :nil];
        }
    }
    else
    {
        [[Globals i] showDialog:self.view
                               :@"Login"
                               :@"Invalid Email"
                               :@"Please enter a valid Email (Example: john@gmail.com)"
                               :1
                               :nil];
    }
}

- (void)registerEmail
{
    if ([self NSStringIsValidEmail:emailText.text])
    {
        if (passwordText.text.length > 3 && passwordText.text.length < 13)
        {
            [self showLoadingAlert];
            [NSThread detachNewThreadSelector:@selector(tryRegister) toTarget:self withObject:nil];
        }
        else
        {
            [[Globals i] showDialog:self.view
                                   :@"Login"
                                   :@"Invalid Password"
                                   :@"Password should be at least 4 to 12 characters."
                                   :1
                                   :nil];
        }
    }
    else
    {
        [[Globals i] showDialog:self.view
                               :@"Login"
                               :@"Invalid Email"
                               :@"Please enter a valid Email (Example: john@gmail.com)"
                               :1
                               :nil];
    }
}

- (void)passwordReset
{
    [[Globals i] showDialog:self.view
                           :@"Retrieve Password"
                           :@"Please enter your Email used for registration:"
                           :nil
                           :4
                           :^(NSInteger index, NSString *text)
     {
         NSLog(@"%@ is entered", text);
         
         if (index == 1) //OK button is clicked
         {
             NSString *returnValue = @"0";
             
             if([self NSStringIsValidEmail:text])
             {
                 NSString *hexHmac = [text HMACWithSecret:kSecret];
                 NSString *uid = [[[Globals i] GameId] stringByAppendingString:hexHmac];
                 
                 NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/PasswordRequest/%@/%@/%@",
                                    WS_URL, [[Globals i] GameId], uid, text];
                 NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 NSURL *url = [[NSURL alloc] initWithString:wsurl2];
                 returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
             }
             else
             {
                 [[Globals i] showDialog:self.view
                                        :@"Retrieve Password"
                                        :@"Invalid Email"
                                        :@"Please enter a valid Email (Example: john@gmail.com)"
                                        :1
                                        :nil];
                 
                 return;
             }
             
             if([returnValue isEqualToString:@"1"])
             {
                 [[Globals i] showDialog:self.view
                                        :@"Retrieve Password"
                                        :@"Request Sent!"
                                        :@"Please check the Email you sent us. We have sent an email with a link to your password. If you can't find it, it might be in your Spam folder."
                                        :1
                                        :nil];
             }
             else
             {
                 [[Globals i] showDialog:self.view
                                        :@"Retrieve Password"
                                        :@"Invalid Email"
                                        :@"Sorry, the Email you entered does not have an account with us."
                                        :1
                                        :nil];
             }
         }
     }];
}

- (void)LoadMainView
{
    FFCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate gotoMain];
}

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

- (BOOL)updateView
{
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // do stuff
    }
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"mailto://support@tapfantasy.com"]];
}

@end
