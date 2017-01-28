
#import "Game.h"

@class Ball;
@class Goal;

@interface Player : SPSprite
{
	SPImage *myImage;
    SPTextField *myTextField;
    SPTextField *nameTextField;
    Game *GameController;
    Ball *ball;
    Goal *defendingGoal;
    Goal *attackingGoal;
    NSString *player_name;
    Player *marking;
    SPPoint *vector;
    SPPoint *basePosition;
    SPPoint *movingTo;
    NSInteger player_number;
    NSInteger player_id;
    NSInteger jersey;
    int team;
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
@property (nonatomic, strong) Game *GameController;
@property (nonatomic, strong) Ball *ball;
@property (nonatomic, strong) Goal *defendingGoal;
@property (nonatomic, strong) Goal *attackingGoal;
@property (nonatomic, strong) NSString *player_name;
@property (nonatomic, strong) Player *marking;
@property (nonatomic, strong) SPPoint *vector;
@property (nonatomic, strong) SPPoint *basePosition;
@property (nonatomic, strong) SPPoint *movingTo;
@property (nonatomic, strong) SPTextField *myTextField;
@property (nonatomic, strong) SPTextField *nameTextField;
@property (nonatomic) NSInteger player_number;
@property (nonatomic) NSInteger player_id;
@property (nonatomic) NSInteger jersey;
@property (nonatomic, assign) int team;
@property (nonatomic) NSInteger role;
@property (nonatomic) NSInteger action;
@property (nonatomic) NSInteger steps;
@property (nonatomic) double actionCountdown;
@property (nonatomic) double speed;
@property (nonatomic) double maxSpeed;
@property (nonatomic) double xx;
@property (nonatomic) double yy;
@property (nonatomic) BOOL scorer;
- (id)init:(NSInteger)p_id number:(NSInteger)num jersey:(NSInteger)jer team:(int)t role:(NSInteger)r name:(NSString*)n;
+ (Player *)initPlayer:(NSInteger)player_id number:(NSInteger)number jersey:(NSInteger)jersey team:(int)team role:(NSInteger)role name:(NSString*)name;
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
- (Player *)getNearest:(BOOL)ownTeam;
- (void)gotBall;
- (void)shoot;
- (NSInteger)pass:(double)urgency;
- (void)passTo:(Player *)obj;
- (void)returnTo:(double)pitchProportion pitchRandMultiplier:(double)pitchRandMultiplier narrowness:(double)narrowness;
- (double)getDistance:(SPPoint *)sppoint;
- (void)moveTo:(double)mX mY:(double)mY;
- (SPPoint*)point;
@end