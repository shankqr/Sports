#import "MainView.h"
#import "Globals.h"
#import "AllianceCell.h"
#import "DialogBoxView.h"

@interface MembersView : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    MainView *mainView;
	IBOutlet UITableView *messageList;
	NSMutableArray *messages;
    NSString *selected_clubid;
    NSString *selected_aid;
    NSString *selected_clubname;
    NSString *alliance_leader_id;
    DialogBoxView *dialogBox;
	NSTimer *timer;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) UITableView *messageList;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) NSString *selected_aid;
@property (nonatomic, strong) NSString *selected_clubname;
@property (nonatomic, strong) NSString *alliance_leader_id;
@property (nonatomic, strong) DialogBoxView *dialogBox;
- (IBAction)cancelButton_tap:(id)sender;
- (void)getNewMessages;
- (void)updateView;
- (void)close;
@end

