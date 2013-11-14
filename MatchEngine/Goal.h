
#import "Game.h"

@class Player;
@class Ball;

@interface Goal : SPSprite
{
    Game *GameController;
	SPImage *myImage;
    int team;
    int side;
}
@property (nonatomic, strong) Game *GameController;
@property (nonatomic) int team;
@property (nonatomic) int side;
- (id)init:(int)s;
+ (Goal *)initGoal:(int)s;
- (BOOL)checkGoal:(Ball *)ball;
- (Player *)getClosestPlayer;
- (SPPoint*)point;
@end