
#import "Game.h"
#import "Player.h"
#import "Ball.h"
#import "Goal.h"

#import "Globals.h"
#import "MainView.h"

@implementation Game
@synthesize mainView;
@synthesize played;
@synthesize proportion;
@synthesize attackingGoal;
@synthesize defendingGoal;
@synthesize teams;
@synthesize homeTeam;
@synthesize awayTeam;
@synthesize players;
@synthesize highlights;
@synthesize highlight;
@synthesize leftGoal;
@synthesize rightGoal;
@synthesize ball;
@synthesize teamsFormation;
@synthesize homeLogo;
@synthesize awayLogo;
@synthesize soundCrowd;
@synthesize soundGoal;
@synthesize soundMiss;
@synthesize soundChant;
@synthesize soundShoot;
@synthesize soundFinish;
@synthesize music1;
@synthesize music2;
@synthesize music3;
@synthesize music4;

- (id)init
{
    if (self = [super init])
	{
        pitch = [SPSprite sprite];
        pitch.rotation = SP_D2R(90);
        pitch.x = SCREEN_WIDTH;
		[self addChild:pitch];
        
        SPImage *backgroundImage;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            backgroundImage = [SPImage imageWithContentsOfFile:@"engine_pitch@2x.png"];
            backgroundImage.scaleX = 2.0f;
            backgroundImage.scaleY = 2.0f;
        }
        else
        {
            backgroundImage = [SPImage imageWithContentsOfFile:@"engine_pitch.png"];
        }
		[pitch addChild:backgroundImage];
        
        SPImage *headerImage;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            headerImage = [SPImage imageWithContentsOfFile:@"engine_header@2x.png"];
            headerImage.scaleX = 2.0f;
            headerImage.scaleY = 2.0f;
        }
        else
        {
            headerImage = [SPImage imageWithContentsOfFile:@"engine_header.png"];
        }
        headerImage.x = 0;
		headerImage.y = 0;
        [pitch addChild:headerImage];
        
        highlightTextField = [SPTextField textFieldWithText:@" "];
		highlightTextField.fontName = @"Febrotesk 4F Unicase Bold";
		highlightTextField.x = 10;
		highlightTextField.y = PITCH_HEIGHT + HIGHLIGHT_OFFSET;
		highlightTextField.vAlign = SPVAlignCenter;
        highlightTextField.hAlign = SPHAlignCenter;
		highlightTextField.fontSize = FONT_SIZE;
        highlightTextField.width = PITCH_WIDTH;
        highlightTextField.color = 0xffffff;
		[pitch addChild:highlightTextField];
        
        goalsHome = 0;
        goalsAway = 0;
        
		scoreTextField = [SPTextField textFieldWithText:[NSString stringWithFormat:@"%d : %d", goalsHome, goalsAway]];
		scoreTextField.fontName = @"Febrotesk 4F Unicase Bold";
		scoreTextField.x = 46;
		scoreTextField.y = 2;
		scoreTextField.vAlign = SPVAlignTop;
        scoreTextField.hAlign = SPHAlignLeft;
		scoreTextField.fontSize = FONT_SIZE;
        scoreTextField.color = 0xffffff;
		[pitch addChild:scoreTextField];
		
		clockTextField = [SPTextField textFieldWithText:[NSString stringWithFormat:@"%d:%d", 90, 00]];
		clockTextField.fontName = @"Febrotesk 4F Unicase Bold";
		clockTextField.x = (PITCH_WIDTH/2) - CLOCK_OFFSET;
		clockTextField.y = -1;
		clockTextField.vAlign = SPVAlignTop;
        clockTextField.hAlign = SPHAlignRight;
		clockTextField.fontSize = FONT_SIZE;
		[pitch addChild:clockTextField];
        
        leftGoal = [Goal initGoal:GOAL_LEFT];
        leftGoal.GameController = self;
        [pitch addChild:leftGoal];
        
        rightGoal = [Goal initGoal:GOAL_RIGHT];
        rightGoal.GameController = self;
        [pitch addChild:rightGoal];
        
        SPTexture *texturename;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            texturename = [SPTexture textureWithContentsOfFile:@"button_skip@2x.png"];
        }
        else
        {
            texturename = [SPTexture textureWithContentsOfFile:@"button_skip.png"];
        }
        SPButton *buttonSkip = [SPButton buttonWithUpState:texturename];
        buttonSkip.x = PITCH_WIDTH - SKIP_OFFSET;
		buttonSkip.y = 0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            buttonSkip.scaleX = 2.0f;
            buttonSkip.scaleY = 2.0f;
        }
        [buttonSkip addEventListener:@selector(onButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [pitch addChild:buttonSkip];
        
        ball = [[Ball alloc] init];
        ball.GameController = self;

        [self addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    }
		
	return self;
}

- (void)loadClub
{
    music1 = [SPSound soundWithContentsOfFile:@"sound_shoot.caf"];
    soundShoot = [music1 createChannel];
    soundShoot.loop = NO;
    soundShoot.volume = 0.75;
    
    music2 = [SPSound soundWithContentsOfFile:@"sound_crowd_goal.caf"];
    soundGoal = [music2 createChannel];
    soundGoal.loop = NO;
    soundGoal.volume = 1.0;
    
    music3 = [SPSound soundWithContentsOfFile:@"sound_crowd0.caf"];
    soundMiss = [music3 createChannel];
    soundMiss.loop = NO;
    soundMiss.volume = 1.0;
    
    music4 = [SPSound soundWithContentsOfFile:@"sound_whistle.caf"];
    soundFinish = [music4 createChannel];
    soundFinish.loop = NO;
    soundFinish.volume = 0.75;
    
    played = NO; //If the player has done their shot etc
    finished = NO;
    paused = NO;
    num = 0;
    frame = 0;
    frameTime = 25;
    maxFrames = 300; //Number of positions to render before scoring
    avMaxFrames = 300;
    proportion = 0; //Proportion of the highlight that we're through = frame/maxFrames
    goalCountdown = -1;
    seconds = 0;
    goalsHome = 0;
    goalsAway = 0;
    
    scoreTextField.text = [NSString stringWithFormat:@"%d : %d", goalsHome, goalsAway];
    
    //Remove all previous players from pitch sprite
    for(Player *p in players)
    {
        [pitch removeChild:p];
    }
    
    [pitch removeChild:homeLogo];
    [pitch removeChild:awayLogo];
    
    [pitch removeChild:ball];
    
    self.players = [[NSMutableArray alloc] initWithObjects:nil];
    self.homeTeam = [[NSMutableArray alloc] initWithObjects:nil];
    self.awayTeam = [[NSMutableArray alloc] initWithObjects:nil];
    
    int player_row = 0;
    NSMutableDictionary *playerRowforID = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    
    NSDictionary *wsMatchData = [[Globals i] getMatchInfoData];
    NSString *club_home_uid = wsMatchData[@"club_home_uid"];
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetClub/%@", WS_URL, club_home_uid];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    NSArray *wsResponse = [[NSArray alloc] initWithContentsOfURL:url];
    NSDictionary *wsClubHome = NULL;
    if([wsResponse count] > 0)
    {
        wsClubHome = [[NSDictionary alloc] initWithDictionary:wsResponse[0] copyItems:YES];
    }
    else
    {
        [self finishedHighlights];
    }
    
    [[Globals i] updateSquadData:[wsMatchData[@"club_home"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
    NSArray *wsPlayersHome = [[NSMutableArray alloc] initWithArray:[[Globals i] getSquadData] copyItems:YES];
    int GK_total = 0;
    int DEFENDER_total = 0;
    int MIDFIELDER_total = 0;
    int ATTACKER_total = 0;
    for(NSDictionary *rowData in wsPlayersHome)
    {
        if (![rowData[@"player_id"] isEqualToString:@"0"])
        {
            Player *p = NULL;
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"gk"]])
            {
                GK_total = GK_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:1 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_GOALKEEPER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"cd1"]])
            {
                DEFENDER_total = DEFENDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:2 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_DEFENDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"cd2"]])
            {
                DEFENDER_total = DEFENDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:3 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_DEFENDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"cd3"]])
            {
                DEFENDER_total = DEFENDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:4 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_DEFENDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"rb"]])
            {
                DEFENDER_total = DEFENDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:5 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_DEFENDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"lb"]])
            {
                DEFENDER_total = DEFENDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:6 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_DEFENDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"im1"]])
            {
                MIDFIELDER_total = MIDFIELDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:7 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_MIDFIELDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"im2"]])
            {
                MIDFIELDER_total = MIDFIELDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:8 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_MIDFIELDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"im3"]])
            {
                MIDFIELDER_total = MIDFIELDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:9 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_MIDFIELDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"rw"]])
            {
                MIDFIELDER_total = MIDFIELDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:10 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_MIDFIELDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"lw"]])
            {
                MIDFIELDER_total = MIDFIELDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:11 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_MIDFIELDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"fw1"]])
            {
                ATTACKER_total = ATTACKER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:12 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_ATTACKER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"fw2"]])
            {
                ATTACKER_total = ATTACKER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:13 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_ATTACKER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubHome[@"fw3"]])
            {
                ATTACKER_total = ATTACKER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:14 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_ATTACKER name:rowData[@"player_name"]];
            }
            
            if (p != NULL)
            {
                [playerRowforID setValue:@(player_row) forKey:rowData[@"player_id"]];
                [self.players addObject:p];
                [self.homeTeam addObject:p];
                player_row = player_row + 1;
            }
        }
    }
    
    if (GK_total == 0)
    {
        Player *p = [Player initPlayer:-1 number:1 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_GOALKEEPER name:@"GK_HOME"];
        [playerRowforID setValue:@(player_row) forKey:@"-1"];
        [self.players addObject:p];
        [self.homeTeam addObject:p];
        player_row = player_row + 1;
    }
    if (DEFENDER_total == 0)
    {
        DEFENDER_total = 1;
        Player *p = [Player initPlayer:-2 number:2 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_DEFENDER name:@"DEF_HOME"];
        [playerRowforID setValue:@(player_row) forKey:@"-2"];
        [self.players addObject:p];
        [self.homeTeam addObject:p];
        player_row = player_row + 1;
    }
    if (MIDFIELDER_total == 0)
    {
        MIDFIELDER_total = 1;
        Player *p = [Player initPlayer:-3 number:7 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_MIDFIELDER name:@"MID_HOME"];
        [playerRowforID setValue:@(player_row) forKey:@"-3"];
        [self.players addObject:p];
        [self.homeTeam addObject:p];
        player_row = player_row + 1;
    }
    if (ATTACKER_total == 0)
    {
        ATTACKER_total = 1;
        Player *p = [Player initPlayer:-4 number:12 jersey:[wsClubHome[@"home_pic"] intValue] team:T_HOME role:P_ATTACKER name:@"FW_HOME"];
        [playerRowforID setValue:@(player_row) forKey:@"-4"];
        [self.players addObject:p];
        [self.homeTeam addObject:p];
        player_row = player_row + 1;
    }
    
    NSMutableDictionary *posHome = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(DEFENDER_total), @"DEFENDER",
                                    @(MIDFIELDER_total), @"MIDFIELDER",
                                    @(ATTACKER_total), @"ATTACKER", nil];
    
    
    NSDictionary *wsClubAway = [[Globals i] getClubData];
    [[Globals i] updateMySquadData];
    NSArray *wsPlayersAway = [[NSMutableArray alloc] initWithArray:[[Globals i] getMySquadData] copyItems:YES];
    GK_total = 0;
    DEFENDER_total = 0;
    MIDFIELDER_total = 0;
    ATTACKER_total = 0;
    for(NSDictionary *rowData in wsPlayersAway)
    {
        if (![rowData[@"player_id"] isEqualToString:@"0"])
        {
            Player *p = NULL;
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"gk"]])
            {
                GK_total = GK_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:1 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_GOALKEEPER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"cd1"]])
            {
                DEFENDER_total = DEFENDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:2 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_DEFENDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"cd2"]])
            {
                DEFENDER_total = DEFENDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:3 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_DEFENDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"cd3"]])
            {
                DEFENDER_total = DEFENDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:4 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_DEFENDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"rb"]])
            {
                DEFENDER_total = DEFENDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:5 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_DEFENDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"lb"]])
            {
                DEFENDER_total = DEFENDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:6 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_DEFENDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"im1"]])
            {
                MIDFIELDER_total = MIDFIELDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:7 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_MIDFIELDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"im2"]])
            {
                MIDFIELDER_total = MIDFIELDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:8 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_MIDFIELDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"im3"]])
            {
                MIDFIELDER_total = MIDFIELDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:9 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_MIDFIELDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"rw"]])
            {
                MIDFIELDER_total = MIDFIELDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:10 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_MIDFIELDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"lw"]])
            {
                MIDFIELDER_total = MIDFIELDER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:11 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_MIDFIELDER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"fw1"]])
            {
                ATTACKER_total = ATTACKER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:12 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_ATTACKER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"fw2"]])
            {
                ATTACKER_total = ATTACKER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:13 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_ATTACKER name:rowData[@"player_name"]];
            }
            if ([rowData[@"player_id"] isEqualToString:wsClubAway[@"fw3"]])
            {
                ATTACKER_total = ATTACKER_total + 1;
                p = [Player initPlayer:[[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] number:14 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_ATTACKER name:rowData[@"player_name"]];
            }
            
            if (p != NULL)
            {
                [playerRowforID setValue:@(player_row) forKey:rowData[@"player_id"]];
                [self.players addObject:p];
                [self.awayTeam addObject:p];
                player_row = player_row + 1;
            }
        }
    }
    
    if (GK_total == 0)
    {
        Player *p = [Player initPlayer:-11 number:1 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_GOALKEEPER name:@"GK_AWAY"];
        [playerRowforID setValue:@(player_row) forKey:@"-11"];
        [self.players addObject:p];
        [self.awayTeam addObject:p];
        player_row = player_row + 1;
    }
    if (DEFENDER_total == 0)
    {
        DEFENDER_total = 1;
        Player *p = [Player initPlayer:-12 number:2 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_DEFENDER name:@"DEF_AWAY"];
        [playerRowforID setValue:@(player_row) forKey:@"-12"];
        [self.players addObject:p];
        [self.awayTeam addObject:p];
        player_row = player_row + 1;
    }
    if (MIDFIELDER_total == 0)
    {
        MIDFIELDER_total = 1;
        Player *p = [Player initPlayer:-13 number:7 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_MIDFIELDER name:@"MID_AWAY"];
        [playerRowforID setValue:@(player_row) forKey:@"-13"];
        [self.players addObject:p];
        [self.awayTeam addObject:p];
        player_row = player_row + 1;
    }
    if (ATTACKER_total == 0)
    {
        ATTACKER_total = 1;
        Player *p = [Player initPlayer:-14 number:12 jersey:[wsClubAway[@"away_pic"] intValue] team:T_AWAY role:P_ATTACKER name:@"FW_AWAY"];
        [playerRowforID setValue:@(player_row) forKey:@"-14"];
        [self.players addObject:p];
        [self.awayTeam addObject:p];
        player_row = player_row + 1;
    }
    
    NSMutableDictionary *posAway = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(DEFENDER_total), @"DEFENDER",
                                    @(MIDFIELDER_total), @"MIDFIELDER",
                                    @(ATTACKER_total), @"ATTACKER", nil];
    
    
    self.teams = [[NSMutableArray alloc] initWithObjects:homeTeam, awayTeam, nil];
    self.teamsFormation = [[NSMutableArray alloc] initWithObjects:posHome, posAway, nil];
    
    for(Player *p in players)
    {
        p.GameController = self;
        p.ball = self.ball;
        [pitch addChild:p];
    }
    
    [pitch addChild:ball];
    
    SPTexture *texturename;
    
    texturename = [SPTexture textureWithContentsOfFile:[NSString stringWithFormat:@"c%@.png", wsClubHome[@"logo_pic"]]];
    homeLogo = [SPButton buttonWithUpState:texturename];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [homeLogo setScaleX:0.3];
        [homeLogo setScaleY:0.3];
    }
    else
    {
        [homeLogo setScaleX:0.15];
        [homeLogo setScaleY:0.15];
    }
    homeLogo.x = 0;
    homeLogo.y = 0;
    [pitch addChild:homeLogo];
    
    texturename = [SPTexture textureWithContentsOfFile:[NSString stringWithFormat:@"c%@.png", wsClubAway[@"logo_pic"]]];
    awayLogo = [SPButton buttonWithUpState:texturename];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [awayLogo setScaleX:0.3];
        [awayLogo setScaleY:0.3];
    }
    else
    {
        [awayLogo setScaleX:0.15];
        [awayLogo setScaleY:0.15];
    }
    awayLogo.x = LOGO2_OFFSET;
    awayLogo.y = 0;
    [pitch addChild:awayLogo];
    
    self.highlights = [[NSMutableArray alloc] initWithObjects: nil];
    NSArray *wsMatchHighlights = [[NSMutableArray alloc] initWithArray:[[Globals i] getMatchHighlightsData] copyItems:YES];
    int highlight_total = 0;
    for(NSDictionary *rowData in wsMatchHighlights)
    {
        if (![rowData[@"highlight_type_id"] isEqualToString:@"0"])
        {
            highlight_total = highlight_total + 1;
            NSMutableDictionary *h1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[playerRowforID valueForKey:[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]], @"player_row",
                                       @([[rowData[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]), @"player_id",
                                       @([rowData[@"match_minute"] intValue]), @"minute",
                                       @([rowData[@"highlight_type_id"] intValue]), @"type_id", nil];
            [self.highlights addObject:h1];
        }
    }
    
    if (highlight_total == 0)
    {
        highlight_total = 2;
        int randomMinute = [[Globals i] Random_next:10 to:80];
        int randomHomePlayer = [[Globals i] Random_next:1 to:10];
        int randomAwayPlayer = [[Globals i] Random_next:1 to:10];
        
        NSDictionary *rowData1 = wsPlayersHome[randomHomePlayer];
        
        NSMutableDictionary *h1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[playerRowforID valueForKey:[rowData1[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]], @"player_row",
                                   @([[rowData1[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]), @"player_id",
                                   @(randomMinute), @"minute",
                                   @0, @"type_id", nil];
        
        [self.highlights addObject:h1];
        
        NSDictionary *rowData2 = wsPlayersAway[randomAwayPlayer];
        
        NSMutableDictionary *h2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[playerRowforID valueForKey:[rowData2[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]], @"player_row",
                                   @([[rowData2[@"player_id"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]), @"player_id",
                                   @(randomMinute), @"minute",
                                   @0, @"type_id", nil];
        
        [self.highlights addObject:h2];
    }
}

- (void)startHighlight
{    
    highlightTextField.text = @" ";
    
    if(num == -1)
    {
        num = 0;
    }
    
    double randomFrame = [[Globals i] Random_next:0.76 to:1.2];
    maxFrames = avMaxFrames * randomFrame;
    frame = 0;

    for(Player *p in players)
    {
        [p reset];
    }
    
    [ball reset];
    
    proportion = 0;
    goalCountdown = -1;
    finished = NO;
    played = NO;
    
    highlight = (self.highlights)[num];
    BOOL homeTeamRight = NO;
    if ([highlight[@"minute"] intValue]>45)
    {
        homeTeamRight = YES;
    }
    
    BOOL homeTeamHasChance = NO;
    double chancesHomeTeamHasPossession = 0;
    int type_id = [highlight[@"type_id"] intValue];
    if (type_id==1)
    {
        homeTeamHasChance = YES;
        chancesHomeTeamHasPossession = 25;
    }
    else
    {
        homeTeamHasChance = NO;
        chancesHomeTeamHasPossession = 75;
    }
    
    BOOL homeTeamHasPossession = NO;
    if (([[Globals i] Random_next:1 to:100]) > chancesHomeTeamHasPossession)
    {
        homeTeamHasPossession = YES;
    }
    else
    {
        homeTeamHasPossession = NO;
    }
    
    Goal *homeTeam_attackingGoal;
    Goal *homeTeam_defendingGoal;
    Goal *awayTeam_attackingGoal;
    Goal *awayTeam_defendingGoal;
    
    if(homeTeamRight)
    {
        rightGoal.team = T_HOME;
        homeTeam_defendingGoal = rightGoal;
        awayTeam_attackingGoal = rightGoal;
        
        leftGoal.team = T_AWAY;
        awayTeam_defendingGoal = leftGoal;
        homeTeam_attackingGoal = leftGoal;
    }
    else
    {
        rightGoal.team = T_AWAY;
        homeTeam_defendingGoal = leftGoal;
        awayTeam_attackingGoal = leftGoal;        
        
        leftGoal.team = T_HOME;
        awayTeam_defendingGoal = rightGoal;
        homeTeam_attackingGoal = rightGoal;
    }
    
    self.attackingGoal = [[NSMutableArray alloc] initWithObjects:homeTeam_attackingGoal, awayTeam_attackingGoal, nil];
    self.defendingGoal = [[NSMutableArray alloc] initWithObjects:homeTeam_defendingGoal, awayTeam_defendingGoal, nil];
    
    [self teamDraw:T_HOME rightHalf:homeTeamRight hasChance:homeTeamHasChance hasPossession:homeTeamHasPossession];
    [self teamDraw:T_AWAY rightHalf:!homeTeamRight hasChance:!homeTeamHasChance hasPossession:!homeTeamHasPossession];
     
    for(Player *p in players)
    {
        if (p.player_id == [highlight[@"player_id"] intValue]) 
        {
            //Move the featured player 1/3 the distance to the goal
            double distX = 0;
            if (p.team == T_HOME)
            {
                distX = homeTeam_attackingGoal.x - p.xx;
            }
            else
            {
                distX = awayTeam_attackingGoal.x - p.xx;
            }
            p.xx += distX / 3;
            p.maxSpeed *= 1.1;
            [p moveTo:p.xx mY:p.yy];
            
            //Tell the player they're the one to score
            p.scorer = YES;
            break;
        }
    }
    
    for(Player *p in players)
    {
        [p decideMove];
    }
     
    seconds = ([highlight[@"minute"] intValue]*60) + (([[Globals i] Random_next:0 to:25])-5);
    
    //NSLog(@"Highlight[%d]: PlayerID:%d Type:%d", num, [[highlight objectForKey:@"player_id"] intValue], [[highlight objectForKey:@"type_id"] intValue]);

    [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
    for(Player *p in players)
    {
        if((p.action == ACTION_IDLE) && (!ball.outOfPlay))
        {
            [p decideMove];
        }
        [p turn];
    }
    
    [ball move];
    if((fabs(ball.vector.x) < .1) && (fabs(ball.vector.y) < .1))
    {
        ball.vector.x = 0;
        ball.vector.y = 0;
        ball.movingTo = Nil;
        
        if([ball outOfPitch])
        {
            ball.outOfPlay = NO;
            ball.vector.x = 1;
            ball.vector.y = 1;
        }
    }
    else
    {
        [self ball_out];
    }
    
    seconds += 0.05;
    [self drawClock];
    
    frame++;
    proportion = frame/maxFrames;
    
    if(goalCountdown > 0)
    {
        goalCountdown--;
    }
    if(goalCountdown == 0)
    {
        finished = YES;
    }
    if((ball.outOfPlay || ball.saved) && (goalCountdown < 0) && !finished && played)
    {
        if (ball.inGoal) 
        {
            [soundGoal play];
            //Flash the player details
            highlightTextField.text = [NSString stringWithFormat:@"%@, %d'th minute", 
                                       [players[[highlight[@"player_row"] intValue]] player_name],
                                       [highlight[@"minute"] intValue]];
            goalCountdown = 50;
            
            [self drawScore];
        }
        else if(ball.saved)
        {
            [soundMiss play];
            highlightTextField.text = @"Saved!";
            goalCountdown = 50;
        }
        else
        {
            [soundMiss play];
            highlightTextField.text = @"Missed!";
            goalCountdown = 20;
        }
        
        for(Player *p in players)
        {
            p.action = ACTION_FINISHED;
        }
    }
    
    if(finished)
    {
        [self removeEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        
        num++;
        if ([highlights count] > num || num < 0) 
        {
            [soundFinish play];
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startHighlight) userInfo:nil repeats:NO];
        }
        else
        {
            [self finishedHighlights];
        }
    }
    //}
}

- (void)ball_out
{
    [self.leftGoal checkGoal:self.ball];
    [self.rightGoal checkGoal:self.ball];
    
    if([ball outOfPitch] && self.played)
    {
        ball.outOfPlay = YES;
        ball.player = Nil;
        ball.team = -1;
    }
    else if([ball outOfPitch] && !ball.outOfPlay)
    {
        //Find the nearest opposition player and give the ball to them
        int teamLostBall = ball.kickedBy.team;
        int teamWithBall = abs(ball.kickedBy.team-1);
        
        //Corner or throw?
        if((ball.xx <= 0) || (ball.xx >= PITCH_WIDTH))
        {
            BOOL inLeftHalf = NO;
            BOOL inTopHalf = NO;
            
            if (ball.xx <= 0) 
            {
                inLeftHalf = YES;
            }
            if (ball.yy <= PITCH_HEIGHT/2) 
            {
                inTopHalf = YES;
            }
            
            BOOL cornerKick = NO;
            double fromPitch = 0;
            double toPitch = 0;
            if (inLeftHalf) 
            {
                fromPitch = PLAYER_WIDTH;
                toPitch = PITCH_WIDTH*0.25;
                if (self.leftGoal.team == teamLostBall) 
                {
                    cornerKick = YES;
                }
            }
            else
            {
                fromPitch = PITCH_WIDTH*0.75;
                toPitch = PITCH_WIDTH-PLAYER_WIDTH;
                if (self.rightGoal.team == teamLostBall) 
                {
                    cornerKick = YES;
                }
            }
            
            if (cornerKick) 
            {
                [self setHighlightText:@"- Corner Kick -"];
                
                //Move half the team into the box, but kick it to the goalscorer if we're on that team
                //or to one of the opposition if not
                for (Player *p in (self.teams)[teamLostBall]) 
                {
                    if (p.role != P_GOALKEEPER) 
                    {
                        p.action = ACTION_IDLE;
                        p.speed = p.maxSpeed;
                        double x = [[Globals i] Random_next:fromPitch to:toPitch];
                        double y = [[Globals i] Random_next:PITCH_HEIGHT*0.3 to:PITCH_HEIGHT*0.7];
                        [p moveTowards:[SPPoint pointWithX:x y:y] speed:0];
                    }
                }
                
                NSMutableArray *midfielders = [[NSMutableArray alloc] init];
                for (Player *p in (self.teams)[teamWithBall]) 
                {
                    if (p.role != P_GOALKEEPER) 
                    {
                        p.action = ACTION_IDLE;
                        p.speed = p.maxSpeed;
                        double x = [[Globals i] Random_next:fromPitch to:toPitch];
                        double y = [[Globals i] Random_next:PITCH_HEIGHT*0.3 to:PITCH_HEIGHT*0.7];
                        [p moveTowards:[SPPoint pointWithX:x y:y] speed:0];
                    }
                    if (p.role == P_MIDFIELDER)
                    {
                        [midfielders addObject:p];
                    }
                }
                int index = floor([[Globals i] Random_next:0 to:[midfielders count]-1]);
                Player *kicker = midfielders[index];
                kicker.action = ACTION_MOVINGCORNER;
                kicker.speed = kicker.maxSpeed*0.7;
                kicker.actionCountdown = kicker.steps;
                
                double newX = 0;
                double newY = 0;
                if (inLeftHalf) 
                {
                    newX = 0;
                }
                else
                {
                    newX = PITCH_WIDTH;
                }
                if (inTopHalf) 
                {
                    newY = 0;
                }
                else
                {
                    newY = PITCH_HEIGHT;
                }
                
                [kicker moveTowards:[SPPoint pointWithX:newX y:newY] speed:0];
                kicker.actionCountdown = kicker.steps;
                
                ball.outOfPlay = YES;
            }
            else
            {
                //Pass ball to goalkeeper
                for (Player *p in (self.teams)[teamWithBall]) 
                {
                    if (p.role == P_GOALKEEPER)
                    {
                        ball.outOfPlay = NO;
                        [p gotBall];
                        p.action = ACTION_IDLE;
                        p.actionCountdown = p.steps;
                    }
                }
                
            }
        }
        else //THROW
        {
            [self setHighlightText:@"- Throw In -"];
            double minDist = 9999;
            Player *nearest;
            
            for (Player *p in (self.teams)[teamWithBall]) 
            {
                if (p.role != P_GOALKEEPER)
                {
                    double dist = [ball getDistance:p.point];
                    if (dist < minDist) 
                    {
                        nearest = p;
                        minDist = dist;
                    }
                }
            }
            nearest.action = ACTION_MOVINGTHROW;
            [nearest moveTowards:ball.point speed:0];
            nearest.actionCountdown = nearest.steps;
            NSMutableArray *nearestPlayers = [nearest getNearestPlayers:YES num:2];
            //Move the two nearest teammates towards the player
            for(Player *p in nearestPlayers)
            {
                double x = ball.xx - p.xx;
                double y = ball.yy - p.yy;
                x = p.xx + x*[[Globals i] Random_next:0.4 to:0.8];
                y = p.yy + y*[[Globals i] Random_next:0.4 to:0.8];
                [p moveTowards:[SPPoint pointWithX:x y:y] speed:0];
            }
            NSMutableArray *nearestOpponents = [nearest getNearestPlayers:NO num:2];
            //Move the two nearest opponents towards the player
            for(Player *p in nearestOpponents)
            {
                double x = ball.xx - p.xx;
                double y = ball.yy - p.yy;
                x = p.xx + x*[[Globals i] Random_next:0.4 to:0.8];
                y = p.yy + y*[[Globals i] Random_next:0.4 to:0.8];
                [p moveTowards:[SPPoint pointWithX:x y:y] speed:0];
            }
            
            ball.outOfPlay = YES;
        }
        
        [self clearObservers];
    }
    
}

- (void)teamDraw:(int)team rightHalf:(BOOL)rightHalf hasChance:(BOOL)hasChance hasPossession:(BOOL)hasPossession
{
    double attackerPosPitch = 0.7375;
	double midfielderPosPitch = 0.4375;
	double defenderPosPitch = 0.1875;
	double goalkeeperPosPitch = 0.03125;
    double proportionDownPitch = 0.5;
    double i_a = 0;
    double i_m = 0;
    int i_d = 0;

    for(Player *p in teams[team])
    {
        if (p.role == P_GOALKEEPER) 
        {
            proportionDownPitch = 0.5;
            [p position:goalkeeperPosPitch proportionDownPitch:proportionDownPitch rightHalf:rightHalf variance:0.1];
            p.maxSpeed *= 1.1;
        }
        
        if (p.role == P_DEFENDER)
        {
            double heads = [teamsFormation[team][@"DEFENDER"] doubleValue];
            proportionDownPitch = (i_d+1) / (heads+1);
            [p position:defenderPosPitch proportionDownPitch:proportionDownPitch rightHalf:rightHalf variance:0.1];
            p.maxSpeed *= 0.9;
            
            if((i_d>0) && (i_d<4))
            {
                NSMutableArray *oppositionAttackers = [[NSMutableArray alloc] init];
                NSMutableArray *oppositionMidfielders = [[NSMutableArray alloc] init];
                for(Player *opposition in teams[abs(team-1)])
                {
                    if (opposition.role == P_ATTACKER) 
                    {
                        [oppositionAttackers addObject:opposition];
                    }
                    if (opposition.role == P_MIDFIELDER) 
                    {
                        [oppositionMidfielders addObject:opposition];
                    }
                }
                if ([oppositionAttackers count] > i_d) 
                {
                    p.marking = oppositionAttackers[i_d];
                    p.action = ACTION_MARKING;
                }
                else
                {
                    if ([oppositionMidfielders count] > i_d)
                    {
                        p.marking = oppositionMidfielders[i_d];
                        p.action = ACTION_MARKING;
                    }
                }
            }
            i_d=i_d+1;
        }
        
        if (p.role == P_MIDFIELDER)
        {
            double heads = [teamsFormation[team][@"MIDFIELDER"] doubleValue];
            proportionDownPitch = (i_m+1) / (heads+1);
            [p position:midfielderPosPitch proportionDownPitch:proportionDownPitch rightHalf:rightHalf variance:0.05];
            i_m=i_m+1;
        }
        
        if (p.role == P_ATTACKER) 
        {
            double heads = [teamsFormation[team][@"ATTACKER"] doubleValue];
            proportionDownPitch = (i_a+1) / (heads+1);
            [p position:attackerPosPitch proportionDownPitch:proportionDownPitch rightHalf:rightHalf variance:0.1];
            p.maxSpeed *= 1.2; //Adjust speed of the player depending on position
            i_a=i_a+1;
        }
    }
    
    //Choose the player with the ball
    if(hasPossession)
	{
        Player *playerWithBall = nil;
        double totalPlayersInTeam = [teams[team] count];
        int random = [[Globals i] Random_next:0 to:(totalPlayersInTeam-1)];
        playerWithBall = teams[team][random];
        
        ball.player = playerWithBall;
        ball.team = team;
        ball.xx = playerWithBall.xx;
        ball.yy = playerWithBall.yy;
    }

}

- (void)getBall
{
    for(Player *p in self.players)
    {
        if(p.role != P_GOALKEEPER)
        {
            p.action = ACTION_PASSEDBALL;
        }
    }
}

- (void)clearObservers
{
    for(Player *p in self.players)
    {
        if((p.action == ACTION_GETTINGBALL) || (p.action == ACTION_PASSEDBALL))
        {
            p.action = ACTION_IDLE;
        }
    }
}

- (void)setHighlightText:(NSString *)text
{
    highlightTextField.text = text;
}

- (void)drawScore
{
    if ([highlight[@"type_id"] intValue] == 1)
    {
        goalsHome = goalsHome + 1;
    }
    else if ([highlight[@"type_id"] intValue] == 2)
    {
        goalsAway = goalsAway + 1;
    }
    
	scoreTextField.text = [NSString stringWithFormat:@"%d : %d", goalsHome, goalsAway];
}

- (void)drawClock
{
    int mins = seconds/60;
    double secs = seconds - (mins*60);
    clockTextField.text = [NSString stringWithFormat:@"%.2d:%.2d", mins, (int)secs];
}

- (void)finishedHighlights
{
    [soundFinish play];
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(exitGame) userInfo:nil repeats:NO];
}

- (void)exitGame
{
    [mainView removeLiveMatch];
}

- (void)playSoundShoot
{
    [soundShoot play];
}

- (void)playSoundGoal
{
    [soundGoal play];
}

- (void)onButtonTriggered:(SPEvent *)event
{
    [self removeEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    
    [self exitGame];
}

- (void)onTouch:(SPTouchEvent *)event 
{

}

@end

