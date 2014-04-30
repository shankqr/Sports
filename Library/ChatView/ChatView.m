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

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (self.messageList == nil)
    {
        self.messageList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.messageList setBackgroundColor:[UIColor clearColor]];
        self.messageList.backgroundView = nil;
        self.messageList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:self.messageList];
    }
	self.messageList.dataSource = self;
	self.messageList.delegate = self;
    
    if (self.messageText == nil)
    {
        self.messageText = [[UITextField alloc] initWithFrame:CGRectZero];
        self.messageText.borderStyle = UITextBorderStyleBezel;
        self.messageText.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.messageText];
    }
	self.messageText.delegate = self;
    
    self.allianceId = @"0";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self keyboardWillHide];
    
    [self sendClicked];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!self.keyboardIsShowing)
    {
        self.keyboardIsShowing = YES;
        if (iPad)
        {
            self.keyboardBounds = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, 264);
        }
        else
        {
            self.keyboardBounds = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, 216);
        }
        
        [self resizeViewControllerToFitScreen];
        
        if([self.messages count] > 0)
        {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messages count] - 1) inSection:0];
            [[self messageList] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

- (void)keyboardWillHide
{
    [self.messageText resignFirstResponder];
    
	self.keyboardIsShowing = NO;
	self.keyboardBounds = CGRectMake(0, 0, 0, 0);
	[self resizeViewControllerToFitScreen];
}

- (void)resizeViewControllerToFitScreen
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
	if (self.keyboardIsShowing)
    {
        CGPoint p = [self.view convertPoint:self.view.frame.origin toView:[[Globals i] firstViewControllerStack].view];
        
        float view_y = p.y;
        float bottom_offset = UIScreen.mainScreen.bounds.size.height-self.view.frame.size.height-view_y;
        float text_y = self.view.frame.size.height-31-self.keyboardBounds.size.height+bottom_offset;
        
        self.messageList.frame = CGRectMake(0, 0, self.view.frame.size.width, text_y);
        self.messageText.frame = CGRectMake(0, text_y, self.view.frame.size.width, 31);
    }
    else
    {
        self.messageList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-31);
        self.messageText.frame = CGRectMake(0, self.view.frame.size.height-31, self.view.frame.size.width, 31);
    }
    
	[UIView commitAnimations];
}

- (void)updateView:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid
{
    self.allianceId = aid;
    self.postTable = tn;
    self.dataSource = ds;
    
    self.keyboardIsShowing = NO;
    
    [self resizeViewControllerToFitScreen];
    
    self.messages = [[NSMutableArray alloc] initWithArray:self.dataSource copyItems:YES];
    [self.messageList reloadData];
    if([self.messages count] > 0)
    {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messages count] - 1) inSection:0];
        [[self messageList] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    if ([self.allianceId isEqualToString:@"0"])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshMessages)
                                                     name:@"ChatWorld"
                                                   object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshMessages)
                                                     name:@"ChatAlliance"
                                                   object:nil];
    }
}

- (void)sendClicked
{
	if([self.messageText.text length] > 0)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              [[Globals i] wsClubDict][@"club_id"],
                              @"club_id",
                              [[Globals i] wsClubDict][@"club_name"],
                              @"club_name",
                              [[Globals i] wsClubDict][@"alliance_id"],
                              @"alliance_id",
                              [[Globals i] wsClubDict][@"alliance_name"],
                              @"alliance_name",
                              self.messageText.text,
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
            [self.messageList reloadData];
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messages count] - 1) inSection:0];
            [[self messageList] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
	}
    
	self.messageText.text = @"";
}

- (void)refreshMessages
{
    if([self.dataSource count] > [self.messages count])
    {
        self.messages = [[NSMutableArray alloc] initWithArray:self.dataSource copyItems:YES];
        [self.messageList reloadData];
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messages count] - 1) inSection:0];
        [[self messageList] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *row1 = (self.messages)[[indexPath row]];

    if([row1[@"club_id"] isEqualToString:[[Globals i] wsClubDict][@"club_id"]])
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
    return [DynamicCell dynamicCell:self.messageList rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
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
    if (self.keyboardIsShowing)
    {
        [self keyboardWillHide];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = self.messages[indexPath.row];
	
    if(![rowData[@"club_id"] isEqualToString:[[Globals i] wsClubDict][@"club_id"]])
    {
        self.selected_clubid = [[NSString alloc] initWithString:rowData[@"club_id"]];
	
        if (self.keyboardIsShowing)
        {
            [self keyboardWillHide];
        }
        
        [[Globals i] closeTemplate];
        
        //Show club viewer
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.selected_clubid forKey:@"club_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
    
	return nil;
}

@end