//
//  Globals.m
//  Kingdom Game
//
//  Created by Shankar on 6/9/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"
#import "LoadingView.h"
#import "PlayerCell.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation Globals

static Globals *_i;

- (id)init
{
	if (self = [super init])
	{
        self.selectedClubId = @"0";
        self.workingUrl = @"0";
        self.offsetServerTimeInterval = 0;
        self.gettingChatWorld = NO;
        self.gettingChatAlliance = NO;
        
        self.wsChatFullArray = [[NSMutableArray alloc] init];
        self.wsAllianceChatFullArray = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (Globals *)i
{
	if (!_i)
	{
		_i = [[Globals alloc] init];
	}
	
	return _i;
}

static dispatch_once_t once;
static NSOperationQueue *connectionQueue;
+ (NSOperationQueue *)connectionQueue
{
    dispatch_once(&once, ^{
        connectionQueue = [[NSOperationQueue alloc] init];
        [connectionQueue setMaxConcurrentOperationCount:1];
        [connectionQueue setName:@"com.tapfantasy.connectionqueue"];
    });
    return connectionQueue;
}

+ (void)getServer:(NSString *)wsurl :(returnBlock)completionBlock
{
    NSURL *url = [NSURL URLWithString:[wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", wsurl, error, [error localizedDescription]);
             completionBlock(NO, nil);
         }
         else
         {
             completionBlock(YES, data);
         }
     }];
}

//Used for mail and report dont show loading and dont track
+ (void)getServerNew:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@%@",
                       [Globals i].world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", wsurl, error, [error localizedDescription]);
             completionBlock(NO, nil);
         }
         else
         {
             completionBlock(YES, data);
         }
     }];
}

+ (void)getServerLoading:(NSString *)wsurl :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    //wsurl = [Globals encodeURL:wsurl];
    wsurl = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsurl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] removeLoadingAlert];});
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", wsurl, error, [error localizedDescription]);
             completionBlock(NO, nil);
             dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showDialogError];});
         }
         else
         {
             completionBlock(YES, data);
         }
     }];
}

+ (void)postServer:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock
{
    NSError* error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *postLength = [@([postData length]) stringValue];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [[Globals i] world_url], service]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.connectionQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", service, error, [error localizedDescription]);
             completionBlock(NO, nil);
         }
         else
         {
             completionBlock(YES, data);
         }
     }];
}

+ (void)getServerLoadingNew:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@%@",
                       [Globals i].world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] removeLoadingAlert];});
         if (error || !response || !data)
         {
             completionBlock(NO, nil);
             dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showDialogError];});
         }
         else
         {
             completionBlock(YES, data);
         }
     }];
}

+ (void)getSpLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@%@",
                       [Globals i].world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] removeLoadingAlert];});
         if (error || !response || !data)
         {
             completionBlock(NO, nil);
             dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showDialogError];});
         }
         else
         {
             NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             if ([returnValue isEqualToString:@"1"]) //Stored Proc Success
             {
                 completionBlock(YES, data);
             }
         }
     }];
}

+ (void)postServerLoading:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    NSError* error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *postLength = [@([postData length]) stringValue];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [[Globals i] world_url], service]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.connectionQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] removeLoadingAlert];});
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", service, error, [error localizedDescription]);
             completionBlock(NO, nil);
             dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showDialogError];});
         }
         else
         {
             completionBlock(YES, data);
         }
     }];
}

- (NSString	*)GameId
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GAME_ID"];
}

- (NSString	*)UID
{
    self.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserUID"];
    
    return self.uid;
}

- (void)setUID:(NSString *)user_uid
{
    self.uid = user_uid;
    [[NSUserDefaults standardUserDefaults] setObject:self.uid forKey:@"UserUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (![user_uid isEqualToString:@""])
    {
        //Get Previos UID
        NSString *prev_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"PrevUID"];
        if (prev_uid != nil)
        {
            if (![prev_uid isEqualToString:user_uid])
            {
                [self resetUserDefaults];
            }
        }
        
        //Set Previous UID
        [[NSUserDefaults standardUserDefaults] setObject:user_uid forKey:@"PrevUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSTimeInterval)updateTime
{
    NSDateFormatter *serverDateFormat = [[NSDateFormatter alloc] init];
    [serverDateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [serverDateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss Z"];
    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/CurrentTime", WS_URL];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    NSString *returnValue  = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    returnValue = [NSString stringWithFormat:@"%@ -0000", returnValue];
    
    NSDate *serverDateTime = [serverDateFormat dateFromString:returnValue];
    NSTimeInterval serverTimeInterval = [serverDateTime timeIntervalSince1970];
    
    NSDate *localdatetime = [NSDate date];
    NSTimeInterval localTimeInterval = [localdatetime timeIntervalSince1970];
    
    self.offsetServerTimeInterval = serverTimeInterval - localTimeInterval;
    
    return serverTimeInterval;
}

- (NSString *)getServerTimeString
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormater setDateFormat:@"HH:mm:ss"];
    
    NSDate *localdatetime = [NSDate date];
    NSDate *serverdatetime = [localdatetime dateByAddingTimeInterval:self.offsetServerTimeInterval];
    
    return [dateFormater stringFromDate:serverdatetime];
}

- (NSString *)getTimeAgo:(NSString *)datetimestring
{
    NSString *diff = datetimestring;
    
    if (datetimestring != nil && [datetimestring length] > 0)
    {
        NSDate *date1 = [[self getDateFormat] dateFromString:[NSString stringWithFormat:@"%@ -0000", datetimestring]];
        if (date1 == nil)
        {
            date1 = [[self getDateFormat] dateFromString:datetimestring];
        }
        
        NSDate *date2 = [NSDate date];
        
        if (self.offsetServerTimeInterval != 0) //Calibrate if local time is adjusted
        {
            date2 = [date2 dateByAddingTimeInterval:self.offsetServerTimeInterval];
        }
        
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        
        // Get conversion to months, days, hours, minutes
        NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
        
        if ([breakdownInfo month] > 0)
        {
            if ([breakdownInfo month] == 1)
            {
                diff = @"1 month ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%@ months ago", @([breakdownInfo month])];
            }
        }
        else if ([breakdownInfo day] > 0)
        {
            if ([breakdownInfo day] == 1)
            {
                diff = @"1 day ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%@ days ago", @([breakdownInfo day])];
            }
        }
        else if ([breakdownInfo hour] > 0)
        {
            if ([breakdownInfo hour] == 1)
            {
                diff = @"1 hour ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%@ hours ago", @([breakdownInfo hour])];
            }
        }
        else if ([breakdownInfo minute] > 0)
        {
            if ([breakdownInfo minute] == 1)
            {
                diff = @"1 min ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%@ mins ago", @([breakdownInfo minute])];
            }
        }
        else if ([breakdownInfo second] > 0)
        {
            if ([breakdownInfo second] == 1)
            {
                diff = @"1 sec ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%@ secs ago", @([breakdownInfo second])];
            }
        }
        else
        {
            diff = @"1 sec ago";
        }
    }
    
    return diff;
}

- (void)showLoadingAlert
{
    NSLog(@"Showing Loading Alert");
    NSArray *imageNames = @[@"g1_0", @"g1_1", @"g1_2", @"g1_3", @"g1_4", @"g1_5"];
    
    CGFloat l_width = 0.0;
    CGFloat l_height = 0.0;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++)
    {
        UIImage *l_image = [UIImage imageNamed:[imageNames objectAtIndex:i]];
        l_width = l_image.size.width/2.0f * SCALE_IPAD;
        l_height = l_image.size.height/2.0f * SCALE_IPAD;
        
        if (!(iPad))
        {
            CGSize scaleSize = CGSizeMake(l_width, l_height);
            UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
            [l_image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
            l_image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        [images addObject:l_image];
    }
    
    if (self.spinImageView == nil)
    {
        self.spinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
        self.spinImageView.animationImages = images;
        self.spinImageView.userInteractionEnabled = YES;
        self.spinImageView.contentMode = UIViewContentModeCenter;
        self.spinImageView.animationDuration = 1.0;
    }
    
    [[UIManager.i firstViewControllerStack].view addSubview:self.spinImageView];
    [self.spinImageView startAnimating];
}

- (void)removeLoadingAlert
{
    NSLog(@"Removing Loading Alert");
    
    [self.spinImageView removeFromSuperview];
}

- (void)showToast:(NSString *)message optionalTitle:(NSString *)title optionalImage:(NSString *)imagename
{
    NSMutableDictionary *dict_cell;
    
    if (title == nil)
    {
        title = @"Success!";
    }
    
    dict_cell = [@{@"r1": title, @"r2": message, @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"r2_color": @"2", @"nofooter": @"1"} mutableCopy];
    
    if (imagename != nil)
    {
        [dict_cell addEntriesFromDictionary:@{@"n1_width": @"60", @"i1": imagename, @"i1_aspect": @"1"}];
    }
    
    [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterSmokeStyle new];
    
    [JCNotificationCenter
     enqueueNotificationWithMessage:dict_cell
     animationType:@"1"
     tapHandler:^{}];
}

- (void)showDialogError
{
    [UIManager.i showDialog:@"Sorry, there was an internet connection issue or your session has timed out. Please retry."];
}

- (double)Random_next:(double)min to:(double)max
{
    return ((double)arc4random() / UINT_MAX) * (max-min) + min;
}

- (NSString *)intString:(NSInteger)val
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = @(val);
    NSString *formattedOutput = [formatter stringFromNumber:number];
    
    return formattedOutput;
}

- (NSString *)numberFormat:(NSString *)val
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:val];
    NSString *formattedOutput = [formatter stringFromNumber:number];
    
    return formattedOutput;
}

- (NSString *)shortNumberFormat:(NSString *)val
{
    double dval = [val doubleValue];
    NSString *shortformNumber = @"1k";
    
    if (dval > 999)
    {
        if (dval > 999999)
        {
            if (dval > 999999999)
            {
                dval = dval / 1000000000;
                if (dval > 99)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.0fb", dval];
                }
                else if (dval > 9)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.1fb", dval];
                }
                else
                {
                    shortformNumber = [NSString stringWithFormat:@"%.2fb", dval];
                }
            }
            else
            {
                dval = dval / 1000000;
                if (dval > 99)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.0fm", dval];
                }
                else if (dval > 9)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.1fm", dval];
                }
                else
                {
                    shortformNumber = [NSString stringWithFormat:@"%.2fm", dval];
                }
            }
        }
        else
        {
            dval = dval / 1000;
            if (dval > 99)
            {
                shortformNumber = [NSString stringWithFormat:@"%.0fk", dval];
            }
            else if (dval > 9)
            {
                shortformNumber = [NSString stringWithFormat:@"%.1fk", dval];
            }
            else
            {
                shortformNumber = [NSString stringWithFormat:@"%.2fk", dval];
            }
        }
    }
    else
    {
        shortformNumber = [NSString stringWithFormat:@"%.0f", dval];
    }
    
    return shortformNumber;
}

- (NSString *)BoolToBit:(NSString *)boolString
{
	if([boolString isEqualToString:@"True"])
		return @"1";
	else
		return @"0";
}

+ (NSString *)encodeURL:(NSString *)urlString
{
    CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, nil, CFSTR(""), kCFStringEncodingUTF8);
    return (NSString *)CFBridgingRelease(newString);
}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length
{
    static char table1[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table1[(value >> 18) & 0x3F];
        output[index + 1] =                    table1[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table1[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table1[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (NSString *)getCountdownString:(NSTimeInterval)differenceSeconds
{
    NSInteger days = (NSInteger)((double)differenceSeconds/(3600.0*24.00));
    NSInteger diffDay = differenceSeconds-(days*3600*24);
    NSInteger hours = (NSInteger)((double)diffDay/3600.00);
    NSInteger diffMin = diffDay-(hours*3600);
    NSInteger minutes = (NSInteger)(diffMin/60.0);
    NSInteger seconds = diffMin-(minutes*60);
    
    NSString *countdown;
    
    if (days > 0)
    {
        countdown = [NSString stringWithFormat:@"%ldd %02ld:%02ld:%02ld",(long)days,(long)hours,(long)minutes,(long)seconds];
    }
    else
    {
        countdown = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours,(long)minutes,(long)seconds];
    }
    
    return countdown;
}

#pragma mark PushNotification
- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *alertMsg;
    
    if( userInfo[@"aps"][@"alert"] != nil)
    {
        alertMsg = userInfo[@"aps"][@"alert"];
    }
    else
    {
        alertMsg = @"{no alert message in dictionary}";
    }
    
    [UIManager.i showDialog:alertMsg];
}

- (void)scheduleNotification:(NSDate *)f_date :(NSString *)alert_body
{
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil)
    {
        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSMutableArray *Arr = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication]scheduledLocalNotifications]];
        for (NSInteger k=0; k<[Arr count]; k++)
        {
            UILocalNotification *not = Arr[k];
            NSString *msgString = [not.userInfo valueForKey:@"key"];
            if([msgString isEqualToString:alert_body])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:not];
            }
        }
        
        UILocalNotification *notif = [[cls alloc] init];
        notif.fireDate = f_date;
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = alert_body;
        notif.alertAction = @"Show";
        notif.soundName = UILocalNotificationDefaultSoundName;
        notif.applicationIconBadgeNumber = 1;
		
        NSDictionary *userDict = @{@"key": alert_body};
        notif.userInfo = userDict;
		
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}

- (void)resetLoginReminderNotification
{
    //Remove all future notifications
    NSString *notificationId = @"login_reminder";
    for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[notify.userInfo objectForKey:@"ID"] isEqualToString:notificationId])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
        }
    }
    
    //Create new future notifcations for 3 days, 7 days and 15 days
    if (self.loginNotification == nil)
    {
        self.loginNotification = [[UILocalNotification alloc] init];
    }
    self.loginNotification.timeZone = [NSTimeZone defaultTimeZone];
    self.loginNotification.soundName = @"sound_toaster.aac";
    NSDictionary *userDict = @{@"ID": @"login_reminder"};
    self.loginNotification.userInfo = userDict;
    
    self.loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*3];
    self.loginNotification.alertBody = @"Your players misses you! It's been 3 days since they last saw you. Login now and catch up with them.";
    [[UIApplication sharedApplication] scheduleLocalNotification:self.loginNotification];
    
    self.loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*7];
    self.loginNotification.alertBody = @"Your players misses you! It's been a week since they last saw you. Login now and catch up with them.";
    [[UIApplication sharedApplication] scheduleLocalNotification:self.loginNotification];
    
    self.loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*15];
    self.loginNotification.alertBody = @"Your players misses you! It's been 2 weeks since they last saw you. Login now and catch up with them.";
    [[UIApplication sharedApplication] scheduleLocalNotification:self.loginNotification];
}

- (NSString *)getFirstChatString
{
    NSString *message;
    
    NSInteger i = [self.wsChatFullArray count];
    
    if (i > 1)
    {
        NSDictionary *rowData = self.wsChatFullArray[i-2];
        message = [NSString stringWithFormat:@"%@: %@",
                   rowData[@"club_name"],
                   rowData[@"message"]];
    }
    else
    {
        message = @"";
    }
    
    return message;
}

- (NSString *)getSecondChatString
{
    NSString *message;
    
    NSInteger i = [self.wsChatFullArray count];
    
    if (i > 0)
    {
        NSDictionary *rowData = self.wsChatFullArray[i-1];
        message = [NSString stringWithFormat:@"%@: %@",
                   rowData[@"club_name"],
                   rowData[@"message"]];
    }
    else
    {
        message = @"";
    }
    
    return message;
}

- (NSString *)getFirstAllianceChatString
{
    NSString *message;
    
    NSInteger i = [self.wsAllianceChatFullArray count];
    
    if (i > 1)
    {
        NSDictionary *rowData = self.wsAllianceChatFullArray[i-2];
        message = [NSString stringWithFormat:@"%@: %@",
                   rowData[@"club_name"],
                   rowData[@"message"]];
    }
    else
    {
        message = @"";
    }
    
    return message;
}

- (NSString *)getSecondAllianceChatString
{
    NSString *message;
    
    NSInteger i = [self.wsAllianceChatFullArray count];
    
    if (i > 0)
    {
        NSDictionary *rowData = self.wsAllianceChatFullArray[i-1];
        message = [NSString stringWithFormat:@"%@: %@",
                   rowData[@"club_name"],
                   rowData[@"message"]];
    }
    else
    {
        message = @"";
    }
    
    return message;
}

- (NSString *)getLastChatID
{
    NSInteger i = [self.wsChatFullArray count];
    if(i == 0)
    {
        return @"0"; //tells server to fetch most current
    }
    else if(i > 0)
    {
        NSDictionary *rowData = self.wsChatFullArray[i-1];
        return rowData[@"chat_id"];
    }
    
    return @"0";
}

- (NSString *)getLastAllianceChatID
{
    NSInteger i = [self.wsAllianceChatFullArray count];
    if(i == 0)
    {
        return @"0"; //tells server to fetch most current
    }
    else if(i > 0)
    {
        NSDictionary *rowData = self.wsAllianceChatFullArray[i-1];
        return rowData[@"chat_id"];
    }
    
    return @"0";
}

- (void)updateChatData
{
    if (!self.gettingChatWorld)
    {
        self.gettingChatWorld = YES;
        
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetChat1/%@",
                           [self world_url], [self getLastChatID]];
        
        [Globals getServer:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 self.wsChatArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
                 if ([self.wsChatArray count] > 0)
                 {
                     if (self.wsChatFullArray == nil)
                     {
                         self.wsChatFullArray = [self.wsChatArray mutableCopy];
                     }
                     else
                     {
                         [self.wsChatFullArray addObjectsFromArray:self.wsChatArray];
                     }
                     
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"ChatWorld"
                      object:self];
                 }
             }
             
             self.gettingChatWorld = NO;
         }];
    }
}

- (void)updateAllianceChatData
{
    if (!self.gettingChatAlliance)
    {
        self.gettingChatAlliance = YES;
        
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetAllianceChat/%@/%@",
                           [self world_url], [self getLastAllianceChatID], self.wsClubDict[@"alliance_id"]];
        
        [Globals getServer:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 self.wsAllianceChatArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
                 
                 if ([self.wsAllianceChatArray count] > 0)
                 {
                     if (self.wsAllianceChatFullArray == nil)
                     {
                         self.wsAllianceChatFullArray = [self.wsAllianceChatArray mutableCopy];
                     }
                     else
                     {
                         [self.wsAllianceChatFullArray addObjectsFromArray:self.wsAllianceChatArray];
                     }
                     
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"ChatAlliance"
                      object:self];
                 }
             }
             
             self.gettingChatAlliance = NO;
         }];
    }
}

- (NSString *)getDtoken
{
    self.devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"Devicetoken"];
    if (self.devicetoken == nil)
    {
        self.devicetoken = @"0";
    }
    
    return self.devicetoken;
}

- (void)setDtoken:(NSString *)dt
{
    self.devicetoken = dt;
    [[NSUserDefaults standardUserDefaults] setObject:self.devicetoken forKey:@"Devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLat
{
    self.latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Latitude"];
    if (self.latitude == nil)
    {
        self.latitude = @"0";
    }
    
    return self.latitude;
}

- (void)setLat:(NSString *)lat
{
    self.latitude = lat;
    [[NSUserDefaults standardUserDefaults] setObject:self.latitude forKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLongi
{
    self.longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Longitude"];
    if (self.longitude == nil)
    {
        self.longitude = @"0";
    }
    
    return self.longitude;
}

- (void)setLongi:(NSString *)longi
{
    self.longitude = longi;
    [[NSUserDefaults standardUserDefaults] setObject:self.longitude forKey:@"Longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)gettLoginBonus
{
    self.loginBonus = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginBonus"];
    if (self.loginBonus == nil)
    {
        self.loginBonus = @"0";
    }
    
    return self.loginBonus;
}

- (void)settLoginBonus:(NSString *)amount
{
    self.loginBonus = amount;
    [[NSUserDefaults standardUserDefaults] setObject:self.loginBonus forKey:@"LoginBonus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)gettPurchasedProduct
{
    self.purchasedProductString = [[NSUserDefaults standardUserDefaults] objectForKey:@"PurchasedProduct"];
    if (self.purchasedProductString == nil)
    {
        self.purchasedProductString = @"0";
    }
    
    return self.purchasedProductString;
}

- (void)settPurchasedProduct:(NSString *)type
{
    self.purchasedProductString = type;
    [[NSUserDefaults standardUserDefaults] setObject:self.purchasedProductString forKey:@"PurchasedProduct"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//MAIL

- (NSDictionary *)gettLocalMailReply
{
    self.localMailReplyDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"MailReply"];
    if (self.localMailReplyDict == nil)
    {
        self.localMailReplyDict = [[NSDictionary alloc] init];
    }
    
    return self.localMailReplyDict;
}

- (void)settLocalMailReply:(NSDictionary *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSDictionary alloc] initWithDictionary:rd copyItems:YES] forKey:@"MailReply"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)findMailReply:(NSString *)mail_id
{
    self.localMailReplyDict = [self gettLocalMailReply];
    
    return [self.localMailReplyDict objectForKey:mail_id];
}

- (void)addMailReply:(NSString *)mail_id :(NSArray *)mail_reply
{
    self.localMailReplyDict = [self gettLocalMailReply];
    NSMutableDictionary *mdReply = [[NSMutableDictionary alloc] initWithDictionary:self.localMailReplyDict copyItems:YES];
    [mdReply setObject:mail_reply forKey:mail_id];
    
    [self settLocalMailReply:mdReply];
}

- (void)deleteLocalMail:(NSString *)mail_id
{
    self.localMailReplyDict = [self gettLocalMailReply];
    
    if ([self.localMailReplyDict count] > 0)
    {
        NSMutableDictionary *mdReply = [[NSMutableDictionary alloc] initWithDictionary:self.localMailReplyDict copyItems:YES];
        [mdReply removeObjectForKey:mail_id];
        [self settLocalMailReply:mdReply];
    }
    
    self.localMailArray = [self gettLocalMailData];
    NSInteger count = [self.localMailArray count];
    NSInteger index_to_remove = -1;
    for (NSUInteger i = 0; i < count; i++)
    {
        if ([self.localMailArray[i][@"mail_id"] isEqualToString:mail_id])
        {
            index_to_remove = i;
        }
    }
    
    if (index_to_remove > -1)
    {
        [self.localMailArray removeObjectAtIndex:index_to_remove];
        [self settLocalMailData:self.localMailArray];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMailView" object:self];
    }
}

- (void)replyCounterPlus:(NSString *)mail_id
{
    self.localMailArray = [self gettLocalMailData];
    NSInteger count = [self.localMailArray count];
    
    for (NSUInteger i = 0; i < count; i++)
    {
        if ([self.localMailArray[i][@"mail_id"] isEqualToString:mail_id])
        {
            NSInteger rcounter = [self.localMailArray[i][@"reply_counter"] intValue] + 1;
            self.localMailArray[i][@"reply_counter"] = [@(rcounter) stringValue];
            
            [self settLocalMailData:self.localMailArray];
        }
    }
}

- (NSString *)gettLastMailId
{
    self.lastMailId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Mailid"];
    if (self.lastMailId == nil)
    {
        self.lastMailId = @"0";
    }
    
    return self.lastMailId;
}

- (void)settLastMailId:(NSString *)mid
{
    self.lastMailId = mid;
    [[NSUserDefaults standardUserDefaults] setObject:self.lastMailId forKey:@"Mailid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)gettLocalMailData
{
    NSMutableArray *fullMutable = [[NSMutableArray alloc] init];
    
    NSArray *lclMail = [[NSUserDefaults standardUserDefaults] arrayForKey:@"MailData"];
    if (lclMail.count > 0)
    {
        for (NSDictionary *obj in lclMail)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:obj copyItems:YES];
                [fullMutable addObject:dic];
            }
        }
    }
    
    return fullMutable;
}

- (void)settLocalMailData:(NSMutableArray *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:rd forKey:@"MailData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMailBadge" object:self];
}

- (void)addLocalMailData:(NSMutableArray *)rd
{
    self.localMailArray = [self gettLocalMailData];
    
    //Check old mails if there is any replies
    for (NSUInteger i = 0; i < [self.localMailArray count]; i++)
    {
        NSString *local_mail_id = self.localMailArray[i][@"mail_id"];
        
        //Search newly fetched mail for match with local mail
        for (NSUInteger j = 0; j < [rd count]; j++)
        {
            if ([rd[j][@"mail_id"] isEqualToString:local_mail_id]) //Match found
            {
                NSUInteger newmail_reply_counter = [rd[j][@"reply_counter"] integerValue];
                NSUInteger oldmail_reply_counter = [self.localMailArray[i][@"reply_counter"] integerValue];
                
                //Reply counter is bigger
                if (newmail_reply_counter > oldmail_reply_counter)
                {
                    self.localMailArray[i][@"open_read"] = @"0"; //Set as not read
                    self.localMailArray[i][@"reply_counter"] = [@(newmail_reply_counter) stringValue]; //update reply_counter
                }
            }
        }
    }
    
    //Add new mails to top of localMailArray
    for (NSInteger i = 0; i < [rd count]; i++)
    {
        if ([rd[i][@"mail_id"] integerValue] > [[self gettLastMailId] integerValue])
        {
            [self.localMailArray insertObject:rd[i] atIndex:0];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.localMailArray forKey:@"MailData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateMailBadge"
     object:self];
    
    NSString *m_id = (rd)[0][@"mail_id"];
    [[Globals i] settLastMailId:m_id];
}

- (BOOL)setMailNotRead:(NSString *)mail_id
{
    BOOL result = NO;
    
    self.localMailArray = [self gettLocalMailData];
    
    for (NSUInteger i = 0; i < [self.localMailArray count]; i++)
    {
        NSString *local_mail_id = self.localMailArray[i][@"mail_id"];
        if ([local_mail_id isEqualToString:mail_id]) //Match found
        {
            result = YES;
            NSInteger replycount = [self.localMailArray[i][@"reply_counter"] integerValue] + 1;
            self.localMailArray[i][@"open_read"] = @"0"; //Set as not read
            self.localMailArray[i][@"reply_counter"] = [@(replycount) stringValue]; //update reply_counter
            
            NSDictionary *replyRow = [[NSDictionary alloc] initWithDictionary:self.localMailArray[i] copyItems:YES];
            [self.localMailArray removeObjectAtIndex:i];
            [self.localMailArray insertObject:replyRow atIndex:0]; //Move to the top
        }
    }
    
    if (result)
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.localMailArray forKey:@"MailData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return result;
}

- (void)updateMailReply:(NSString *)mail_id
{
    NSString *service_name = @"GetMailReply";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       mail_id];
    
    [Globals getServerLoadingNew:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
                 
                 if (returnArray.count > 0)
                 {
                     self.wsMailReplyArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                     
                     [self addMailReply:mail_id :self.wsMailReplyArray];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMailDetail"
                                                                         object:self
                                                                       userInfo:nil];
                 }
             }
         });
     }];
}

- (NSInteger)getMailBadgeNumber
{
    NSInteger count = 0;
    
    NSArray *lclMail = [[NSUserDefaults standardUserDefaults] arrayForKey:@"MailData"];
    if ([lclMail count] > 0)
    {
        for (NSDictionary *rowData in lclMail)
        {
            if ([rowData isKindOfClass:[NSDictionary class]])
            {
                if ([rowData[@"open_read"] isEqualToString:@"0"])
                {
                    count = count + 1;
                }
            }
        }
    }
    
    return count;
}





///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//END OF SAME CODE
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




- (NSString	*)GameType
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GAME_TYPE"];
}

- (NSString	*)GameUrl
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GAME_URL"];
}

- (NSString	*)world_url
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GAME_URL"];
}

- (void)resetUserDefaults
{
    [self settLocalMailReply:[[NSDictionary alloc] init]];
    [self settLastMailId:@"0"];
    [self settLocalMailData:[[NSMutableArray alloc] init]];
}

- (NSString *)getServerDateTimeString
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //[dateFormater setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [dateFormater setDateFormat:@"EEEE, MMMM d, yyyy HH:mm:ss"];
    
    NSDate *localdatetime = [NSDate date];
    NSDate *serverdatetime = [localdatetime dateByAddingTimeInterval:self.offsetServerTimeInterval];
    
    NSString *datenow = [dateFormater stringFromDate:serverdatetime];
    return datenow;
}

- (NSDateFormatter *)getDateFormat
{
    if (self.dateFormat == nil)
    {
        self.dateFormat = [[NSDateFormatter alloc] init];
        [self.dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [self.dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        //[self.dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss Z"];
        [self.dateFormat setDateFormat:@"EEEE, MMMM d, yyyy HH:mm:ss Z"];
    }
    
    return self.dateFormat;
}

- (void)showLoading
{
    self.loadingView = [[LoadingView alloc] init];
    self.loadingView.title = @"Loading";
    [[UIManager.i peekViewControllerStack].view addSubview:self.loadingView.view];
    [self.loadingView updateView];
}

- (void)removeLoading
{
    if (self.loadingView != nil)
    {
        [self.loadingView close];
    }
}

- (void)pushChatVC:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid
{
    ChatView *achatView = [[ChatView alloc] init];
    achatView.title = @"Alliance Wall";
    
    [UIManager.i showTemplate:@[achatView] :@"Alliance Wall" :10];
    [achatView updateView:ds table:tn a_id:aid];
}

- (void)initSound
{
	//Setup button sound
	NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_button.aif", [[NSBundle mainBundle] resourcePath]]];
	self.buttonAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
    self.buttonAudio.numberOfLoops = 0;
    self.buttonAudio.volume = 1.0;
	
	//Setup back sound
	NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_toaster.aac", [[NSBundle mainBundle] resourcePath]]];
	self.backAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
	self.backAudio.numberOfLoops = 0;
    self.backAudio.volume = 1.0;
    
    //Setup money sound
	NSURL *url4 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_cash.caf", [[NSBundle mainBundle] resourcePath]]];
	self.moneyAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url4 error:nil];
	self.moneyAudio.numberOfLoops = 0;
    self.moneyAudio.volume = 1.0;
    
    //Setup win sound
	NSURL *url5 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_crowd_goal.caf", [[NSBundle mainBundle] resourcePath]]];
	self.winAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url5 error:nil];
	self.winAudio.numberOfLoops = 0;
    self.winAudio.volume = 1.0;
    
    //Setup lose sound
	NSURL *url6 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_crowd0.caf", [[NSBundle mainBundle] resourcePath]]];
	self.loseAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url6 error:nil];
	self.loseAudio.numberOfLoops = 0;
    self.loseAudio.volume = 1.0;
}

- (void)buttonSound
{
	[self.buttonAudio play];
}

- (void)toasterSound
{
	[self.backAudio play];
}

- (void)moneySound
{
	[self.moneyAudio play];
}

- (void)winSound
{
	[self.winAudio play];
}

- (void)loseSound
{
	[self.loseAudio play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if(flag)
    {
		NSLog(@"Did finish playing");
	}
    else
    {
		NSLog(@"Did NOT finish playing");
	}
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	NSLog(@"%@", [error description]);
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)saveLocation
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // We don't want to be notified of small changes in location, preferring to use our
    // last cached results, if any.
    locationManager.distanceFilter = 50;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!oldLocation ||
        (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
         oldLocation.coordinate.longitude != newLocation.coordinate.longitude &&
         newLocation.horizontalAccuracy <= 100.0))
    {
        NSString *lati = [NSString stringWithFormat:@"%g", newLocation.coordinate.latitude];
		NSString *longi = [NSString stringWithFormat:@"%g", newLocation.coordinate.longitude];
        
        if (![lati isEqual: @"0"])
        {
            [self setLat:lati];
        }
        
        if (![longi isEqual: @"0"])
        {
            [self setLongi:longi];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"%@", error);
}

- (void)showLogin:(LoginBlock)block
{
    if (self.loginView == nil)
    {
        self.loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
        self.loginView.title = @"Login";
    }
    self.loginView.loginBlock = block;
    
    [UIManager.i showTemplate:@[self.loginView] :@"Login" :2];
    
    //UIManager.i.templateView.closeButton.hidden = YES;
    
    [self.loginView updateView];
}

- (void)fbPublishStory:(NSString *)message :(NSString *)caption :(NSString *)picture
{

}

- (NSInteger)xpFromLevel:(NSInteger)level
{
    return (level-1)*(level-1)*10;
}

- (NSInteger)levelFromXp:(NSInteger)xp
{
    return sqrt(xp/10) + 1;
}

- (NSInteger)getXp
{
    NSInteger xp = [self.wsClubDict[@"xp"] integerValue];
    return xp;
}

- (NSInteger)getXpMax
{
    return [self xpFromLevel:[self getLevel]+1];
}

- (NSInteger)getXpMaxBefore
{
    return [self xpFromLevel:[self getLevel]];
}

- (NSInteger)getLevel
{
    return [self levelFromXp:[self getXp]];
}

- (void)checkVersion
{
    if (self.wsProductIdentifiers != nil)
    {
        float latest_version = [self.wsProductIdentifiers[@"latest_version"] floatValue];
        float this_version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
        
        if (latest_version > this_version)
        {
            [UIManager.i showDialogBlock:@"New Version Available. Upgrade to latest version?"
                                 :2
                                 :^(NSInteger index, NSString *text)
             {
                 if(index == 1) //YES
                 {
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.wsProductIdentifiers[@"url_app"]]];
                 }
             }];
        }
    }
}

- (void)updateProductIdentifiers
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/ProductIdentifiers/%@", 
					   WS_URL, [self GameId]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	self.wsProductIdentifiers = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *)getProductIdentifiers
{
	return self.wsProductIdentifiers;
}

- (BOOL)updateSalesData
{
    BOOL hasSale = NO;
    
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetSales",
					   WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
    if (wsResponse.count > 0)
    {
        self.wsSalesData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
        hasSale = YES;
    }
    else
    {
        self.wsSalesData = nil;
    }
    
    return hasSale;
}

- (BOOL)updateEventSolo
{
    BOOL hasEvent = NO;
    
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetEventSolo",
					   self.world_url];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
    if (wsResponse.count > 0)
    {
        self.wsEventSolo = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
        hasEvent = YES;
    }
    else
    {
        self.wsEventSolo = nil;
    }
    
    return hasEvent;
}

- (BOOL)updateEventAlliance
{
    BOOL hasEvent = NO;
    
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetEventAlliance",
					   self.world_url];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
    if (wsResponse.count > 0)
    {
        self.wsEventAlliance = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
        hasEvent = YES;
    }
    else
    {
        self.wsEventAlliance = nil;
    }
    
    return hasEvent;
}

- (BOOL)updateClubData
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetClub/%@",
                   WS_URL, self.UID];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
    
    if([wsResponse count] > 0)
    {
        self.wsClubDict = [[NSMutableDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"UpdateHeader"
         object:self]; //Update to header
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)getServerClubData:(returnBlock)completionBlock
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetClub/%@",
                       WS_URL, self.UID];
    NSURL *url = [NSURL URLWithString:[wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", wsurl, error, [error localizedDescription]);
             completionBlock(NO, nil);
         }
         else
         {
             NSArray *wsResponse = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
             if([wsResponse count] > 0)
             {
                 self.wsClubDict = [[NSMutableDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
                 completionBlock(YES, data);
             }
             else
             {
                 completionBlock(NO, nil);
             }
         }
     }];
}

- (void)updateClubInfoData: (NSString *) clubId
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetClubInfo/%@", 
					   WS_URL, clubId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	self.wsClubInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (void)updateClubInfoFb: (NSString *)fb_id
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetClubFB/%@", 
					   WS_URL, fb_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	if(wsResponse.count > 0)
	{
		self.wsClubInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
	}
}

- (void)updateMyAchievementsData
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetAchievements/%@", 
					   [self world_url], self.wsClubDict[@"club_id"]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	self.wsMyAchievementsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSString *)PlayerSkill1
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Keeper";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Keeper";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Footwork";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Catching";
    }
    else
    {
        return @"Keeper";
    }
}

- (NSString *)PlayerSkill2
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Defend";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Defend";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Defensive";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Running";
    }
    else
    {
        return @"Defend";
    }
}

- (NSString *)PlayerSkill3
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Playmaking";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Playmaking";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Dribbling";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Pitching";
    }
    else
    {
        return @"Playmaking";
    }
}

- (NSString *)PlayerSkill4
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Attack";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Attack";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Shooting";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Hitting";
    }
    else
    {
        return @"Attack";
    }
}

- (NSString *)PlayerSkill5
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Passing";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Passing";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Passing";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Throwing";
    }
    else
    {
        return @"Passing";
    }
}

- (NSString *)PlayerSkill6
{
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        return @"Condition";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        return @"Condition";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        return @"Condition";
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        return @"Condition";
    }
    else
    {
        return @"Condition";
    }
}

- (NSUInteger)getMaxSeries:(NSUInteger)division
{
	if(division == 1)
		return 1;
	if(division == 2)
		return 5;
	if(division == 3)
		return 25;
	if(division == 4)
		return 125;
	if(division > 4)
		return 625;
	
	return 1;
}

- (NSString *)gettAccepted
{
    self.acceptedMatch = [[NSUserDefaults standardUserDefaults] objectForKey:@"AcceptedMatch"];
    if (self.acceptedMatch == nil)
    {
        self.acceptedMatch = @"0";
    }
    
    return self.acceptedMatch;
}

- (void)settAccepted:(NSString *)match_id
{
    self.acceptedMatch = match_id;
    [[NSUserDefaults standardUserDefaults] setObject:self.acceptedMatch forKey:@"AcceptedMatch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeEnergy
{
    NSInteger energy_max = [self.wsClubDict[@"energy"] integerValue];
    NSInteger energy_togo = energy_max - self.energy;
    if (energy_togo > 0)
    {
        [self scheduleNotification:[[NSDate date] dateByAddingTimeInterval:energy_togo*180] :@"Your energy is full! Train your players and level up now!"];
    }
}

- (NSInteger)retrieveEnergy
{
	self.energy = [self.wsClubDict[@"e"] integerValue];
	[self storeEnergy];
	
	return self.energy;
}

- (PlayerCell *)playerCellHandler:(UITableView *)tableView
						indexPath:(NSIndexPath *)indexPath
					  playerArray:(NSMutableArray *)players
						 checkPos:(BOOL)checkPos
{
	static NSString *CellIdentifier = @"PlayerCell";
	PlayerCell *cell = (PlayerCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlayerCell" owner:self options:nil];
		cell = (PlayerCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = players[row];
	NSString *row_player_id = rowData[@"player_id"];
	NSString *player_id = row_player_id;
	NSString *name = rowData[@"player_name"];
	NSString *age = rowData[@"player_age"];
	cell.playerName.text = [NSString stringWithFormat:@"%@ (Age: %@)", name, age];
	
	NSString *salary = [[Globals i] numberFormat:rowData[@"player_salary"]];
	NSString *mvalue = [[Globals i] numberFormat:rowData[@"player_value"]];
	cell.playerValue.text = [NSString stringWithFormat:@"$%@/week (Value: $%@)", salary, mvalue];
	
	cell.keeper.text = [NSString stringWithFormat:@"%ld", (long)[rowData[@"keeper"] integerValue]/2];
    [cell.pbkeeper setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"keeper"] integerValue]/10]]];
    
	cell.defending.text = [NSString stringWithFormat:@"%ld", (long)[rowData[@"defend"] integerValue]/2];
    [cell.pbdefending setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"defend"] integerValue]/10]]];
    
	cell.playmaking.text = [NSString stringWithFormat:@"%ld", (long)[rowData[@"playmaking"] integerValue]/2];
    [cell.pbplaymaking setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"playmaking"] integerValue]/10]]];
    
	cell.passing.text = [NSString stringWithFormat:@"%ld", (long)[rowData[@"passing"] integerValue]/2];
    [cell.pbpassing setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"passing"] integerValue]/10]]];
    
	cell.scoring.text = [NSString stringWithFormat:@"%ld", (long)[rowData[@"attack"] integerValue]/2];
    [cell.pbscoring setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%ld.png", (long)[rowData[@"attack"] integerValue]/10]]];
    
	cell.stamina.text = [NSString stringWithFormat:@"%ld%%", (long)[rowData[@"fitness"] integerValue]/2];
    
    if ([rowData[@"fitness"] integerValue] < 80)
    {
        cell.stamina.textColor = [UIColor redColor];
    }
    else if ([rowData[@"fitness"] integerValue] < 150)
    {
        cell.stamina.textColor = [UIColor yellowColor];
    }
    else
    {
        cell.stamina.textColor = [UIColor greenColor];
    }
	
	cell.card1.backgroundColor = [UIColor clearColor];
	cell.card2.backgroundColor = [UIColor clearColor];
	
	if([rowData[@"card_red"] integerValue] == 1)
	{
		cell.card1.backgroundColor = [UIColor redColor];
	}
	else if([rowData[@"card_yellow"] integerValue] == 2)
	{
		cell.card1.backgroundColor = [UIColor yellowColor];
		cell.card2.backgroundColor = [UIColor yellowColor];
	}
	else if([rowData[@"card_yellow"] integerValue] == 1)
	{
		cell.card1.backgroundColor = [UIColor yellowColor];
	}
	else
    {
		cell.card1.backgroundColor = [UIColor clearColor];
		cell.card2.backgroundColor = [UIColor clearColor];
	}
	
	switch([rowData[@"player_condition"] integerValue])
	{
		case 1:
            [cell.injuredbruisedImage setImage:[UIImage imageNamed:@"icon_bruised.png"]];
			break;
		case 2:
            [cell.injuredbruisedImage setImage:[UIImage imageNamed:@"icon_injured.png"]];
			break;
		default:
			cell.injuredbruisedImage.image = nil;
			break;
	}
    
    if ([rowData[@"player_condition_days"] integerValue] > 0)
    {
        cell.condition.text = [NSString stringWithFormat:@"%@ Days", rowData[@"player_condition_days"]];
    }
    else
    {
        cell.condition.text = @"";
    }
    
	[cell.faceImage setImage:[UIImage imageNamed:[self getFaceImageName:player_id]]];
	
	NSInteger g = [rowData[@"player_goals"] integerValue];
	switch(g)
	{
		case 0:
			cell.star5.image = nil;
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 1:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 2:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 3:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 4:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 5:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 6:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 7:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star1.image = nil;
			break;
		case 8:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star1.image = nil;
			break;
		case 9:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star1 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		case 10:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star1 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		default:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
	}
	
	if(checkPos)
	{
        if ([[[Globals i] GameType] isEqualToString:@"hockey"])
        {
            if([self.wsClubDict[@"gk"] isEqualToString:row_player_id])
                cell.position.text = @"(GK)";
            else if([self.wsClubDict[@"rw"] isEqualToString:row_player_id])
                cell.position.text = @"(WNG1)";
            else if([self.wsClubDict[@"lw"] isEqualToString:row_player_id])
                cell.position.text = @"(WNG2)";
            else if([self.wsClubDict[@"cd1"] isEqualToString:row_player_id])
                cell.position.text = @"(DEF1)";
            else if([self.wsClubDict[@"cd2"] isEqualToString:row_player_id])
                cell.position.text = @"(DEF2)";
            else if([self.wsClubDict[@"im1"] isEqualToString:row_player_id])
                cell.position.text = @"(CTR1)";
            else if([self.wsClubDict[@"im2"] isEqualToString:row_player_id])
                cell.position.text = @"(CTR2)";
            else if([self.wsClubDict[@"fw1"] isEqualToString:row_player_id])
                cell.position.text = @"(FWD1)";
            else if([self.wsClubDict[@"fw2"] isEqualToString:row_player_id])
                cell.position.text = @"(FWD2)";
            else if([self.wsClubDict[@"sgk"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.GK)";
            else if([self.wsClubDict[@"sd"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.DEF)";
            else if([self.wsClubDict[@"sim"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.CTR)";
            else if([self.wsClubDict[@"sfw"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.FWD)";
            else if([self.wsClubDict[@"sw"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.WING)";
            else
                cell.position.text = @" ";
        }
        else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
        {
            if([self.wsClubDict[@"gk"] isEqualToString:row_player_id])
                cell.position.text = @"(PG)";
            else if([self.wsClubDict[@"cd1"] isEqualToString:row_player_id])
                cell.position.text = @"(SG)";
            else if([self.wsClubDict[@"im1"] isEqualToString:row_player_id])
                cell.position.text = @"(CTR)";
            else if([self.wsClubDict[@"fw1"] isEqualToString:row_player_id])
                cell.position.text = @"(PF)";
            else if([self.wsClubDict[@"fw2"] isEqualToString:row_player_id])
                cell.position.text = @"(SF)";
            else if([self.wsClubDict[@"sgk"] isEqualToString:row_player_id])
                cell.position.text = @"(B.PG)";
            else if([self.wsClubDict[@"sd"] isEqualToString:row_player_id])
                cell.position.text = @"(B.SG)";
            else if([self.wsClubDict[@"sim"] isEqualToString:row_player_id])
                cell.position.text = @"(B.CTR)";
            else if([self.wsClubDict[@"sfw"] isEqualToString:row_player_id])
                cell.position.text = @"(B.PF)";
            else if([self.wsClubDict[@"sw"] isEqualToString:row_player_id])
                cell.position.text = @"(B.SF)";
            else
                cell.position.text = @" ";
        }
        else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
        {
            if([[self.wsClubDict objectForKey:@"gk"] isEqualToString:row_player_id])
                cell.position.text = @"(C)";
            else if([[self.wsClubDict objectForKey:@"rb"] isEqualToString:row_player_id])
                cell.position.text = @"(RF)";
            else if([[self.wsClubDict objectForKey:@"lb"] isEqualToString:row_player_id])
                cell.position.text = @"(LF)";
            else if([[self.wsClubDict objectForKey:@"cd1"] isEqualToString:row_player_id])
                cell.position.text = @"(CF)";
            else if([[self.wsClubDict objectForKey:@"cd2"] isEqualToString:row_player_id])
                cell.position.text = @"(SS)";
            else if([[self.wsClubDict objectForKey:@"im1"] isEqualToString:row_player_id])
                cell.position.text = @"(P)";
            else if([[self.wsClubDict objectForKey:@"fw1"] isEqualToString:row_player_id])
                cell.position.text = @"(1B)";
            else if([[self.wsClubDict objectForKey:@"fw2"] isEqualToString:row_player_id])
                cell.position.text = @"(2B)";
            else if([[self.wsClubDict objectForKey:@"fw3"] isEqualToString:row_player_id])
                cell.position.text = @"(3B)";
            else if([[self.wsClubDict objectForKey:@"sgk"] isEqualToString:row_player_id])
                cell.position.text = @"(Bench 1)";
            else if([[self.wsClubDict objectForKey:@"sd"] isEqualToString:row_player_id])
                cell.position.text = @"(Bench 2";
            else if([[self.wsClubDict objectForKey:@"sim"] isEqualToString:row_player_id])
                cell.position.text = @"(Bench 3)";
            else if([[self.wsClubDict objectForKey:@"sfw"] isEqualToString:row_player_id])
                cell.position.text = @"(Bench 4)";
            else if([[self.wsClubDict objectForKey:@"sw"] isEqualToString:row_player_id])
                cell.position.text = @"(Bench 5)";
            else
                cell.position.text = @" ";
        }
        else
        {
            if([self.wsClubDict[@"gk"] isEqualToString:row_player_id])
                cell.position.text = @"(GK)";
            else if([self.wsClubDict[@"rb"] isEqualToString:row_player_id])
                cell.position.text = @"(DR)";
            else if([self.wsClubDict[@"lb"] isEqualToString:row_player_id])
                cell.position.text = @"(DL)";
            else if([self.wsClubDict[@"rw"] isEqualToString:row_player_id])
                cell.position.text = @"(MR)";
            else if([self.wsClubDict[@"lw"] isEqualToString:row_player_id])
                cell.position.text = @"(ML)";
            else if([self.wsClubDict[@"cd1"] isEqualToString:row_player_id])
                cell.position.text = @"(DC1)";
            else if([self.wsClubDict[@"cd2"] isEqualToString:row_player_id])
                cell.position.text = @"(DC2)";
            else if([self.wsClubDict[@"cd3"] isEqualToString:row_player_id])
                cell.position.text = @"(DC3)";
            else if([self.wsClubDict[@"im1"] isEqualToString:row_player_id])
                cell.position.text = @"(MC1)";
            else if([self.wsClubDict[@"im2"] isEqualToString:row_player_id])
                cell.position.text = @"(MC2)";
            else if([self.wsClubDict[@"im3"] isEqualToString:row_player_id])
                cell.position.text = @"(MC3)";
            else if([self.wsClubDict[@"fw1"] isEqualToString:row_player_id])
                cell.position.text = @"(SC1)";
            else if([self.wsClubDict[@"fw2"] isEqualToString:row_player_id])
                cell.position.text = @"(SC2)";
            else if([self.wsClubDict[@"fw3"] isEqualToString:row_player_id])
                cell.position.text = @"(SC3)";
            else if([self.wsClubDict[@"sgk"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.GK)";
            else if([self.wsClubDict[@"sd"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.DCLR)";
            else if([self.wsClubDict[@"sim"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.MC)";
            else if([self.wsClubDict[@"sfw"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.SC)";
            else if([self.wsClubDict[@"sw"] isEqualToString:row_player_id])
                cell.position.text = @"(Sub.MLR)";
            else
                cell.position.text = @" ";
        }
	}
	else
	{
		cell.position.text = rowData[@"position"];
	}
    
    cell.skill1.text = [self PlayerSkill1];
    cell.skill2.text = [self PlayerSkill2];
    cell.skill3.text = [self PlayerSkill3];
    cell.skill4.text = [self PlayerSkill4];
    cell.skill5.text = [self PlayerSkill5];
	
	return cell;
}

- (NSString *)getFaceImageName:(NSString *)player_id
{
    NSInteger pid = [player_id integerValue];
	NSInteger f = (pid % 1000);
	NSString *fname = [NSString stringWithFormat:@"z%ld.png", (long)f];
    
    if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        fname = [NSString stringWithFormat:@"z%ld.jpg", (long)f];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        f = (pid % 1500);
        fname = [NSString stringWithFormat:@"z%ld.jpg", (long)f];
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        f = (pid % 360);
        fname = [NSString stringWithFormat:@"z%ld.png", (long)f];
    }
    
    return fname;
}

- (NSString *)urlEnc:(NSString *)str
{
    NSString *escaped = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"/" withString:@"="];
    escaped = [escaped stringByReplacingOccurrencesOfString:@":" withString:@";"];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"?" withString:@","];
    
    return escaped;
}

- (void)buyProduct:(NSString *)productId :(NSString *)isVirtualMoney :(NSString *)json
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/BuyProductNew/%@/%@/%@/%@",
					   WS_URL, isVirtualMoney, productId, self.UID, json];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
}

- (void)changeTraining:(NSString *)trainingId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangeTraining/%@/%@",
					   WS_URL, self.UID, trainingId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
	[self updateClubData]; //training_id is set
    
    [self showToast:@"Training Changed for the week" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)changeFormation:(NSString *)formationId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangeFormation/%@/%@",
					   WS_URL, self.UID, formationId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
	
    [self updateClubData]; //formation_id is set
    
    [self showToast:@"Formation Changed" optionalTitle:nil optionalImage:@"tick_yes"];

}

- (void)changeTactic:(NSString *)tacticId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangeTactic/%@/%@",
					   WS_URL, self.UID, tacticId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
	[self updateClubData]; //tactic_id is set
    
    [self showToast:@"Tactics Changed" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)changePlayerFormation:(NSString *)player_id :(NSString *)formation_pos
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangePlayerFormation/%@/%@/%@",
					   WS_URL, self.UID, player_id, formation_pos];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
	[self updateClubData]; //player_id at formation set
    
    [self showToast:@"Player is Set" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)challengeClub:(NSString *)home :(NSString *)away :(NSString *)win :(NSString *)lose :(NSString *)draw :(NSString *)note
{
	NSString *encodedNote = [self urlEnc:note];
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/CreateChallenge/%@/%@/%@/%@/%@/%@",
					   WS_URL, self.UID, away, win, lose, draw, encodedNote];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"Club has been challenged" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (NSString *)doPost:(NSString *)message
{
	NSString *encodedMessage = [self urlEnc:message];
    NSString *encodedClubName = [self urlEnc:self.wsClubDict[@"club_name"]];
    NSString *club_id = self.wsClubDict[@"club_id"];
    NSString *a_id = self.wsClubDict[@"alliance_id"];
    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AlliancePost/%@/%@/%@/%@",
                       WS_URL, a_id, club_id, encodedClubName, encodedMessage];
    
    return [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:wsurl] encoding:NSASCIIStringEncoding error:nil];
}

- (NSString *)doBid:(NSString *)player_id :(NSString *)value
{
	NSString *encodedValue = [self urlEnc:value];
    NSString *encodedClubName = [self urlEnc:self.wsClubDict[@"club_name"]];
    NSString *club_id = self.wsClubDict[@"club_id"];
    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/DoBid/%@/%@/%@/%@/%@",
                       WS_URL, self.UID, club_id, encodedClubName, player_id, encodedValue];
    
    
    [self showToast:@"Bid is successful" optionalTitle:nil optionalImage:@"tick_yes"];

    return [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:wsurl] encoding:NSASCIIStringEncoding error:nil];
}

- (void)challengeAccept:(NSString *)match_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AcceptChallenge/%@/%@",
					   WS_URL, match_id, self.UID];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
}

- (void)sellPlayer:(NSString *)player_value :(NSString *)player_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/SellPlayers/%@/%@/%@",
					   WS_URL, self.UID, player_value, player_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"Player Sold" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)healPlayer:(NSString *)player_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/HealPlayer/%@/%@",
					   WS_URL, self.UID, player_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"Player Healed" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)energizePlayer:(NSString *)player_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/EnergizePlayer/%@/%@",
					   WS_URL, self.UID, player_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"Player Energized" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)buyCoach:(NSString *)coach_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/BuyCoachs/%@/%@",
					   WS_URL, self.UID, coach_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"A new coach has been assigned to your club." optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)resetClub
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ResetClub/%@",
					   WS_URL, self.UID];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
    
    [self showToast:@"Club Reset Success" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)updateCurrentSeasonData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetCurrentSeason",
					   WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	self.wsCurrentSeasonData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *)getCurrentSeasonData
{
	return self.wsCurrentSeasonData;
}

- (NSDictionary *)getClubData
{
	return self.wsClubDict;
}

- (NSDictionary *)getClubInfoData
{
	return self.wsClubInfoData;
}

- (void)updateSquadData:(NSString *)clubId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayers/%@",
                       WS_URL, clubId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	self.wsSquadData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getSquadData
{
	return self.wsSquadData;
}

- (void)updateMySquadData
{
	self.workingSquad = 1;
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayers/%@",
					   WS_URL, self.wsClubDict[@"club_id"]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	self.wsMySquadData = [[NSMutableArray alloc] initWithContentsOfURL:url];
	self.workingSquad = 0;
}

- (NSMutableArray *)getMySquadData
{
	return self.wsMySquadData;
}

- (NSMutableArray *)getMyAchievementsData
{
	return self.wsMyAchievementsData;
}

- (void)updateAllianceData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAlliance",
					   WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	self.wsAllianceData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getAllianceData
{
	return self.wsAllianceData;
}

- (NSInteger)getAchievementsBadge
{
	NSInteger count = 0;
	
	if([self.wsMyAchievementsData count] > 0)
	{
		for(NSDictionary *rowData in self.wsMyAchievementsData)
		{
			if(![rowData[@"club_id"] isEqualToString:@"0"])
			{
                if([rowData[@"claimed"] isEqualToString:@"False"])
                {
                    count = count + 1;
                }
			}
		}
	}
	
	return count;
}

- (void)updateProducts
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetProducts", WS_URL];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsProductsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getProducts
{
	return self.wsProductsData;
}

- (void)updatePlayerSaleData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayersBid", WS_URL];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsPlayerSaleData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getPlayerSaleData
{
	return self.wsPlayerSaleData;
}

- (void)updateCoachData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetCoaches", WS_URL];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsCoachData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getCoachData
{
	return self.wsCoachData;
}

- (void)updatePlayerInfoData:(NSString *)playerId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayerInfo/%@",
					   WS_URL, playerId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	self.wsPlayerInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *)getPlayerInfoData
{
	return self.wsPlayerInfoData;
}

- (void)updateMatchInfoData:(NSString *)matchId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchInfo/%@",
					   WS_URL, matchId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	self.wsMatchInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *)getMatchInfoData
{
	return self.wsMatchInfoData;
}

- (void)updateMatchData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchUpcomings/%@",
                           WS_URL, self.UID];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsMatchData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMatchData
{
	return self.wsMatchData;
}

- (void)updateMatchPlayedData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchPlayeds/%@",
                           WS_URL, self.UID];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsMatchPlayedData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMatchPlayedData
{
	return self.wsMatchPlayedData;
}

- (void)updateMatchHighlightsData:(NSString *)matchId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchHighlights/%@",
					   WS_URL, matchId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	self.wsMatchHighlightsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMatchHighlightsData
{
	return self.wsMatchHighlightsData;
}

- (void)updateChallengesData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetChallenge/%@",
                           WS_URL, self.UID];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsChallengesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getChallengesData
{
	return self.wsChallengesData;
}

- (void)updateChallengedData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetChallengeds/%@",
                           WS_URL, self.UID];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsChallengedData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getChallengedData
{
	return self.wsChallengedData;
}

- (void)updateLeagueData:(NSString *)division : (NSString *)series
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetSeries/%@/%@",
                           WS_URL, division, series];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsLeagueData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getLeagueData
{
	return self.wsLeagueData;
}

- (void)updatePromotionData:(NSString *)division
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetLeaguePromotion/%@",
                           WS_URL, division];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsPromotionData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getPromotionData
{
	return self.wsPromotionData;
}

- (void)updateLeagueScorersData:(NSString *)division :(NSString *)top
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetLeagueTopScorers/%@/%@",
                           WS_URL, division, top];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsLeagueScorersData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getLeagueScorersData
{
	return self.wsLeagueScorersData;
}

- (void)updateMatchFixturesData:(NSString *)division :(NSString *)series
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchFixtures/%@/%@",
                           WS_URL, division, series];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsMatchFixturesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMatchFixturesData
{
	return self.wsMatchFixturesData;
}

- (void)updateAllianceCupFixturesData:(NSString *)a_id round:(NSString *)round
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceCupFixtures/%@/%@",
						   WS_URL, a_id, round];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsAllianceCupFixturesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getAllianceCupFixturesData
{
	return self.wsAllianceCupFixturesData;
}

- (void)updateTrophyData:(NSString *)clubId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetTrophy/%@",
					   WS_URL, clubId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	self.wsTrophyData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getTrophyData
{
	return self.wsTrophyData;
}

- (void)updateNewsData:(NSString *)division :(NSString *)series :(NSString *)playing_cup
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetNews/%@/%@/%@/%@",
                           WS_URL, self.wsClubDict[@"club_id"], division, series, playing_cup];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsNewsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getNewsData
{
	return self.wsNewsData;
}

- (void)updateWallData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceWall/%@",
                           WS_URL, self.wsClubDict[@"alliance_id"]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsWallData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getWallData
{
	return self.wsWallData;
}

- (void)updateEventsData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceEvents/%@",
                           WS_URL, self.wsClubDict[@"alliance_id"]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsEventsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getEventsData
{
	return self.wsEventsData;
}

- (void)updateDonationsData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceDonations/%@",
                       WS_URL, self.wsClubDict[@"alliance_id"]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsDonationsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getDonationsData
{
	return self.wsDonationsData;
}

- (void)updateAppliedData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceApply/%@",
                       WS_URL, self.wsClubDict[@"alliance_id"]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsAppliedData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getAppliedData
{
	return self.wsAppliedData;
}

- (void)updateMembersData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceMembers/%@",
                       WS_URL, self.wsClubDict[@"alliance_id"]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsMembersData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMembersData
{
	return self.wsMembersData;
}

- (void)updateMarqueeData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMarquee/%@/%@/%@/%@",
                       WS_URL, self.wsClubDict[@"club_id"], self.wsClubDict[@"division"], self.wsClubDict[@"series"], [self BoolToBit:self.wsClubDict[@"playing_cup"]]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	self.wsMarqueeData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *)getMarqueeData
{
	return self.wsMarqueeData;
}

@end
