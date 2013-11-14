
#import "Game.h"

@class MainView;

@interface GameController : SPViewController
{
    MainView *mainView;
    Game *game;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) Game *game;
- (void)stopGame;
- (void)startGame;
@end