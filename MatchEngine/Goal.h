
#import "Game.h"

@class Player;
@class Ball;

@interface Goal : SPSprite
{
    Game *GameController;
	SPImage *myImage;
    int team;
    NSInteger side;
}
@property (nonatomic, strong) Game *GameController;
@property (nonatomic, assign) int team;
@property (nonatomic) NSInteger side;
- (id)init:(NSInteger)s;
+ (Goal *)initGoal:(NSInteger)s;
- (BOOL)checkGoal:(Ball *)ball;
- (Player *)getClosestPlayer;
- (SPPoint*)point;
@end