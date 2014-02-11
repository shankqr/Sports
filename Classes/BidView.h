

@interface BidView : UIViewController 
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) NSString *player_id;
@property (nonatomic, strong) IBOutlet UITextField *messageText;
@property (nonatomic, strong) IBOutlet UITableView *messageList;
@property (nonatomic, strong) IBOutlet UITableView *playerList;
@property (nonatomic, strong) IBOutlet UIButton *bidButton;
@property (nonatomic, strong) IBOutlet UILabel *stopWatchLabel;
@property (nonatomic, strong) IBOutlet UILabel *minBidLabel;
@property (nonatomic, strong) NSMutableArray *wsBidList;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSTimer *stopWatchTimer;

@property (nonatomic, assign) NSTimeInterval b1s;
@property (nonatomic, assign) Boolean keyboardIsShowing;
@property (nonatomic, assign) CGRect keyboardBounds;

- (void)updateView:(NSMutableArray *)player;

@end

