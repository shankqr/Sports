//
//  Audio.m
//  Liberty Bell
//
//  Created by TapFantasy on 5/26/13.
//  Copyright (c) 2013 TapFantasy. All rights reserved.
//

#import "Audio.h"

@implementation Audio

@synthesize mainViewDelegate;

- (void) initializeBackgroundMusic
{
    NSMutableArray *music = [mainViewDelegate.config objectForKey:@"backgroundMusic"];
    
    backgroundMusic = [[NSMutableArray alloc] initWithCapacity:[music count]];
    
    for (int i = 0; i < [music count]; i++)
    {
        NSString *currentMusicTitle = [music objectAtIndex:i];
        NSString *path = [[NSBundle mainBundle] pathForResource:currentMusicTitle ofType:@"mp3"];
        
        AVAudioPlayer *temp = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        
        [temp prepareToPlay];
        
        [backgroundMusic addObject:temp];
    }
    
    currentTrack = -1;
}

- (void) initializeSoundEffects
{
    NSDictionary *currentFile;
    NSString *title;
    NSString *type;
    NSString *path;
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-arm-pulled"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    fxArmPulled = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    [fxArmPulled prepareToPlay];
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-cheers"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    fxCheers = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    [fxCheers prepareToPlay];
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-insert-coin"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    fxInsertCoin = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    [fxInsertCoin prepareToPlay];
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-jackpot"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    fxJackpot = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    [fxJackpot prepareToPlay];
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-winning-combination"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    fxWinningCombination = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    [fxWinningCombination prepareToPlay];
    
    fxCoinDropping = [NSMutableArray arrayWithCapacity:32];
    fxWhoosh = [NSMutableArray arrayWithCapacity:3];
    fxPop = [NSMutableArray arrayWithCapacity:3];
    fxSlide = [NSMutableArray arrayWithCapacity:3];
    fxAppear = [NSMutableArray arrayWithCapacity:3];
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-coin-dropping"];
    
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    for (int i = 0; i < 32; i++)
    {
        AVAudioPlayer *temp = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        
        [temp prepareToPlay];
        
        [fxCoinDropping addObject:temp];
    }
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-reel-click"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
        
    fxReelClick = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        
    [fxReelClick prepareToPlay];
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-reel-stop"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    fxReelStop = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    [fxReelClick prepareToPlay];
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-slide"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    for (int i = 0; i < 3; i++)
    {
        AVAudioPlayer *temp = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        
        [temp prepareToPlay];
        
        [fxSlide addObject:temp];
    }
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-pop"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    for (int i = 0; i < 3; i++)
    {
        AVAudioPlayer *temp = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        
        [temp prepareToPlay];
        
        [fxPop addObject:temp];
    }
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-whoosh"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    for (int i = 0; i < 3; i++)
    {
        AVAudioPlayer *temp = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        
        [temp prepareToPlay];
        
        [fxWhoosh addObject:temp];
    }
    
    currentFile = [[mainViewDelegate.config objectForKey:@"soundEffects"] objectForKey:@"fx-appear"];
    title = [currentFile objectForKey:@"file"];
    type = [currentFile objectForKey:@"type"];
    path = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    for (int i = 0; i < 3; i++)
    {
        AVAudioPlayer *temp = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        
        [temp prepareToPlay];
        
        [fxAppear addObject:temp];
    }
    
    currentFxCoinDropping = -1;
    currentFxPop = -1;
    currentFxSlide = -1;
    currentFxWhoosh = -1;
    currentFxAppear = -1;
}

- (void) startNextSong
{
    BOOL musicOn = NO; //[mainViewDelegate getMusicOn];
    
    //NSLog(@"%i", musicOn);
    
    if (musicOn)
    {
        float fadeTime = [[[mainViewDelegate.config objectForKey:@"variables"] objectForKey:@"crossFadeTime"] floatValue];
        
        int rand =  arc4random() % [backgroundMusic count];
        
        while (rand == currentTrack)
        {
            rand =  arc4random() % [backgroundMusic count];
        }
        
        [self fadeIn:rand];
        
        if (currentTrack != -1)
        {
            [self fadeOut:currentTrack];
        }
        
        currentTrack = rand;
        
        AVAudioPlayer *temp = [backgroundMusic objectAtIndex:currentTrack];
        
        float delay = temp.duration - fadeTime;
        
        [self performSelector:@selector(startNextSong) withObject:nil afterDelay:delay];
    }
}

- (void) fadeIn:(int)index
{
    AVAudioPlayer *temp = [backgroundMusic objectAtIndex:index];
    
    [temp setVolume:0.0];
    
    [temp play];
    
    [self performSelectorInBackground:@selector(fadeInBack:) withObject:[NSNumber numberWithInt:index]];
}

- (void) fadeOut:(int)index
{
    float backgroundMusicVolume = [[[mainViewDelegate.config objectForKey:@"variables"] objectForKey:@"backgroundMusicVolume"] floatValue];
    
    AVAudioPlayer *temp = [backgroundMusic objectAtIndex:index];
    
    [temp setVolume:backgroundMusicVolume];
    
    [self performSelectorInBackground:@selector(fadeOutBack:) withObject:[NSNumber numberWithInt:index]];
}

- (void) fadeInBack:(NSNumber *)index
{
    float backgroundMusicVolume = [[[mainViewDelegate.config objectForKey:@"variables"] objectForKey:@"backgroundMusicVolume"] floatValue];
    
    float fadeTime = [[[mainViewDelegate.config objectForKey:@"variables"] objectForKey:@"crossFadeTime"] floatValue];
    
    float fadeTimeInterval = [[[mainViewDelegate.config objectForKey:@"variables"] objectForKey:@"crossFadeTimeInterval"] floatValue];
    
    AVAudioPlayer *temp = [backgroundMusic objectAtIndex:[index intValue]];
    
    float addition = backgroundMusicVolume / (fadeTime / fadeTimeInterval);
    float newValue = (temp.volume + addition);
    
    if (newValue > backgroundMusicVolume) newValue = backgroundMusicVolume;
    
    [temp setVolume:newValue];
    
    if (temp.volume < backgroundMusicVolume)
    {
        [NSThread sleepForTimeInterval:fadeTimeInterval];
        [self fadeInBack:index];
    }
}

- (void) fadeOutBack:(NSNumber *)index
{
    float backgroundMusicVolume = [[[mainViewDelegate.config objectForKey:@"variables"] objectForKey:@"backgroundMusicVolume"] floatValue];
    
    float fadeTime = [[[mainViewDelegate.config objectForKey:@"variables"] objectForKey:@"crossFadeTime"] floatValue];
    
    float fadeTimeInterval = [[[mainViewDelegate.config objectForKey:@"variables"] objectForKey:@"crossFadeTimeInterval"] floatValue];
    
    AVAudioPlayer *temp = [backgroundMusic objectAtIndex:[index intValue]];
    
    float addition = backgroundMusicVolume / (fadeTime / fadeTimeInterval);
    float newValue = (temp.volume - addition);
    
    if (newValue < 0) newValue = 0;
    
    [temp setVolume:newValue];
    
    [NSThread sleepForTimeInterval:fadeTimeInterval];
    
    if (temp.volume > 0.0)
    {
        [NSThread sleepForTimeInterval:fadeTimeInterval];
        [self fadeOutBack:index];
    }
    else
    {
        [temp stop];
    }
}

- (void) stopBackgroundSound
{
    for (int i = 0; i < [backgroundMusic count]; i++)
    {
        AVAudioPlayer *temp = [backgroundMusic objectAtIndex:i];
        
        if ([temp isPlaying])
        {
            [self fadeOut:i];
        }
    }
}

- (void) playFxArmPulled
{
    [fxArmPulled play];
}

- (void) playFxCheers
{
    [fxCheers play];
}

- (void) playFxInsertCoin
{
    [fxInsertCoin play];
}

- (void) playFxJackpot
{
    [fxJackpot play];
}

- (void) playFxWinningCombination
{
    [fxWinningCombination play];
}

- (void) playFxCoinDropping
{
    currentFxCoinDropping++;
    
    if (currentFxCoinDropping >= [fxCoinDropping count])
    {
        currentFxCoinDropping = 0;
    }
    
    AVAudioPlayer *temp = [fxCoinDropping objectAtIndex:currentFxCoinDropping];
    
    [temp play];
}

- (void) playFxReelClick
{
    [fxReelClick play];
}

- (void) stopFxReelClick
{
    [fxReelClick stop];
    [fxReelClick setCurrentTime:0];
}

- (void) playFxReelStop
{
    [fxReelStop play];
}

- (void) playFxSlide
{
    currentFxSlide++;
    
    if (currentFxSlide >= [fxSlide count])
    {
        currentFxSlide = 0;
    }
    
    AVAudioPlayer *temp = [fxSlide objectAtIndex:currentFxSlide];
    
    [temp play];
}

- (void) playFxPop
{
    currentFxPop++;
    
    if (currentFxPop >= [fxPop count])
    {
        currentFxPop = 0;
    }
    
    AVAudioPlayer *temp = [fxPop objectAtIndex:currentFxPop];
    
    [temp play];
}

- (void) playFxWhoosh
{
    currentFxWhoosh++;
    
    if (currentFxWhoosh >= [fxWhoosh count])
    {
        currentFxWhoosh = 0;
    }
    
    AVAudioPlayer *temp = [fxWhoosh objectAtIndex:currentFxWhoosh];
    
    [temp play];
}

- (void) playFxAppear
{
    currentFxAppear++;
    
    if (currentFxAppear >= [fxAppear count])
    {
        currentFxAppear = 0;
    }
    
    AVAudioPlayer *temp = [fxAppear objectAtIndex:currentFxAppear];
    
    [temp play];
}

@end
