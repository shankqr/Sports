//
//  Globals.m
//  FFC
//
//  Created by Shankar on 6/9/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"

@implementation Globals
@synthesize activityIndicator;
@synthesize wsProductIdentifiers;
@synthesize wsClubData;
@synthesize wsClubInfoData;
@synthesize wsSquadData;
@synthesize wsMySquadData;
@synthesize wsMatchData;
@synthesize wsMatchPlayedData;
@synthesize wsMatchHighlightsData;
@synthesize wsChallengesData;
@synthesize wsChallengedData;
@synthesize wsLeagueData;
@synthesize wsMatchFixturesData;
@synthesize wsNewsData;
@synthesize wsChatData;
@synthesize wsChatFullData;
@synthesize wsMarqueeData;
@synthesize wsFriendsData;
@synthesize wsCurrentSeasonData;
@synthesize wsPlayerInfoData;
@synthesize wsMatchInfoData;
@synthesize wsLeagueScorersData;
@synthesize wsPromotionData;
@synthesize wsCupScorersData;
@synthesize wsCupFixturesData;
@synthesize wsAllClubsData;
@synthesize wsWallData;
@synthesize wsEventsData;
@synthesize wsDonationsData;
@synthesize wsAppliedData;
@synthesize wsMembersData;
@synthesize wsAllianceCupFixturesData;
@synthesize wsMapClubsData;
@synthesize wsNearClubsData;
@synthesize wsPlayerSaleData;
@synthesize wsCoachData;
@synthesize wsProductsData;
@synthesize wsTrophyData;
@synthesize wsMyAchievementsData;
@synthesize wsAllianceData;
@synthesize challengeMatchId;
@synthesize selectedPos;
@synthesize selectedPlayer;
@synthesize selectedDivision;
@synthesize selectedSeries;
@synthesize workingUrl;
@synthesize purchasedPlayerId;
@synthesize purchasedCoachId;
@synthesize workingSquad;
@synthesize wsCupRounds;
@synthesize selectedClubId;
@synthesize workingAllClubs;
@synthesize energy;
@synthesize purchasedProductString;
@synthesize offsetServerTimeInterval;
@synthesize loginBonus;
@synthesize acceptedMatch;
@synthesize latitude;
@synthesize longitude;
@synthesize devicetoken;
@synthesize uid;
@synthesize dialogBox;

static Globals *_i;
static NSString *GameId = @"0";


- (id) init
{
	if (self = [super init])
	{
		
	}
	return self;
}

+ (Globals *) i
{
	if (!_i)
	{
		_i = [[Globals alloc] init];
	}
	
	return _i;
}

- (NSString	*) GameId
{
	return GameId;
}

- (NSString	*) UID
{
    uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserUID"];
    
    return uid;
}

- (void)setUID:(NSString *)user_uid
{
    uid = user_uid;
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"UserUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:title
						  message:message
						  delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert show];
}

- (void)showLoadingAlert:(UIView*)view
{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

- (void)removeLoadingAlert:(UIView*)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)createDialogBox
{
    if (dialogBox == NULL)
    {
        dialogBox = [[DialogBoxView2 alloc] initWithNibName:@"DialogBoxView2" bundle:nil];
    }
}

- (void)removeDialogBox
{
	if(dialogBox != NULL)
	{
		[dialogBox.view removeFromSuperview];
	}
}

- (void)showDialog:(UIView *)view :(NSString *)l1 :(NSString *)l2 :(NSString *)l3 :(NSInteger)type :(DialogBlock)block
{
    [self createDialogBox];
    dialogBox.titleText = l1;
    dialogBox.whiteText = l2;
    dialogBox.promptText = l3;
    dialogBox.dialogType = type;
    [view addSubview:dialogBox.view];
    dialogBox.dialogBlock = block;
    [dialogBox updateView];
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

- (double)Random_next:(double)min to:(double)max
{
    return ((double)arc4random() / UINT_MAX) * (max-min) + min;
    //return floorf(((float)arc4random() / ARC4RANDOM_MAX) * max);
}

- (void)scheduleNotification:(NSDate *)fire_date :(NSString *)alert_body
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
        notif.fireDate = fire_date;
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

- (void)presentNotification:(NSString *)alert_body
{
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil)
    {
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
        notif.alertBody = alert_body;
        notif.alertAction = @"Show";
        notif.soundName = UILocalNotificationDefaultSoundName;
        notif.applicationIconBadgeNumber = 1;
		
        NSDictionary *userDict = @{@"key": alert_body};
        notif.userInfo = userDict;
		
        [[UIApplication sharedApplication] presentLocalNotificationNow:notif];
    }
}

- (NSString *)gettPurchasedProduct
{
    purchasedProductString = [[NSUserDefaults standardUserDefaults] objectForKey:@"PurchasedProduct"];
    if (purchasedProductString == Nil)
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
    if (loginBonus == Nil)
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

- (NSString *)gettAccepted
{
    acceptedMatch = [[NSUserDefaults standardUserDefaults] objectForKey:@"AcceptedMatch"];
    if (acceptedMatch == Nil)
    {
        acceptedMatch = @"0";
    }
    
    return acceptedMatch;
}

- (void)settAccepted:(NSString *)match_id
{
    acceptedMatch = match_id;
    [[NSUserDefaults standardUserDefaults] setObject:acceptedMatch forKey:@"AcceptedMatch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getDevicetoken
{
    devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"Devicetoken"];
    if (devicetoken == Nil)
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
    if (latitude == Nil)
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
    if (longitude == Nil)
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
    int xp = [[wsClubData[@"xp"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
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

- (void)setOffsetTime:(NSTimeInterval)serverTime
{
    NSDate *localdatetime = [NSDate date];
    self.offsetServerTimeInterval = [localdatetime timeIntervalSince1970] - serverTime;
}

- (void)storeEnergy
{
    int energy_max = [[wsClubData[@"energy"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
    int energy_togo = energy_max - energy;
    if (energy_togo > 0)
    {
        [self scheduleNotification:[[NSDate date] dateByAddingTimeInterval:energy_togo*180] :@"Your energy is full! Train your players and level up now!"];
    }
}

- (NSInteger)retrieveEnergy
{
	self.energy = [[wsClubData[@"e"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
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
	NSString *player_id = [row_player_id stringByReplacingOccurrencesOfString:@"," withString:@""];
	NSString *name = rowData[@"player_name"];
	NSString *age = rowData[@"player_age"]; 
	cell.playerName.text = [NSString stringWithFormat:@"%@ (Age: %@)", name, age];
	
	NSString *salary = [[Globals i] numberFormat:rowData[@"player_salary"]];
	NSString *mvalue = [[Globals i] numberFormat:rowData[@"player_value"]];
	cell.playerValue.text = [NSString stringWithFormat:@"$%@/week (Value: $%@)", salary, mvalue];
	
	cell.keeper.text = [NSString stringWithFormat:@"%d", [rowData[@"keeper"] intValue]/2];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [cell.pbkeeper setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"keeper"] intValue]/10]]];
    }
    else
    {
        [cell.pbkeeper setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"keeper"] intValue]/10]]];
    }
    
	cell.defending.text = [NSString stringWithFormat:@"%d", [rowData[@"defend"] intValue]/2];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [cell.pbdefending setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"defend"] intValue]/10]]];
    }
    else
    {
        [cell.pbdefending setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"defend"] intValue]/10]]];
    }
    
	cell.playmaking.text = [NSString stringWithFormat:@"%d", [rowData[@"playmaking"] intValue]/2];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [cell.pbplaymaking setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"playmaking"] intValue]/10]]];
    }
    else
    {
        [cell.pbplaymaking setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"playmaking"] intValue]/10]]];
    }
    
	cell.passing.text = [NSString stringWithFormat:@"%d", [rowData[@"passing"] intValue]/2];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [cell.pbpassing setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"passing"] intValue]/10]]];
    }
    else
    {
        [cell.pbpassing setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"passing"] intValue]/10]]];
    }
    
	cell.scoring.text = [NSString stringWithFormat:@"%d", [rowData[@"attack"] intValue]/2];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [cell.pbscoring setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"attack"] intValue]/10]]];
    }
    else
    {
        [cell.pbscoring setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pbar%d.png", [rowData[@"attack"] intValue]/10]]];
    }
    
	cell.stamina.text = [NSString stringWithFormat:@"%d%%", [rowData[@"fitness"] intValue]/2];

    if ([rowData[@"fitness"] intValue] < 80) 
    {
        cell.stamina.textColor = [UIColor redColor];
    }
    else if ([rowData[@"fitness"] intValue] < 150) 
    {
        cell.stamina.textColor = [UIColor yellowColor];
    }
    else
    {
        cell.stamina.textColor = [UIColor greenColor];
    }
	
	cell.card1.backgroundColor = [UIColor clearColor];
	cell.card2.backgroundColor = [UIColor clearColor];
	
	if([rowData[@"card_red"] intValue] == 1)
	{
		cell.card1.backgroundColor = [UIColor redColor];
	}
	else if([rowData[@"card_yellow"] intValue] == 2)
	{
		cell.card1.backgroundColor = [UIColor yellowColor];
		cell.card2.backgroundColor = [UIColor yellowColor];
	}
	else if([rowData[@"card_yellow"] intValue] == 1)
	{
		cell.card1.backgroundColor = [UIColor yellowColor];
	}
	else 
    {
		cell.card1.backgroundColor = [UIColor clearColor];
		cell.card2.backgroundColor = [UIColor clearColor];
	}
	
	switch([rowData[@"player_condition"] intValue])
	{
		case 1:
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [cell.injuredbruisedImage setImage:[UIImage imageNamed:@"bruised.png"]];
            }
            else
            {
                [cell.injuredbruisedImage setImage:[UIImage imageNamed:@"bruised.png"]];
            }
			break;
		case 2:
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [cell.injuredbruisedImage setImage:[UIImage imageNamed:@"injured.png"]];
            }
            else
            {
                [cell.injuredbruisedImage setImage:[UIImage imageNamed:@"injured.png"]];
            }
			break;
		default:
			cell.injuredbruisedImage.image = nil;
			break;
	}
    
    if ([rowData[@"player_condition_days"] intValue] > 0) 
    {
        cell.condition.text = [NSString stringWithFormat:@"%@ Days", rowData[@"player_condition_days"]];
    }
    else
    {
        cell.condition.text = @"";
    }
	
	int pid = [player_id intValue];
	int f = (pid % 12) + 1;
	NSString *fname = [NSString stringWithFormat:@"s%d.png", f];
	[cell.faceImage setImage:[UIImage imageNamed:fname]];
	
	int g = [rowData[@"player_goals"] intValue];
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
        if([wsClubData[@"gk"] isEqualToString:row_player_id])
            cell.position.text = @"(GK)";
        else if([wsClubData[@"rb"] isEqualToString:row_player_id])
            cell.position.text = @"(DR)";
        else if([wsClubData[@"lb"] isEqualToString:row_player_id])
            cell.position.text = @"(DL)";
        else if([wsClubData[@"rw"] isEqualToString:row_player_id])
            cell.position.text = @"(MR)";
        else if([wsClubData[@"lw"] isEqualToString:row_player_id])
            cell.position.text = @"(ML)";
        else if([wsClubData[@"cd1"] isEqualToString:row_player_id])
            cell.position.text = @"(DC1)";
        else if([wsClubData[@"cd2"] isEqualToString:row_player_id])
            cell.position.text = @"(DC2)";
        else if([wsClubData[@"cd3"] isEqualToString:row_player_id])
            cell.position.text = @"(DC3)";
        else if([wsClubData[@"im1"] isEqualToString:row_player_id])
            cell.position.text = @"(MC1)";
        else if([wsClubData[@"im2"] isEqualToString:row_player_id])
            cell.position.text = @"(MC2)";
        else if([wsClubData[@"im3"] isEqualToString:row_player_id])
            cell.position.text = @"(MC3)";
        else if([wsClubData[@"fw1"] isEqualToString:row_player_id])
            cell.position.text = @"(SC1)";
        else if([wsClubData[@"fw2"] isEqualToString:row_player_id])
            cell.position.text = @"(SC2)";
        else if([wsClubData[@"fw3"] isEqualToString:row_player_id])
            cell.position.text = @"(SC3)";
        else if([wsClubData[@"sgk"] isEqualToString:row_player_id])
            cell.position.text = @"(Sub.GK)";
        else if([wsClubData[@"sd"] isEqualToString:row_player_id])
            cell.position.text = @"(Sub.DCLR)";
        else if([wsClubData[@"sim"] isEqualToString:row_player_id])
            cell.position.text = @"(Sub.MC)";
        else if([wsClubData[@"sfw"] isEqualToString:row_player_id])
            cell.position.text = @"(Sub.SC)";
        else if([wsClubData[@"sw"] isEqualToString:row_player_id])
            cell.position.text = @"(Sub.MLR)";
        else
        {
            cell.position.text = @" ";
        }
	}
	else
	{
		cell.position.text = rowData[@"position"];
	}
	
	return cell;
}

- (UIButton *)buttonWithTitle:(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
{	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];	
	if (darkTextColor)
	{
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	else
	{
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}


- (NSString *) BoolToBit: (NSString *)boolString
{
	if([boolString isEqualToString:@"True"])
		return @"1";
	else
		return @"0";
}

+ (NSString *)urlEncode:(NSString *)str
{
	NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;=\""), kCFStringEncodingUTF8));
	return result;
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)buyProduct:(NSString *)productId :(NSString *)isVirtualMoney :(NSString *)json
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/BuyProductNew/%@/%@/%@/%@", 
					   WS_URL, isVirtualMoney, productId, self.UID, json];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
}

- (void) importFacebook:(NSString *) fb_uid
					   :(NSString *) fb_name
					   :(NSString *) fb_pic
					   :(NSString *) fb_sex
					   :(NSString *) fb_email
{
	NSString *pic = [self urlEnc:fb_pic];
	NSString *nm = [self urlEnc:fb_name];
	NSString *mail = [self urlEnc:fb_email];
	
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ImportFacebook/%@/%@/%@/%@/%@/%@", 
					   WS_URL, self.UID, fb_uid, nm, pic, fb_sex, mail];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
	
}

- (void) changeTraining: (NSString *) trainingId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangeTraining/%@/%@", 
					   WS_URL, self.UID, trainingId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
	[self updateClubData];
}

- (void) changeFormation: (NSString *) formationId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangeFormation/%@/%@", 
					   WS_URL, self.UID, formationId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
	[self updateClubData];
}

- (void) changeTactic: (NSString *) tacticId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangeTactic/%@/%@", 
					   WS_URL, self.UID, tacticId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
	[self updateClubData];
}

- (void)changePlayerFormation:(NSString *)player_id :(NSString *)formation_pos
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ChangePlayerFormation/%@/%@/%@", 
					   WS_URL, self.UID, player_id, formation_pos];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
	[self updateClubData];
}

- (void)challengeClub:(NSString *)home :(NSString *)away :(NSString *)win :(NSString *)lose :(NSString *)draw :(NSString *)note
{
	NSString *encodedNote = [self urlEnc:note];
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/CreateChallenge/%@/%@/%@/%@/%@/%@", 
					   WS_URL, self.UID, away, win, lose, draw, encodedNote];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
}

- (NSString *) doChat:(NSString *)message
{
	NSString *encodedMessage = [self urlEnc:message];
    NSString *encodedClubName = [self urlEnc:wsClubData[@"club_name"]];
    NSString *club_id = [wsClubData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/DoChat/%@/%@/%@", 
                       WS_URL, club_id, encodedClubName, encodedMessage];
    
    return [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:wsurl] encoding:NSASCIIStringEncoding error:NULL];
}

- (NSString *) doPost:(NSString *)message
{
	NSString *encodedMessage = [self urlEnc:message];
    NSString *encodedClubName = [self urlEnc:wsClubData[@"club_name"]];
    NSString *club_id = [wsClubData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *a_id = [wsClubData[@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AlliancePost/%@/%@/%@/%@",
                       WS_URL, a_id, club_id, encodedClubName, encodedMessage];
    
    return [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:wsurl] encoding:NSASCIIStringEncoding error:NULL];
}

- (NSString *)doBid:(NSString *)player_id :(NSString *)value
{
	NSString *encodedValue = [self urlEnc:value];
    NSString *encodedClubName = [self urlEnc:wsClubData[@"club_name"]];
    NSString *club_id = [wsClubData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/DoBid/%@/%@/%@/%@/%@", 
                       WS_URL, self.UID, club_id, encodedClubName, player_id, encodedValue];
    
    return [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:wsurl] encoding:NSASCIIStringEncoding error:NULL];
}

- (void) challengeAccept: (NSString *) match_id
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
}

- (void) healPlayer: (NSString *) player_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/HealPlayer/%@/%@", 
					   WS_URL, self.UID, player_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
}

- (void) energizePlayer: (NSString *) player_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/EnergizePlayer/%@/%@", 
					   WS_URL, self.UID, player_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
}

- (void) buyCoach: (NSString *) coach_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/BuyCoachs/%@/%@", 
					   WS_URL, self.UID, coach_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
}

- (void) resetClub
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ResetClub/%@", 
					   WS_URL, self.UID];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	[NSArray arrayWithContentsOfURL:url];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updateCurrentSeasonData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetCurrentSeason",
					   WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsCurrentSeasonData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *) getCurrentSeasonData
{
	return wsCurrentSeasonData;
}

- (void) updateProductIdentifiers
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/ProductIdentifiers/%@", 
					   WS_URL, GameId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsProductIdentifiers = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *) getProductIdentifiers
{
	return wsProductIdentifiers;
}

- (BOOL)updateClubData
{
	if(!workingClub)
	{
		workingClub = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetClub/%@", 
					   WS_URL, self.UID];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
		
		workingClub = NO;
		
		if([wsResponse count] > 0)
		{
			wsClubData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
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

- (NSDictionary *) getClubData
{
	return wsClubData;
}

- (void) updateClubInfoData: (NSString *) clubId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetClubInfo/%@", 
					   WS_URL, clubId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsClubInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (void) updateClubInfoFb: (NSString *)fb_id
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetClubFB/%@", 
					   WS_URL, fb_id];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	if(wsResponse.count > 0)
	{
		wsClubInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
	}
}

- (NSDictionary *) getClubInfoData
{
	return wsClubInfoData;
}

- (void) updateAllClubsData
{
	if(!workingAllClubs)
	{
		workingAllClubs = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetClubsSearch", WS_URL];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsAllClubsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingAllClubs = NO;
	}
}

- (NSMutableArray *) getAllClubsData
{
	return wsAllClubsData;
}

- (void) updateMapClubsData
{
	if(!workingMapClubs)
	{
		workingMapClubs = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetClubs", WS_URL];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsMapClubsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingMapClubs = NO;
	}
}

- (NSMutableArray *) getMapClubsData
{
	return wsMapClubsData;
}

- (void) updateSquadData: (NSString *) clubId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayers/%@", 
						   WS_URL, clubId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsSquadData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *) getSquadData
{
	return wsSquadData;
}

- (void) updateMySquadData
{
	workingSquad = 1;
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayers/%@", 
					   WS_URL, [wsClubData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsMySquadData = [[NSMutableArray alloc] initWithContentsOfURL:url];
	workingSquad = 0;
}

- (NSMutableArray *) getMySquadData
{
	return wsMySquadData;
}

- (void) updateMyAchievementsData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAchievements/%@", 
					   WS_URL, [wsClubData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsMyAchievementsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *) getMyAchievementsData
{
	return wsMyAchievementsData;
}

- (void) updateAllianceData
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAlliance",
					   WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsAllianceData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *) getAllianceData
{
	return wsAllianceData;
}

- (NSInteger)getAchievementsBadge
{
	int count = 0;
	
	if([wsMyAchievementsData count] > 0)
	{
		for(NSDictionary *rowData in wsMyAchievementsData)
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

- (void) updateProducts
{
	if(!workingProducts)
	{
		workingProducts = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetProducts", WS_URL];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsProductsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingProducts = NO;
	}
}

- (NSMutableArray *) getProducts
{
	return wsProductsData;
}

- (void) updatePlayerSaleData
{
	if(!workingPlayerSale)
	{
		workingPlayerSale = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayersBid", WS_URL];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsPlayerSaleData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingPlayerSale = NO;
	}
}

- (NSMutableArray *) getPlayerSaleData
{
	return wsPlayerSaleData;
}

- (void) updateCoachData
{
	if(!workingCoach)
	{
		workingCoach = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetCoaches", WS_URL];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsCoachData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingCoach = NO;
	}
}

- (NSMutableArray *) getCoachData
{
	return wsCoachData;
}

- (void) updatePlayerInfoData: (NSString *) playerId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetPlayerInfo/%@", 
					   WS_URL, playerId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsPlayerInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *) getPlayerInfoData
{
	return wsPlayerInfoData;
}

- (void) updateMatchInfoData: (NSString *) matchId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchInfo/%@", 
					   WS_URL, matchId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsMatchInfoData = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *) getMatchInfoData
{
	return wsMatchInfoData;
}

- (void) updateMatchData
{
	if(!workingMatchFuture)
	{
		workingMatchFuture = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchUpcomings/%@", 
					   WS_URL, self.UID];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsMatchData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingMatchFuture = NO;
	}
}

- (NSMutableArray *) getMatchData
{
	return wsMatchData;
}

- (void) updateMatchPlayedData
{
	if(!workingMatchPlayed)
	{
		workingMatchPlayed = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchPlayeds/%@", 
					   WS_URL, self.UID];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsMatchPlayedData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingMatchPlayed = NO;
	}
}

- (NSMutableArray *) getMatchPlayedData
{
	return wsMatchPlayedData;
}

- (void) updateMatchHighlightsData: (NSString *) matchId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchHighlights/%@", 
					   WS_URL, matchId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsMatchHighlightsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *) getMatchHighlightsData
{
	return wsMatchHighlightsData;
}

- (void) updateChallengesData
{
	if(!workingChallenges)
	{
		workingChallenges = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetChallenge/%@", 
					   WS_URL, self.UID];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsChallengesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingChallenges = NO;
	}
}

- (NSMutableArray *) getChallengesData
{
	return wsChallengesData;
}

- (void) updateChallengedData
{
	if(!workingChallenged)
	{
		workingChallenged = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetChallengeds/%@", 
					   WS_URL, self.UID];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsChallengedData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingChallenged = NO;
	}
}

- (NSMutableArray *) getChallengedData
{
	return wsChallengedData;
}

- (void) updateLeagueData: (NSString *) division : (NSString *) series
{
	if(!workingLeague)
	{
		workingLeague = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetSeries/%@/%@", 
					   WS_URL, division, series];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsLeagueData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingLeague = NO;
	}
}

- (NSMutableArray *) getLeagueData
{
	return wsLeagueData;
}

- (void) updatePromotionData: (NSString *) division
{
	if(!workingPromotion)
	{
		workingPromotion = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetLeaguePromotion/%@", 
					   WS_URL, division];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsPromotionData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingPromotion = NO;
	}
}

- (NSMutableArray *) getPromotionData
{
	return wsPromotionData;
}

- (void) updateLeagueScorersData: (NSString *) division : (NSString *) top
{
	if(!workingLeagueScorers)
	{
		workingLeagueScorers = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetLeagueTopScorers/%@/%@", 
					   WS_URL, division, top];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsLeagueScorersData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingLeagueScorers = NO;
	}
}

- (NSMutableArray *) getLeagueScorersData
{
	return wsLeagueScorersData;
}

- (void) updateMatchFixturesData: (NSString *) division : (NSString *) series
{
	if(!workingLeagueFixtures)
	{
		workingLeagueFixtures = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMatchFixtures/%@/%@", 
					   WS_URL, division, series];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsMatchFixturesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingLeagueFixtures = NO;
	}
}

- (NSMutableArray *) getMatchFixturesData
{
	return wsMatchFixturesData;
}

- (void) updateCupRounds
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetCupRounds", WS_URL];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
	wsCupRounds = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
}

- (NSDictionary *) getCupRounds
{
	return wsCupRounds;
}

- (void) updateCupFixturesData:(NSString *)round
{
	if(!workingCupFixtures)
	{
		workingCupFixtures = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetCupFixtures/%@",
						   WS_URL, round];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsCupFixturesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingCupFixtures = NO;
	}
}

- (NSMutableArray *) getCupFixturesData
{
	return wsCupFixturesData;
}

- (void) updateAllianceCupFixturesData:(NSString *)round
{
	if(!workingAllianceCupFixtures)
	{
		workingAllianceCupFixtures = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceCupFixtures/%@/%@", 
						   WS_URL, [wsClubData[@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""], round];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsAllianceCupFixturesData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingAllianceCupFixtures = NO;
	}
}

- (NSMutableArray *) getAllianceCupFixturesData
{
	return wsAllianceCupFixturesData;
}

- (void) updateCupScorersData: (NSString *) top
{
	if(!workingCupScorers)
	{
		workingCupScorers = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetCupTopScorers/%@", 
					   WS_URL, top];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsCupScorersData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingCupScorers = NO;
	}
}

- (NSMutableArray *) getCupScorersData
{
	return wsCupScorersData;
}

- (void) updateTrophyData: (NSString *) clubId
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetTrophy/%@", 
					   WS_URL, clubId];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsTrophyData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *) getTrophyData
{
	return wsTrophyData;
}

- (NSString *) getLast1Chat
{
    int i = [wsChatFullData count];
    if (i==0)
    {
        return @"0"; //tells server to fetch most current
    }
    else
    {
        NSDictionary *rowData = wsChatFullData[i-1];
        NSString *message = [NSString stringWithFormat:@" [%@]: %@", 
                             rowData[@"club_name"],
                             rowData[@"message"]];
        return message;
    }
}

- (NSString *) getLast2Chat
{
    int i = [wsChatFullData count];
    if (i<2)
    {
        return @"0"; //tells server to fetch most current
    }
    else
    {
        NSDictionary *rowData = wsChatFullData[i-2];
        NSString *message = [NSString stringWithFormat:@" [%@]: %@", 
                             rowData[@"club_name"],
                             rowData[@"message"]];
        rowData = wsChatFullData[i-1];
        message = [NSString stringWithFormat:@"%@ \n [%@]: %@", 
                   message,
                   rowData[@"club_name"],
                   rowData[@"message"]];
        return message;
    }
}

- (NSString *) getLast3Chat
{
    int i = [wsChatFullData count];
    if (i<3)
    {
        return @"0"; //tells server to fetch most current
    }
    else
    {
        NSDictionary *rowData = wsChatFullData[i-3];
        NSString *message = [NSString stringWithFormat:@" [%@]: %@", 
                             rowData[@"club_name"],
                             rowData[@"message"]];
        rowData = wsChatFullData[i-2];
        message = [NSString stringWithFormat:@"%@ \n [%@]: %@", 
                   message,
                   rowData[@"club_name"],
                   rowData[@"message"]];
        rowData = wsChatFullData[i-1];
        message = [NSString stringWithFormat:@"%@ \n [%@]: %@", 
                   message,
                   rowData[@"club_name"],
                   rowData[@"message"]];
        return message;
    }
}

- (NSString *) getLastChatID
{
    int i = [wsChatFullData count];
    if(i == 0)
    {
        return @"0"; //tells server to fetch most current
    }
    else
    {
        NSDictionary *rowData = wsChatFullData[i-1];
        return [rowData[@"chat_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
}

- (void) updateChatData
{
	if(!workingChat)
	{
		workingChat = YES;
        
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetChat/%@/%@/%@/%@/%@", 
                           WS_URL, [self getLastChatID], [wsClubData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""], wsClubData[@"division"], wsClubData[@"series"], [self BoolToBit:wsClubData[@"playing_cup"]]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsChatData = [[NSMutableArray alloc] initWithContentsOfURL:url];
        
        if(wsChatFullData == nil)
        {
            wsChatFullData = [[NSMutableArray alloc] initWithArray:wsChatData copyItems:YES];
        }
        else
        {
            [wsChatFullData addObjectsFromArray:wsChatData];
        }
        
        
		workingChat = NO;
	}
}

- (NSMutableArray *) getChatData
{
	return wsChatData;
}

- (void) updateNewsData: (NSString *) division : (NSString *) series : (NSString *) playing_cup
{
	if(!workingNews)
	{
		workingNews = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetNews/%@/%@/%@/%@", 
					 WS_URL, [wsClubData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""], division, series, playing_cup];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsNewsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingNews = NO;
	}
}

- (NSMutableArray *) getNewsData
{
	return wsNewsData;
}

- (void) updateWallData
{
	if(!workingWall)
	{
		workingWall = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceWall/%@",
                           WS_URL, [wsClubData[@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsWallData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingWall = NO;
	}
}

- (NSMutableArray *) getWallData
{
	return wsWallData;
}

- (void) updateEventsData
{
	if(!workingEvents)
	{
		workingEvents = YES;
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceEvents/%@",
                           WS_URL, [wsClubData[@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
		NSURL *url = [[NSURL alloc] initWithString:wsurl];
		wsEventsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
		workingEvents = NO;
	}
}

- (NSMutableArray *) getEventsData
{
	return wsEventsData;
}

- (void) updateDonationsData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceDonations/%@",
                           WS_URL, [wsClubData[@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsDonationsData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *) getDonationsData
{
	return wsDonationsData;
}

- (void) updateAppliedData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceApply/%@",
                       WS_URL, [wsClubData[@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsAppliedData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *) getAppliedData
{
	return wsAppliedData;
}

- (void) updateMembersData
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetAllianceMembers/%@",
                       WS_URL, [wsClubData[@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    wsMembersData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *) getMembersData
{
	return wsMembersData;
}

- (void) updateMarqueeData: (NSString *) division : (NSString *) series : (NSString *) playing_cup
{
	NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetMarquee/%@/%@/%@/%@", 
					 WS_URL, [wsClubData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""], division, series, playing_cup];
	NSURL *url = [[NSURL alloc] initWithString:wsurl];
	wsMarqueeData = [[NSMutableArray alloc] initWithContentsOfURL:url];
}

- (NSMutableArray *) getMarqueeData
{
	return wsMarqueeData;
}

@end
