//
//  Audio.h
//  Liberty Bell
//
//  Created by TapFantasy on 5/26/13.
//  Copyright (c) 2013 TapFantasy. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface Audio : NSObject
{
    NSMutableArray *backgroundMusic;
    int currentTrack;
    
    AVAudioPlayer *fxArmPulled;
    AVAudioPlayer *fxCheers;
    AVAudioPlayer *fxInsertCoin;
    AVAudioPlayer *fxJackpot;
    AVAudioPlayer *fxWinningCombination;
    AVAudioPlayer *fxReelClick;
    AVAudioPlayer *fxReelStop;

    NSMutableArray *fxCoinDropping;
    NSMutableArray *fxSlide;
    NSMutableArray *fxPop;
    NSMutableArray *fxWhoosh;
    NSMutableArray *fxAppear;
    
    int currentFxCoinDropping;
    int currentFxSlide;
    int currentFxPop;
    int currentFxWhoosh;
    int currentFxAppear;
}
@property (nonatomic, strong) NSDictionary *config;
+ (Audio *)i;
- (void) initializeBackgroundMusic;
- (void) initializeSoundEffects;
- (void) fadeIn:(int)index;
- (void) fadeOut:(int)index;
- (void) fadeInBack:(NSNumber *)index;
- (void) fadeOutBack:(NSNumber *)index;
- (void) startNextSong;
- (void) stopBackgroundSound;
- (void) playFxArmPulled;
- (void) playFxCheers;
- (void) playFxInsertCoin;
- (void) playFxJackpot;
- (void) playFxWinningCombination;
- (void) playFxCoinDropping;
- (void) playFxReelClick;
- (void) stopFxReelClick;
- (void) playFxReelStop;
- (void) playFxSlide;
- (void) playFxPop;
- (void) playFxWhoosh;
- (void) playFxAppear;

@end
