
#import "Game.h"

@class Player;

@interface Ball : SPSprite 
{
	SPImage *myImage;
    Game *GameController;
    Player *player;
    Player *kickedBy;
    Player *movingToObj;
    SPPoint *vector;    
    SPPoint *movingTo;
    int rotation;
    int team;
    int steps;    
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
@property (nonatomic, strong) Game *GameController;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Player *kickedBy;
@property (nonatomic, strong) Player *movingToObj;
@property (nonatomic, strong) SPPoint *vector;
@property (nonatomic, strong) SPPoint *movingTo;
@property (nonatomic) int team;
@property (nonatomic) int steps;
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
- (SPPoint *)moveTowardsPlayer:(Player *)obj;
- (double)getDistance:(SPPoint *)sppoint;
- (void)moveTo:(double)mX mY:(double)mY;
- (SPPoint*)point;
- (void)debug;
- (void)onEnterFrame:(SPEnterFrameEvent *)event;
@end
