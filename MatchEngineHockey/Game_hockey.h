
#import "Sparrow.h"


@class Ball_hockey;
@class Player_hockey;
@class Goal_hockey;

@interface Game_hockey : SPStage
{
    
	SPTextField *scoreTextField;
	SPTextField *clockTextField;
    SPTextField *highlightTextField;
	SPSprite *pitch;
    Goal_hockey *leftGoal;
    Goal_hockey *rightGoal;
	Ball_hockey *ball;
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
@property (nonatomic, strong) Ball_hockey *ball;
@property (nonatomic, strong) Goal_hockey *leftGoal;
@property (nonatomic, strong) Goal_hockey *rightGoal;
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
