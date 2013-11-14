#import "MainView.h"
#import "Globals.h"
#import "ChatCell.h"

@interface EventsView : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    MainView *mainView;
	IBOutlet UITableView *messageList;
	NSMutableArray *messages;
	NSTimer *timer;
}
@property (nonatomic,strong) MainView *mainView;
@property (nonatomic,strong) UITableView *messageList;
@property (nonatomic,strong) NSMutableArray *messages;
- (IBAction)cancelButton_tap:(id)sender;
- (void)getNewMessages;
- (void)updateView;
- (void)close;
@end

