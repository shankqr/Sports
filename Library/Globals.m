//
//  Globals.m
//  Kingdom Game
//
//  Created by Shankar on 6/9/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"
#import "FriendProtocols.h"
#import "BuyView.h"
#import "WorldsView.h"
#import "DAAppsViewController.h"
#import "MMProgressHUD.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterSmokeStyle.h"

@implementation Globals
@synthesize viewControllerStack;
@synthesize buttonAudio;
@synthesize backAudio;
@synthesize moneyAudio;
@synthesize winAudio;
@synthesize loseAudio;
@synthesize wsProductIdentifiers;
@synthesize wsClubData;
@synthesize wsWorldClubData;
@synthesize wsClubInfoData;
@synthesize wsReportData;
@synthesize wsMailData;
@synthesize wsMailReply;
@synthesize localReportData;
@synthesize localMailData;
@synthesize localMailReply;
@synthesize wsChatData;
@synthesize wsChatFullData;
@synthesize wsAllianceChatData;
@synthesize wsAllianceChatFullData;
@synthesize wsMyAchievementsData;
@synthesize wsBaseData;
@synthesize wsBasesData;
@synthesize workingUrl;
@synthesize selectedClubId;
@synthesize selectedBaseId;
@synthesize purchasedProductString;
@synthesize offsetServerTimeInterval;
@synthesize loginBonus;
@synthesize latitude;
@synthesize longitude;
@synthesize devicetoken;
@synthesize uid;
@synthesize selectedMapTile;
@synthesize dialogBox;
@synthesize templateView;
@synthesize buyView;
@synthesize wsWorldData;
@synthesize wsWorldsData;
@synthesize worldsView;
@synthesize loginView;
@synthesize lastReportId;
@synthesize lastMailId;
@synthesize chatView;
@synthesize allianceChatView;
@synthesize mailCompose;
@synthesize loginNotification;

static Globals *_i;
static NSString *GameId = @"1";

- (id)init
{
	if (self = [super init])
	{
        self.selectedClubId = @"0";
        self.workingUrl = @"0";
        self.selectedMapTile = @"0";
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
        [connectionQueue setMaxConcurrentOperationCount:2];
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
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
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

+ (void)postServerLoading:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    NSError* error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
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
	return GameId;
}

- (NSString	*)UID
{
    uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserUID"];
    
    return uid;
}

- (NSString	*)world_url
{
    return [NSString stringWithFormat:@"http://%@/%@", wsWorldData[@"server_ip"], wsWorldData[@"server_webservice"]];
}

- (void)setUID:(NSString *)user_uid
{
    uid = user_uid;
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"UserUID"];
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

- (void)resetUserDefaults
{
    [self settLocalMailReply:[[NSDictionary alloc] init]];
    [self settLastMailId:@"0"];
    [self settLocalMailData:[[NSMutableArray alloc] init]];
    
    [self settLastReportId:@"0"];
    [self settLocalReportData:[[NSMutableArray alloc] init]];
    [self settSelectedBaseId:@"0"];
}

- (void)updateTime
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
    
    offsetServerTimeInterval = serverTimeInterval - localTimeInterval;
}

- (NSString *)getServerTimeString
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormater setDateFormat:@"HH:mm:ss"];
    
    NSDate *localdatetime = [NSDate date];
    NSDate *serverdatetime = [localdatetime dateByAddingTimeInterval:offsetServerTimeInterval];

    return [dateFormater stringFromDate:serverdatetime];
}

- (NSString *)getServerDateTimeString
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormater setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSDate *localdatetime = [NSDate date];
    NSDate *serverdatetime = [localdatetime dateByAddingTimeInterval:offsetServerTimeInterval];
    
    return [dateFormater stringFromDate:serverdatetime];
}

- (NSString *)getTimeAgo:(NSString *)datetimestring
{
    NSString *diff = datetimestring;
    
    if (datetimestring != nil && [datetimestring length] > 0)
    {
        NSDateFormatter *serverDateFormat = [[NSDateFormatter alloc] init];
        [serverDateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [serverDateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [serverDateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss Z"];
        
        NSDate *date1 = [serverDateFormat dateFromString:[NSString stringWithFormat:@"%@ -0000", datetimestring]];
        NSDate *date2 = [NSDate date];
        
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        
        // Get conversion to months, days, hours, minutes
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
        
        if ([breakdownInfo month] > 0)
        {
            if ([breakdownInfo month] == 1)
            {
                diff = @"1 month ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%d months ago", [breakdownInfo month]];
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
                diff = [NSString stringWithFormat:@"%d days ago", [breakdownInfo day]];
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
                diff = [NSString stringWithFormat:@"%d hours ago", [breakdownInfo hour]];
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
                diff = [NSString stringWithFormat:@"%d mins ago", [breakdownInfo minute]];
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
                diff = [NSString stringWithFormat:@"%d secs ago", [breakdownInfo second]];
            }
        }
    }

    return diff;
}

- (void)emailToDeveloper
{
    NSString *mailto = [NSString stringWithFormat:@"mailto://support@tapfantasy.com?subject=%@(Version %@)",
                        GAME_NAME,
                        GAME_VERSION];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mailto stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)showLoadingAlert
{
    NSArray *images = @[[UIImage imageNamed:@"g1_0.png"],
                        [UIImage imageNamed:@"g1_1.png"],
                        [UIImage imageNamed:@"g1_2.png"],
                        [UIImage imageNamed:@"g1_3.png"],
                        [UIImage imageNamed:@"g1_4.png"],
                        [UIImage imageNamed:@"g1_5.png"]];
    
    [[MMProgressHUD sharedHUD] setOverlayMode:MMProgressHUDWindowOverlayModeLinear];
    //[[MMProgressHUD sharedHUD] setOverlayMode:MMProgressHUDWindowOverlayModeGradient];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:nil status:nil images:images];
}

- (void)removeLoadingAlert
{
    [MMProgressHUD dismiss];
    
    //[self showToast:@"Loading completed!" optionalTitle:nil optionalImage:@"tick_yes"];
}

- (void)showToast:(NSString *)message optionalTitle:(NSString *)title optionalImage:(NSString *)imagename
{
    [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterSmokeStyle new];

    [JCNotificationCenter
     enqueueNotificationWithMessage:message
     title:title
     image:imagename
     tapHandler:^{}];
}

- (void)createDialogBox
{
    if (dialogBox == nil)
    {
        dialogBox = [[DialogBoxView alloc] initWithNibName:@"DialogBoxView" bundle:nil];
    }
}

- (void)removeDialogBox
{
	if(dialogBox != nil)
	{
		[dialogBox.view removeFromSuperview];
	}
}

- (void)showDialog:(NSString *)l1
{
    [self createDialogBox];
    
    dialogBox.promptText = l1;
    dialogBox.dialogType = 1;
    [[self peekViewControllerStack].view addSubview:dialogBox.view];
    dialogBox.dialogBlock = nil;
    
    [dialogBox updateView];
}

- (void)showDialogError
{
    [self showDialog:@"Sorry, there was an internet connection issue or your session has timed out. Please retry."];
}

- (void)showDialogBlock:(NSString *)l1 :(NSInteger)type :(DialogBlock)block
{
    [self createDialogBox];
    
    dialogBox.promptText = l1;
    dialogBox.dialogType = type;
    [[self peekViewControllerStack].view addSubview:dialogBox.view];
    dialogBox.dialogBlock = block;
    
    [dialogBox updateView];
}

- (void)flushViewControllerStack
{
    if(viewControllerStack == nil)
    {
        viewControllerStack = [[NSMutableArray alloc] init];
    }
    
    [viewControllerStack removeAllObjects];
}

- (void)pushViewControllerStack:(UIViewController *)view
{
    if(viewControllerStack == nil)
    {
        viewControllerStack = [[NSMutableArray alloc] init];
    }
    
    [viewControllerStack addObject:view];
}

- (UIViewController *)popViewControllerStack
{
    UIViewController *view = nil;
    
    if ([viewControllerStack count] != 0)
    {
        view = [viewControllerStack lastObject];
        [viewControllerStack removeLastObject];
    }
    
    return view;
}

- (UIViewController *)peekViewControllerStack
{
    UIViewController *view = nil;
    
    if ([viewControllerStack count] != 0)
    {
        view = [viewControllerStack lastObject];
    }
    
    return view;
}

- (BOOL)isCurrentView:(UIViewController *)view
{
    return ([self peekViewControllerStack] == view);
}

- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType
{
    templateView = [[TemplateView alloc] init];
    
    templateView.delegate = self;
	templateView.viewControllers = viewControllers;
    templateView.title = title;
    templateView.frameType = frameType;
    
    [[self peekViewControllerStack].view addSubview:templateView.view];
    
    [templateView updateView];
    [self pushViewControllerStack:templateView];
}

- (void)pushTemplateNav:(UIViewController *)view
{
    [self buttonSound];
    
    [(TemplateView *)[self peekViewControllerStack] pushNav:view];
}

- (void)backTemplate
{
    [(TemplateView *)[self peekViewControllerStack] back];
}

- (void)closeTemplate
{
    [self backSound];
    
    [(TemplateView *)[self peekViewControllerStack] cleanView];
    [[self peekViewControllerStack].view removeFromSuperview];
    
    [self popViewControllerStack];
}

- (void)showBuy
{
    if (buyView == nil)
    {
        buyView = [[BuyView alloc] initWithStyle:UITableViewStylePlain];
        buyView.title = @"Buy Diamonds 1";
        [buyView updateView];
    }
    
    [self showTemplate:@[buyView] :@"Buy Diamonds" :1];
    
    //Disable the Buy button
    templateView.buyButton.hidden = YES;
    templateView.currencyLabel.hidden = YES;
}

- (void)showWorlds
{
    if (worldsView == nil)
    {
        worldsView = [[WorldsView alloc] initWithStyle:UITableViewStylePlain];
        worldsView.title = @"Select World 1";
        [worldsView updateView];
    }

    [self showTemplate:@[worldsView] :@"Select World" :1];
    
    //Disable the Buy button
    templateView.buyButton.hidden = YES;
    templateView.currencyLabel.hidden = YES;
}

- (void)showChat
{
	if(chatView == nil)
    {
        chatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
    }
    chatView.title = @"World";
    
    if([wsWorldClubData[@"alliance_id"] isEqualToString:@"0"])
    {
        [self showTemplate:@[chatView] :@"Chat" :1];
        [chatView updateView:[[Globals i] wsChatFullData] table:@"chat" a_id:@"0"];
    }
    else
    {
        if(allianceChatView == nil)
        {
            allianceChatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
        }
        allianceChatView.title = @"Alliance";
        
        [self showTemplate:@[chatView, allianceChatView] :@"Chat" :1];
        
        [chatView updateView:[[Globals i] wsChatFullData] table:@"chat" a_id:@"0"];
        
        [allianceChatView updateView:[[Globals i] wsAllianceChatFullData] table:@"alliance_chat" a_id:@"0"];
        allianceChatView.isAllianceChat = @"1";
    }
}

- (void)pushChatVC:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid
{
    ChatView *achatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
    achatView.title = @"Chat";
    
    [self pushTemplateNav:achatView];
    [achatView updateView:ds table:tn a_id:aid];
}

- (void)pushMoreGamesVC
{
    DAAppsViewController *appsViewController = [[DAAppsViewController alloc] init];
    NSArray *values = [wsProductIdentifiers[@"promote_apps"] componentsSeparatedByString:@","];
    [appsViewController loadAppsWithAppIds:values completionBlock:nil];
    
    [self pushTemplateNav:appsViewController];
}

- (void)mailCompose:(NSString *)isAlli toID:(NSString *)toid toName:(NSString *)toname
{
    if(mailCompose == nil)
    {
        mailCompose = [[MailCompose alloc] initWithStyle:UITableViewStylePlain];
    }
    mailCompose.title = @"Mail";
    mailCompose.isAlliance = isAlli;
    mailCompose.toID = toid;
    mailCompose.toName = toname;
    
    [self showTemplate:@[mailCompose] :@"Message" :1];
}

- (BOOL)mh_tabBarController:(TemplateView *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %u", tabBarController, viewController, index);
    
	return YES;
}

- (void)mh_tabBarController:(TemplateView *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %u", tabBarController, viewController, index);
}

- (DynamicCell *)dynamicCell:(UITableView *)tableView rowData:(NSDictionary *)rowData cellWidth:(float)cell_width
{
    DynamicCell *cell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
    
    if (cell == nil)
    {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DynamicCell"];
    }
    
    [cell drawCell:rowData cellWidth:cell_width];
    
    return cell;
}

- (CGFloat)textHeight:(NSString *)text lblWidth:(CGFloat)label_width fontSize:(CGFloat)font_size
{
    CGSize constraint = CGSizeMake(label_width, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:DEFAULT_FONT size:font_size] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height, CELL_LABEL_HEIGHT);
}

- (CGFloat)dynamicCellHeight:(NSDictionary *)rowData cellWidth:(float)cell_width
{
    CGFloat cell_height = CELL_EMPTY_HEIGHT;
    CGFloat r1_length = cell_width - CELL_CONTENT_MARGIN*2;
    CGFloat r2_length = 0.0f;
    CGFloat col1_length = 0.0f;
    
    if (rowData[@"i1"] != nil)
    {
        r1_length -= CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
    }
    else if (rowData[@"n1"] != nil)
    {
        r1_length -= CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
    }

    if (rowData[@"i2"] != nil)
    {
        r1_length -= CELL_IMAGE2_WIDTH - CELL_CONTENT_SPACING;
    }
    
    r2_length = r1_length;
    
    if (rowData[@"c1"] != nil)
    {
        CGFloat c1_ratio = 4;
        if (rowData[@"c1_ratio"] != nil)
        {
            c1_ratio = [rowData[@"c1_ratio"] floatValue];
            if (c1_ratio < 2 || c1_ratio > 10)
            {
                c1_ratio = 4;
            }
        }
        col1_length = r1_length/c1_ratio;
        r1_length -= col1_length - CELL_CONTENT_SPACING;
        col1_length -= CELL_CONTENT_SPACING;
    }
    
    if (rowData[@"align_top"] == nil)
    {
        r2_length = r1_length;
    }
    
    if (rowData[@"h1"] != nil && ![rowData[@"h1"] isEqualToString:@""])
    {
        cell_height = CELL_HEADER_HEIGHT;
    }
    else if ([rowData[@"h1"] isEqualToString:@""])
    {
        cell_height = CELL_HEADER_HEIGHT;
    }
    else
    {
        if ((rowData[@"r1"] != nil) && ![rowData[@"r1"] isEqualToString:@""])
        {
            cell_height += [self textHeight:rowData[@"r1"] lblWidth:r1_length fontSize:R1_FONT_SIZE];
        }
        
        if ((rowData[@"r2"] != nil) && ![rowData[@"r2"] isEqualToString:@""])
        {
            cell_height += [self textHeight:rowData[@"r2"] lblWidth:r2_length fontSize:R2_FONT_SIZE];
        }
        else if ((rowData[@"i1"] != nil) && ![rowData[@"i1"] isEqualToString:@""])
        {
            cell_height += CELL_LABEL_HEIGHT;
        }
        
        if ((rowData[@"r3"] != nil) && ![rowData[@"r3"] isEqualToString:@""])
        {
            cell_height += [self textHeight:rowData[@"r3"] lblWidth:r2_length fontSize:R3_FONT_SIZE];
        }
        
        if (rowData[@"t1"] != nil)
        {
            if (rowData[@"t1_height"] != nil)
            {
                cell_height += [rowData[@"t1_height"] floatValue];
            }
            else
            {
                cell_height += CELL_LABEL_HEIGHT;
            }
        }
    }
    
    return cell_height;
}

- (double)Random_next:(double)min to:(double)max
{
    return ((double)arc4random() / UINT_MAX) * (max-min) + min;
}

- (void)initSound
{
	//Setup button sound
	NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_button.aif", [[NSBundle mainBundle] resourcePath]]];
	buttonAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
    buttonAudio.numberOfLoops = 0;
    buttonAudio.volume = 1.0;
	
	//Setup back sound
	NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_toaster.aac", [[NSBundle mainBundle] resourcePath]]];
	backAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
	backAudio.numberOfLoops = 0;
    backAudio.volume = 1.0;
    
    //Setup money sound
	NSURL *url4 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_cash.caf", [[NSBundle mainBundle] resourcePath]]];
	moneyAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url4 error:nil];
	moneyAudio.numberOfLoops = 0;
    moneyAudio.volume = 1.0;
    
    //Setup win sound
	NSURL *url5 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_crowd_goal.caf", [[NSBundle mainBundle] resourcePath]]];
	winAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url5 error:nil];
	winAudio.numberOfLoops = 0;
    winAudio.volume = 1.0;
    
    //Setup lose sound
	NSURL *url6 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_crowd0.caf", [[NSBundle mainBundle] resourcePath]]];
	loseAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url6 error:nil];
	loseAudio.numberOfLoops = 0;
    loseAudio.volume = 1.0;
}

- (void)buttonSound
{
	//[buttonAudio play];
}

- (void)backSound
{
	//[backAudio play];
}

- (void)toasterSound
{
	[backAudio play];
}

- (void)moneySound
{
	[moneyAudio play];
}

- (void)winSound
{
	[winAudio play];
}

- (void)loseSound
{
	[loseAudio play];
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

    [self showDialog:alertMsg];
}

- (void)scheduleNotification:(NSDate *)f_date :(NSString *)alert_body
{
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil)
    {
        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSMutableArray *Arr = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication]scheduledLocalNotifications]];
        for (int k=0; k<[Arr count]; k++)
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
    if (loginNotification == nil)
    {
        loginNotification = [[UILocalNotification alloc] init];
    }
    loginNotification.timeZone = [NSTimeZone defaultTimeZone];
    loginNotification.soundName = @"sound_toaster.aac";
    NSDictionary *userDict = @{@"ID": @"login_reminder"};
    loginNotification.userInfo = userDict;
    
    loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*3];
    loginNotification.alertBody = @"Your players misses you! It's been 3 days since they last saw you. Login now and catch up with them.";
    [[UIApplication sharedApplication] scheduleLocalNotification:loginNotification];
    
    loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*7];
    loginNotification.alertBody = @"Your players misses you! It's been a week since they last saw you. Login now and catch up with them.";
    [[UIApplication sharedApplication] scheduleLocalNotification:loginNotification];
    
    loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*15];
    loginNotification.alertBody = @"Your players misses you! It's been 2 weeks since they last saw you. Login now and catch up with them.";
    [[UIApplication sharedApplication] scheduleLocalNotification:loginNotification];
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

- (void)fblogin
{
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    
    // Configure the picker ...
    friendPickerController.title = @"Select a Friend";
    // Set this view controller as the friend picker delegate
    friendPickerController.delegate = self;
    // Ask for friend device data
    friendPickerController.fieldsForRequest = [NSSet setWithObjects:@"installed", nil];
    
    friendPickerController.allowsMultipleSelection = NO;
    
    // Fetch the data
    [friendPickerController loadData];
    
    // iOS 5+
    [[self peekViewControllerStack] presentViewController:friendPickerController
                       animated:YES
                     completion:nil];
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUserExtraFields>)user
{
    if (user.installed)
    {
        return YES;
    }
    
    // Friend is not an iOS user, do not include them
    return NO;
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [self backSound];
    [[self peekViewControllerStack] dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    [[Globals i] buttonSound];
    
    FBFriendPickerViewController *fpc = (FBFriendPickerViewController *)sender;
    
    for (id<FBGraphUser> user in fpc.selection)
    {
        //NSString *strToEncrypt  = user.id;
        //NSString *secret        = @"year2000";
        //NSString *hexHmac       = [strToEncrypt HMACWithSecret:secret];
        
        //[self showFBClubViewer:hexHmac];
    }
    
    [[self peekViewControllerStack] dismissViewControllerAnimated:YES completion:nil];
}

- (void)showLogin:(LoginBlock)block
{
    if (loginView == nil)
    {
        loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
        loginView.title = @"Login";
    }
    loginView.loginBlock = block;
    
    [self showTemplate:@[loginView] :@"Login" :0];
    
    //Disable the Buy & Close button
    templateView.buyButton.hidden = YES;
    templateView.currencyLabel.hidden = YES;
    templateView.closeButton.hidden = YES;
    
    [loginView updateView];
}

- (void)shareButton
{
    [[Globals i] buttonSound];
    
    //NSString *message = @"Check out this very cool App!";
	//NSString *caption = @"Come on and join in the fun.";
	//NSString *picture = @"Icon-72.png";
    
    //[self NativePublishStory:message :caption :picture];
    
    [self showDialog:@"Thank you for sharing this App with your friends."];
}

// will attempt different approaches depending upon configuration.
- (void)postStatusUpdate:(NSString *)message
{
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.tapfantasy.com/kingdom"];
    
    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    // The first method tries to share via the Facebook app. This allows sharing without
    // the user having to authorize your app, and is available as long as the user has the
    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    // Facebook app.
    // The second method tries to share via Facebook's iOS6 integration, which also
    // allows sharing without the user having to authorize your app, and is available as
    // long as the user has linked their Facebook account with iOS6. This publish will
    // result in a popup iOS6 dialog.
    // The third method tries to share via a Graph API request. This does require the user
    // to authorize your app. They must also grant your app publish permissions. This
    // allows the app to publish without any user interaction.
    
    // If it is available, we will first try to post using the share dialog in the Facebook app
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare
                                                          name:@"TapFantasy Inc."
                                                       caption:nil
                                                   description:message
                                                       picture:nil
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error)
    {
                                                           if (error)
                                                           {
                                                               NSLog(@"Error: %@", error.description);
                                                           }
                                                           else
                                                           {
                                                               NSLog(@"Success!");
                                                           }
                                                       }];
    
    if (!appCall)
    {
        // Next try to post using Facebook's iOS6 integration
        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:[self peekViewControllerStack]
                                                                              initialText:message
                                                                                    image:nil
                                                                                      url:urlToShare
                                                                                  handler:nil];
        
        if (!displayedNativeDialog)
        {
            // Lastly, fall back on a request for permissions and a direct post using the Graph API
            [self performPublishAction:^{
                FBRequestConnection *connection = [[FBRequestConnection alloc] init];
                
                connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
                | FBRequestConnectionErrorBehaviorAlertUser
                | FBRequestConnectionErrorBehaviorRetry;
                
                [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
                     completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
                {
                         //Post was successfull or failed!
                     }];
                [connection start];
            }];
        }
    }
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void)performPublishAction:(void (^)(void))action
{
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound)
    {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error)
        {
                                                if (!error)
                                                {
                                                    action();
                                                }
                                                else if (error.fberrorCategory != FBErrorCategoryUserCancelled)
                                                {
                                                    [self showDialog:@"Unable to get permission to post"];
                                                }
                                            }];
    }
    else
    {
        action();
    }
}

- (NSDictionary *)gettLocalMailReply
{
    self.localMailReply = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"MailReply"];
    if (self.localMailReply == nil)
    {
        self.localMailReply = [[NSDictionary alloc] init];
    }
    
    return self.localMailReply;
}

- (void)settLocalMailReply:(NSDictionary *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSDictionary alloc] initWithDictionary:rd copyItems:YES] forKey:@"MailReply"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)findMailReply:(NSString *)mail_id
{
    self.localMailReply = [self gettLocalMailReply];
    
    return [self.localMailReply objectForKey:mail_id];
}

- (void)addMailReply:(NSString *)mail_id :(NSArray *)mail_reply
{
    self.localMailReply = [self gettLocalMailReply];
    NSMutableDictionary *mdReply = [[NSMutableDictionary alloc] initWithDictionary:self.localMailReply copyItems:YES];
    [mdReply setObject:mail_reply forKey:mail_id];
    
    [self settLocalMailReply:mdReply];
}

- (void)deleteLocalMail:(NSString *)mail_id
{
    self.localMailReply = [self gettLocalMailReply];
    
    if ([self.localMailReply count] > 0)
    {
        NSMutableDictionary *mdReply = [[NSMutableDictionary alloc] initWithDictionary:self.localMailReply copyItems:YES];
        [mdReply removeObjectForKey:mail_id];
        [self settLocalMailReply:mdReply];
    }
    
    self.localMailData = [self gettLocalMailData];
    int count = [self.localMailData count];
    int index_to_remove = -1;
    for (NSUInteger i = 0; i < count; i++)
    {
        if ([localMailData[i][@"mail_id"] isEqualToString:mail_id])
        {
            index_to_remove = i;
        }
    }
    
    if (index_to_remove > -1)
    {
        [self.localMailData removeObjectAtIndex:index_to_remove];
        [self settLocalMailData:self.localMailData];
    }
}

- (void)replyCounterPlus:(NSString *)mail_id
{
    self.localMailData = [self gettLocalMailData];
    int count = [self.localMailData count];

    for (NSUInteger i = 0; i < count; i++)
    {
        if ([localMailData[i][@"mail_id"] isEqualToString:mail_id])
        {
            int rcounter = [localMailData[i][@"reply_counter"] intValue] + 1;
            localMailData[i][@"reply_counter"] = [NSString stringWithFormat:@"%d", rcounter];
            
            [self settLocalMailData:self.localMailData];
        }
    }
}

- (NSString *)gettLastMailId
{
    lastMailId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Mailid"];
    if (lastMailId == nil)
    {
        lastMailId = @"0";
    }
    
    return lastMailId;
}

- (void)settLastMailId:(NSString *)mid
{
    lastMailId = mid;
    [[NSUserDefaults standardUserDefaults] setObject:lastMailId forKey:@"Mailid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)gettLocalMailData
{
    self.localMailData = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"MailData"];
    if (self.localMailData == nil)
    {
        self.localMailData = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *fullMutable = [[NSMutableArray alloc] init];
    
    for (NSDictionary *obj in localMailData)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:obj copyItems:YES];
        [fullMutable addObject:dic];
    }
    
    return fullMutable;
}

- (void)settLocalMailData:(NSMutableArray *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc] initWithArray:rd copyItems:YES] forKey:@"MailData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self.mainView updateMailBadge];
}

- (void)addLocalMailData:(NSMutableArray *)rd
{
    self.localMailData = [self gettLocalMailData];
    
    if (self.localMailData == nil)
    {
        self.localMailData = [[NSMutableArray alloc] init];
    }
    
    //Check old mails if there is any replies
    for (NSUInteger i = 0; i < [self.localMailData count]; i++)
    {
        NSString *local_mail_id = self.localMailData[i][@"mail_id"];
        
        //Search newly fetched mail for match with local mail
        for (NSUInteger j = 0; j < [rd count]; j++)
        {
            if ([rd[j][@"mail_id"] isEqualToString:local_mail_id]) //Match found
            {
                //Reply counter is not same
                if (![rd[j][@"reply_counter"] isEqualToString:localMailData[i][@"reply_counter"]])
                {
                    self.localMailData[i][@"open_read"] = @"0";
                    self.localMailData[i][@"reply_counter"] = rd[i][@"reply_counter"];
                }
            }
        }
    }
    
    //Add new mails to localMailData
    for (NSInteger i = [rd count]-1; i > -1; i--)
    {
        if ([rd[i][@"mail_id"] intValue] > [[self gettLastMailId] intValue])
        {
            [self.localMailData insertObject:rd[i] atIndex:0];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:localMailData forKey:@"MailData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)gettLastReportId
{
    lastReportId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Reportid"];
    if (lastReportId == nil)
    {
        lastReportId = @"0";
    }
    
    return lastReportId;
}

- (void)settLastReportId:(NSString *)rid
{
    lastReportId = rid;
    [[NSUserDefaults standardUserDefaults] setObject:lastReportId forKey:@"Reportid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)gettLocalReportData
{
    self.localReportData = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"ReportData"];
    if (self.localReportData == nil)
    {
        self.localReportData = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *fullMutable = [[NSMutableArray alloc] init];
    
    for (NSDictionary *obj in localReportData)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:obj copyItems:YES];
        [fullMutable addObject:dic];
    }
    
    return fullMutable;
}

- (void)settLocalReportData:(NSMutableArray *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc] initWithArray:rd copyItems:YES] forKey:@"ReportData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self.mainView updateReportBadge];
}

- (void)addLocalReportData:(NSMutableArray *)rd
{
    if ([self gettLocalReportData] == nil)
    {
        self.localReportData = [[NSMutableArray alloc] init];
    }
    
    [self.localReportData addObjectsFromArray:rd];
    
    [[NSUserDefaults standardUserDefaults] setObject:localReportData forKey:@"ReportData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)gettSelectedWorldData
{
    self.wsWorldData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WorldData"];
    
    return self.wsWorldData;
}

- (void)refreshSelectedWorldData
{
    [self gettSelectedWorldData];
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetWorld/%@",
					   WS_URL, wsWorldData[@"world_id"]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
    
	self.wsWorldData = [[NSMutableDictionary alloc] initWithContentsOfURL:url];
    
    [[NSUserDefaults standardUserDefaults] setObject:wsWorldData forKey:@"WorldData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)settSelectedWorldData:(NSDictionary *)wd
{
    self.wsWorldData = [[NSDictionary alloc] initWithDictionary:wd copyItems:YES];

    [[NSUserDefaults standardUserDefaults] setObject:wsWorldData forKey:@"WorldData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.loginView updateWorldLabel];
}

- (NSString *)gettSelectedBaseId
{
    selectedBaseId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Baseid"];
    if (selectedBaseId == nil)
    {
        selectedBaseId = @"0";
    }
    
    return selectedBaseId;
}

- (void)settSelectedBaseId:(NSString *)bid
{
    selectedBaseId = bid;
    [[NSUserDefaults standardUserDefaults] setObject:selectedBaseId forKey:@"Baseid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)gettPurchasedProduct
{
    purchasedProductString = [[NSUserDefaults standardUserDefaults] objectForKey:@"PurchasedProduct"];
    if (purchasedProductString == nil)
    {
        purchasedProductString = @"0";
    }
    
    return purchasedProductString;
}

- (void)settPurchasedProduct:(NSString *)type
{
    purchasedProductString = type;
    [[NSUserDefaults standardUserDefaults] setObject:purchasedProductString forKey:@"PurchasedProduct"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)gettLoginBonus
{
    loginBonus = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginBonus"];
    if (loginBonus == nil)
    {
        loginBonus = @"0";
    }
    
    return loginBonus;
}

- (void)settLoginBonus:(NSString *)amount
{
    loginBonus = amount;
    [[NSUserDefaults standardUserDefaults] setObject:loginBonus forKey:@"LoginBonus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getDevicetoken
{
    devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"Devicetoken"];
    if (devicetoken == nil)
    {
        devicetoken = @"0";
    }
    
    return devicetoken;
}

- (void)setDevicetoken:(NSString *)dt
{
    devicetoken = dt;
    [[NSUserDefaults standardUserDefaults] setObject:devicetoken forKey:@"Devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLat
{
    latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Latitude"];
    if (latitude == nil)
    {
        latitude = @"0";
    }
    
    return latitude;
}

- (void)setLat:(NSString *)lat
{
    latitude = lat;
    [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLongi
{
    longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Longitude"];
    if (longitude == nil)
    {
        longitude = @"0";
    }
    
    return longitude;
}

- (void)setLongi:(NSString *)longi
{
    longitude = longi;
    [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:@"Longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)xpFromLevel:(int)level
{
    return (level-1)*(level-1)*10;
}

- (int)levelFromXp:(int)xp
{
    return sqrt(xp/10) + 1;
}

- (int)getXp
{
    int xp = [wsWorldClubData[@"xp"] intValue];
    return xp;
}

- (int)getXpMax
{
    return [self xpFromLevel:[self getLevel]+1];
}

- (int)getXpMaxBefore
{
    return [self xpFromLevel:[self getLevel]];
}

- (int)getLevel
{
    return [self levelFromXp:[self getXp]];
}

- (NSString *)intString:(int)val
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
    CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, CFSTR(""), kCFStringEncodingUTF8);
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
    int days = (int)((double)differenceSeconds/(3600.0*24.00));
    int diffDay = differenceSeconds-(days*3600*24);
    int hours = (int)((double)diffDay/3600.00);
    int diffMin = diffDay-(hours*3600);
    int minutes = (int)(diffMin/60.0);
    int seconds = diffMin-(minutes*60);
    
    NSString* countdown = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    
    return countdown;
}

- (void)updateMainView:(NSString *)base_id
{
    [self settSelectedBaseId:base_id];
    [self updateBaseData];
    //[self.mainView updateView];
}

- (void)checkVersion:(UIView *)view
{
    NSInteger count = [self.wsProductIdentifiers count];
    
    if (count == 0) //Have not fetched latest server settings
    {
        [self updateProductIdentifiers];
    }
    
    float latest_version = [wsProductIdentifiers[@"latest_version"] floatValue];
    float this_version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
    
    if (latest_version > this_version)
    {
        [self showDialogBlock:@"New Version Available. Upgrade to latest version?"
                             :2
                             :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.wsProductIdentifiers[@"url_app"]]];
             }
         }];
    }
    
    [UAAppReviewManager setSignificantEventsUntilPrompt:5];
    
    [UAAppReviewManager appLaunched:YES];
    
    // The AppID is the only required setup
	[UAAppReviewManager setAppID:wsProductIdentifiers[@"app_id"]]; // Game
    
    // Debug means that it will popup on the next available change
    //[UAAppReviewManager setDebug:YES];
    
    // YES here means it is ok to show, it is the only override to Debug == YES.
    [UAAppReviewManager userDidSignificantEvent:YES];
    
    //[UAAppReviewManager showPrompt];
}

- (void)updateProductIdentifiers
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/ProductIdentifiers/%@", 
					   WS_URL, GameId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsProductIdentifiers = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (BOOL)updateClubData
{
	if(!workingClub)
	{
		workingClub = YES;
		NSString *wsurl = [NSString stringWithFormat:@"%@/GetClub/%@", 
					   WS_URL, self.UID];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
		
		workingClub = NO;
		
		if([wsResponse count] > 0)
		{
			wsClubData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
			
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"UpdateClubData"
             object:self];
            
            return YES;
		}
		else
		{
			return NO;
		}
	}
	else 
	{
		return NO;
	}
}

- (BOOL)updateWorldClubData
{
	if(!workingWorldClub)
	{
		workingWorldClub = YES;
		NSString *wsurl = [NSString stringWithFormat:@"%@/GetClub/%@/%@",
                           [self world_url], wsClubData[@"club_id"], wsClubData[@"uid"]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
		
		workingWorldClub = NO;
		
		if([wsResponse count] > 0)
		{
			wsWorldClubData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
			return YES;
		}
		else
		{
			return NO;
		}
	}
	else
	{
		return NO;
	}
}

- (void)updateClubInfoData: (NSString *) clubId
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetClubInfo/%@", 
					   WS_URL, clubId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsClubInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (void)updateClubInfoFb: (NSString *)fb_id
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetClubFB/%@", 
					   WS_URL, fb_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	if(wsResponse.count > 0)
	{
		wsClubInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
	}
}

- (void)updateMyAchievementsData
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetAchievements/%@", 
					   [self world_url], wsWorldClubData[@"club_id"]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsMyAchievementsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (void)updateBasesData
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetBases/%@",
					   [self world_url], wsWorldClubData[@"club_id"]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsBasesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (void)updateWorldsData
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetAllWorld",
					   WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsWorldsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (void)updateBaseData
{
    NSString *baseid = @"0";
    
    if ([self.gettSelectedBaseId isEqualToString:@"0"])
    {
        [self updateBasesData];
        wsBaseData = [[NSDictionary alloc] initWithDictionary:wsBasesData[0] copyItems:YES];
        
        baseid = [[Globals i] wsBaseData][@"base_id"];
        [self settSelectedBaseId:baseid];
    }
    else
    {
        baseid = self.gettSelectedBaseId;
        
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetBase/%@/%@",
                           [self world_url], baseid, wsClubData[@"club_id"]];
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
        if (wsResponse.count > 0)
        {
            wsBaseData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
        }
        else
        {
            [self updateBasesData];
            wsBaseData = [[NSDictionary alloc] initWithDictionary:wsBasesData[0] copyItems:YES];
            
            baseid = [[Globals i] wsBaseData][@"base_id"];
            [self settSelectedBaseId:baseid];
        }
        
    }
}

- (NSInteger)getMailBadgeNumber
{
	int count = 0;
	
	if([localMailData count] > 0)
	{
		for(NSDictionary *rowData in localMailData)
		{
			if([rowData[@"open_read"] isEqualToString:@"0"])
			{
                count = count + 1;
			}
		}
	}
	
	return count;
}

- (NSInteger)getReportBadgeNumber
{
	int count = 0;
	
	if([localReportData count] > 0)
	{
		for(NSDictionary *rowData in localReportData)
		{
			if([rowData[@"open_read"] isEqualToString:@"0"])
			{
                count = count + 1;
			}
		}
	}
	
	return count;
}

- (NSString *)getLastChatString
{
    NSString *message;
    
    int i = [wsChatFullData count];
    if (i == 0)
    {
        message = @""; //nothing to display
    }
    else if (i == 1)
    {
        NSDictionary *rowData = wsChatFullData[0];
        message = [NSString stringWithFormat:@"%@: %@",
                             rowData[@"club_name"],
                             rowData[@"message"]];
    }
    else
    {
        NSDictionary *rowData = wsChatFullData[i-2];
        message = [NSString stringWithFormat:@"%@: %@",
                             rowData[@"club_name"],
                             rowData[@"message"]];
        
        rowData = wsChatFullData[i-1];
        message = [NSString stringWithFormat:@"%@\n%@: %@",
                   message,
                   rowData[@"club_name"],
                   rowData[@"message"]];
    }
    
    return message;
}

- (NSString *)getLastChatID
{
    int i = [wsChatFullData count];
    if(i == 0)
    {
        return @"0"; //tells server to fetch most current
    }
    else
    {
        NSDictionary *rowData = wsChatFullData[i-1];
        return rowData[@"chat_id"];
    }
}

- (NSString *)getLastAllianceChatID
{
    int i = [wsAllianceChatFullData count];
    if(i == 0)
    {
        return @"0"; //tells server to fetch most current
    }
    else
    {
        NSDictionary *rowData = wsAllianceChatFullData[i-1];
        return rowData[@"chat_id"];
    }
}

- (void)updateChatData
{
	if(!workingChat)
	{
		workingChat = YES;
        
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetChat/%@",
                           [self world_url], [self getLastChatID]];
        
        [Globals getServer:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 self.wsChatData = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
                 if ([wsChatData count] > 0)
                 {
                     if(wsChatFullData == nil)
                     {
                         wsChatFullData = [[NSMutableArray alloc] initWithArray:wsChatData copyItems:YES];
                     }
                     else
                     {
                         [wsChatFullData addObjectsFromArray:wsChatData];
                     }
                 }
             }
             
             workingChat = NO;
         }];
	}
}

- (void)updateAllianceChatData
{
	if(!workingAllianceChat)
	{
		workingAllianceChat = YES;
        
		NSString *wsurl = [NSString stringWithFormat:@"%@/GetAllianceChat/%@/%@",
                           [self world_url], [self getLastAllianceChatID], wsWorldClubData[@"alliance_id"]];
        
        [Globals getServer:wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 self.wsAllianceChatData = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
                 
                 if ([wsAllianceChatData count] > 0)
                 {
                     if(wsAllianceChatFullData == nil)
                     {
                         wsAllianceChatFullData = [[NSMutableArray alloc] initWithArray:wsAllianceChatData copyItems:YES];
                     }
                     else
                     {
                         [wsAllianceChatFullData addObjectsFromArray:wsAllianceChatData];
                     }
                 }
             }
             
             workingAllianceChat = NO;
         }];
	}
}

- (void)updateReportData
{
	if(!workingReport)
	{
		workingReport = YES;
		NSString *wsurl = [NSString stringWithFormat:@"%@/GetReport/%@/%@/%@",
                           [self world_url],
                           [self gettLastReportId],
                           wsWorldClubData[@"club_id"],
                           wsWorldClubData[@"alliance_id"]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsReportData = [[NSMutableArray alloc] initWithContentsOfURL:url];
        
        if (wsReportData.count > 0)
        {
            [self settLastReportId:(wsReportData)[0][@"report_id"]];
            [self addLocalReportData:wsReportData];
        }
        
		workingReport = NO;
	}
}

- (void)updateMailData //Get all mail from mail_id=0 because need to see if there is reply
{
	if(!workingMail)
	{
		workingMail = YES;
		NSString *wsurl = [NSString stringWithFormat:@"%@/GetMail/0/%@/%@",
                           [self world_url],
                           wsWorldClubData[@"club_id"],
                           wsWorldClubData[@"alliance_id"]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsMailData = [[NSMutableArray alloc] initWithContentsOfURL:url];
        
        if (wsMailData.count > 0)
        {
            [self addLocalMailData:wsMailData];
            [self settLastMailId:(wsMailData)[0][@"mail_id"]];
        }
        
		workingMail = NO;
	}
}

- (void)updateMailReply:(NSString *)mail_id
{
	NSString *wsurl = [NSString stringWithFormat:@"%@/GetMailReply/%@",
                           [self world_url],
                           mail_id];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsMailReply = [[NSMutableArray alloc] initWithContentsOfURL:url];
    
    if (wsMailReply.count > 0)
    {
        [self addMailReply:mail_id :wsMailReply];
    }
}

@end
