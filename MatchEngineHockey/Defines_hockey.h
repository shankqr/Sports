//
//  Defines.h
//  Sports
//
//  Created by Shankar on 11/19/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#define GRAVITY 0.8
#define P_GOALKEEPER 1
#define P_DEFENDER 2
#define P_MIDFIELDER 3
#define P_ATTACKER 4
#define T_HOME 0
#define T_AWAY 1
#define GOAL_LEFT 0
#define GOAL_RIGHT 1
#define ACTION_IDLE 0
#define ACTION_RETURNING 1
#define ACTION_MARKING 2
#define ACTION_INTERCEPTING 3
#define ACTION_ATTACKINGGOAL 4
#define ACTION_RUNNING 5
#define ACTION_GETTINGBALL 6
#define ACTION_KICKINGBALL 7
#define ACTION_PASSEDBALL 8
#define ACTION_CELEBRATING 9
#define ACTION_FINISHED 10
#define ACTION_SAVING 11
#define ACTION_RUNNINGONSIDE 12
#define ACTION_TACKLING 13
#define ACTION_MOVINGTHROW 14
#define ACTION_MOVINGCORNER 15
#define ACTION_TAKINGTHROW 16
#define ACTION_TAKINGCORNER 17

#define PLAYER_WIDTH 9
#define PLAYER_HEIGHT 50
#define PLAYER_SCALE (iPad ? 1.0f : 0.5f)
#define PLAYER_NAME (iPad ? 40.0f : 20.0f)
#define PITCH_WIDTH (iPad ? 940.0f : 470.0f)
#define PITCH_HEIGHT (iPad ? 528.0f : 264.0f)
#define PITCH_WIDTH_OFFSET (iPad ? 10.0f : 5.0f)
#define PITCH_HEIGHT_OFFSET (iPad ? 54.0f : 27.0f)
#define FONT_SIZE (iPad ? 40.0f : 20.0f)
#define GOAL_OFFSET (iPad ? 0.0f : 0.0f)
#define SKIP_OFFSET (iPad ? 180.0f : 100.0f)
#define CLOCK_OFFSET (iPad ? 50.0f : 97.0f)
#define HIGHLIGHT_OFFSET (iPad ? 20.0f : -20.0f)
#define HIGHLIGHT_COLOR (iPad ? 0xffffff : 0x000000)
#define LOGO1_OFFSET (iPad ? 0.0f : 10.0f)
#define LOGO2_OFFSET (iPad ? 140.0f : 100.0f)

@interface NSObject ()

@end
