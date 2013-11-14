//
//  Globals.h
//  FFC
//
//  Created by Shankar on 6/9/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//
#define TACTICS_TOTAL 9
#define ARC4RANDOM_MAX 0x100000000LL
#define iPad    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define STAR_FULL (iPad ? @"star.png" : @"star.png")
#define STAR_HALF (iPad ? @"halfstar.png" : @"halfstar.png")
#define SCREEN_WIDTH (iPad ? 768.0f : 320.0f)
#define SCREEN_WIDTH_HALF (iPad ? 384.0f : 160.0f)
#define DetailTableViewController_font (iPad ? 36.0f : 15.0f)
#define DetailTableViewController_cellheight (iPad ? 150.0f : 68.0f)
#define DetailTableViewController_cellpadding (iPad ? 50.0f : 16.0f)
#define HeaderJobsView_height (iPad ? 277.0f : 120.0f)
#define HeaderSquadSelect_height (iPad ? 75.0f : 50.0f)
#define HeaderSquad_height (iPad ? 180.0f : 75.0f)
#define HeaderNews_height (iPad ? 180.0f : 75.0f)
#define HeaderStaff_height (iPad ? 180.0f : 100.0f)
#define HeaderFinance_height (iPad ? 268.0f : 118.0f)
#define HeaderBuy_height (iPad ? 150.0f : 75.0f)
#define Header_height (iPad ? 180.0f : 75.0f)
#define Footer_height (iPad ? 200.0f : 90.0f)
#define Footer_titlewidth (iPad ? 730.0f : 280.0f)
#define Footer_titleheight (iPad ? 120.0f : 80.0f)
#define Footer_msg_y (iPad ? 45.0f : 5.0f)
#define Webfooter_y (iPad ? 1370.0f : 780.0f)
#define Maintable_height (iPad ? 1460.0f : 905.0f)
#define SLIDE_x (iPad ? 64.0f : 0.0f)
#define SLIDE_y (iPad ? 30.0f : 5.0f)
#define SLIDE_width (iPad ? 640.0f : 320.0f)
#define SLIDE_height (iPad ? 320.0f : 160.0f)
#define BUTTON_LOGIN_x1 (iPad ? 264.0f : 100.0f)
#define BUTTON_LOGIN_y1 (iPad ? 900.0f : 360.0f)
#define BUTTON_x0 (iPad ? 3.0f : 0.0f)
#define BUTTON_x1 (iPad ? 125.0f : 0.0f)
#define BUTTON_x2 (iPad ? 255.0f : 65.0f)
#define BUTTON_x3 (iPad ? 385.0f : 129.0f)
#define BUTTON_x4 (iPad ? 515.0f : 193.0f)
#define BUTTON_x5 (iPad ? 643.0f : 257.0f)
#define BUTTON_y1 (iPad ? 470.0f : 240.0f)
#define BUTTON_y2 (iPad ? 460.0f : 240.0f)
#define BUTTON_y3 (iPad ? 620.0f : 316.0f)
#define BUTTON_y4 (iPad ? 780.0f : 392.0f)
#define BUTTON_y5 (iPad ? 940.0f : 392.0f)
#define BUTTON_y6 (iPad ? 1100.0f : 392.0f)
#define BUTTON_width (iPad ? 124.0f : 59.0f)
#define BUTTON_height (iPad ? 150.0f : 75.0f)
#define BACK_y (iPad ? 944.0f : 440.0f)
#define Marquee_height (iPad ? 40.0f : 15.0f)
#define Marquee_font (iPad ? 36.0f : 16.0f)
#define Chat_y (iPad ? 180.0f : 125.0f)
#define Chat_height (iPad ? 140.0f : 60.0f)
#define Chat_font (iPad ? 36.0f : 15.0f)
#define Banner_y (iPad ? 320.0f : 75.0f)
#define Animation_x1 159*SCALE_IPAD
#define Animation_y1 180*SCALE_IPAD
#define JobButton_x (iPad ? 568.0f : 238.0f)
#define JobButton_y (iPad ? 116.0f : 55.0f)
#define JobButton_width (iPad ? 150.0f : 74.0f)
#define JobButton_height (iPad ? 150.0f : 76.0f)
#define MatchView_frame_x (iPad ? 545.0f : 210.0f)
#define MatchView_frame_width (iPad ? 110.0f : 50.0f)
#define MatchView_frame1_x (iPad ? 110.0f : 50.0f)
#define MatchView_frame1_y (iPad ? 4.0f : 1.0f)
#define MatchView_frame2_x (iPad ? 110.0f : 50.0f)
#define MatchView_frame2_width (iPad ? 430.0f : 160.0f)
#define LeagueView_cellheight (iPad ? 56.0f : 25.0f)
#define TacticsView_frame_offset (iPad ? 150.0f : 47.0f)
#define TacticsView_frame_y (iPad ? 100.0f : 15.0f)
#define Subs_x1 (iPad ? 324.0f : 130.0f)
#define Subs_x2 (iPad ? 70.0f : 10.0f)
#define Subs_x3 (iPad ? 230.0f : 90.0f)
#define Subs_x4 (iPad ? 400.0f : 170.0f)
#define Subs_x5 (iPad ? 560.0f : 250.0f)
#define Subs_y1 (iPad ? 630.0f : 265.0f)
#define Subs_y2 (iPad ? 780.0f : 340.0f)
#define Subs_y3 (iPad ? 380.0f : 150.0f)
#define Pos_y1 (iPad ? 310.0f : 95.0f)
#define Pos_y2 (iPad ? 460.0f : 170.0f)
#define Pos_y3 (iPad ? 610.0f : 245.0f)
#define Pos_y4 (iPad ? 760.0f : 320.0f)
#define Pos_x1 (iPad ? 164.0f : 50.0f)
#define Pos_x2 (iPad ? 484.0f : 210.0f)
#define Pos_x3 (iPad ? 10.0f : 2.0f)
#define Pos_x4 (iPad ? 164.0f : 66.0f)
#define Pos_x5 (iPad ? 484.0f : 194.0f)
#define Pos_x6 (iPad ? 640.0f : 258.0f)
#define BID_CEILING (iPad ? 381.0f : 191.0f)
#define BID_BUTTON_WIDTH (iPad ? 144.0f : 72.0f)
#define SCALE_IPAD (iPad ? 2.0f : 1.0f)
#define GAME_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define PBAR_SMALL (iPad ? 20.0f : 10.0f)
#define PBAR_BIG (iPad ? 120.0f : 60.0f)
#define PBAR1_X (iPad ? 45.0f : 20.0f)
#define PBAR1_Y (iPad ? 80.0f : 35.0f)
#define PBAR2_X (iPad ? 135.0f : 52.0f)
#define PBAR2_Y (iPad ? 545.0f : 243.0f)
#define PBAR3_X (iPad ? 820.0f : 367.0f)
#define PBAR3_Y (iPad ? 160.0f : 95.0f)
#define POSX_DECREASE (iPad ? 48.0f : 4.0f)
#define ARRAY_FLAGS [NSArray arrayWithObjects: @" ", @"Afghanistan", @"Aland Islands", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Anguilla", @"Antarctica", @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Aruba", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize", @"Benin", @"Bermuda", @"Bhutan", @"BIOT", @"Bolivia", @"Bosnian", @"Botswana", @"Bouvet Island", @"Brazil", @"British Antarctic Territory", @"British Virgin Islands", @"Brunei", @"Bulgaria", @"Burkina Faso", @"Burma", @"Burundi", @"Cambodia", @"Cameroon", @"Canada", @"Cape Verde", @"Cayman Islands", @"CentralAfricanRepublic", @"Chad", @"Chile", @"China", @"Christmas Island", @"Cocos Islands", @"Colombia", @"Comoros", @"Congo", @"Congo Kinshasa", @"Cook Islands", @"Costa Rica", @"Croatian", @"Cuba", @"Cyprus", @"Czech Republic", @"Denmark", @"Djibouti", @"Dominican Republic", @"Dominicana", @"East Timor", @"Ecuador", @"Egypt", @"El Salvador", @"England", @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia", @"European Union", @"Ex Yugoslavia", @"Falkland Islands", @"Faroe Islands", @"Fiji", @"Finland", @"France", @"French Polynesia", @"French Southern Territories", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Gibraltar", @"Greece", @"Greenland", @"Grenada", @"Guadeloupe", @"Guam", @"Guatemala", @"Guernsey", @"Guinea Bissau", @"Guinea", @"Guyana", @"Haiti", @"Holy see", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran", @"Iraq", @"Ireland", @"Isle of Man", @"Israel", @"Italy", @"Ivory Coast", @"Jamaica", @"Jan Mayen", @"Japan", @"Jarvis Island", @"Jersey", @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati", @"Korea", @"Kosovo", @"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia", @"Lebanon", @"Lesotho", @"Liberia", @"Libya", @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macau", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia", @"Maldives", @"Mali", @"Malta", @"Marshall Islands", @"Martinique", @"Mauritania", @"Mauritius", @"Mayotte", @"Mexico", @"Micronesia", @"Moldova", @"Monaco", @"Mongolia", @"Montenegro", @"Montserrat", @"Morocco", @"Mozambique", @"Myanmar", @"Namibia", @"Nauru", @"Nepal", @"Netherlands Antilles", @"Netherlands", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Niue", @"Norfolk Island", @"North Korea", @"Northern Ireland", @"Northern Mariana Islands", @"Norway", @"Oman", @"Pakistan", @"Palau", @"Palestinian Territory", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Pitcairn", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Reunion", @"Romania", @"Russia", @"Rwanda", @"Saint Pierre and Miquelon", @"Saint Vincent and the Grenadines", @"Saint Barthelemy", @"Saint Helena Dependencies", @"Saint Helena", @"Saint Kitts and Nevis", @"Saint Lucia", @"Saint Martin", @"Samoa", @"San Marino", @"Sao Tome and Principe", @"Saudi Arabia", @"Scotland", @"Senegal", @"Serbia", @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"SMOM", @"Solomon Islands", @"Somalia", @"South Africa", @"South Georgia", @"Spain", @"SPM", @"Sri Lanka", @"Sudan", @"Suriname", @"Svalbard", @"SVG", @"Swaziland", @"Sweden", @"Switzerland", @"Syria", @"Taiwan", @"Tajikistan", @"Tanzania", @"Thailand", @"Timor Leste", @"Togo", @"Tokelau", @"Tonga", @"Trinidad and Tobago", @"Tunisia", @"Turkey", @"Turkmenistan", @"Turks and Caicos Islands", @"Tuvalu", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Vatican City", @"Venezuela", @"Vietnam", @"Virgin Islands", @"Wales", @"Wallis and Futuna", @"Western Sahara", @"Yemen", @"Zambia", @"Zimbabwe", nil]
#define CORE_URL @"http://football.tapfantasy.com"
#define WS_URL CORE_URL "/football"
#define SPORTS_TYPE @"football"

#define DEFAULT_FONT @"Febrotesk 4F Unicase Bold"
#define DEFAULT_FONT_SIZE 18.0f * SCALE_IPAD
#define DEFAULT_FONT_SMALL_SIZE 14.0f * SCALE_IPAD
#define DEFAULT_FONT_BIG_SIZE 20.0f * SCALE_IPAD

#import "PlayerCell.h"
#import "MBProgressHUD.h"
#import "DialogBoxView2.h"

@interface Globals : NSObject 
{
    DialogBoxView2 *dialogBox;
	UIActivityIndicatorView *activityIndicator;
	NSDictionary *wsProductIdentifiers;
	NSDictionary *wsClubData;
	NSDictionary *wsClubInfoData;
	NSDictionary *wsCurrentSeasonData;
	NSDictionary *wsPlayerInfoData;
	NSDictionary *wsMatchInfoData;
	NSDictionary *wsCupRounds;
	NSMutableArray *wsSquadData;
	NSMutableArray *wsMySquadData;
	NSMutableArray *wsMatchData;
	NSMutableArray *wsMatchPlayedData;
	NSMutableArray *wsChallengesData;
	NSMutableArray *wsChallengedData;
	NSMutableArray *wsMatchHighlightsData;
	NSMutableArray *wsLeagueData;
	NSMutableArray *wsMatchFixturesData;
	NSMutableArray *wsNewsData;
    NSMutableArray *wsChatData;
    NSMutableArray *wsChatFullData;
	NSMutableArray *wsMarqueeData;
	NSMutableArray *wsFriendsData;
	NSMutableArray *wsLeagueScorersData;
	NSMutableArray *wsPromotionData;
	NSMutableArray *wsCupScorersData;
	NSMutableArray *wsCupFixturesData;
	NSMutableArray *wsAllClubsData;
	NSMutableArray *wsMapClubsData;
	NSMutableArray *wsNearClubsData;
	NSMutableArray *wsPlayerSaleData;
	NSMutableArray *wsCoachData;
	NSMutableArray *wsProductsData;
	NSMutableArray *wsTrophyData;
    NSMutableArray *wsMyAchievementsData;
    NSMutableArray *wsAllianceData;
    NSMutableArray *wsWallData;
    NSMutableArray *wsEventsData;
    NSMutableArray *wsDonationsData;
    NSMutableArray *wsAppliedData;
    NSMutableArray *wsMembersData;
    NSMutableArray *wsAllianceCupFixturesData;
	NSString *challengeMatchId;
	NSString *selectedPlayer;
	NSString *selectedPos;
	NSString *workingUrl;
	NSString *purchasedPlayerId;
	NSString *purchasedCoachId;
	NSString *selectedClubId;
	NSInteger selectedDivision;
	NSInteger selectedSeries;
	NSInteger workingSquad;
	NSInteger energy;
    NSString *purchasedProductString;
    NSString *loginBonus;
    NSString *acceptedMatch;
    NSString *latitude;
    NSString *longitude;
    NSString *devicetoken;
    NSString *uid;
    NSTimeInterval offsetServerTimeInterval;
	BOOL workingClub;
	BOOL workingAllClubs;
	BOOL workingMapClubs;
	BOOL workingNews;
    BOOL workingWall;
    BOOL workingEvents;
    BOOL workingChat;
	BOOL workingProducts;
	BOOL workingPlayerSale;
	BOOL workingCoach;
	BOOL workingMatchFuture;
	BOOL workingMatchPlayed;
	BOOL workingChallenges;
	BOOL workingChallenged;
	BOOL workingLeague;
	BOOL workingPromotion;
	BOOL workingLeagueScorers;
	BOOL workingLeagueFixtures;
	BOOL workingCupFixtures;
	BOOL workingCupScorers;
    BOOL workingAllianceCupFixtures;
}
@property (nonatomic, strong) DialogBoxView2 *dialogBox;
@property (nonatomic, strong) NSString *purchasedProductString;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSDictionary *wsProductIdentifiers;
@property (nonatomic, strong) NSDictionary *wsClubData;
@property (nonatomic, strong) NSDictionary *wsClubInfoData;
@property (nonatomic, strong) NSDictionary *wsCurrentSeasonData;
@property (nonatomic, strong) NSDictionary *wsPlayerInfoData;
@property (nonatomic, strong) NSDictionary *wsMatchInfoData;
@property (nonatomic, strong) NSDictionary *wsCupRounds;
@property (nonatomic, strong) NSMutableArray *wsSquadData;
@property (nonatomic, strong) NSMutableArray *wsMySquadData;
@property (nonatomic, strong) NSMutableArray *wsMatchData;
@property (nonatomic, strong) NSMutableArray *wsMatchPlayedData;
@property (nonatomic, strong) NSMutableArray *wsChallengesData;
@property (nonatomic, strong) NSMutableArray *wsChallengedData;
@property (nonatomic, strong) NSMutableArray *wsMatchHighlightsData;
@property (nonatomic, strong) NSMutableArray *wsLeagueData;
@property (nonatomic, strong) NSMutableArray *wsMatchFixturesData;
@property (nonatomic, strong) NSMutableArray *wsNewsData;
@property (nonatomic, strong) NSMutableArray *wsWallData;
@property (nonatomic, strong) NSMutableArray *wsEventsData;
@property (nonatomic, strong) NSMutableArray *wsDonationsData;
@property (nonatomic, strong) NSMutableArray *wsAppliedData;
@property (nonatomic, strong) NSMutableArray *wsMembersData;
@property (nonatomic, strong) NSMutableArray *wsChatData;
@property (nonatomic, strong) NSMutableArray *wsChatFullData;
@property (nonatomic, strong) NSMutableArray *wsMarqueeData;
@property (nonatomic, strong) NSMutableArray *wsFriendsData;
@property (nonatomic, strong) NSMutableArray *wsLeagueScorersData;
@property (nonatomic, strong) NSMutableArray *wsPromotionData;
@property (nonatomic, strong) NSMutableArray *wsCupScorersData;
@property (nonatomic, strong) NSMutableArray *wsCupFixturesData;
@property (nonatomic, strong) NSMutableArray *wsAllClubsData;
@property (nonatomic, strong) NSMutableArray *wsMapClubsData;
@property (nonatomic, strong) NSMutableArray *wsNearClubsData;
@property (nonatomic, strong) NSMutableArray *wsPlayerSaleData;
@property (nonatomic, strong) NSMutableArray *wsCoachData;
@property (nonatomic, strong) NSMutableArray *wsProductsData;
@property (nonatomic, strong) NSMutableArray *wsTrophyData;
@property (nonatomic, strong) NSMutableArray *wsMyAchievementsData;
@property (nonatomic, strong) NSMutableArray *wsAllianceData;
@property (nonatomic, strong) NSMutableArray *wsAllianceCupFixturesData;
@property (nonatomic, strong) NSString *challengeMatchId;
@property (nonatomic, strong) NSString *selectedPlayer;
@property (nonatomic, strong) NSString *selectedPos;
@property (nonatomic, strong) NSString *workingUrl;
@property (nonatomic, strong) NSString *purchasedPlayerId;
@property (nonatomic, strong) NSString *purchasedCoachId;
@property (nonatomic, strong) NSString *selectedClubId;
@property (nonatomic, strong) NSString *loginBonus;
@property (nonatomic, strong) NSString *acceptedMatch;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *devicetoken;
@property (nonatomic, strong) NSString *uid;
@property (readwrite) NSInteger selectedDivision;
@property (readwrite) NSInteger selectedSeries;
@property (readwrite) NSInteger workingSquad;
@property (readwrite) NSInteger energy;
@property (readwrite) NSTimeInterval offsetServerTimeInterval;
@property (readwrite) BOOL workingAllClubs;
+ (Globals *) i;
- (NSString *) GameId;
- (NSString *) UID;
- (void)setUID:(NSString *)user_uid;
- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;
- (void)showLoadingAlert:(UIView *)view;
- (void)removeLoadingAlert:(UIView *)view;
- (void)showDialog:(UIView *)view :(NSString *)l1 :(NSString *)l2 :(NSString *)l3 :(NSInteger)type :(DialogBlock)block;
- (void)createDialogBox;
- (void)removeDialogBox;
- (NSString *)gettAccepted;
- (void)settAccepted:(NSString *)match_id;
- (NSUInteger)getMaxSeries:(NSUInteger)division;
- (void)setLat:(NSString *)lat;
- (NSString *)getLat;
- (void)setLongi:(NSString *)longi;
- (NSString *)getLongi;
- (void)setDevicetoken:(NSString *)dt;
- (NSString *)getDevicetoken;
- (double)Random_next:(double)min to:(double)max;
- (void)scheduleNotification:(NSDate *)fire_date :(NSString *)alert_body;
- (void)presentNotification:(NSString *)alert_body;
- (void)storeEnergy;
- (PlayerCell *)playerCellHandler:(UITableView *)tableView 
						indexPath:(NSIndexPath *)indexPath 
					  playerArray:(NSMutableArray *)players
						 checkPos:(BOOL)checkPos;
- (UIButton *)buttonWithTitle:(NSString *)title
					  target:(id)target
					selector:(SEL)selector
					   frame:(CGRect)frame
					   image:(UIImage *)image
				imagePressed:(UIImage *)imagePressed
			   darkTextColor:(BOOL)darkTextColor;
- (NSString *) BoolToBit: (NSString *)boolString;
- (NSString *)urlEnc:(NSString *)str;
- (void)buyProduct:(NSString *)productId :(NSString *)isVirtualMoney :(NSString *)json;
- (void) importFacebook:(NSString *) fb_uid 
					   :(NSString *) fb_name 
					   :(NSString *) fb_pic 
					   :(NSString *) fb_sex 
					   :(NSString *) fb_birthday;
- (void) changeTraining: (NSString *) trainingId;
- (void) changeFormation: (NSString *) formationId;
- (void) changeTactic: (NSString *) tacticId;
- (void)changePlayerFormation:(NSString *)player_id :(NSString *)formation_pos;
- (void)challengeClub:(NSString *)home :(NSString *)away :(NSString *)win :(NSString *)lose :(NSString *)draw :(NSString *)note;
- (void) challengeAccept: (NSString *) match_id;
- (void)sellPlayer:(NSString *)player_value :(NSString *)player_id;
- (void) buyCoach: (NSString *) coach_id;
- (void) updateProducts;
- (void) resetClub;
- (void) updateMyAchievementsData;
- (void) healPlayer: (NSString *) player_id;
- (void) energizePlayer: (NSString *) player_id;
- (NSMutableArray *) getMyAchievementsData;
- (NSString *)doBid:(NSString *)player_id :(NSString *)value;
- (NSString *) doChat:(NSString *)message;
- (NSString *) getLast1Chat;
- (NSString *) getLast2Chat;
- (NSString *) getLast3Chat;
- (NSMutableArray *) getProducts;
- (void) updateCurrentSeasonData;
- (NSDictionary *) getCurrentSeasonData;
- (BOOL) updateClubData;
- (NSDictionary *) getClubData;
- (void) updateAllClubsData;
- (NSMutableArray *) getAllClubsData;
- (void) updateMapClubsData;
- (NSMutableArray *) getMapClubsData;
- (void) updateClubInfoData: (NSString *) clubId;
- (void) updateClubInfoFb: (NSString *)fb_id;
- (NSDictionary *) getClubInfoData;
- (void) updatePlayerInfoData: (NSString *) playerId;
- (NSDictionary *) getPlayerInfoData;
- (void) updateCoachData;
- (NSMutableArray *) getCoachData;
- (void) updatePlayerSaleData;
- (NSMutableArray *) getPlayerSaleData;
- (void) updateMatchInfoData: (NSString *) matchId;
- (NSDictionary *) getMatchInfoData;
- (void) updateSquadData: (NSString *) clubId;
- (NSMutableArray *) getSquadData;
- (void) updateMatchData;
- (NSMutableArray *) getMatchData;
- (void) updateMatchPlayedData;
- (NSMutableArray *) getMatchPlayedData;
- (void) updateMatchHighlightsData: (NSString *) matchId;
- (NSMutableArray *) getMatchHighlightsData;
- (void) updateChallengesData;
- (NSMutableArray *) getChallengesData;
- (void) updateChallengedData;
- (NSMutableArray *) getChallengedData;
- (void) updateLeagueData: (NSString *) division : (NSString *) series;
- (NSMutableArray *) getLeagueData;
- (void) updateMatchFixturesData: (NSString *) division : (NSString *) series;
- (NSMutableArray *) getMatchFixturesData;
- (void) updateCupRounds;
- (NSDictionary *) getCupRounds;
- (void) updateCupFixturesData: (NSString *) round;
- (NSMutableArray *) getCupFixturesData;
- (void) updateNewsData: (NSString *) division : (NSString *) series : (NSString *) playing_cup;
- (NSMutableArray *) getNewsData;
- (NSString *) getLastChatID;
- (void) updateChatData;
- (NSMutableArray *) getChatData;
- (void) updateMarqueeData: (NSString *) division : (NSString *) series : (NSString *) playing_cup;
- (NSMutableArray *) getMarqueeData;
- (void) updatePromotionData: (NSString *) division;
- (NSMutableArray *) getPromotionData;
- (void) updateLeagueScorersData: (NSString *) division : (NSString *) top;
- (NSMutableArray *) getLeagueScorersData;
- (void) updateCupScorersData: (NSString *) top;
- (NSMutableArray *) getCupScorersData;
- (void) updateTrophyData: (NSString *) clubId;
- (NSMutableArray *) getTrophyData;
- (void) updateProductIdentifiers;
- (NSDictionary *) getProductIdentifiers;
- (void) updateMySquadData;
- (NSMutableArray *) getMySquadData;
- (NSString *)gettPurchasedProduct;
- (void)settPurchasedProduct:(NSString *)type;
- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length;
- (NSString *)getCountdownString:(NSTimeInterval)differenceSeconds;
- (NSInteger)retrieveEnergy;
- (void)setOffsetTime:(NSTimeInterval)serverTime;
- (int)xpFromLevel:(int)level;
- (int)levelFromXp:(int)xp;
- (int)getXp;
- (int)getXpMax;
- (int)getXpMaxBefore;
- (int)getLevel;
- (NSString *)intString:(int)val;
- (NSString *)numberFormat:(NSString *)val;
- (NSString *)gettLoginBonus;
- (void)settLoginBonus:(NSString *)amount;
- (NSInteger)getAchievementsBadge;
- (void) updateAllianceData;
- (NSMutableArray *) getAllianceData;
- (void) updateWallData;
- (NSMutableArray *) getWallData;
- (NSString *) doPost:(NSString *)message;
- (void) updateEventsData;
- (NSMutableArray *) getEventsData;
- (void) updateDonationsData;
- (NSMutableArray *) getDonationsData;
- (void) updateAppliedData;
- (NSMutableArray *) getAppliedData;
- (void) updateMembersData;
- (NSMutableArray *) getMembersData;
- (void) updateAllianceCupFixturesData:(NSString *)round;
- (NSMutableArray *) getAllianceCupFixturesData;
@end
