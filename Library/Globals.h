//
//  Globals.h
//  Kingdom Game
//
//  Created by Shankar on 6/9/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#define ARC4RANDOM_MAX 0x100000000LL
#define iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define SCALE_IPAD (iPad ? 2.0f : 1.0f)
#define SCREEN_TEMPLATE_WIDTH (iPad ? 768.0f : 320.0f)
#define SCREEN_OFFSET_BOTTOM 0.0f * SCALE_IPAD
#define SCREEN_OFFSET_X 0.0f * SCALE_IPAD
#define SCREEN_OFFSET_MAINHEADER_Y 65.0f * SCALE_IPAD
#define SCREEN_OFFSET_DIALOGHEADER_Y 15.0f * SCALE_IPAD
#define CELL_CONTENT_WIDTH (iPad ? 768.0f : 320.0f)
#define CELL_CONTENT_MARGIN 10.0f * SCALE_IPAD
#define CELL_CONTENT_Y 3.0f * SCALE_IPAD
#define CELL_CONTENT_SPACING 5.0f * SCALE_IPAD
#define CELL_HEADER_HEIGHT 44.0f * SCALE_IPAD
#define CELL_HEADER_Y 15.0f * SCALE_IPAD
#define CELL_IMAGE1_SIZE 30.0f * SCALE_IPAD
#define CELL_IMAGE2_HEIGHT 20.0f * SCALE_IPAD
#define CELL_IMAGE2_WIDTH 10.0f * SCALE_IPAD
#define CELL_LABEL_HEIGHT 20.0f * SCALE_IPAD
#define CELL_DEFAULT_HEIGHT 22.0f * SCALE_IPAD
#define CELL_EMPTY_HEIGHT 10.0f * SCALE_IPAD
#define ARRAY_FLAGS [NSArray arrayWithObjects: @" ", @"Afghanistan", @"Aland Islands", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Anguilla", @"Antarctica", @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Aruba", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize", @"Benin", @"Bermuda", @"Bhutan", @"BIOT", @"Bolivia", @"Bosnian", @"Botswana", @"Bouvet Island", @"Brazil", @"British Antarctic Territory", @"British Virgin Islands", @"Brunei", @"Bulgaria", @"Burkina Faso", @"Burma", @"Burundi", @"Cambodia", @"Cameroon", @"Canada", @"Cape Verde", @"Cayman Islands", @"CentralAfricanRepublic", @"Chad", @"Chile", @"China", @"Christmas Island", @"Cocos Islands", @"Colombia", @"Comoros", @"Congo", @"Congo Kinshasa", @"Cook Islands", @"Costa Rica", @"Croatian", @"Cuba", @"Cyprus", @"Czech Republic", @"Denmark", @"Djibouti", @"Dominican Republic", @"Dominicana", @"East Timor", @"Ecuador", @"Egypt", @"El Salvador", @"England", @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia", @"European Union", @"Ex Yugoslavia", @"Falkland Islands", @"Faroe Islands", @"Fiji", @"Finland", @"France", @"French Polynesia", @"French Southern Territories", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Gibraltar", @"Greece", @"Greenland", @"Grenada", @"Guadeloupe", @"Guam", @"Guatemala", @"Guernsey", @"Guinea Bissau", @"Guinea", @"Guyana", @"Haiti", @"Holy see", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran", @"Iraq", @"Ireland", @"Isle of Man", @"Israel", @"Italy", @"Ivory Coast", @"Jamaica", @"Jan Mayen", @"Japan", @"Jarvis Island", @"Jersey", @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati", @"Korea", @"Kosovo", @"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia", @"Lebanon", @"Lesotho", @"Liberia", @"Libya", @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macau", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia", @"Maldives", @"Mali", @"Malta", @"Marshall Islands", @"Martinique", @"Mauritania", @"Mauritius", @"Mayotte", @"Mexico", @"Micronesia", @"Moldova", @"Monaco", @"Mongolia", @"Montenegro", @"Montserrat", @"Morocco", @"Mozambique", @"Myanmar", @"Namibia", @"Nauru", @"Nepal", @"Netherlands Antilles", @"Netherlands", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Niue", @"Norfolk Island", @"North Korea", @"Northern Ireland", @"Northern Mariana Islands", @"Norway", @"Oman", @"Pakistan", @"Palau", @"Palestinian Territory", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Pitcairn", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Reunion", @"Romania", @"Russia", @"Rwanda", @"Saint Pierre and Miquelon", @"Saint Vincent and the Grenadines", @"Saint Barthelemy", @"Saint Helena Dependencies", @"Saint Helena", @"Saint Kitts and Nevis", @"Saint Lucia", @"Saint Martin", @"Samoa", @"San Marino", @"Sao Tome and Principe", @"Saudi Arabia", @"Scotland", @"Senegal", @"Serbia", @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"SMOM", @"Solomon Islands", @"Somalia", @"South Africa", @"South Georgia", @"Spain", @"SPM", @"Sri Lanka", @"Sudan", @"Suriname", @"Svalbard", @"SVG", @"Swaziland", @"Sweden", @"Switzerland", @"Syria", @"Taiwan", @"Tajikistan", @"Tanzania", @"Thailand", @"Timor Leste", @"Togo", @"Tokelau", @"Tonga", @"Trinidad and Tobago", @"Tunisia", @"Turkey", @"Turkmenistan", @"Turks and Caicos Islands", @"Tuvalu", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Vatican City", @"Venezuela", @"Vietnam", @"Virgin Islands", @"Wales", @"Wallis and Futuna", @"Western Sahara", @"Yemen", @"Zambia", @"Zimbabwe", nil]
#define STAR_FULL @"star.png"
#define STAR_HALF @"halfstar.png"
#define SCREEN_WIDTH (iPad ? 768.0f : 320.0f)
#define HeaderSquadSelect_height (iPad ? 75.0f : 50.0f)
#define HeaderSquad_height (iPad ? 180.0f : 75.0f)
#define Maintable_height (iPad ? 1300.0f : 730.0f)
#define SLIDE_x (iPad ? 64.0f : 0.0f)
#define SLIDE_y (iPad ? 30.0f : 5.0f)
#define SLIDE_width (iPad ? 640.0f : 320.0f)
#define SLIDE_height (iPad ? 320.0f : 160.0f)
#define Marquee_height (iPad ? 40.0f : 15.0f)
#define MatchView_frame_x (iPad ? 545.0f : 210.0f)
#define MatchView_frame_width (iPad ? 110.0f : 50.0f)
#define MatchView_frame1_x (iPad ? 110.0f : 50.0f)
#define MatchView_frame1_y (iPad ? 4.0f : 1.0f)
#define MatchView_frame2_x (iPad ? 110.0f : 50.0f)
#define MatchView_frame2_width (iPad ? 430.0f : 160.0f)
#define LeagueView_cellheight (iPad ? 56.0f : 25.0f)
#define TacticsView_frame_offset (iPad ? 150.0f : 47.0f)
#define TacticsView_frame_y (iPad ? 100.0f : 15.0f)
#define BID_CEILING (iPad ? 381.0f : 191.0f)
#define BID_BUTTON_WIDTH (iPad ? 144.0f : 72.0f)
#define PBAR_SMALL (iPad ? 20.0f : 10.0f)
#define PBAR_BIG (iPad ? 120.0f : 60.0f)
#define PBAR1_X (iPad ? 45.0f : 20.0f)
#define PBAR1_Y (iPad ? 80.0f : 35.0f)
#define PBAR2_X (iPad ? 135.0f : 52.0f)
#define PBAR2_Y (iPad ? 545.0f : 243.0f)
#define PBAR3_X (iPad ? 820.0f : 367.0f)
#define PBAR3_Y (iPad ? 160.0f : 95.0f)

#define DEFAULT_FONT @"MLS 2013"
#define DEFAULT_FONT_SIZE 22.0f * SCALE_IPAD
#define DEFAULT_FONT_SMALL_SIZE 18.0f * SCALE_IPAD
#define DEFAULT_FONT_BIG_SIZE 26.0f * SCALE_IPAD
#define MINIMUM_FONT_SIZE 1.0f * SCALE_IPAD
#define R1_FONT_SIZE 18.0f * SCALE_IPAD
#define R2_FONT_SIZE 17.0f * SCALE_IPAD
#define R3_FONT_SIZE 15.0f * SCALE_IPAD
#define C1_FONT_SIZE 16.0f * SCALE_IPAD

#define GAME_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define GAME_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define WS_URL [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GAME_URL"]

#import "MailView.h"
#import "MailCompose.h"
#import "ChatView.h"
#import "DialogBoxView.h"
#import "TemplateView.h"
#import "LoginView.h"
#import "DynamicCell.h"
#import <AVFoundation/AVFoundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import "UIColor+Crayola.h"
#import "UAAppReviewManager.h"
#import "CustomBadge.h"

@class BuyView;
@class WorldsView;
@class PlayerCell;

@interface Globals : NSObject
<AVAudioPlayerDelegate, FBFriendPickerDelegate, CLLocationManagerDelegate, TemplateDelegate>
{
    NSMutableArray *viewControllerStack;
    AVAudioPlayer *buttonAudio;
	AVAudioPlayer *backAudio;
    AVAudioPlayer *moneyAudio;
    AVAudioPlayer *winAudio;
    AVAudioPlayer *loseAudio;
	NSDictionary *wsProductIdentifiers;
	NSDictionary *wsClubData;
    NSDictionary *wsBaseData;
    NSDictionary *wsWorldData;
	NSDictionary *wsClubInfoData;
	NSMutableArray *wsReportData;
    NSMutableArray *wsMailData;
    NSMutableArray *wsMailReply;
    NSMutableArray *localReportData;
    NSMutableArray *localMailData;
    NSDictionary *localMailReply;
    NSMutableArray *wsChatData;
    NSMutableArray *wsChatFullData;
    NSMutableArray *wsAllianceChatData;
    NSMutableArray *wsAllianceChatFullData;
    NSMutableArray *wsMyAchievementsData;
    NSMutableArray *wsBasesData;
    NSMutableArray *wsWorldsData;
    NSString *lastReportId;
    NSString *lastMailId;
	NSString *workingUrl;
	NSString *selectedClubId;
    NSString *selectedBaseId;
    NSString *purchasedProductString;
    NSString *loginBonus;
    NSString *latitude;
    NSString *longitude;
    NSString *devicetoken;
    NSString *uid;
    NSString *selectedMapTile;
    NSTimeInterval offsetServerTimeInterval;
    MailCompose *mailCompose;
    ChatView *chatView;
    ChatView *allianceChatView;
    LoginView *loginView;
    BuyView *buyView;
    WorldsView *worldsView;
    DialogBoxView *dialogBox;
    TemplateView *templateView;
    UILocalNotification* loginNotification;
	BOOL workingClub;
    BOOL workingWorldClub;
	BOOL workingReport;
    BOOL workingMail;
    BOOL workingWall;
    BOOL workingEvents;
    BOOL workingChat;
    BOOL workingAllianceChat;
    
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
	NSString *purchasedPlayerId;
	NSString *purchasedCoachId;
    NSString *acceptedMatch;
	NSInteger selectedDivision;
	NSInteger selectedSeries;
	NSInteger workingSquad;
	NSInteger energy;
	BOOL workingAllClubs;
	BOOL workingNews;
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
@property (nonatomic, strong) NSMutableArray *viewControllerStack;
@property (nonatomic, strong) AVAudioPlayer *buttonAudio;
@property (nonatomic, strong) AVAudioPlayer *backAudio;
@property (nonatomic, strong) AVAudioPlayer *moneyAudio;
@property (nonatomic, strong) AVAudioPlayer *winAudio;
@property (nonatomic, strong) AVAudioPlayer *loseAudio;
@property (nonatomic, strong) NSDictionary *wsProductIdentifiers;
@property (nonatomic, strong) NSDictionary *wsClubData;
@property (nonatomic, strong) NSDictionary *wsBaseData;
@property (nonatomic, strong) NSDictionary *wsWorldData;
@property (nonatomic, strong) NSDictionary *wsClubInfoData;
@property (nonatomic, strong) NSDictionary *localMailReply;
@property (nonatomic, strong) NSMutableArray *wsReportData;
@property (nonatomic, strong) NSMutableArray *wsMailData;
@property (nonatomic, strong) NSMutableArray *wsMailReply;
@property (nonatomic, strong) NSMutableArray *localReportData;
@property (nonatomic, strong) NSMutableArray *localMailData;
@property (nonatomic, strong) NSMutableArray *wsChatData;
@property (nonatomic, strong) NSMutableArray *wsChatFullData;
@property (nonatomic, strong) NSMutableArray *wsAllianceChatData;
@property (nonatomic, strong) NSMutableArray *wsAllianceChatFullData;
@property (nonatomic, strong) NSMutableArray *wsMyAchievementsData;
@property (nonatomic, strong) NSMutableArray *wsBasesData;
@property (nonatomic, strong) NSMutableArray *wsWorldsData;
@property (nonatomic, strong) NSString *purchasedProductString;
@property (nonatomic, strong) NSString *lastReportId;
@property (nonatomic, strong) NSString *lastMailId;
@property (nonatomic, strong) NSString *workingUrl;
@property (nonatomic, strong) NSString *selectedClubId;
@property (nonatomic, strong) NSString *selectedBaseId;
@property (nonatomic, strong) NSString *loginBonus;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *devicetoken;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *selectedMapTile;
@property (nonatomic, strong) MailCompose *mailCompose;
@property (nonatomic, strong) ChatView *chatView;
@property (nonatomic, strong) ChatView *allianceChatView;
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) BuyView *buyView;
@property (nonatomic, strong) WorldsView *worldsView;
@property (nonatomic, strong) DialogBoxView *dialogBox;
@property (nonatomic, strong) TemplateView *templateView;
@property (nonatomic, strong) UILocalNotification* loginNotification;
@property (readwrite) NSTimeInterval offsetServerTimeInterval;

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
@property (nonatomic, strong) NSMutableArray *wsAllianceData;
@property (nonatomic, strong) NSMutableArray *wsAllianceCupFixturesData;
@property (nonatomic, strong) NSString *challengeMatchId;
@property (nonatomic, strong) NSString *selectedPlayer;
@property (nonatomic, strong) NSString *selectedPos;
@property (nonatomic, strong) NSString *purchasedPlayerId;
@property (nonatomic, strong) NSString *purchasedCoachId;
@property (nonatomic, strong) NSString *acceptedMatch;
@property (readwrite) NSInteger selectedDivision;
@property (readwrite) NSInteger selectedSeries;
@property (readwrite) NSInteger workingSquad;
@property (readwrite) NSInteger energy;
@property (readwrite) BOOL workingAllClubs;

typedef void (^returnBlock)(BOOL success, NSData *data);
+ (void)postServer:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock;
+ (void)postServerLoading:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock;
+ (void)getServer:(NSString *)wsurl :(returnBlock)completionBlock;
+ (void)getServerLoading:(NSString *)wsurl :(returnBlock)completionBlock;
+ (Globals *)i;
+ (NSOperationQueue *)connectionQueue;
- (NSString *)GameId;
- (NSString *)UID;
- (NSString *)world_url;
- (void)setUID:(NSString *)user_uid;
- (void)showLoadingAlert;
- (void)removeLoadingAlert;
- (void)showToast:(NSString *)message optionalTitle:(NSString *)title optionalImage:(NSString *)imagename;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType;
- (void)closeTemplate;
- (void)showDialog:(NSString *)l1;
- (void)showDialogBlock:(NSString *)l1 :(NSInteger)type :(DialogBlock)block;
- (void)showDialogError;
- (void)createDialogBox;
- (void)removeDialogBox;
- (void)setLat:(NSString *)lat;
- (NSString *)getLat;
- (void)setLongi:(NSString *)longi;
- (NSString *)getLongi;
- (void)setDevicetoken:(NSString *)dt;
- (NSString *)getDevicetoken;
- (double)Random_next:(double)min to:(double)max;
- (void)scheduleNotification:(NSDate *)f_date :(NSString *)alert_body;
- (void)resetLoginReminderNotification;
- (NSString *)BoolToBit: (NSString *)boolString;
- (NSString *)shortNumberFormat:(NSString *)val;
- (UITableViewCell *)dynamicCell:(UITableView *)tableView rowData:(NSDictionary *)rowData cellWidth:(float)cell_width;
- (CGFloat)dynamicCellHeight:(NSDictionary *)rowData cellWidth:(float)cell_width;
- (void)updateTime;
- (NSString *)getServerTimeString;
- (NSString *)getServerDateTimeString;
- (NSString *)getTimeAgo:(NSString *)datetimestring;
- (void)buttonSound;
- (void)initSound;
- (void)backSound;
- (void)moneySound;
- (void)toasterSound;
- (void)winSound;
- (void)loseSound;
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
- (void)showLogin:(LoginBlock)block;
- (void)showWorlds;
- (void)fblogin;
- (void)saveLocation;
- (void)showBuy;
- (void)backTemplate;
- (void)pushTemplateNav:(UIViewController *)view;
- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)updateMyAchievementsData;
- (NSString *)getLastChatString;
- (BOOL)updateClubData;
- (void)updateClubInfoData:(NSString *)clubId;
- (void)updateClubInfoFb:(NSString *)fb_id;
- (NSString *)getLastChatID;
- (NSString *)getLastAllianceChatID;
- (void)updateChatData;
- (void)updateAllianceChatData;
- (void)checkVersion;
- (void)updateProductIdentifiers;
- (NSString *)gettSelectedBaseId;
- (void)settSelectedBaseId:(NSString *)bid;
- (NSString *)gettPurchasedProduct;
- (void)settPurchasedProduct:(NSString *)type;
- (NSString *)getCountdownString:(NSTimeInterval)differenceSeconds;
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
- (void)updateBasesData;
- (void)updateBaseData;
- (void)updateMainView:(NSString *)base_id;
- (NSDictionary *)gettSelectedWorldData;
- (void)settSelectedWorldData:(NSDictionary *)wd;
- (void)updateWorldsData;
- (void)updateReportData;
- (NSInteger)getReportBadgeNumber;
- (NSMutableArray *)gettLocalReportData;
- (void)settLocalReportData:(NSMutableArray *)rd;
- (void)addLocalReportData:(NSMutableArray *)rd;
- (NSString *)gettLastReportId;
- (void)settLastReportId:(NSString *)rid;
- (NSDictionary *)gettLocalMailReply;
- (void)settLocalMailReply:(NSDictionary *)rd;
- (NSArray *)findMailReply:(NSString *)mail_id;
- (void)updateMailData;
- (void)updateMailReply:(NSString *)mail_id;
- (NSInteger)getMailBadgeNumber;
- (NSMutableArray *)gettLocalMailData;
- (void)settLocalMailData:(NSMutableArray *)rd;
- (void)addLocalMailData:(NSMutableArray *)rd;
- (NSString *)gettLastMailId;
- (void)settLastMailId:(NSString *)rid;
- (CGFloat)textHeight:(NSString *)text lblWidth:(CGFloat)label_width fontSize:(CGFloat)font_size;
- (void)addMailReply:(NSString *)mail_id :(NSArray *)mail_reply;
- (void)deleteLocalMail:(NSString *)mail_id;
- (void)replyCounterPlus:(NSString *)mail_id;
- (void)refreshSelectedWorldData;
- (void)flushViewControllerStack;
- (void)pushViewControllerStack:(UIViewController *)view;
- (UIViewController *)popViewControllerStack;
- (UIViewController *)peekViewControllerStack;
- (BOOL)isCurrentView:(UIViewController *)view;
- (void)emailToDeveloper;
- (void)pushChatVC:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid;
- (void)showChat;
- (void)mailCompose:(NSString *)isAlli toID:(NSString *)toid toName:(NSString *)toname;
- (void)pushMoreGamesVC;
- (void)fbPublishStory:(NSString *)message :(NSString *)caption :(NSString *)picture;

//SPORTS
- (NSString *)GameType;
- (NSString *)GameUrl;
- (NSString *)PlayerSkill1;
- (NSString *)PlayerSkill2;
- (NSString *)PlayerSkill3;
- (NSString *)PlayerSkill4;
- (NSString *)PlayerSkill5;
- (NSString *)PlayerSkill6;
- (NSString *)gettAccepted;
- (void)settAccepted:(NSString *)match_id;
- (NSUInteger)getMaxSeries:(NSUInteger)division;
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

- (NSString *)urlEnc:(NSString *)str;
- (void)buyProduct:(NSString *)productId :(NSString *)isVirtualMoney :(NSString *)json;
- (void)changeTraining:(NSString *)trainingId;
- (void)changeFormation:(NSString *)formationId;
- (void)changeTactic:(NSString *)tacticId;
- (void)changePlayerFormation:(NSString *)player_id :(NSString *)formation_pos;
- (void)challengeClub:(NSString *)home :(NSString *)away :(NSString *)win :(NSString *)lose :(NSString *)draw :(NSString *)note;
- (void)challengeAccept:(NSString *)match_id;
- (void)sellPlayer:(NSString *)player_value :(NSString *)player_id;
- (void)buyCoach:(NSString *)coach_id;
- (void)updateProducts;
- (void)resetClub;
- (void)healPlayer:(NSString *)player_id;
- (void)energizePlayer:(NSString *)player_id;
- (NSMutableArray *)getMyAchievementsData;
- (NSString *)doBid:(NSString *)player_id :(NSString *)value;
- (NSMutableArray *)getProducts;
- (void)updateCurrentSeasonData;
- (NSDictionary *)getCurrentSeasonData;
- (NSDictionary *)getClubData;
- (void)updateAllClubsData;
- (NSMutableArray *)getAllClubsData;
- (void)updateClubInfoData:(NSString *)clubId;
- (void)updateClubInfoFb:(NSString *)fb_id;
- (NSDictionary *)getClubInfoData;
- (void)updatePlayerInfoData:(NSString *)playerId;
- (NSDictionary *)getPlayerInfoData;
- (void)updateCoachData;
- (NSMutableArray *)getCoachData;
- (void)updatePlayerSaleData;
- (NSMutableArray *)getPlayerSaleData;
- (void)updateMatchInfoData:(NSString *)matchId;
- (NSDictionary *)getMatchInfoData;
- (void)updateSquadData:(NSString *)clubId;
- (NSMutableArray *)getSquadData;
- (void)updateMatchData;
- (NSMutableArray *)getMatchData;
- (void)updateMatchPlayedData;
- (NSMutableArray *)getMatchPlayedData;
- (void)updateMatchHighlightsData:(NSString *)matchId;
- (NSMutableArray *)getMatchHighlightsData;
- (void)updateChallengesData;
- (NSMutableArray *)getChallengesData;
- (void)updateChallengedData;
- (NSMutableArray *)getChallengedData;
- (void)updateLeagueData:(NSString *)division :(NSString *)series;
- (NSMutableArray *)getLeagueData;
- (void)updateMatchFixturesData:(NSString *)division :(NSString *)series;
- (NSMutableArray *)getMatchFixturesData;
- (void)updateNewsData:(NSString *)division :(NSString *)series :(NSString *)playing_cup;
- (NSMutableArray *)getNewsData;
- (void)updateMarqueeData:(NSString *)division :(NSString *)series :(NSString *)playing_cup;
- (NSMutableArray *)getMarqueeData;
- (void)updatePromotionData:(NSString *)division;
- (NSMutableArray *)getPromotionData;
- (void)updateLeagueScorersData:(NSString *)division :(NSString *)top;
- (NSMutableArray *)getLeagueScorersData;
- (void)updateTrophyData:(NSString *)clubId;
- (NSMutableArray *)getTrophyData;
- (NSDictionary *)getProductIdentifiers;
- (void)updateMySquadData;
- (NSMutableArray *)getMySquadData;
- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length;
- (NSInteger)retrieveEnergy;
- (void)setOffsetTime:(NSTimeInterval)serverTime;
- (NSInteger)getAchievementsBadge;
- (void)updateAllianceData;
- (NSMutableArray *)getAllianceData;
- (void)updateWallData;
- (NSMutableArray *)getWallData;
- (NSString *)doPost:(NSString *)message;
- (void)updateEventsData;
- (NSMutableArray *)getEventsData;
- (void)updateDonationsData;
- (NSMutableArray *)getDonationsData;
- (void)updateAppliedData;
- (NSMutableArray *)getAppliedData;
- (void)updateMembersData;
- (NSMutableArray *)getMembersData;
- (void)updateAllianceCupFixturesData:(NSString *)round;
- (NSMutableArray *)getAllianceCupFixturesData;
- (void)showMoreGames;
@end
