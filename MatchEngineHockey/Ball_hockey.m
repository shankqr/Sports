
#import "Defines_hockey.h"
#import "Ball_hockey.h"
#import "Player_hockey.h"
#import "Goal_hockey.h"
#import "Globals.h"

@implementation Ball_hockey
@synthesize GameController;
@synthesize team;
@synthesize player;
@synthesize kickedBy;
@synthesize movingToObj;
@synthesize movingTo;
@synthesize outOfPlay;
@synthesize inGoal;
@synthesize saved;
@synthesize toPosition;
@synthesize maxSpeed;
@synthesize speed;
@synthesize steps;
@synthesize speedV;
@synthesize offGround;
@synthesize vector;
@synthesize xx;
@synthesize yy;

- (id)init
{
    if (self = [super init])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            myImage = [SPImage imageWithContentsOfFile:@"engine_ball_hockey@2x.png"];
            myImage.scaleX = 2.0f;
            myImage.scaleY = 2.0f;
        }
        else
        {
            myImage = [SPImage imageWithContentsOfFile:@"engine_ball_hockey.png"];
        }
		myImage.x = -myImage.width/2;
		myImage.y = -myImage.height/2;
		//myImage.color = 0xEE7600;
		[self addChild:myImage];
        
        toPosition = NO; //Set if the ball is on its way somewhere
        maxSpeed = 8; //15
        vector = [[SPPoint alloc] initWithX:0 y:0];
        
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];

	}
    return self;
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event 
{
    rotation += 20;
    //self.rotation = SP_D2R(rotation);
}

- (void)reset 
{
    saved = NO;
    outOfPlay = NO;
    inGoal = NO;
	self.xx = 0;
    self.yy = 0;
    speed = 6; //12
    steps = 0;
    speedV = 0;
    offGround = 0;
    team = -1;
    toPosition = NO;
    movingToObj = Nil;
    movingTo = Nil;
    kickedBy = Nil;
    player = Nil;
    self.vector.x = 0;
    self.vector.y = 0;
}

- (BOOL)outOfPitch
{
    if((self.xx < 0) || (self.xx > PITCH_WIDTH) || (self.yy < 0) || (self.yy > PITCH_HEIGHT))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)move
{
    if (player != Nil) 
    {
        player.nameTextField.text = player.name;

        self.xx = player.xx + [[Globals i] Random_next:player.vector.x*1 to:player.vector.x*2.5];
        self.yy = player.yy + [[Globals i] Random_next:player.vector.y*1 to:player.vector.y*2.5];
        [self moveTo:self.xx mY:self.yy];
    }
    
    if((fabs(self.vector.x) == 0) && (fabs(self.vector.y) == 0))
    {

    }
    else
    {
        if (movingToObj != Nil)
        {
            double distFromTarget = [self getDistance:self.movingToObj.point];
            if((distFromTarget < self.speed) && (self.offGround < PLAYER_HEIGHT))
            {
                [self.movingToObj gotBall];
            }
        }

        double newX = self.xx + self.vector.x;
        double newY = self.yy + self.vector.y;
    
        if((self.offGround == 0) && (self.speedV == 0))
        {
            self.vector.x *= .99;
            self.vector.y *= .99;
        }
        else
        {
            self.speedV -= GRAVITY;
            self.offGround += self.speedV;
        }
    
        if((self.offGround <= 0) && (fabs(self.speedV) > 0))
        {
            self.offGround *= -1;
            self.speedV *= -.7;
            self.vector.x *= .95;
            self.vector.y *= .95;
        }
        else if((fabs(self.offGround) < 2) && (fabs(self.speedV) < 2))
        {
            self.offGround = 0;
            self.speedV = 0;
        }
    
        self.steps--;
        [self moveTo:newX mY:newY];
    }
}

- (SPPoint *)moveTowards:(SPPoint *)obj
{
    //Where will the player be by the time the ball gets there?
    double distX = obj.x - self.xx;
    double distY = obj.y - self.yy;
    double dist = sqrt((distX * distX) + (distY * distY));
    double finalX = obj.x;
    double finalY = obj.y;
    
    //Now we know the spot to aim for
    if (self.movingTo != Nil) 
    {
        self.movingTo.x = finalX;
        self.movingTo.y = finalY;
    }
    else
    {
        self.movingTo = [[SPPoint alloc] initWithX:finalX y:finalY];
    }
    distX = finalX - self.xx;
    distY = finalY - self.yy;
    dist = sqrt((distX * distX) + (distY * distY));
    double prop = self.speed / dist;
    self.vector.x = (distX*prop);
    self.vector.y = (distY*prop);
    self.steps = ceil(dist / self.speed);
    
    return movingTo;
}

- (SPPoint *)moveTowardsPlayer:(Player_hockey *)obj
{
    //Where will the player be by the time the ball gets there?
    double distX = obj.xx - self.xx;
    double distY = obj.yy - self.yy;
    double dist = sqrt((distX * distX) + (distY * distY));
    double finalX = obj.xx;
    double finalY = obj.yy;

    double numFrames = dist / self.speed;
    finalX += (obj.vector.x * numFrames);
    finalY += (obj.vector.y * numFrames);
    
    //Now we know the spot to aim for
    if (self.movingTo != Nil) 
    {
        self.movingTo.x = finalX;
        self.movingTo.y = finalY;
    }
    else
    {
        self.movingTo = [[SPPoint alloc] initWithX:finalX y:finalY];
    }
    distX = finalX - self.xx;
    distY = finalY - self.yy;
    dist = sqrt((distX * distX) + (distY * distY));
    double prop = self.speed / dist;
    self.vector.x = (distX*prop);
    self.vector.y = (distY*prop);
    self.movingToObj = obj;
    self.steps = ceil(dist / self.speed);
    
    return movingTo;
}

- (void)kick
{
    [GameController clearObservers];
    kickedBy = player;
    player = Nil;
}

- (double)getDistance:(SPPoint *)sppoint
{
    SPPoint *p1 = [SPPoint pointWithX:self.xx y:self.yy];
    double dist = [SPPoint distanceFromPoint:p1 toPoint:sppoint];
    return dist;
}

- (void)moveTo:(double)mX mY:(double)mY
{
    self.x = mX + PITCH_WIDTH_OFFSET;
    self.y = mY + PITCH_HEIGHT_OFFSET;// - (self.offGround); //.7 foreshortening of the view
    
    self.xx = mX;
    self.yy = mY;
}

- (SPPoint*)point
{
    return [[SPPoint alloc] initWithX:self.xx y:self.yy];
}

- (void)debug
{
    NSLog(@"Ball atPlayer:%d kickedByPlayer:%d movingToObj:%d steps:%d C(%.2f , %.2f) V<%.2f , %.2f>", player.player_id, kickedBy.player_id, movingToObj.player_id, steps, xx, yy, vector.x, vector.y);
}

@end

