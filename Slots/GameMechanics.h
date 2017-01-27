//
//  GameMechanics.h
//  Liberty Bell
//
//  Created by TapFantasy on 5/25/13.
//  Copyright (c) 2013 TapFantasy. All rights reserved.
//

@protocol GameMechanicsDelegate <NSObject>

@property (nonatomic, retain) NSDictionary *config;

@end

@interface GameMechanics : NSObject
{
    id <GameMechanicsDelegate> mainViewDelegate;
    int currentCoins;
}

- (int) getCombination:(NSArray *)combination;
- (int) getWins;
- (void) addWin:(int)win;
- (int) getCoinsUsed;
- (void) addCoinsUsed:(int)coins;
- (void) removeCoins;
- (void) setCredits:(int)credits;
- (void) addCredits:(int)credits;
- (int) getCredits;
- (void) decreaseCredits:(int)credits;
- (void) increaseCredits:(int)credits;

@property (nonatomic, retain) id <GameMechanicsDelegate> mainViewDelegate;

@end
