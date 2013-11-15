
#import "Game_hockey.h"

@class Ball_hockey;
@class Goal_hockey;

@interface Player_hockey : SPSprite
{
	SPImage *myImage;
    SPTextField *myTextField;
    SPTextField *nameTextField;
    Game_hockey *GameController;
    Ball_hockey *ball;
    Goal_hockey *defendingGoal;
    Goal_hockey *attackingGoal;
    NSString *name;
    Player_hockey *marking;
    SPPoint *vector;
    SPPoint *basePosition;
    SPPoint *movingTo;
    int player_number;
    int player_id;
    int jersey;
    int team;
    int role;
    int action;
    int steps;
    double actionCountdown;    
    double speed;
    double maxSpeed;
    double xx;
    double yy;
    BOOL scorer;
}
@property (nonatomic, strong) Game_hockey *GameController;
@property (nonatomic, strong) Ball_hockey *ball;
@property (nonatomic, strong) Goal_hockey *defendingGoal;
@property (nonatomic, strong) Goal_hockey *attackingGoal;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Player_hockey *marking;
@property (nonatomic, strong) SPPoint *vector;
@property (nonatomic, strong) SPPoint *basePosition;
@property (nonatomic, strong) SPPoint *movingTo;
@property (nonatomic, strong) SPTextField *myTextField;
@property (nonatomic, strong) SPTextField *nameTextField;
@property (nonatomic) int player_number;
@property (nonatomic) int player_id;
@property (nonatomic) int jersey;
@property (nonatomic) int team;
@property (nonatomic) int role;
@property (nonatomic) int action;
@property (nonatomic) int steps;
@property (nonatomic) double actionCountdown;
@property (nonatomic) double speed;
@property (nonatomic) double maxSpeed;
@property (nonatomic) double xx;
@property (nonatomic) double yy;
@property (nonatomic) BOOL scorer;
- (id)init:(int)p_id number:(int)num jersey:(int)jer team:(int)t role:(int)r name:(NSString*)n;
+ (Player_hockey *)initPlayer:(int)player_id number:(int)number jersey:(int)jersey team:(int)team role:(int)role name:(NSString*)name;
- (void)reset;
- (void)move;
- (void)position:(double)proportionAlongPitch proportionDownPitch:(double)proportionDownPitch rightHalf:(BOOL)rightHalf variance:(double)variance;
- (SPPoint *)moveTowards:(SPPoint *)obj speed:(double)spd;
- (void)turn;
- (void)decideMove;
- (int)base_decideMove;
- (void)getBall;
- (BOOL)isOffside;
- (double)getOffside:(double)posX;
- (NSMutableArray *)getNearestPlayers:(BOOL)ownTeam num:(int)num;
- (Player_hockey *)getNearest:(BOOL)ownTeam;
- (void)gotBall;
- (void)shoot;
- (int)pass:(double)urgency;
- (void)passTo:(Player_hockey *)obj;
- (void)returnTo:(double)pitchProportion pitchRandMultiplier:(double)pitchRandMultiplier narrowness:(double)narrowness;
- (double)getDistance:(SPPoint *)sppoint;
- (void)moveTo:(double)mX mY:(double)mY;
- (SPPoint*)point;
@end