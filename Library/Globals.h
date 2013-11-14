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
#define SCREEN_OFFSET_MAINHEADER_Y 45.0f * SCALE_IPAD
#define SCREEN_OFFSET_DIALOGHEADER_Y 15.0f * SCALE_IPAD
#define MINIMUM_FONT_SIZE 1.0f * SCALE_IPAD
#define DEFAULT_FONT_SIZE 13.0f * SCALE_IPAD
#define R1_FONT_SIZE 14.0f * SCALE_IPAD
#define R2_FONT_SIZE 13.0f * SCALE_IPAD
#define R3_FONT_SIZE 10.0f * SCALE_IPAD
#define C1_FONT_SIZE 13.0f * SCALE_IPAD
#define DEFAULT_FONT @"Nasalization Free"
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
#define TILE_WIDTH 70.0f
#define TILE_HEIGHT 42.0f
#define MAP_HEIGHT 20.0f
#define TILE_MAX_ROW_CAPACITY 1000 // add 0 to increase rows capacity
#define TILE_ID_MAKE(col, row) ( col + 1 ) * TILE_MAX_ROW_CAPACITY + ( row + 1 )
#define TILE_COL_FROMID(id) id/TILE_MAX_ROW_CAPACITY - 1
#define TILE_ROW_FROMID(id) id%TILE_MAX_ROW_CAPACITY - 1
#define GAME_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define GAME_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define ARRAY_FLAGS [NSArray arrayWithObjects: @" ", @"Afghanistan", @"Aland Islands", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Anguilla", @"Antarctica", @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Aruba", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize", @"Benin", @"Bermuda", @"Bhutan", @"BIOT", @"Bolivia", @"Bosnian", @"Botswana", @"Bouvet Island", @"Brazil", @"British Antarctic Territory", @"British Virgin Islands", @"Brunei", @"Bulgaria", @"Burkina Faso", @"Burma", @"Burundi", @"Cambodia", @"Cameroon", @"Canada", @"Cape Verde", @"Cayman Islands", @"CentralAfricanRepublic", @"Chad", @"Chile", @"China", @"Christmas Island", @"Cocos Islands", @"Colombia", @"Comoros", @"Congo", @"Congo Kinshasa", @"Cook Islands", @"Costa Rica", @"Croatian", @"Cuba", @"Cyprus", @"Czech Republic", @"Denmark", @"Djibouti", @"Dominican Republic", @"Dominicana", @"East Timor", @"Ecuador", @"Egypt", @"El Salvador", @"England", @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia", @"European Union", @"Ex Yugoslavia", @"Falkland Islands", @"Faroe Islands", @"Fiji", @"Finland", @"France", @"French Polynesia", @"French Southern Territories", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Gibraltar", @"Greece", @"Greenland", @"Grenada", @"Guadeloupe", @"Guam", @"Guatemala", @"Guernsey", @"Guinea Bissau", @"Guinea", @"Guyana", @"Haiti", @"Holy see", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran", @"Iraq", @"Ireland", @"Isle of Man", @"Israel", @"Italy", @"Ivory Coast", @"Jamaica", @"Jan Mayen", @"Japan", @"Jarvis Island", @"Jersey", @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati", @"Korea", @"Kosovo", @"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia", @"Lebanon", @"Lesotho", @"Liberia", @"Libya", @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macau", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia", @"Maldives", @"Mali", @"Malta", @"Marshall Islands", @"Martinique", @"Mauritania", @"Mauritius", @"Mayotte", @"Mexico", @"Micronesia", @"Moldova", @"Monaco", @"Mongolia", @"Montenegro", @"Montserrat", @"Morocco", @"Mozambique", @"Myanmar", @"Namibia", @"Nauru", @"Nepal", @"Netherlands Antilles", @"Netherlands", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Niue", @"Norfolk Island", @"North Korea", @"Northern Ireland", @"Northern Mariana Islands", @"Norway", @"Oman", @"Pakistan", @"Palau", @"Palestinian Territory", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Pitcairn", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Reunion", @"Romania", @"Russia", @"Rwanda", @"Saint Pierre and Miquelon", @"Saint Vincent and the Grenadines", @"Saint Barthelemy", @"Saint Helena Dependencies", @"Saint Helena", @"Saint Kitts and Nevis", @"Saint Lucia", @"Saint Martin", @"Samoa", @"San Marino", @"Sao Tome and Principe", @"Saudi Arabia", @"Scotland", @"Senegal", @"Serbia", @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"SMOM", @"Solomon Islands", @"Somalia", @"South Africa", @"South Georgia", @"Spain", @"SPM", @"Sri Lanka", @"Sudan", @"Suriname", @"Svalbard", @"SVG", @"Swaziland", @"Sweden", @"Switzerland", @"Syria", @"Taiwan", @"Tajikistan", @"Tanzania", @"Thailand", @"Timor Leste", @"Togo", @"Tokelau", @"Tonga", @"Trinidad and Tobago", @"Tunisia", @"Turkey", @"Turkmenistan", @"Turks and Caicos Islands", @"Tuvalu", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Vatican City", @"Venezuela", @"Vietnam", @"Virgin Islands", @"Wales", @"Wallis and Futuna", @"Western Sahara", @"Yemen", @"Zambia", @"Zimbabwe", nil]
#define CORE_URL @"http://www.tapfantasy.com"
#define WS_URL CORE_URL "/kingdom"
#define APP_TYPE @"kingdom"

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
    NSDictionary *wsWorldClubData;
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
@property (nonatomic, strong) NSDictionary *wsWorldClubData;
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
- (void)fblogin;
- (void)saveLocation;
- (void)shareButton;
- (void)showBuy;
- (void)backTemplate;
- (void)pushTemplateNav:(UIViewController *)view;
- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)updateMyAchievementsData;
- (NSString *)getLastChatString;
- (BOOL)updateClubData;
- (BOOL)updateWorldClubData;
- (void)updateClubInfoData:(NSString *)clubId;
- (void)updateClubInfoFb:(NSString *)fb_id;
- (NSString *)getLastChatID;
- (NSString *)getLastAllianceChatID;
- (void)updateChatData;
- (void)updateAllianceChatData;
- (void)checkVersion:(UIView *)view;
- (void)updateProductIdentifiers;
- (NSString *)gettSelectedBaseId;
- (void)settSelectedBaseId:(NSString *)bid;
- (NSString *)gettPurchasedProduct;
- (void)settPurchasedProduct:(NSString *)type;
- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length;
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
- (void)showWorlds;
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
@end
