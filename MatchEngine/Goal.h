
#import "Game.h"

@class Player;
@class Ball;

@interface Goal : SPSprite
{
    Game *GameController;
	SPImage *myImage;
    NSInteger team;
    NSInteger side;
}
@property (nonatomic, strong) Game *GameController;
@property (nonatomic) NSInteger team;
@property (nonatomic) NSInteger side;
- (id)init:(NSInteger)s;
+ (Goal *)initGoal:(NSInteger)s;
- (BOOL)checkGoal:(Ball *)ball;
- (Player *)getClosestPlayer;
- (SPPoint*)point;
@end