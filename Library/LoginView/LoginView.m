//
//  LoginView.m
//  Kingdom Game
//
//  Created by Shankar on 6/10/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "LoginView.h"
#import "Globals.h"
#import "NSString+HMAC.h"

#define kSecret @"year2000"

NSString *const SCSessionStateChangedNotification = @"com.tapf:SCSessionStateChangedNotification";

@implementation LoginView

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
    [[self.emailText layer] setBorderColor:[[UIColor grayColor] CGColor]]; //border color
    [[self.emailText layer] setBackgroundColor:[[UIColor whiteColor] CGColor]]; //background color
    [[self.emailText layer] setBorderWidth:1.5]; // border width
    [[self.emailText layer] setCornerRadius:5]; // radius of rounded corners
    [self.emailText setClipsToBounds: YES]; //clip text within the bounds
    
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@", GAME_VERSION];
    
    self.launchWithInternet = YES;
}

- (BOOL)updateView
{
    if ([[Globals i] UID] != nil && [[[Globals i] UID] length] > 1) //AutoLogin
    {
        [self performSelectorOnMainThread:@selector(LoadMainView)
                               withObject:nil
                            waitUntilDone:YES];
    }
    
    return YES;
}

- (void)updateWorldLabel
{
    NSString *wname = [Globals i].wsWorldData[@"world_name"];
    
    self.lblWorld.text = wname;
    [self.ivFlag setImage:[UIImage imageNamed:[NSString stringWithFormat:@"flag_%@.png", [Globals i].wsWorldData[@"flag_id"]]]];
}

- (IBAction)emailLogin:(UIButton *)sender
{
    if (self.launchWithInternet)
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
    if (self.launchWithInternet)
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
    if (self.launchWithInternet)
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

        NSString *fid = [self.emailText.text lowercaseString];
        NSString *hexHmac = [fid HMACWithSecret:kSecret];
        NSString *uid = [[[Globals i] GameId] stringByAppendingString:hexHmac];
        NSString *email = self.emailText.text;
        NSString *hexPassword = [self stringToHex:self.passwordText.text];
        
        NSString *wsurl = [NSString stringWithFormat:@"%@/Login/%@/%@/%@/%@/%@/%@",
                           WS_URL, uid, email, hexPassword, [[Globals i] getLat], [[Globals i] getLongi], [[Globals i] getDtoken]];
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        NSString *returnValue = [[NSString alloc] initWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        
        NSInteger retval = [returnValue integerValue];
        
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
            
            [UIManager.i showDialog:@"Invalid Email or Password. If have not Registered, please tap on +Register button."];
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
        
        NSString *fid = [self.emailText.text lowercaseString];
        NSString *hexHmac = [fid HMACWithSecret:kSecret];
        NSString *uid = [[[Globals i] GameId] stringByAppendingString:hexHmac];
        NSString *email = self.emailText.text;
        NSString *hexPassword = [self stringToHex:self.passwordText.text];
        
        NSString *wsurlreg = [NSString stringWithFormat:@"%@/Register2/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
                              WS_URL, [[Globals i] GameId], uid, hexPassword, @"0", email, @"0", @"0", @"0", @"0", [[Globals i] getDtoken]];
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
            
            [UIManager.i showDialog:@"The email you entered is already registered. Tap on Login instead."];
        }
        
	}
}

- (void)loginEmail
{
    if ([self NSStringIsValidEmail:self.emailText.text])
    {
        if (self.passwordText.text.length > 3 && self.passwordText.text.length < 13)
        {
            [[Globals i] showLoadingAlert];
            [NSThread detachNewThreadSelector:@selector(tryLogin) toTarget:self withObject:nil];
        }
        else
        {
            [UIManager.i showDialog:@"Invalid Password. Password should be at least 4 to 12 characters."];
        }
    }
    else
    {
        [UIManager.i showDialog:@"Invalid Email. Please enter a valid Email (Example: john@gmail.com)"];

    }
}

- (void)registerEmail
{
    if ([self NSStringIsValidEmail:self.emailText.text])
    {
        if (self.passwordText.text.length > 3 && self.passwordText.text.length < 13)
        {
            [[Globals i] showLoadingAlert];
            [NSThread detachNewThreadSelector:@selector(tryRegister) toTarget:self withObject:nil];
        }
        else
        {
            [UIManager.i showDialog:@"Invalid Password. Password should be at least 4 to 12 characters."];
        }
    }
    else
    {
        [UIManager.i showDialog:@"Invalid Email. Please enter a valid Email (Example: john@gmail.com)"];
    }
}

- (void)passwordReset
{
    [UIManager.i showDialogBlock:@"Please enter your login Email"
                                :4
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //OK button is clicked
         {
             NSString *returnValue = @"0";
             
             if([self NSStringIsValidEmail:text])
             {
                 text = [text lowercaseString];
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
                 [UIManager.i showDialog:@"Invalid Email. Please enter a valid Email (Example: john@gmail.com)"];
                 
                 return;
             }
             
             if([returnValue isEqualToString:@"1"])
             {
                 [UIManager.i showDialog:@"Please check the Email you sent us. We have sent an email to you with a link to your password. If you can't find it, it might be in your Spam folder."];
             }
             else
             {
                 [UIManager.i showDialog:@"Sorry, the Email you entered does not have an account with us."];
             }
         }
     }];
}

- (void)LoadMainView
{
    [UIManager.i closeTemplate];
    
    if (self.loginBlock != nil)
    {
        self.loginBlock(1);
    }
}

@end
