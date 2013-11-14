
#import "GameController.h"
#import "MainView.h"

@implementation GameController
@synthesize mainView;
@synthesize game;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.multitouchEnabled = YES;
    }
    return self;
}

- (void)stopGame
{
    [SPAudioEngine stop];
}

- (void)startGame
{
    [SPAudioEngine start];
    
    [self startWithRoot:[Game class] supportHighResolutions:YES doubleOnPad:YES];
    //get the game instance
    game = (Game *)[self root];
    
    game.mainView = self.mainView;
    [game loadClub];
    [game startHighlight];
}

@end