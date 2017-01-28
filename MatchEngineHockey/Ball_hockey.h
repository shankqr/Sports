
#import "Game_hockey.h"

@class Player_hockey;

@interface Ball_hockey : SPSprite 
{
	SPImage *myImage;
    Game_hockey *GameController;
    Player_hockey *player;
    Player_hockey *kickedBy;
    Player_hockey *movingToObj;
    SPPoint *vector;    
    SPPoint *movingTo;
    NSInteger rotation;
    int team;
    NSInteger steps;    
    double xx;
    double yy;
    double maxSpeed;
    double speed;
    double speedV;
    double offGround;
    BOOL outOfPlay;
    BOOL saved;
    BOOL inGoal;
    BOOL toPosition;
}
@property (nonatomic, strong) Game_hockey *GameController;
@property (nonatomic, strong) Player_hockey *player;
@property (nonatomic, strong) Player_hockey *kickedBy;
@property (nonatomic, strong) Player_hockey *movingToObj;
@property (nonatomic, strong) SPPoint *vector;
@property (nonatomic, strong) SPPoint *movingTo;
@property (nonatomic, assign) int team;
@property (nonatomic) NSInteger steps;
@property (nonatomic) double xx;
@property (nonatomic) double yy;
@property (nonatomic) double maxSpeed;
@property (nonatomic) double speed;
@property (nonatomic) double speedV;
@property (nonatomic) double offGround;
@property (nonatomic) BOOL outOfPlay;
@property (nonatomic) BOOL inGoal;
@property (nonatomic) BOOL saved;
@property (nonatomic) BOOL toPosition;
- (void)reset;
- (void)move;
- (BOOL)outOfPitch;
- (void)kick;
- (SPPoint *)moveTowards:(SPPoint *)obj;
- (SPPoint *)moveTowardsPlayer:(Player_hockey *)obj;
- (double)getDistance:(SPPoint *)sppoint;
- (void)moveTo:(double)mX mY:(double)mY;
- (SPPoint*)point;
- (void)debug;
- (void)onEnterFrame:(SPEnterFrameEvent *)event;
@end
