//
//  ChatView.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface ChatView : UIViewController
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSString *isAllianceChat;
    NSString *allianceId;
    NSString *postTable;
    NSMutableArray *dataSource;
    NSString *selected_clubid;
    NSMutableArray *messages;
	NSTimer *refreshTimer;
    Boolean keyboardIsShowing;
    CGRect keyboardBounds;
	IBOutlet UITextField *messageText;
	IBOutlet UITableView *messageList;
}
@property (nonatomic, strong) NSString *isAllianceChat;
@property (nonatomic, strong) NSString *allianceId;
@property (nonatomic, strong) NSString *postTable;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) UITextField *messageText;
@property (nonatomic, strong) UITableView *messageList;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSTimer *refreshTimer;
- (void)updateView:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid;
@end