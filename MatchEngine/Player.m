
#import "Player.h"
#import "Ball.h"
#import "Goal.h"

#import "Globals.h"

@implementation Player
@synthesize GameController;
@synthesize ball;
@synthesize defendingGoal;
@synthesize attackingGoal;
@synthesize player_number;
@synthesize player_id;
@synthesize jersey;
@synthesize team;
@synthesize role;
@synthesize action;
@synthesize actionCountdown;
@synthesize steps;
@synthesize speed;
@synthesize maxSpeed;
@synthesize scorer;
@synthesize player_name;
@synthesize marking;
@synthesize vector;
@synthesize basePosition;
@synthesize movingTo;
@synthesize xx;
@synthesize yy;
@synthesize myTextField;
@synthesize nameTextField;


- (id)init:(int)p_id number:(int)num jersey:(int)jer team:(int)t role:(int)r name:(NSString*)n
{
    if (self = [super init]) 
    {
        self.player_id = p_id;
        self.player_number = num;
        self.jersey = jer;
        self.team = t;
        self.role = r;
        self.player_name = n;
        
        myImage = [SPImage imageWithContentsOfFile:[NSString stringWithFormat:@"j%d.png", self.jersey]];       
        [myImage setScaleX:PLAYER_SCALE];
        [myImage setScaleY:PLAYER_SCALE];
		myImage.x = -myImage.width/2;
		myImage.y = -myImage.height/2;
		[self addChild:myImage];
        
        if (self.team == T_AWAY) 
        {
            myTextField = [SPTextField textFieldWithText:[NSString stringWithFormat:@"%d", self.player_number]];
            myTextField.fontName = DEFAULT_FONT;
            myTextField.x = -myTextField.width/2;
            myTextField.y = -myTextField.height/2 - 2;
            myTextField.vAlign = SPVAlignCenter;
            myTextField.fontSize = 28.0*PLAYER_SCALE;
            [self addChild:myTextField];
        }
        
        nameTextField = [SPTextField textFieldWithText:@""];
        nameTextField.fontName = DEFAULT_FONT;
        nameTextField.x = -myTextField.width/2;
        nameTextField.y = -myTextField.height/2 - PLAYER_NAME;
        nameTextField.vAlign = SPVAlignCenter;
        nameTextField.fontSize = 22.0*PLAYER_SCALE;
        nameTextField.color = 0xffffff;
        [self addChild:nameTextField];
        
        self.vector = [[SPPoint alloc] initWithX:0.0f y:0.0f];
        self.basePosition = [[SPPoint alloc] initWithX:0.0f y:0.0f];
	}
    return self;
}

+ (Player *)initPlayer:(int)player_id number:(int)number jersey:(int)jersey team:(int)team role:(int)role name:(NSString*)name
{
	return [[Player alloc] init:player_id number:number jersey:jersey team:team role:role name:name];
}

- (void)reset 
{
    self.action = ACTION_IDLE;
    self.steps = -1;
    self.movingTo = Nil;
    self.scorer = NO;
    self.maxSpeed = 3;
    self.actionCountdown = 0;
    self.marking = Nil;
    self.basePosition.x = 0;
    self.basePosition.y = 0;
	self.xx = 0;
    self.yy = 0;
    self.speed = self.maxSpeed*[[Globals i] Random_next:0.4 to:0.8];
    self.vector.x = 0;
    self.vector.y = 0;
    nameTextField.text = @"";
}

- (void)move
{
    if (self.steps > 0)
    {

    double newX=0;
    double newY=0;
    if ((self.movingTo != Nil) && ([self getDistance:self.movingTo]<2))
    {
        newX = self.movingTo.x;
        newY = self.movingTo.y;
        self.steps = 0;
        self.vector.x = 0;
        self.vector.y = 0;
        if((self.action != ACTION_PASSEDBALL) && (self.action != ACTION_SAVING))
        {
            self.action = ACTION_IDLE;
        }
    }
    else
    {
        double minDist = PITCH_WIDTH;
        Player *obstruction = Nil;
        newX = self.xx + self.vector.x;
        newY = self.yy + self.vector.y;
        if((self.action!=ACTION_TACKLING) && (self.action!=ACTION_PASSEDBALL) && (self.action!=ACTION_MOVINGCORNER) && (self.action!=ACTION_MOVINGTHROW))
        {
            //Check for obstructions
            for (Player *p in GameController.players) 
            {
                if(p.player_id != self.player_id)
                {
                    double newDist = [p getDistance:[SPPoint pointWithX:newX y:newY]];
                    double dist = [p getDistance:[SPPoint pointWithX:self.xx y:self.yy]];
                    double minWidth = 1;
                    if (p.team==self.team) 
                    {
                        minWidth=0.25;
                    }
                    else
                    {
                        minWidth=1;
                    }
                    if ((newDist < dist) && (newDist < PLAYER_WIDTH * minWidth)) 
                    {
                        if (newDist < minDist) 
                        {
                            minDist = newDist;
                            obstruction = p;
                        }
                    }
                }
            }
            if (obstruction != Nil) 
            {
                double random = 1;
                if ([[Globals i] Random_next:0 to:1] < 0.5)
                {
                    random = -1;
                }
                else
                {
                    random = 1;
                }
                double angle = PI / 2 * random;
                self.vector.x = (self.vector.x * cosf(angle)) - (self.vector.y * sinf(angle));
                self.vector.y = (self.vector.x * sinf(angle)) + (self.vector.y * cosf(angle));
                newX = self.xx + self.vector.x;
                newY = self.yy + self.vector.y;
                self.actionCountdown = 10;
            }
        }
        else if(self.action==ACTION_TACKLING)
        {
            self.vector.x *= 0.94;
            self.vector.y *= 0.94;
        }
    }
    
    if (newX < 0) 
    {
        newX = 0;
        self.vector.x *= -0.6;
    }
    else if (newX > PITCH_WIDTH)
    {
        newX = PITCH_WIDTH - 5;
        self.vector.x *= -0.6;
    }
    if (newY < 0) 
    {
        newY = 0;
        self.vector.y *= -0.6;
    }
    else if (newY > PITCH_HEIGHT)
    {
        newY = PITCH_HEIGHT - 5;
        self.vector.y *= -0.6;
    }
    double offsideX = [self getOffside:-1];
    if (offsideX>0) 
    {
        if (fabs(offsideX-self.xx) < fabs(offsideX-self.xx-self.vector.x))
        {
            self.vector.x = -self.vector.x;
            self.vector.y = -self.vector.y;
            self.action = ACTION_RUNNINGONSIDE;
            self.actionCountdown = 50;
        }
    }
    
    [self moveTo:newX mY:newY];
    if (ball.player.player_id == self.player_id) 
    {
        [ball moveTo:self.xx mY:self.yy];
    }
}
}

- (void)position:(double)proportionAlongPitch proportionDownPitch:(double)proportionDownPitch rightHalf:(BOOL)rightHalf variance:(double)variance
{
    //Variance = how far the player might wander. Attackers wander more than defenders
    //Set positions the players aim to return to
    
    double baseX = 0;
    double baseY = 0;
    if (rightHalf) 
    {
        baseX = PITCH_WIDTH - proportionAlongPitch*PITCH_WIDTH;
    }
    else
    {
        baseX = proportionAlongPitch * PITCH_WIDTH;
    }
    baseY = PITCH_HEIGHT * proportionDownPitch;
    
    self.basePosition.x = baseX;
    self.basePosition.y = baseY;
    
    double scaleX = (1/proportionAlongPitch);
    double propX = [[Globals i] Random_next:0 to:scaleX];
    propX = pow(propX, variance);
    propX = proportionAlongPitch * propX;
    
    double scaleY = (1/proportionDownPitch);
    double propY = [[Globals i] Random_next:0 to:scaleY];
    propY = pow(propY, variance);
    propY = proportionDownPitch * propY;
    
    if (rightHalf)
    {
        self.xx = PITCH_WIDTH - propX*PITCH_WIDTH;
    }
    else
    {
        self.xx = propX * PITCH_WIDTH;
    }
    
    self.yy = PITCH_HEIGHT * propY;
    [self moveTo:self.xx mY:self.yy];
}

- (SPPoint *)moveTowards:(SPPoint *)obj speed:(double)spd
{
    double distX = obj.x - self.xx;
    double distY = obj.y - self.yy;
    double dist = sqrt((distX*distX)+(distY*distY));
    if (spd != 0) 
    {
        self.speed = speed;
    }
    if (dist < 2) 
    {
        self.vector.x = 0;
        self.vector.y = 0;
        self.movingTo = Nil;
    }
    else if(dist > 0)
    {
        double prop = speed / dist;
        self.vector.x = distX*prop;
        self.vector.y = distY*prop;
        self.steps = dist / speed;
        if (self.movingTo!=Nil) 
        {
            self.movingTo.x = obj.x;
            self.movingTo.y = obj.y;
        }
        else
        {
            self.movingTo = [[SPPoint alloc] initWithX:obj.x y:obj.y];
        }
    }
    return self.vector;
}

- (void)decideMove
{
    if (self.action == ACTION_PASSEDBALL) 
    {
        return;
    }
    
    self.defendingGoal = (GameController.defendingGoal)[team];
    self.attackingGoal = (GameController.attackingGoal)[team];
    BOOL playerHasBall = NO;
    if (ball.player.player_id==self.player_id) 
    {
        playerHasBall = YES;
    }
    double distToBall = [self getDistance:ball.point];
    //double distToOwnGoal = [self getDistance:self.defendingGoal.point];
    double ballDistToOwnGoal = [ball getDistance:self.defendingGoal.point];
    BOOL teamHasBall = NO;
    if (ball.team==self.team) 
    {
        teamHasBall = YES;
    }
    BOOL ballWithOppKeeper = NO;
    Player *goalkeeper = Nil;
    for (Player *p in (GameController.teams)[abs(self.team-1)])
    {
        if (p.role==P_GOALKEEPER) 
        {
            goalkeeper = p;
            break;
        }
    }
    if (goalkeeper!=Nil) 
    {
        if(ball.player.player_id == goalkeeper.player_id)
        {
            ballWithOppKeeper = YES;
        }
    }
    
    if (self.role == P_ATTACKER) 
    {
        int actionn = [self base_decideMove];
        if (actionn > -1) 
        {
            self.action = actionn;
        }
        else
        {
            if (!teamHasBall) 
            {
                if((distToBall < PITCH_WIDTH / 10) && (!ballWithOppKeeper))
                {
                    [self getBall];
                }
                else if((ballDistToOwnGoal < PITCH_WIDTH / 5) && (distToBall < PITCH_WIDTH / 6))
                {
                    [self getBall];
                }
                else
                {
                    [self returnTo:0.25 pitchRandMultiplier:3 narrowness:0];
                }
            }
            else if(([[Globals i] Random_next:0 to:1]<0.9) || [self isOffside])
            {
                [self returnTo:0.25 pitchRandMultiplier:3 narrowness:0];
            }
            else
            {
                self.action = ACTION_IDLE;
            }
        }
    }
    if (self.role == P_MIDFIELDER)
    {
        int actionn = [self base_decideMove];
        if (actionn > -1) 
        {
            self.action = actionn;
        }
        else
        {
            if (!teamHasBall) 
            {
                if((distToBall < PITCH_WIDTH / 10) && (!ballWithOppKeeper))
                {
                    [self getBall];
                }
                else if((ballDistToOwnGoal < PITCH_WIDTH / 5) && (distToBall < PITCH_WIDTH / 6))
                {
                    [self getBall];
                }
                else if([[Globals i] Random_next:0 to:1]<0.6)
                {
                    [self returnTo:0.17 pitchRandMultiplier:10 narrowness:0.2];
                }
            }
            else if(([[Globals i] Random_next:0 to:1]<0.6) || [self isOffside])
            {
                [self returnTo:0.2 pitchRandMultiplier:8 narrowness:-1];
            }
            else
            {
                self.action = ACTION_IDLE;
            }
        }
    }
    if (self.role == P_DEFENDER)
    {
        int actionn = [self base_decideMove];
        if (actionn > -1) 
        {
            self.action = actionn;
        }
        else
        {
            if (!teamHasBall) 
            {
                if((distToBall < PITCH_WIDTH / 7) && (!ballWithOppKeeper))
                {
                    [self getBall];
                }
                else if((ballDistToOwnGoal < PITCH_WIDTH / 5) && (distToBall < PITCH_WIDTH / 6))
                {
                    [self getBall];
                }
                else if((self.marking!=Nil) && ([self.marking getDistance:defendingGoal.point]<PITCH_WIDTH/3))
                {
                    self.action = ACTION_MARKING;
                }
                else
                {
                    //double pitchProportion = 0;
                    if(ballDistToOwnGoal < PITCH_WIDTH / 3)
                    {
                        //pitchProportion = 0.1;
                        [self returnTo:-1 pitchRandMultiplier:25 narrowness:0.6];
                    }
                    else
                    {
                        //pitchProportion = 0.014;
                        [self returnTo:0.143 pitchRandMultiplier:25 narrowness:0.3];
                    }
                }
            }//Most of the time won't do anything
            else if(([[Globals i] Random_next:0 to:1]<0.8) || [self isOffside])
            {
                [self returnTo:0.2 pitchRandMultiplier:10 narrowness:-2];
            }
            else
            {
                self.action = ACTION_IDLE;
            }
        }
    }
    if (self.role == P_GOALKEEPER)
    {
        if (self.action == ACTION_SAVING) 
        {
            return;
        }
        
        if (playerHasBall) 
        {
            [self pass:0];
        }
        else
        {
            if (!teamHasBall) 
            {
                if((distToBall < PITCH_WIDTH / 10) && (!ballWithOppKeeper))
                {
                    [self getBall];
                }
                else if(ballDistToOwnGoal < PITCH_WIDTH / 4)
                {
                    [self moveTowards:defendingGoal.point speed:self.speed];
                }
                else if(([[Globals i] Random_next:0 to:1]<0.7) || [self isOffside])
                {
                    [self returnTo:0.067 pitchRandMultiplier:6 narrowness:0.95];
                }
                else
                {
                    self.action = ACTION_IDLE;
                }
            }
            else
            {
                [self returnTo:0.1 pitchRandMultiplier:1 narrowness:-1];
            }

        }
    }
}

- (int)base_decideMove
{
    self.defendingGoal = (GameController.defendingGoal)[team];
    self.attackingGoal = (GameController.attackingGoal)[team];
    
    int actionn = -1;
    BOOL playerHasBall = NO;
    if (ball.player.player_id==self.player_id)
    {
        playerHasBall = YES;
    }

    BOOL teamHasBall = NO;
    if (ball.team == self.team) 
    {
        teamHasBall = YES;
    }
    BOOL actionPlayer = NO;
    if(self.player_id == [(GameController.highlight)[@"player_id"] intValue])
    {
        actionPlayer = YES;
    }
    if (playerHasBall) 
    {
        if(actionPlayer)
        {
            actionn = ACTION_ATTACKINGGOAL;
            double speedd = [[Globals i] Random_next:self.maxSpeed*0.8 to:self.maxSpeed];
            [self moveTowards:[SPPoint pointWithX:attackingGoal.x y:attackingGoal.y] speed:speedd];
        }
        else
        {
            double towardsGoalX = attackingGoal.x - self.xx;
            double towardsGoalY = attackingGoal.y - self.yy;
            double destX = self.xx + towardsGoalX*[[Globals i] Random_next:0.2 to:0.5];
            double propY = fabs(towardsGoalY/(PITCH_HEIGHT/2));
            double destY = self.yy + (towardsGoalY * [[Globals i] Random_next:propY-0.9 to:propY]);
            SPPoint *dest = [SPPoint pointWithX:destX y:destY];
            double speedd = [[Globals i] Random_next:self.maxSpeed*0.7 to:self.maxSpeed];
            [self moveTowards:dest speed:speedd];
            actionn = ACTION_RUNNING;
            self.actionCountdown = 50;
        }
    }
    else
    {
        if (actionPlayer && !GameController.played && teamHasBall && (![self isOffside]))
        {
            actionn = ACTION_ATTACKINGGOAL;
            double speedd = [[Globals i] Random_next:self.maxSpeed*0.5 to:self.maxSpeed*0.8];
            [self moveTowards:[SPPoint pointWithX:attackingGoal.x y:attackingGoal.y] speed:speedd];
            self.actionCountdown = 50;
        }
    }
    return actionn;
}

- (void)getBall
{
    if (self.action != ACTION_SAVING) 
    {
        self.action = ACTION_GETTINGBALL;
    }
}

- (BOOL)isOffside
{
    self.defendingGoal = (GameController.defendingGoal)[team];
    self.attackingGoal = (GameController.attackingGoal)[team];
    
    if ((ball.player.player_id==self.player_id) || (ball.player==Nil)) 
    {
        return NO;
    }
    
    double posX = self.xx;
    BOOL isOffside = YES;
    double minDist = 9999;
    double playerGoalDistX = fabs(self.attackingGoal.x-posX);
	double ballGoalDistX = fabs(self.attackingGoal.x - ball.xx);
	//Can't be offside if you're behind the ball
    if(ballGoalDistX <= playerGoalDistX)
    {
        return NO;
    }
    for (Player *p in (GameController.teams)[abs(self.team-1)])
    {
        if (p.role!=P_GOALKEEPER) 
        {
            double opponentGoalDistX = fabs(self.attackingGoal.x-p.xx);
            if(opponentGoalDistX <= playerGoalDistX)
            {
				return NO;
            }
			else if(playerGoalDistX < minDist)
            {
				//isOffside = p.xx;
            }
        }
    }
    
    return isOffside;
}

- (double)getOffside:(double)posX
{
    self.defendingGoal = (GameController.defendingGoal)[team];
    self.attackingGoal = (GameController.attackingGoal)[team];
    
    if ((ball.player.player_id==self.player_id) || (ball.player==Nil)) 
    {
        return -1;
    }
    
    if (posX == -1) 
    {
        posX = self.xx;
    }
    double isOffside = -1;
    double minDist = 9999;
    double playerGoalDistX = fabs(self.attackingGoal.x-posX);
	double ballGoalDistX = fabs(self.attackingGoal.x - ball.xx);
	//Can't be offside if you're behind the ball
    if(ballGoalDistX <= playerGoalDistX)
    {
        return -1;
    }
    for (Player *p in (GameController.teams)[abs(self.team-1)])
    {
        if (p.role!=P_GOALKEEPER) 
        {
            double opponentGoalDistX = fabs(self.attackingGoal.x-p.xx);
            if(opponentGoalDistX <= playerGoalDistX)
            {
				return -1;
            }
			else if(playerGoalDistX < minDist)
            {
				isOffside = p.xx;
            }
        }
    }
    
    return isOffside;
}


- (Player *)getNearest:(BOOL)ownTeam
{
    double minDist = 99999;
    Player *nearest = Nil;

    NSMutableArray *players;
    if (ownTeam) 
    {
        players = (GameController.teams)[self.team];
    }
    else
    {
        players = (GameController.teams)[abs(self.team-1)];
    }
    
    for(Player *p in players)
    {
        if (p.player_id != self.player_id) 
        {
            double dist = [self getDistance:[SPPoint pointWithX:p.xx y:p.yy]];
            if (dist < minDist) 
            {
                nearest = p;
                minDist = dist;
            }
        }
    }
    return nearest;
}

- (NSMutableArray *)getNearestPlayers:(BOOL)ownTeam num:(int)num
{
    NSMutableArray *playersDistance = [[NSMutableArray alloc] init];
    NSMutableArray *players;
    if (ownTeam) 
    {
        players = (GameController.teams)[self.team];
    }
    else
    {
        players = (GameController.teams)[abs(self.team-1)];
    }
    int player_row = -1;
    for(Player *p in players)
    {
        player_row = player_row + 1;
        if (p.player_id != self.player_id) 
        {
            double dist = [self getDistance:p.point];
            
            NSDictionary *dict = @{@"Player": @(player_row), @"Distance": @(dist)};
            [playersDistance addObject:dict];
            //NSLog(@"Nearest Player[%d]: %.2f", p.player_id, dist);
        }
    }
    
    NSSortDescriptor * d = [[NSSortDescriptor alloc] initWithKey:@"Distance" ascending:YES];
    NSArray * descriptors = @[d];
    NSArray * sortedArray = [playersDistance sortedArrayUsingDescriptors:descriptors];
    
    NSMutableArray *nearest = [[NSMutableArray alloc] init];
    for (int i=0; i<num; i++) 
    {
        if ([sortedArray count] > i) 
        {
            player_row = [sortedArray[i][@"Player"] intValue];
            [nearest addObject:players[player_row]];
        }
    }

    return nearest;
}

- (void)gotBall
{
    if(((self.role==P_GOALKEEPER) && (![ball outOfPitch])
        && ([(GameController.highlight)[@"type_id"] intValue]<3) 
        && ([(GameController.highlight)[@"player_id"] intValue] == ball.kickedBy.player_id)) 
       || (ball.speed > ball.maxSpeed) 
       || (ball.kickedBy.player_id == self.player_id))
    {
		return;
    }

    if (GameController.played && ([(GameController.highlight)[@"type_id"] intValue]>2)) 
    {
        ball.saved = YES;
    }
    [GameController clearObservers];
    ball.team = self.team;
    ball.xx = self.xx;
    ball.yy = self.yy;
    ball.player = self;
    ball.vector.x = 0;
    ball.vector.y = 0;
    ball.speed = 0;
    ball.speedV = 0;
    ball.steps = 0;
    ball.inGoal = NO;
    
    //Goalkeeper picks up the ball, except backpasses
    if ((self.role==P_GOALKEEPER) && (ball.kickedBy!=Nil) && (ball.kickedBy.team!=self.team))
    {
        ball.offGround = PLAYER_HEIGHT*0.5;
    }
    else
    {
        ball.offGround = 0;
    }
    ball.movingToObj = Nil;
    ball.kickedBy = Nil;
    self.actionCountdown = 50;
}

- (void)shoot
{
    [GameController playSoundShoot];
    [GameController playSoundGoal];
    
    self.defendingGoal = (GameController.defendingGoal)[team];
    self.attackingGoal = (GameController.attackingGoal)[team];
    
    if (GameController.played) 
    {
        return;
    }
    SPPoint *towardsGoal = [SPPoint pointWithX:attackingGoal.x-self.xx y:attackingGoal.y-self.yy];
    if ([self.vector angleToPoint:towardsGoal] < 60) 
    {
        if ([(GameController.highlight)[@"type_id"] intValue]<3) 
        {
            ball.speed = ball.maxSpeed * [[Globals i] Random_next:1 to:1.3];
            Player *goalkeeper = Nil;
            for (Player *p in (GameController.teams)[abs(self.team-1)])
            {
                if (p.role==P_GOALKEEPER) 
                {
                    goalkeeper = p;
                }
            }
            if (goalkeeper!=Nil) 
            {
                double factor = 1;
                if (goalkeeper.yy > PITCH_HEIGHT/2) 
                {
                    factor = -1;
                }
                double gy = goalkeeper.yy + ([[Globals i] Random_next:0.2 to:0.4]*factor*attackingGoal.height);
                [ball moveTowards:[SPPoint pointWithX:attackingGoal.x y:gy]];
                //double goalkeeperTowardsY = gy - goalkeeper.y;
                goalkeeper.speed = goalkeeper.maxSpeed*[[Globals i] Random_next:1 to:1.5];
                ball.speedV = 1.5; //2
            }
        }
        else
        {
            double rand = [[Globals i] Random_next:0 to:1];
            if (rand > 0.8) 
            {
                double factor = 1;
                if ([[Globals i] Random_next:0 to:1] < 0.5)
                {
                    factor = -1;
                }
                double ay = attackingGoal.y + attackingGoal.height*sqrt([[Globals i] Random_next:0.4 to:1.5])*factor;
                ball.speed = ball.maxSpeed*[[Globals i] Random_next:1 to:1.4];
                [ball moveTowards:[SPPoint pointWithX:attackingGoal.x y:ay]];
            }
            else if((rand > 0.6) && ([self getDistance:[SPPoint pointWithX:attackingGoal.x y:attackingGoal.y]] > 60))
            {
                double ay = attackingGoal.y + attackingGoal.height*[[Globals i] Random_next:-0.2 to:0.2];
                double distBallToGoal = [ball getDistance:[SPPoint pointWithX:attackingGoal.x y:attackingGoal.y]];
                ball.speed = ball.maxSpeed * [[Globals i] Random_next:1.5 to:1.8];
                ball.speedV = distBallToGoal * GRAVITY / (2*ball.speed) * 3.5; //4
                [ball moveTowards:[SPPoint pointWithX:attackingGoal.x y:ay]];
            }
            else
            {
                Player *goalkeeper = Nil;
                for (Player *p in (GameController.teams)[abs(self.team-1)])
                {
                    if (p.role==P_GOALKEEPER) 
                    {
                        goalkeeper = p;
                    }
                }
                if (goalkeeper!=Nil) 
                {
                    ball.speedV = [[Globals i] Random_next:1 to:3]; //2 to 3
                    ball.speed = ball.maxSpeed * [[Globals i] Random_next:0.7 to:0.9];
                    [ball moveTowardsPlayer:goalkeeper];
                    [goalkeeper moveTowards:[SPPoint pointWithX:ball.xx y:ball.yy] speed:goalkeeper.maxSpeed];
                    goalkeeper.action = ACTION_SAVING;
                }
            }
        }
        [ball kick];
        GameController.played = YES;
        self.action = ACTION_KICKINGBALL;
        self.actionCountdown = 5;
    }
    else
    {
        [self moveTowards:[SPPoint pointWithX:attackingGoal.x y:attackingGoal.y] speed:self.speed];
    }
}

- (int)pass:(double)urgency
{
    NSMutableArray *playerWeights = [[NSMutableArray alloc] init];
    Player *scorerr = (GameController.players)[[(GameController.highlight)[@"player_row"] intValue]];
    Player *nearestToPasser = [self getNearest:YES];
    double distToNearest = [self getDistance:[SPPoint pointWithX:nearestToPasser.xx y:nearestToPasser.yy]];
    BOOL isHighlightTeam = NO;
    if ((self.team == scorerr.team) && !GameController.played)
    {
        isHighlightTeam = YES;
    }
    int player_row_in_team = -1;
    double weight = 1;
    for (Player *p in (GameController.teams)[team]) 
    {
        player_row_in_team = player_row_in_team + 1;
        if (p.player_id != self.player_id) 
        {
            //Find a player with the best relationship of angle and distance
            SPPoint *vector_player = [[SPPoint alloc] initWithX:p.xx-self.xx y:p.yy-self.yy];
            double dist = [self getDistance:[SPPoint pointWithX:p.xx y:p.yy]];
            if ((dist > PITCH_WIDTH/3) && (urgency>0))
            {
                continue;
            }
            if ((fabs(self.vector.x) > 0) && (fabs(self.vector.y) > 0) && (urgency>0))
            {
                double angle = [self.vector angleToPoint:vector_player];
                if (angle > 90)
                {
                    continue;
                }
                weight = fabs(angle) / 90;
                weight = weight * dist / PITCH_WIDTH / 4;
            }
            else
            {
                weight = dist / PITCH_WIDTH / 4;
            }
            //Make sure the player we want to pass to isn't too tightly marked
			//unless we're trying to get rid of the ball
            Player *mark = [p getNearest:NO];
            double distToMark = [self getDistance:[SPPoint pointWithX:mark.xx y:mark.yy]];
            double distObjToMark = [p getDistance:[SPPoint pointWithX:mark.xx y:mark.yy]];
			if((distObjToMark < PLAYER_WIDTH * fmin(2,dist/50)) && (distToMark < dist))
			{
                if (p.player_id != [(GameController.highlight)[@"player_id"] intValue])
                {
                    if (isHighlightTeam) 
                    {
                        continue;
                    }
                    else
                    {
                        weight = sqrt(weight);
                    }
                }
            }
            if (p.player_id == scorerr.player_id) 
            {
                weight /= sqrt(urgency*20);
            }
            else
            {
                weight = pow(weight, 0.25);
            }
            //Mark down if the passer is closely marked
            double distNearestToPassee = [nearestToPasser getDistance:[SPPoint pointWithX:p.xx y:p.yy]];
            if (distToNearest < PLAYER_WIDTH * 4) 
            {
                if (p.player_id != [(GameController.highlight)[@"player_id"] intValue])
                {
                    if((distNearestToPassee + (PLAYER_WIDTH/2) < dist) && (isHighlightTeam) && (nearestToPasser.action!=ACTION_TACKLING))
					{
                        continue;
                    }
					else
                    {
						weight = sqrt(weight);
                    }
                }
            }
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@(player_row_in_team), @"Player", @(weight), @"Weight", nil];
            [playerWeights addObject:dict];
             //TAPFANTASY
            //NSLog(@"Passing to Player[%d]: %.2f", player_row_in_team, weight);
        }
    }
    
    NSSortDescriptor *d = [[NSSortDescriptor alloc] initWithKey:@"Weight" ascending:YES];
    NSArray *descriptors = @[d];
    NSArray * sortedWeights = [playerWeights sortedArrayUsingDescriptors:descriptors];
    if ([sortedWeights count]<1)
    {
        return -1;
    }
    
    player_row_in_team = [sortedWeights[0][@"Player"] intValue];
    Player *obj = (GameController.teams)[team][player_row_in_team];
    if (obj.player_id == self.player_id) 
    {
        return -1;
    }
    //If it's the goalkeeper and there's an opposition player near us, pass down the pitch
    if ((self.role==P_GOALKEEPER) && (distToNearest<[self getDistance:[SPPoint pointWithX:obj.xx y:obj.yy]]))
    {
        NSMutableArray *midfielders = [[NSMutableArray alloc] init];
        for (Player *p in (GameController.teams)[self.team])
        {
            if (p.role==P_MIDFIELDER) 
            {
                if ([self getDistance:[SPPoint pointWithX:p.xx y:p.yy]]<(PITCH_WIDTH/3)) 
                {
                    [midfielders addObject:p];
                }
            }
        }
        if ([midfielders count]>0) 
        {
            if ([midfielders count]==1) 
            {
                obj = midfielders[0];
            }
            else
            {
                int randindex = [[Globals i] Random_next:0 to:([midfielders count]-1)];
                obj = midfielders[randindex];
            }
        }
        else
        {
            obj = Nil;
        }
    }
    if((obj.player_id == self.player_id) || (obj == Nil))
    {
        return -1;
    }
    //Don't pass to offside player
    if ([obj isOffside]) 
    {
        [self returnTo:0 pitchRandMultiplier:0.167 narrowness:8];
        return -1;
    }
    [self passTo:obj];

    return obj.player_id;
}

- (void)passTo:(Player *)obj
{
    [GameController playSoundShoot];

    double dist = [self getDistance:[SPPoint pointWithX:obj.xx y:obj.yy]];
    if (dist > PITCH_WIDTH/4) 
    {
        ball.speed = fmin(dist/20, ball.maxSpeed);
        ball.speedV = dist * GRAVITY / (4*ball.speed); //2*
    }
    else
    {
        ball.speed = ball.maxSpeed*0.8;
        ball.speedV = 0;
    }
    
    [ball moveTowardsPlayer:obj];
    
    if (ball.speedV != -1) 
    {
        double dist = [ball getDistance:ball.movingTo];
        ball.speed = fmin(dist/20, ball.maxSpeed);
        ball.speedV = dist * GRAVITY / (4*ball.speed); //2*
    }
     
    [obj moveTowards:[SPPoint pointWithX:ball.xx y:ball.yy] speed:obj.maxSpeed];
    self.action = ACTION_KICKINGBALL;
    obj.actionCountdown = 0;
    [ball kick];
    obj.action = ACTION_PASSEDBALL;
    self.actionCountdown = 5;
}

- (void)returnTo:(double)pitchProportion pitchRandMultiplier:(double)pitchRandMultiplier narrowness:(double)narrowness
{
    if (narrowness==-1)
    {
        narrowness = 0;
    }
    if (pitchProportion==-1) 
    {
        pitchProportion = 0.167;
    }
    if (pitchRandMultiplier==-1) 
    {
        pitchRandMultiplier = 8;
    }
    
    self.defendingGoal = (GameController.defendingGoal)[team];
    self.attackingGoal = (GameController.attackingGoal)[team];
    
    BOOL teamHasBall = NO;
    if (ball.team == self.team) 
    {
        teamHasBall = YES;
    }
    Goal *moveToGoal = self.defendingGoal;
    if (teamHasBall)
    {
        moveToGoal = self.attackingGoal;
    }
    double adjustX = (moveToGoal.x - self.basePosition.x) * pitchProportion;
    double randX = [[Globals i] Random_next:-1 to:1];
    //randX = Math.sqrt(Math.abs(randX)) * randX / Math.abs(randX) * pitch.width() * (pitchProportion / pitchRandMultiplier);
    double abs_randX = fabs(randX);
    randX = sqrt(abs_randX) * randX / abs_randX * PITCH_WIDTH * (pitchProportion / pitchRandMultiplier);
    double moveX = self.basePosition.x + randX + adjustX;
    if (moveX < 0) 
    {
        moveX = 0;
    }
    else if (moveX > PITCH_WIDTH)
    {
        moveX = PITCH_WIDTH;
    }
    double randY = [[Globals i] Random_next:-1 to:1];
    double abs_randY = fabs(randY);
    randY = sqrt(abs_randY) * randY / abs_randY * PITCH_HEIGHT * (pitchProportion / 4 / pitchRandMultiplier);
    double moveY = self.basePosition.y + randY;
    if (narrowness>0) 
    {
        double distToCenter = (PITCH_HEIGHT/2) - self.yy;
        moveY += distToCenter * narrowness;
    }
    if (moveY < 0) 
    {
        moveY = 0;
    }
    else if (moveY > PITCH_HEIGHT)
    {
        moveY = PITCH_HEIGHT;
    }
    double speedd = [[Globals i] Random_next:(self.maxSpeed-self.maxSpeed*0.8) to:(self.maxSpeed*0.9)];
    
    double offside = [self getOffside:moveX];
    if (offside > 0)
    {
        moveX = offside;
    }
    //TAPFANTASY
    //Make the action player move towards the goal more
    if (self.player_id == [(GameController.highlight)[@"player_id"] intValue]) 
    {
        moveY += (self.attackingGoal.y - moveY)/5;
        moveX += (self.attackingGoal.x - moveX)/2;
    }
    
    SPPoint *newPos = [SPPoint pointWithX:moveX y:moveY];
    
    float distToNewPos = [self getDistance:newPos];
    if (distToNewPos > PLAYER_WIDTH)
    {
        [self moveTowards:newPos speed:speedd];
    }
    self.action = ACTION_RETURNING;
    self.actionCountdown = 50;
}

- (double)getDistance:(SPPoint *)sppoint
{
    SPPoint *p1 = [SPPoint pointWithX:self.xx y:self.yy];
    double dist = [SPPoint distanceFromPoint:p1 toPoint:sppoint];
    return dist;
}

- (SPPoint*)point
{
    return [[SPPoint alloc] initWithX:self.xx y:self.yy];
}

- (void)moveTo:(double)mX mY:(double)mY
{
    self.x = mX + PITCH_WIDTH_OFFSET;
    self.y = mY + PITCH_HEIGHT_OFFSET;
    
    self.xx = mX;
    self.yy = mY;
}

- (void)turn
{
    nameTextField.text = @"";
    self.defendingGoal = (GameController.defendingGoal)[team];
    self.attackingGoal = (GameController.attackingGoal)[team];
    
    double distToBall = [self getDistance:ball.point];
    double distToGoal = [self getDistance:attackingGoal.point];
    double distBallToGoal = [SPPoint distanceFromPoint:ball.point toPoint:defendingGoal.point];
    BOOL playerHasBall = NO;
    if (ball.player.player_id==self.player_id) 
    {
        playerHasBall = YES;
    }
    BOOL teamHasBall = NO;
    if (ball.team == self.team) 
    {
        teamHasBall = YES;
    }
    
    //NSLog(@"P[%d]: C(%.2f,%.2f) Steps:%d V<%.2f , %.2f> action:%d role:%d distToBall:%.2f distToGoal:%.2f", self.player_id, self.x, self.y, self.steps, self.vector.x, self.vector.y, self.action, self.role, distToBall, distToGoal);
    //NSLog(@"Ball C(%.2f , %.2f) V<%.2f , %.2f> Steps:%d", ball.xx, ball.yy, ball.vector.x, ball.vector.y, ball.steps);
    
    if (self.actionCountdown > 1) 
    {
        self.actionCountdown--;
    }
    else if (self.actionCountdown == 1)
    {
        self.actionCountdown = 0;
        if (self.action == ACTION_MOVINGTHROW) 
        {
            [ball reset];
            [self gotBall];
            Player *nearest = [self getNearest:YES];
            self.action = ACTION_IDLE;
            [self passTo:nearest];
            
            [GameController setHighlightText:@""];
        }
        else if (self.action == ACTION_MOVINGCORNER)
        {
            [ball reset];
            [self gotBall];

            int index = floor([[Globals i] Random_next:0 to:[(GameController.teams)[self.team] count]-1]);
            Player *striker = (GameController.teams)[self.team][index];
            
            if (striker.role == P_GOALKEEPER) //Pass to Goalkeeper
            {
                if (index>0) 
                {
                    index=index-1;
                }
                else
                {
                    index=index+1;
                }
                striker = (GameController.teams)[self.team][index];
            }
            
            if (striker.player_id == ball.player.player_id) //Pass to yourself
            {
                if (index>0) 
                {
                    index=index-1;
                }
                else
                {
                    index=index+1;
                }
                striker = (GameController.teams)[self.team][index];
            }
            self.action = ACTION_IDLE;
            [self passTo:striker];
            
            [GameController setHighlightText:@""];
        }
        else
        {
            self.action = ACTION_IDLE;
        }
    }
    if(((distToBall < ball.speed) || (distToBall < PLAYER_WIDTH * 4))
        && ((self.action == ACTION_SAVING) || ([(GameController.highlight)[@"type_id"] intValue]>2)
        || (ball.kickedBy.player_id != [(GameController.highlight)[@"player_id"] intValue]))
           && (self.role == P_GOALKEEPER))
	{
        [self gotBall];
		[self decideMove];
	}
	else if((distToBall < ball.speed) && (ball.player==Nil) && (self.action != ACTION_KICKINGBALL) && (ball.offGround < PLAYER_HEIGHT) && (self.action != ACTION_TACKLING))
	{
        double ballNextX = ball.xx;
		double ballNextY = ball.yy;
        if ((fabs(ball.vector.x) > 0) && (fabs(ball.vector.y) > 0)) 
        {
            ballNextX += ball.vector.x;
            ballNextY += ball.vector.y;
        }
		Player *nearest = [self getNearest:NO];
		double dist = [self getDistance:nearest.point];
        if(!((dist < PLAYER_WIDTH * 4) && (nearest.player_id == [(GameController.highlight)[@"player_id"] intValue]) 
             && ([(GameController.highlight)[@"type_id"] intValue]>2 
                 || (ball.kickedBy.player_id != [(GameController.highlight)[@"player_id"] intValue]))))
		{
            if ([self getDistance:[SPPoint pointWithX:ballNextX y:ballNextY]] < ball.speed*1.5) 
            {
                [self gotBall];
                [self decideMove];
            }
        }
    }
    //Don't run away if the ball's coming towards you
    if (self.action == ACTION_PASSEDBALL) 
    {
        SPPoint *dest;
        if (ball.steps >= 0) 
        {
            double destX = ball.xx + (ball.steps*ball.vector.x);
            double destY = ball.yy + (ball.steps*ball.vector.y);
            dest = [SPPoint pointWithX:destX y:destY];
        }
        else
        {
            dest = ball.point;
        }
        [self moveTowards:dest speed:self.maxSpeed];
        
    } //When the other team's attacking, decide what to do
    else if ((distToBall<PITCH_WIDTH/4)&&(distBallToGoal<PITCH_WIDTH/5)&&(self.action!=ACTION_TACKLING)&&(self.action!=ACTION_SAVING))
    {
        [self decideMove];
    }
    else if((distToBall<PITCH_WIDTH/20)&&(ball.player.player_id!=self.player_id)
            &&((ball.player!=Nil)&&(ball.player.team!=self.team))
            &&(self.action!=ACTION_TACKLING)&&(self.action!=ACTION_SAVING))
    {
        [self getBall];
    }
    BOOL shoot = NO;
    double urgencyToPass = 0;
    //double urgencyToScore = 0;
    //Make the player move away from a marker
    if (playerHasBall) 
    {
        if (!GameController.played) 
        {
            //Want to pass to the scoring player % of the way through the highlight
            urgencyToPass = GameController.proportion + 0.12;
            //Want to pass to the scoring player % of the way through the highlight
            //urgencyToScore = GameController.proportion;
        }
        if ((self.player_id == [(GameController.highlight)[@"player_id"] intValue]) 
            && (GameController.proportion > 0.8)) 
        {
            urgencyToPass = 0;
        }
        else if (distToGoal < PITCH_WIDTH/4)
        {
            urgencyToPass = pow(urgencyToPass, 0.2);
        }
        Player *nearest = [self getNearest:NO];
        double nearestDist = [self getDistance:nearest.point];
        if (nearestDist < PLAYER_WIDTH * 3) 
        {
            urgencyToPass = pow(urgencyToPass, 0.2);
        }
        shoot = playerHasBall && ([[Globals i] Random_next:0 to:1]<PITCH_WIDTH/30/distToGoal) 
        && !GameController.played && (distToGoal<PITCH_WIDTH/4) 
        && ((self.player_id == [(GameController.highlight)[@"player_id"] intValue]) 
            || ([(GameController.players)[[(GameController.highlight)[@"player_row"] intValue]] team] != self.team));
    }
    if (playerHasBall&&(self.player_id == [(GameController.highlight)[@"player_id"] intValue])
        &&(distToGoal<PITCH_WIDTH/5)&&([(GameController.highlight)[@"type_id"] intValue]>2)) 
    {
        shoot = YES;
    }
    else if (playerHasBall && ([[self.attackingGoal getClosestPlayer] player_id]==self.player_id))
    {
        if (distToGoal<PITCH_WIDTH/6) 
        {
            shoot = YES;
        }
        else
        {
            self.action = ACTION_ATTACKINGGOAL;
        }
    }
    if (shoot) 
    {
        if ((self.player_id == [(GameController.highlight)[@"player_id"] intValue])
            &&(distToGoal<PITCH_WIDTH/5)) 
        {
            if (([(GameController.highlight)[@"type_id"] intValue]>2) 
                || (distToGoal<PITCH_WIDTH/7) || ([[Globals i] Random_next:0 to:1]<PITCH_WIDTH/20/distToGoal) ) 
            {
                [self shoot];
            }
        }
        else if (self.player_id != [(GameController.highlight)[@"player_id"] intValue])
        {
            Player *keeper = Nil;
            for (Player *p in (GameController.teams)[abs(self.team-1)])
            {
                if (p.role==P_GOALKEEPER)
                {
                    keeper = p;
                }
            }
            if (keeper!=Nil)
            {
                [keeper moveTowards:ball.point speed:keeper.maxSpeed];
                [self passTo:keeper];
            }
        }
    }
    else if (playerHasBall && (([[Globals i] Random_next:0 to:1]<urgencyToPass/30) || ((urgencyToPass>1))))
                 //&& ([[Globals i] Random_next:0 to:1]<0.05)))
    {
        //TODO: if the player is the scorer and has a clear run on goal, then do it
        int passed_player_id = [self pass:urgencyToPass];
        if (passed_player_id != -1) 
        {
            if(self.player_id != [(GameController.highlight)[@"player_id"] intValue])
            {
                Player *scorerr = (GameController.players)[[(GameController.highlight)[@"player_row"] intValue]];
                [self moveTowards:scorerr.point speed:self.speed];
            }
        }
    }
    else if (self.action == ACTION_ATTACKINGGOAL)
    {
        if(!playerHasBall && (distToGoal>PITCH_WIDTH/6))
        {
            [self moveTowards:self.attackingGoal.point speed:self.speed];
        }
        else if(playerHasBall)
        {
            [self moveTowards:self.attackingGoal.point speed:self.speed];
        }
    }//Make sure a defender follows their marked player
    else if(self.action == ACTION_MARKING)
    {
        if (([self.marking getDistance:self.defendingGoal.point]>PITCH_WIDTH/3) || teamHasBall) 
        {
            self.action = ACTION_IDLE;
        }
        else
        {
            //Urgency to mark?
            double urgency = [self.marking getDistance:self.defendingGoal.point]/PITCH_WIDTH * 4;
            if (([[Globals i] Random_next:0 to:1]<urgency) && ([self getDistance:self.marking.point]>PLAYER_WIDTH * 2.5)) 
            {
                if (self.marking.player_id == [(GameController.highlight)[@"player_id"] intValue]) 
                {
                    SPPoint *towards = marking.point;
                    double destX = [[Globals i] Random_next:-PLAYER_WIDTH to:PLAYER_WIDTH]*5;
                    double destY = [[Globals i] Random_next:-PLAYER_WIDTH to:PLAYER_WIDTH]*5;
                    SPPoint *towardsTo = [SPPoint pointWithX:destX y:destY]; 
                    [self moveTowards:[towards addPoint:towardsTo] speed:(sqrt(urgency)*self.maxSpeed)];
                }
                else
                {
                    [self moveTowards:self.marking.point speed:(sqrt(urgency)*self.maxSpeed)];
                }
            }
        }
    }
    else if(self.action == ACTION_TACKLING)
    {
        if ((distToBall<PLAYER_WIDTH/5) && (ball.player.player_id!=self.player_id)) 
        {
            //Chance of a successful tackle?
            double chance = [[Globals i] Random_next:0.25 to:1];
            chance = chance * chance;
            double proportion = GameController.proportion;
            if (self.player_id == [(GameController.highlight)[@"player_id"] intValue]) 
            {
                chance = 0.8;
            }
            else if((ball.player != Nil) && (ball.player.player_id == [(GameController.highlight)[@"player_id"] intValue]))
            {
                chance = 0.0;
            }
            else if([(GameController.players)[[(GameController.highlight)[@"player_row"] intValue]] team] == self.team)
            {
                chance = proportion + 0.25;
            }
            else if([(GameController.players)[[(GameController.highlight)[@"player_row"] intValue]] team] != self.team)
            {
                chance = 1 - proportion;
            }
            //Success?
            if ([[Globals i] Random_next:0 to:1] < chance) 
            {
                [self gotBall];
            }
        }
    }
    else if(self.action == ACTION_GETTINGBALL)
    {
        double ballNextTurnX = ball.xx + ball.vector.x;
        double ballNextTurnY = ball.yy + ball.vector.y;
        double nextDist = [self getDistance:[SPPoint pointWithX:ballNextTurnX y:ballNextTurnY]];
        if (nextDist > distToBall+(self.speed*2)) //*3
        {
            [self decideMove];
        }
        else if(distToBall > PITCH_WIDTH/5) //10 - if ice hockey
        {
            [self decideMove];
            //self.action = ACTION_PASSEDBALL; - if ice hockey
        }
        else
        {
            //Tackle?
            double tackle = 0;
            if ((ball.player!=Nil) && (distToBall<PLAYER_WIDTH*3)) 
            {
                //double proportion = GameController.proportion;
                SPPoint *ballPlayerNext = [ball.player.point addPoint:ball.player.vector];
                SPPoint *thisPlayerNext = [self.point addPoint:self.vector];
                double nextDist = [SPPoint distanceFromPoint:ballPlayerNext toPoint:thisPlayerNext];
                if (nextDist<distToBall) 
                {
                    tackle = 0.5;
                }
                //The highlight player tries to tackle a lot
                if (self.player_id == [(GameController.highlight)[@"player_id"] intValue]) 
                {
                    tackle = pow(tackle, 0.25);
                }//Reckless tackle
                else if(ball.player.player_id == [(GameController.highlight)[@"player_id"] intValue])
                {
                    tackle = pow(tackle, 0.25);
                }
            }
            //Tackling?
            if ([[Globals i] Random_next:0 to:1] < tackle/5)
            {
                self.action = ACTION_TACKLING;
                self.actionCountdown = 15;
                [self moveTowards:ball.point speed:(self.maxSpeed*1.4)];
                self.movingTo = Nil;
            }
            else
            {
                double urgency = PITCH_WIDTH/20/distToBall;
                self.speed = self.maxSpeed*[[Globals i] Random_next:fmin(urgency, 1) to:1];
                //If we're near the ball and no-one has it, grab it
                if ([[Globals i] Random_next:0 to:1] < urgency/10)
                {
                    if (ball.player!=Nil) 
                    {
                        [self moveTowards:ball.player.point speed:self.speed];
                    }
                    else
                    {
                        [self moveTowards:ball.point speed:self.speed];
                    }
                }
                else
                {
                    [self decideMove];
                }

            }
        }
    }
    
    [self move];
}

@end
