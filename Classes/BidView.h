

@interface BidView : UIViewController 
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    NSString *selected_clubid;
    NSString *player_id;
	IBOutlet UITextField *messageText;
	IBOutlet UITableView *messageList;
    IBOutlet UITableView *playerList;
    IBOutlet UIButton *bidButton;
    IBOutlet UILabel *stopWatchLabel;
    IBOutlet UILabel *minBidLabel;
	NSMutableArray *wsBidList;
    NSMutableArray *players;
    Boolean keyboardIsShowing;
    CGRect keyboardBounds;
    NSTimer *stopWatchTimer;
    NSDateFormatter *dateFormat;
    NSDateFormatter *serverFormat;
    NSTimeInterval b1s;
}
@property (nonatomic,strong) NSString *selected_clubid;
@property (nonatomic,strong) NSString *player_id;
@property (nonatomic,strong) IBOutlet UITextField *messageText;
@property (nonatomic,strong) IBOutlet UITableView *messageList;
@property (nonatomic,strong) IBOutlet UITableView *playerList;
@property (nonatomic,strong) IBOutlet UIButton *bidButton;
@property (nonatomic,strong) IBOutlet UILabel *stopWatchLabel;
@property (nonatomic,strong) IBOutlet UILabel *minBidLabel;
@property (nonatomic,strong) NSMutableArray *wsBidList;
@property (nonatomic,strong) NSMutableArray *players;
@property (nonatomic,strong) NSTimer *stopWatchTimer;
@property (nonatomic,strong) NSDateFormatter *dateFormat;
@property (nonatomic,strong) NSDateFormatter *serverFormat;
@property (readwrite) NSTimeInterval b1s;
- (void)updateView:(NSMutableArray *)player;
@end

