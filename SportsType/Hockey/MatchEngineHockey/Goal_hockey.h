
#import "Game_hockey.h"

@class Player_hockey;
@class Ball_hockey;

@interface Goal_hockey : SPSprite
{
    Game_hockey *GameController;
	SPImage *myImage;
    int team;
    int side;
}
@property (nonatomic, strong) Game_hockey *GameController;
@property (nonatomic) int team;
@property (nonatomic) int side;
- (id)init:(int)s;
+ (Goal_hockey *)initGoal:(int)s;
- (BOOL)checkGoal:(Ball_hockey *)ball;
- (Player_hockey *)getClosestPlayer;
- (SPPoint*)point;
@end