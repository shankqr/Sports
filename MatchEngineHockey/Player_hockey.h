
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
    NSString *player_name;
    Player_hockey *marking;
    SPPoint *vector;
    SPPoint *basePosition;
    SPPoint *movingTo;
    NSInteger player_number;
    NSInteger player_id;
    NSInteger jersey;
    NSInteger team;
    NSInteger role;
    NSInteger action;
    NSInteger steps;
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
@property (nonatomic, strong) NSString *player_name;
@property (nonatomic, strong) Player_hockey *marking;
@property (nonatomic, strong) SPPoint *vector;
@property (nonatomic, strong) SPPoint *basePosition;
@property (nonatomic, strong) SPPoint *movingTo;
@property (nonatomic, strong) SPTextField *myTextField;
@property (nonatomic, strong) SPTextField *nameTextField;
@property (nonatomic) NSInteger player_number;
@property (nonatomic) NSInteger player_id;
@property (nonatomic) NSInteger jersey;
@property (nonatomic) NSInteger team;
@property (nonatomic) NSInteger role;
@property (nonatomic) NSInteger action;
@property (nonatomic) NSInteger steps;
@property (nonatomic) double actionCountdown;
@property (nonatomic) double speed;
@property (nonatomic) double maxSpeed;
@property (nonatomic) double xx;
@property (nonatomic) double yy;
@property (nonatomic) BOOL scorer;
- (id)init:(NSInteger)p_id number:(NSInteger)num jersey:(NSInteger)jer team:(NSInteger)t role:(NSInteger)r name:(NSString*)n;
+ (Player_hockey *)initPlayer:(NSInteger)player_id number:(NSInteger)number jersey:(NSInteger)jersey team:(NSInteger)team role:(NSInteger)role name:(NSString*)name;
- (void)reset;
- (void)move;
- (void)position:(double)proportionAlongPitch proportionDownPitch:(double)proportionDownPitch rightHalf:(BOOL)rightHalf variance:(double)variance;
- (SPPoint *)moveTowards:(SPPoint *)obj speed:(double)spd;
- (void)turn;
- (void)decideMove;
- (NSInteger)base_decideMove;
- (void)getBall;
- (BOOL)isOffside;
- (double)getOffside:(double)posX;
- (NSMutableArray *)getNearestPlayers:(BOOL)ownTeam num:(NSInteger)num;
- (Player_hockey *)getNearest:(BOOL)ownTeam;
- (void)gotBall;
- (void)shoot;
- (NSInteger)pass:(double)urgency;
- (void)passTo:(Player_hockey *)obj;
- (void)returnTo:(double)pitchProportion pitchRandMultiplier:(double)pitchRandMultiplier narrowness:(double)narrowness;
- (double)getDistance:(SPPoint *)sppoint;
- (void)moveTo:(double)mX mY:(double)mY;
- (SPPoint*)point;
@end