
#import "Game_hockey.h"

@class Player_hockey;
@class Ball_hockey;

@interface Goal_hockey : SPSprite
{
    Game_hockey *GameController;
	SPImage *myImage;
    NSInteger team;
    NSInteger side;
}
@property (nonatomic, strong) Game_hockey *GameController;
@property (nonatomic) NSInteger team;
@property (nonatomic) NSInteger side;
- (id)init:(NSInteger)s;
+ (Goal_hockey *)initGoal:(NSInteger)s;
- (BOOL)checkGoal:(Ball_hockey *)ball;
- (Player_hockey *)getClosestPlayer;
- (SPPoint*)point;
@end