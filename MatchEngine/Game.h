
#import "Sparrow.h"

#define GRAVITY 0.8
#define P_GOALKEEPER 1
#define P_DEFENDER 2
#define P_MIDFIELDER 3
#define P_ATTACKER 4
#define T_HOME 0
#define T_AWAY 1
#define GOAL_LEFT 0
#define GOAL_RIGHT 1
#define ACTION_IDLE 0
#define ACTION_RETURNING 1
#define ACTION_MARKING 2
#define ACTION_INTERCEPTING 3
#define ACTION_ATTACKINGGOAL 4
#define ACTION_RUNNING 5
#define ACTION_GETTINGBALL 6
#define ACTION_KICKINGBALL 7
#define ACTION_PASSEDBALL 8
#define ACTION_CELEBRATING 9
#define ACTION_FINISHED 10
#define ACTION_SAVING 11
#define ACTION_RUNNINGONSIDE 12
#define ACTION_TACKLING 13
#define ACTION_MOVINGTHROW 14
#define ACTION_MOVINGCORNER 15
#define ACTION_TAKINGTHROW 16
#define ACTION_TAKINGCORNER 17

#define PLAYER_WIDTH 9
#define PLAYER_HEIGHT 50
#define PLAYER_SCALE (iPad ? 1.0f : 0.5f)
#define PLAYER_NAME (iPad ? 40.0f : 20.0f)
#define PITCH_WIDTH (iPad ? 940.0f : 470.0f)
#define PITCH_HEIGHT (iPad ? 580.0f : 290.0f)
#define PITCH_WIDTH_OFFSET (iPad ? 10.0f : 5.0f)
#define PITCH_HEIGHT_OFFSET (iPad ? 50.0f : 25.0f)
#define FONT_SIZE (iPad ? 40.0f : 20.0f)
#define GOAL_OFFSET (iPad ? 7.0f : 2.0f)
#define SKIP_OFFSET (iPad ? 180.0f : 100.0f)
#define CLOCK_OFFSET (iPad ? 70.0f : 97.0f)
#define HIGHLIGHT_OFFSET (iPad ? 44.0f : -50.0f)
#define HIGHLIGHT_COLOR (iPad ? 0xffffff : 0x000000)
#define LOGO1_OFFSET (iPad ? 0.0f : 10.0f)
#define LOGO2_OFFSET (iPad ? 140.0f : 100.0f)

@class Ball;
@class Player;
@class Goal;

@interface Game : SPSprite
{
	SPTextField *scoreTextField;
	SPTextField *clockTextField;
    SPTextField *highlightTextField;
	SPSprite *pitch;
    Goal *leftGoal;
    Goal *rightGoal;
	Ball *ball;
    SPButton *homeLogo;
    SPButton *awayLogo;
    SPSoundChannel *soundCrowd;
    SPSoundChannel *soundGoal;
    SPSoundChannel *soundMiss;
    SPSoundChannel *soundChant;
    SPSoundChannel *soundShoot;
    SPSoundChannel *soundFinish;
    SPSound *music1;
    SPSound *music2;
    SPSound *music3;
    SPSound *music4;
    NSMutableArray *teamsFormation;
    NSMutableArray *attackingGoal;
    NSMutableArray *defendingGoal;
    NSMutableArray *teams;
    NSMutableArray *homeTeam;
    NSMutableArray *awayTeam;
    NSMutableArray *players;
    NSMutableArray *highlights;
    NSMutableDictionary *highlight;
    NSInteger num;
	NSInteger goalsHome;
	NSInteger goalsAway;
    double seconds; 
    double frame;
    double frameTime;
    double maxFrames;
    double avMaxFrames;
    double proportion;
    double goalCountdown;
    BOOL played;
    BOOL finished;
    BOOL paused;
}
@property (nonatomic) BOOL played;
@property (nonatomic) double proportion;
@property (nonatomic, strong) Ball *ball;
@property (nonatomic, strong) Goal *leftGoal;
@property (nonatomic, strong) Goal *rightGoal;
@property (nonatomic, strong) SPButton *homeLogo;
@property (nonatomic, strong) SPButton *awayLogo;
@property (nonatomic, strong) SPSoundChannel *soundCrowd;
@property (nonatomic, strong) SPSoundChannel *soundGoal;
@property (nonatomic, strong) SPSoundChannel *soundMiss;
@property (nonatomic, strong) SPSoundChannel *soundChant;
@property (nonatomic, strong) SPSoundChannel *soundShoot;
@property (nonatomic, strong) SPSoundChannel *soundFinish;
@property (nonatomic, strong) SPSound *music1;
@property (nonatomic, strong) SPSound *music2;
@property (nonatomic, strong) SPSound *music3;
@property (nonatomic, strong) SPSound *music4;
@property (nonatomic, strong) NSMutableArray *teamsFormation;
@property (nonatomic, strong) NSMutableArray *attackingGoal;
@property (nonatomic, strong) NSMutableArray *defendingGoal;
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, strong) NSMutableArray *homeTeam;
@property (nonatomic, strong) NSMutableArray *awayTeam;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSMutableArray *highlights;
@property (nonatomic, strong) NSMutableDictionary *highlight;
- (void)onEnterFrame:(SPEnterFrameEvent *)event;
- (void)ball_out;
- (void)teamDraw:(NSInteger)team rightHalf:(BOOL)rightHalf hasChance:(BOOL)hasChance hasPossession:(BOOL)hasPossession;
- (void)clearObservers;
- (void)getBall;
- (void)startHighlight;
- (void)finishedHighlights;
- (void)onTouch:(SPTouchEvent *)event;
- (void)drawScore;
- (void)drawClock;
- (void)setHighlightText:(NSString *)text;
- (void)playSoundShoot;
- (void)playSoundGoal;
- (void)exitGame;
- (void)loadClub;
@end
