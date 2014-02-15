//
//  GameMechanics.m
//  Liberty Bell
//
//  Created by TapFantasy on 5/25/13.
//  Copyright (c) 2013 TapFantasy. All rights reserved.
//

#import "GameMechanics.h"

@implementation GameMechanics

@synthesize mainViewDelegate;

- (int) getCombination:(NSArray *)combination
{
    int ret = -1;
    
    NSArray *combinations = [mainViewDelegate.config objectForKey:@"combinations"];
    
    for (int i = 0; i < [combinations count]; i++)
    {
        NSArray *thisCombination = [[combinations objectAtIndex:i] objectForKey:@"combination"];
        
        BOOL match = YES;
        
        for (int j = 0; j < [combination count]; j++)
        {
            NSString *thisItem = [thisCombination objectAtIndex:j];
            NSString *inputItem = [combination objectAtIndex:j];
            
            if ((![thisItem isEqualToString:@"wildcard"]) && ![thisItem isEqualToString:inputItem])
            {
                match = NO;
                break;
            }
        }
        
        if (match)
        {
            ret = i;
            break;
        }
    }
    
    return ret;
}

- (int) getWins
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"wins"] intValue];
}

- (void) addWin:(int)win
{
    int currentWins = [self getWins];
    
    currentWins += win;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:currentWins] forKey:@"wins"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int) getCoinsUsed
{
    return currentCoins;
}

- (void) addCoinsUsed:(int)coins
{
    currentCoins += coins;
}

- (void) removeCoins
{
    currentCoins = 0;
}

- (int) getCredits
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"credits"] intValue];
}

- (void) setCredits:(int)credits
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:credits] forKey:@"credits"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) addCredits:(int)credits
{
    int currentCredits = [self getCredits];
    
    currentCredits += credits;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:currentCredits] forKey:@"credits"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) decreaseCredits:(int)credits
{
    int currentCredits = [self getCredits];
    
    currentCredits -= credits;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:currentCredits] forKey:@"credits"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) increaseCredits:(int)credits
{
    int currentCredits = [self getCredits];
    
    currentCredits += credits;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:currentCredits] forKey:@"credits"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
