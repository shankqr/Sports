
#import "Defines_hockey.h"
#import "Goal_hockey.h"
#import "Player_hockey.h"
#import "Ball_hockey.h"
#import "Globals.h"

@implementation Goal_hockey
@synthesize GameController;
@synthesize team;
@synthesize side;


- (id)init:(NSInteger)s
{
    if (self = [super init]) 
    {
        self.side = s;
        self.y = (PITCH_HEIGHT/2)+PITCH_HEIGHT_OFFSET+GOAL_OFFSET;
        
        if (side == 0)
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                myImage = [SPImage imageWithContentsOfFile:@"engine_goal_left_hockey@2x.png"];
                myImage.scaleX = 2.0f;
                myImage.scaleY = 2.0f;
            }
            else
            {
                myImage = [SPImage imageWithContentsOfFile:@"engine_goal_left_hockey.png"];
            }
            self.x = 0;
            myImage.x = -myImage.width + PITCH_WIDTH_OFFSET;
        }
        else
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                myImage = [SPImage imageWithContentsOfFile:@"engine_goal_right_hockey@2x.png"];
                myImage.scaleX = 2.0f;
                myImage.scaleY = 2.0f;
            }
            else
            {
                myImage = [SPImage imageWithContentsOfFile:@"engine_goal_right_hockey.png"];
            }
            self.x = PITCH_WIDTH;
            myImage.x = 0 + PITCH_WIDTH_OFFSET;
        }
        
		myImage.y = -myImage.height/2;
        
		[self addChild:myImage];
	}
    return self;
}


+ (Goal_hockey *)initGoal:(NSInteger)s
{
	return [[Goal_hockey alloc] init:s];
}

- (BOOL)checkGoal:(Ball_hockey *)ball
{
    //TODO: hit the post
    //BOOL crossedLine = NO;
    if (((self.side == GOAL_LEFT) && (ball.xx < self.x)) ||
        ((self.side == GOAL_RIGHT) && (ball.xx > self.x)))
    {
        //crossedLine = YES;
        
        //if ((ball.yy > self.y - self.height/2) && (ball.yy < self.y + self.height/2) && (ball.offGround < 10)) 
        //{
            if ((([(GameController.highlight)[@"type_id"] integerValue]==1) && (self.team == T_AWAY)) 
                || (([(GameController.highlight)[@"type_id"] integerValue]==2) && (self.team == T_HOME)))
            {
                    ball.inGoal = YES;
                    return YES;
            }
        //}
    }
    //TODO: make the ball stop at the back of the net
    return NO;
}

- (Player_hockey *)getClosestPlayer
{
    double minDist = 9999;
    Player_hockey *nearest;
    
    for (Player_hockey *p in GameController.players) 
    {
        SPPoint *p1 = [SPPoint pointWithX:self.x y:self.y];
        SPPoint *p2 = [SPPoint pointWithX:p.xx y:p.yy];
        double dist = [SPPoint distanceFromPoint:p1 toPoint:p2];
        if (dist < minDist) 
        {
            minDist = dist;
            nearest = p;
        }
    }
    return nearest;
}

- (SPPoint*)point
{
    return [[SPPoint alloc] initWithX:self.x y:self.y];
}

@end
