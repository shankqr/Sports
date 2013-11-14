#import "MainView.h"
#import "Globals.h"
#import "ChatCell.h"

@interface WallView : UIViewController
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    MainView *mainView;
    NSString *selected_clubid;
	IBOutlet UITextField *messageText;
	IBOutlet UITableView *messageList;
	NSMutableArray *messages;
	NSTimer *timer;
    Boolean keyboardIsShowing;
    CGRect keyboardBounds;
}
@property (nonatomic,strong) MainView *mainView;
@property (nonatomic,strong) NSString *selected_clubid;
@property (nonatomic,strong) UITextField *messageText;
@property (nonatomic,strong) UITableView *messageList;
@property (nonatomic,strong) NSMutableArray *messages;
- (IBAction)sendClicked:(id)sender;
- (IBAction)cancelButton_tap:(id)sender;
- (IBAction)messageText_tap:(id)sender;
- (void)getNewMessages;
- (void)updateView;
- (void)close;
- (void)resizeViewControllerToFitScreen;
@end

