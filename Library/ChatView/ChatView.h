//
//  ChatView.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface ChatView : UIViewController
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString *allianceId;
@property (nonatomic, strong) NSString *postTable;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) UITextField *messageText;
@property (nonatomic, strong) UITableView *messageList;
@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, assign) Boolean keyboardIsShowing;
@property (nonatomic, assign) CGRect keyboardBounds;

- (void)updateView:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid;

@end