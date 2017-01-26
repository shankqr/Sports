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
#define SCREEN_WIDTH (iPad ? 768.0f : 320.0f)
#define SCREEN_OFFSET_BOTTOM 0.0f * SCALE_IPAD
#define SCREEN_OFFSET_X 0.0f * SCALE_IPAD
#define SCREEN_OFFSET_MAINHEADER_Y (iPad ? 130.0f : 60.0f)
#define SCREEN_OFFSET_DIALOGHEADER_Y 15.0f * SCALE_IPAD
#define ARRAY_FLAGS [NSArray arrayWithObjects: @" ", @"Afghanistan", @"Aland Islands", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Anguilla", @"Antarctica", @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Aruba", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize", @"Benin", @"Bermuda", @"Bhutan", @"BIOT", @"Bolivia", @"Bosnian", @"Botswana", @"Bouvet Island", @"Brazil", @"British Antarctic Territory", @"British Virgin Islands", @"Brunei", @"Bulgaria", @"Burkina Faso", @"Burma", @"Burundi", @"Cambodia", @"Cameroon", @"Canada", @"Cape Verde", @"Cayman Islands", @"CentralAfricanRepublic", @"Chad", @"Chile", @"China", @"Christmas Island", @"Cocos Islands", @"Colombia", @"Comoros", @"Congo", @"Congo Kinshasa", @"Cook Islands", @"Costa Rica", @"Croatian", @"Cuba", @"Cyprus", @"Czech Republic", @"Denmark", @"Djibouti", @"Dominican Republic", @"Dominicana", @"East Timor", @"Ecuador", @"Egypt", @"El Salvador", @"England", @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia", @"European Union", @"Ex Yugoslavia", @"Falkland Islands", @"Faroe Islands", @"Fiji", @"Finland", @"France", @"French Polynesia", @"French Southern Territories", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Gibraltar", @"Greece", @"Greenland", @"Grenada", @"Guadeloupe", @"Guam", @"Guatemala", @"Guernsey", @"Guinea Bissau", @"Guinea", @"Guyana", @"Haiti", @"Holy see", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran", @"Iraq", @"Ireland", @"Isle of Man", @"Israel", @"Italy", @"Ivory Coast", @"Jamaica", @"Jan Mayen", @"Japan", @"Jarvis Island", @"Jersey", @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati", @"Korea", @"Kosovo", @"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia", @"Lebanon", @"Lesotho", @"Liberia", @"Libya", @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macau", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia", @"Maldives", @"Mali", @"Malta", @"Marshall Islands", @"Martinique", @"Mauritania", @"Mauritius", @"Mayotte", @"Mexico", @"Micronesia", @"Moldova", @"Monaco", @"Mongolia", @"Montenegro", @"Montserrat", @"Morocco", @"Mozambique", @"Myanmar", @"Namibia", @"Nauru", @"Nepal", @"Netherlands Antilles", @"Netherlands", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Niue", @"Norfolk Island", @"North Korea", @"Northern Ireland", @"Northern Mariana Islands", @"Norway", @"Oman", @"Pakistan", @"Palau", @"Palestinian Territory", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Pitcairn", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Reunion", @"Romania", @"Russia", @"Rwanda", @"Saint Pierre and Miquelon", @"Saint Vincent and the Grenadines", @"Saint Barthelemy", @"Saint Helena Dependencies", @"Saint Helena", @"Saint Kitts and Nevis", @"Saint Lucia", @"Saint Martin", @"Samoa", @"San Marino", @"Sao Tome and Principe", @"Saudi Arabia", @"Scotland", @"Senegal", @"Serbia", @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"SMOM", @"Solomon Islands", @"Somalia", @"South Africa", @"South Georgia", @"Spain", @"SPM", @"Sri Lanka", @"Sudan", @"Suriname", @"Svalbard", @"SVG", @"Swaziland", @"Sweden", @"Switzerland", @"Syria", @"Taiwan", @"Tajikistan", @"Tanzania", @"Thailand", @"Timor Leste", @"Togo", @"Tokelau", @"Tonga", @"Trinidad and Tobago", @"Tunisia", @"Turkey", @"Turkmenistan", @"Turks and Caicos Islands", @"Tuvalu", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Vatican City", @"Venezuela", @"Vietnam", @"Virgin Islands", @"Wales", @"Wallis and Futuna", @"Western Sahara", @"Yemen", @"Zambia", @"Zimbabwe", nil]
#define STAR_FULL @"icon_star.png"
#define STAR_HALF @"icon_halfstar.png"
#define HeaderSquadSelect_height (iPad ? 75.0f : 50.0f)
#define HeaderSquad_height (iPad ? 180.0f : 75.0f)
#define Maintable_height (iPad ? 1400.0f : 850.0f)
#define Header_height (iPad ? 180.0f : 75.0f)
#define SLIDE_x (iPad ? 0.0f : 0.0f)
#define SLIDE_y (iPad ? 30.0f : 5.0f)
#define SLIDE_width (iPad ? 600.0f : 250.0f)
#define SLIDE_height (iPad ? 320.0f : 160.0f)
#define Marquee_height (iPad ? 40.0f : 21.0f)
#define Chatpreview_height (iPad ? 110.0f : 55.0f)
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
#define FORMATION_SEGMENT_Y (iPad ? 730.0f : 340.0f)
#define CELL_CONTENT_WIDTH UIScreen.mainScreen.bounds.size.width
#define TABLE_FOOTER_VIEW_HEIGHT 50.0f * SCALE_IPAD
#define TABLE_HEADER_VIEW_HEIGHT 44.0f * SCALE_IPAD
#define DEFAULT_CONTENT_SPACING 5.0f * SCALE_IPAD

#define DEFAULT_FONT @"TrebuchetMS"
#define DEFAULT_FONT_BOLD @"TrebuchetMS-Bold"
#define DEFAULT_FONT_SIZE 18.0f * SCALE_IPAD
#define DEFAULT_FONT_SMALL_SIZE 14.0f * SCALE_IPAD
#define DEFAULT_FONT_BIG_SIZE 22.0f * SCALE_IPAD
#define MINIMUM_FONT_SIZE 1.0f * SCALE_IPAD
#define MENU_FONT_SIZE (iPad ? 28.0f : 14.0f)

#define PLUGIN_HEIGHT UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_MAINHEADER_Y - SCREEN_OFFSET_BOTTOM
#define CHART_CONTENT_MARGIN 10.0f * SCALE_IPAD
#define SMALL_FONT_SIZE 12.0f * SCALE_IPAD
#define MEDIUM_FONT_SIZE 16.0f * SCALE_IPAD
#define BIG_FONT_SIZE 24.0f * SCALE_IPAD

//Main Menu
#define buttons_per_row (iPad ? 5 : 4)
#define menu_start_y (iPad ? 370.0f : 175.0f)
#define menu_label_height (iPad ? 42.0f : 21.0f)
#define menu_margin_y (iPad ? 20.0f : 10.0f)

//Football
#define Pos_x1 (iPad ? 164.0f : 50.0f)
#define Pos_x2 (iPad ? 484.0f : 210.0f)
#define Pos_x3 (iPad ? 10.0f : 2.0f)
#define Pos_x4 (iPad ? 164.0f : 66.0f)
#define Pos_x5 (iPad ? 484.0f : 194.0f)
#define Pos_x6 (iPad ? 640.0f : 258.0f)
#define Pos_y1 (iPad ? 160.0f : 45.0f)
#define Pos_y2 (iPad ? 310.0f : 120.0f)
#define Pos_y3 (iPad ? 460.0f : 195.0f)
#define Pos_y4 (iPad ? 610.0f : 270.0f)
#define Subs_x1 (iPad ? 324.0f : 130.0f)
#define Subs_x2 (iPad ? 70.0f : 10.0f)
#define Subs_x3 (iPad ? 230.0f : 90.0f)
#define Subs_x4 (iPad ? 400.0f : 170.0f)
#define Subs_x5 (iPad ? 560.0f : 250.0f)
#define Subs_y1 (iPad ? 480.0f : 185.0f)
#define Subs_y2 (iPad ? 630.0f : 260.0f)
#define Subs_y3 (iPad ? 230.0f : 70.0f)

//Hockey
#define Pos_x1_hockey (iPad ? 164.0f : 50.0f)
#define Pos_x2_hockey (iPad ? 484.0f : 210.0f)
#define Pos_x3_hockey (iPad ? 10.0f : 2.0f)
#define Pos_x4_hockey (iPad ? 164.0f : 66.0f)
#define Pos_x5_hockey (iPad ? 484.0f : 194.0f)
#define Pos_x6_hockey (iPad ? 640.0f : 258.0f)
#define Pos_y1_hockey (iPad ? 110.0f : 45.0f)
#define Pos_y2_hockey (iPad ? 260.0f : 120.0f)
#define Pos_y3_hockey (iPad ? 410.0f : 195.0f)
#define Pos_y4_hockey (iPad ? 560.0f : 270.0f)
#define Subs_x1_hockey (iPad ? 324.0f : 130.0f)
#define Subs_x2_hockey (iPad ? 70.0f : 10.0f)
#define Subs_x3_hockey (iPad ? 230.0f : 90.0f)
#define Subs_x4_hockey (iPad ? 400.0f : 170.0f)
#define Subs_x5_hockey (iPad ? 560.0f : 250.0f)
#define Subs_y1_hockey (iPad ? 480.0f : 185.0f)
#define Subs_y2_hockey (iPad ? 630.0f : 260.0f)
#define Subs_y3_hockey (iPad ? 230.0f : 70.0f)

//Baseball
#define Pos_x1_baseball (iPad ? 324.0f : 130.0f)
#define Pos_x2_baseball (iPad ? 160.0f : 60.0f)
#define Pos_x3_baseball (iPad ? 490.0f : 200.0f)
#define Pos_x4_baseball (iPad ? 230.0f : 90.0f)
#define Pos_x5_baseball (iPad ? 415.0f : 170.0f)
#define Pos_x6_baseball (iPad ? 75.0f : 26.0f)
#define Pos_x7_baseball (iPad ? 572.0f : 234.0f)
#define Pos_y1_baseball (iPad ? 510.0f : 230.0f)
#define Pos_y2_baseball (iPad ? 375.0f : 170.0f)
#define Pos_y3_baseball (iPad ? 245.0f : 110.0f)
#define Pos_y4_baseball (iPad ? 115.0f : 60.0f)
#define Pos_y5_baseball (iPad ? 42.0f : 30.0f)
#define Subs_x1_baseball (iPad ? 324.0f : 130.0f)
#define Subs_x2_baseball (iPad ? 70.0f : 10.0f)
#define Subs_x3_baseball (iPad ? 230.0f : 90.0f)
#define Subs_x4_baseball (iPad ? 400.0f : 170.0f)
#define Subs_x5_baseball (iPad ? 560.0f : 250.0f)
#define Subs_y1_baseball (iPad ? 430.0f : 165.0f)
#define Subs_y2_baseball (iPad ? 580.0f : 240.0f)
#define Subs_y3_baseball (iPad ? 180.0f : 50.0f)

#define DIALOG_CONTENT_MARGIN (20.0f*SCALE_IPAD)
#define DIALOG_CELL_WIDTH (CELL_CONTENT_WIDTH - DIALOG_CONTENT_MARGIN*3)

#define GAME_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define GAME_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define WS_URL [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GAME_URL"]

#import "MailView.h"
#import "ChatView.h"
#import "DialogBoxView.h"
#import "TemplateView.h"
#import "LoginView.h"
#import "DynamicCell.h"
#import "DCFineTuneSlider.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@class LoadingView;
@class PlayerCell;
@class MainView;

@interface Globals : NSObject <AVAudioPlayerDelegate, CLLocationManagerDelegate, TemplateDelegate>

@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) DialogBoxView *dialogBox;
@property (nonatomic, strong) TemplateView *templateView;
@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) NSMutableArray *viewControllerStack;
@property (nonatomic, strong) AVAudioPlayer *buttonAudio;
@property (nonatomic, strong) AVAudioPlayer *backAudio;
@property (nonatomic, strong) AVAudioPlayer *moneyAudio;
@property (nonatomic, strong) AVAudioPlayer *winAudio;
@property (nonatomic, strong) AVAudioPlayer *loseAudio;
@property (nonatomic, strong) NSDictionary *wsSalesData;
@property (nonatomic, strong) NSDictionary *wsEventSolo;
@property (nonatomic, strong) NSDictionary *wsEventAlliance;
@property (nonatomic, strong) NSDictionary *wsProductIdentifiers;
@property (nonatomic, strong) NSMutableDictionary *wsClubDict;
@property (nonatomic, strong) NSDictionary *wsBaseData;
@property (nonatomic, strong) NSDictionary *wsWorldData;
@property (nonatomic, strong) NSDictionary *wsClubInfoData;
@property (nonatomic, strong) NSDictionary *localMailReplyDict;
@property (nonatomic, strong) NSMutableArray *wsReportData;
@property (nonatomic, strong) NSMutableArray *wsMailArray;
@property (nonatomic, strong) NSMutableArray *wsMailReplyArray;
@property (nonatomic, strong) NSMutableArray *localReportData;
@property (nonatomic, strong) NSMutableArray *localMailArray;
@property (nonatomic, strong) NSMutableArray *wsChatArray;
@property (nonatomic, strong) NSMutableArray *wsChatFullArray;
@property (nonatomic, strong) NSMutableArray *wsAllianceChatArray;
@property (nonatomic, strong) NSMutableArray *wsAllianceChatFullArray;
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
@property (nonatomic, strong) UILocalNotification* loginNotification;
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
@property (nonatomic, strong) NSDateFormatter *dateFormat;

@property (nonatomic, assign) NSTimeInterval offsetServerTimeInterval;
@property (nonatomic, assign) NSInteger selectedDivision;
@property (nonatomic, assign) NSInteger selectedSeries;
@property (nonatomic, assign) NSInteger workingSquad;
@property (nonatomic, assign) NSInteger energy;
@property (nonatomic, assign) BOOL gettingChatWorld;
@property (nonatomic, assign) BOOL gettingChatAlliance;

typedef void (^returnBlock)(BOOL success, NSData *data);

+ (void)postServer:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock;
+ (void)postServerLoading:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock;

+ (void)getServer:(NSString *)wsurl :(returnBlock)completionBlock;
+ (void)getServerLoading:(NSString *)wsurl :(returnBlock)completionBlock;

+ (void)getServerNew:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
+ (void)getServerLoadingNew:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
+ (void)getSpLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;

+ (Globals *)i;
+ (NSOperationQueue *)connectionQueue;
- (NSString *)GameId;
- (NSString *)UID;
- (NSString *)world_url;
- (void)setUID:(NSString *)user_uid;
- (void)showLoadingAlert;
- (void)removeLoadingAlert;
- (void)showToast:(NSString *)message optionalTitle:(NSString *)title optionalImage:(NSString *)imagename;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType :(NSInteger)selectedIndex :(UIViewController *)headerView;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType :(NSInteger)selectedIndex;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title;
- (void)closeTemplate;
- (void)showDialog:(NSString *)l1;
- (void)showDialogBlock:(NSString *)l1 :(NSInteger)type :(DialogBlock)block;
- (void)showDialogError;
- (void)setLat:(NSString *)lat;
- (NSString *)getLat;
- (void)setLongi:(NSString *)longi;
- (NSString *)getLongi;
- (void)setDtoken:(NSString *)dt;
- (NSString *)getDtoken;
- (double)Random_next:(double)min to:(double)max;
- (void)scheduleNotification:(NSDate *)f_date :(NSString *)alert_body;
- (void)resetLoginReminderNotification;
- (NSString *)BoolToBit: (NSString *)boolString;
- (NSString *)shortNumberFormat:(NSString *)val;
- (NSTimeInterval)updateTime;
- (NSString *)getServerTimeString;
- (NSString *)getServerDateTimeString;
- (NSString *)getTimeAgo:(NSString *)datetimestring;
- (void)buttonSound;
- (void)initSound;
- (void)moneySound;
- (void)toasterSound;
- (void)winSound;
- (void)loseSound;
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
- (void)showLogin:(LoginBlock)block;
- (void)saveLocation;
- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)updateMyAchievementsData;
- (BOOL)updateClubData;
- (void)getServerClubData:(returnBlock)completionBlock;
- (void)updateClubInfoData:(NSString *)clubId;
- (void)updateClubInfoFb:(NSString *)fb_id;
- (NSString *)getLastChatID;
- (NSString *)getLastAllianceChatID;
- (void)updateChatData;
- (void)updateAllianceChatData;
- (NSString *)getFirstChatString;
- (NSString *)getSecondChatString;
- (NSString *)getFirstAllianceChatString;
- (NSString *)getSecondAllianceChatString;
- (void)checkVersion;
- (void)updateProductIdentifiers;
- (NSString *)gettPurchasedProduct;
- (void)settPurchasedProduct:(NSString *)type;
- (NSString *)getCountdownString:(NSTimeInterval)differenceSeconds;
- (NSInteger)xpFromLevel:(NSInteger)level;
- (NSInteger)levelFromXp:(NSInteger)xp;
- (NSInteger)getXp;
- (NSInteger)getXpMax;
- (NSInteger)getXpMaxBefore;
- (NSInteger)getLevel;
- (NSString *)intString:(NSInteger)val;
- (NSString *)numberFormat:(NSString *)val;
- (NSString *)gettLoginBonus;
- (void)settLoginBonus:(NSString *)amount;
- (NSDictionary *)gettLocalMailReply;
- (void)settLocalMailReply:(NSDictionary *)rd;
- (NSArray *)findMailReply:(NSString *)mail_id;
- (void)updateMailReply:(NSString *)mail_id;
- (NSInteger)getMailBadgeNumber;
- (NSMutableArray *)gettLocalMailData;
- (void)settLocalMailData:(NSMutableArray *)rd;
- (void)addLocalMailData:(NSMutableArray *)rd;
- (NSString *)gettLastMailId;
- (void)settLastMailId:(NSString *)rid;
- (void)addMailReply:(NSString *)mail_id :(NSArray *)mail_reply;
- (void)deleteLocalMail:(NSString *)mail_id;
- (void)replyCounterPlus:(NSString *)mail_id;
- (void)flushViewControllerStack;
- (void)pushViewControllerStack:(UIViewController *)view;
- (UIViewController *)popViewControllerStack;
- (UIViewController *)peekViewControllerStack;
- (UIViewController *)firstViewControllerStack;
- (BOOL)isCurrentView:(UIViewController *)view;
- (void)pushChatVC:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid;
- (void)fbPublishStory:(NSString *)message :(NSString *)caption :(NSString *)picture;
- (NSString *)currentViewTitle;

//SPORTS
- (NSString *)getFaceImageName:(NSString *)player_id;
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

- (UIImage *)dynamicImage:(CGRect)frame prefix:(NSString *)prefix;

- (UIButton *)dynamicButtonWithTitle:(NSString *)title
                              target:(id)target
                            selector:(SEL)selector
                               frame:(CGRect)frame
                                type:(NSString *)type;

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
- (void)updateMarqueeData;
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
- (void)updateAllianceCupFixturesData:(NSString *)a_id round:(NSString *)round;
- (NSMutableArray *)getAllianceCupFixturesData;
- (void)showLoading;
- (void)removeLoading;
- (BOOL)updateSalesData;
- (NSDateFormatter *)getDateFormat;
- (void)closeAllTemplate;
- (BOOL)updateEventSolo;
- (BOOL)updateEventAlliance;

@end
