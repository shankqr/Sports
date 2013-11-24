
#import "DialogBoxView.h"

@class SquadView;
@class MainView;
@class DialogBoxView;
@interface PlayerView : UIViewController 
<UITableViewDataSource, UITableViewDelegate, DialogBoxDelegate>
{
    MainView *mainView;
    SquadView *squadView;
    NSString *player_id;
    IBOutlet UITableView *playerList;
    NSMutableArray *players;
    DialogBoxView *dialogBox;
    IBOutlet UIImageView *flagImageView;
    IBOutlet UILabel *nationLabel;
    IBOutlet UILabel *moraleLabel;
}
@property (nonatomic,strong) MainView *mainView;
@property (nonatomic,strong) SquadView *squadView;
@property (nonatomic,strong) NSString *player_id;
@property (nonatomic,strong) IBOutlet UITableView *playerList;
@property (nonatomic,strong) NSMutableArray *players;
@property (nonatomic,strong) DialogBoxView *dialogBox;
@property (nonatomic,strong) IBOutlet UIImageView *flagImageView;
@property (nonatomic,strong) IBOutlet UILabel *nationLabel;
@property (nonatomic,strong) IBOutlet UILabel *moraleLabel;
-(IBAction)sellButton_tap:(id)sender;
-(IBAction)energizeButton_tap:(id)sender;
-(IBAction)healButton_tap:(id)sender;
-(IBAction)renameButton_tap:(id)sender;
-(IBAction)improveButton_tap:(id)sender;
-(IBAction)moraleButton_tap:(id)sender;
-(void)updateView:(NSDictionary *)player;
@end

