//
//  ChatView.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "ChatView.h"
#import "Globals.h"

@implementation ChatView
@synthesize isAllianceChat;
@synthesize allianceId;
@synthesize postTable;
@synthesize dataSource;
@synthesize selected_clubid;
@synthesize messages;
@synthesize messageText;
@synthesize messageList;
@synthesize refreshTimer;

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self refreshMessages];
    
    if(!refreshTimer.isValid)
    {
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refreshMessages) userInfo:nil repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    if(refreshTimer.isValid)
    {
        [refreshTimer invalidate];
    }
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	messageList.dataSource = self;
	messageList.delegate = self;
	messageText.delegate = self;
    
    self.allianceId = @"0";
    self.isAllianceChat = @"0";
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSValue *keyboardBoundsValue = userInfo[UIKeyboardFrameBeginUserInfoKey];
	[keyboardBoundsValue getValue:&keyboardBounds];
	keyboardIsShowing = YES;
	[self resizeViewControllerToFitScreen];
    
    if([self.messages count] > 0)
    {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([messages count] - 1) inSection:0];
        [[self messageList] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)note
{
	keyboardIsShowing = NO;
	keyboardBounds = CGRectMake(0, 0, 0, 0);
	[self resizeViewControllerToFitScreen];
}

- (void)resizeViewControllerToFitScreen 
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
	if (keyboardIsShowing)
    {
        self.messageList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-31-keyboardBounds.size.height);
        self.messageText.frame = CGRectMake(0, self.view.frame.size.height-31-keyboardBounds.size.height, self.view.frame.size.width, 31);
    }
    else
    {
        self.messageList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-31);
        self.messageText.frame = CGRectMake(0, self.view.frame.size.height-31, self.view.frame.size.width, 31);
    }
    
	[UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    if([string isEqualToString:@"\n"])
	{
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)updateView:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid
{
    self.allianceId = aid;
    self.postTable = tn;
    self.dataSource = ds;
    
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self resizeViewControllerToFitScreen];
    
    self.messages = [[NSMutableArray alloc] initWithArray:self.dataSource copyItems:YES];
    [messageList reloadData];
    if([self.messages count] > 0)
    {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([messages count] - 1) inSection:0];
        [[self messageList] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (IBAction)messageText_tap:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)sendClicked:(id)sender
{
    [[Globals i] buttonSound];
    
	if([messageText.text length] > 0)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              [[Globals i] wsClubData][@"club_id"],
                              @"club_id",
                              [[Globals i] wsClubData][@"club_name"],
                              @"club_name",
                              [[Globals i] wsClubData][@"alliance_id"],
                              @"alliance_id",
                              [[Globals i] wsClubData][@"alliance_name"],
                              @"alliance_name",
                              messageText.text,
                              @"message",
                              self.postTable,
                              @"table_name",
                              self.allianceId,
                              @"target_alliance_id",
                              nil];
        
        [Globals postServer:dict :@"PostChat" :^(BOOL success, NSData *data){}];
        
        //Show typed text instantly
        NSString *datenow = [[Globals i] getServerDateTimeString];
        [dict addEntriesFromDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        datenow,
                                        @"date_posted", nil]];
        if (self.messages != nil)
        {
            [self.messages addObject:dict];
        }
        else
        {
            self.messages = [[NSMutableArray alloc] initWithObjects:dict, nil];
        }
        if([self.messages count] > 0)
        {
            [messageList reloadData];
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([messages count] - 1) inSection:0];
            [[self messageList] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
	}
    
	messageText.text = @"";
}

- (void)refreshMessages
{
    if ([self.isAllianceChat isEqualToString:@"1"])
    {
        [[Globals i] updateAllianceChatData];
        self.dataSource = [[Globals i] wsAllianceChatFullData];
    }
    
    if([self.dataSource count] > [self.messages count])
    {
        self.messages = [[NSMutableArray alloc] initWithArray:self.dataSource copyItems:YES];
        [messageList reloadData];
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([messages count] - 1) inSection:0];
        [[self messageList] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *row1 = (self.messages)[[indexPath row]];

    if([row1[@"club_id"] isEqualToString:[[Globals i] wsClubData][@"club_id"]])
    {
        return @{@"align_top": @"1", @"r1": row1[@"club_name"], @"r2": row1[@"message"], @"r3": [[Globals i] getTimeAgo:row1[@"date_posted"]], @"c1": row1[@"alliance_name"], @"c1_ratio": @"2.5", @"c1_color": @"2"};
    }
    else
    {
        return @{@"select_able": @"1", @"align_top": @"1", @"r1": row1[@"club_name"], @"r2": row1[@"message"], @"r3": [[Globals i] getTimeAgo:row1[@"date_posted"]], @"c1": row1[@"alliance_name"], @"c1_ratio": @"2.5", @"c1_color": @"2"};
    }
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[Globals i] dynamicCell:messageList rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[Globals i] dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
	return [self.messages count];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (keyboardIsShowing)
    {
        [self.messageText resignFirstResponder];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = self.messages[indexPath.row];
	
    if(![rowData[@"club_id"] isEqualToString:[[Globals i] wsClubData][@"club_id"]])
    {
        selected_clubid = [[NSString alloc] initWithString:rowData[@"club_id"]];
	
        if (keyboardIsShowing)
        {
            [self.messageText resignFirstResponder];
        }
        
        //Show club viewer
    }
    
	return nil;
}

@end