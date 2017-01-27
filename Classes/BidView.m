
#import "BidView.h"
#import "Globals.h"
#import "PlayerCell.h"

@implementation BidView

- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.messageText.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopTimer];
    [self keyboardWillHide];
}

- (void)updateView:(NSMutableArray *)player
{
    self.b1s = 0.0;
    	
	self.messageText.delegate = self;
    
    self.players = player;
    self.stopWatchTimer = nil;
    self.stopWatchLabel.text = @" ";
    self.messageText.text = @"";
    self.minBidLabel.text = @" ";

    [self.playerList reloadData];
    NSDictionary *rowData = (self.players)[0];
    self.player_id = rowData[@"player_id"];
    
    [self getNewMessages];
}

- (void)getNewMessages
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/GetBid/%@", WS_URL, self.player_id];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    self.wsBidList = [[NSMutableArray alloc] initWithContentsOfURL:url];
    
    NSDictionary *rowData;
    NSString *bid_value;
    
    if([self.wsBidList count] > 0)
    {
        [self resizeViewControllerToFitScreen];
        
        if (!self.keyboardIsShowing)
        {
            rowData = (self.wsBidList)[[self.wsBidList count]-1];
            bid_value = [rowData[@"bid_value"]stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSInteger auto_input = [bid_value integerValue]+10000;
            NSString *minBid = [NSString stringWithFormat:@"%ld", (long)auto_input];
            self.messageText.text = minBid;
            self.minBidLabel.text = [NSString stringWithFormat:@"Min Bid:$%@", [[Globals i] numberFormat:minBid]];
        }
        
        [self startTimer];
    }
    else
    {
        [self stopTimer];
        
        [self.messageList reloadData];
        NSString *returnValue  = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        
        if([returnValue isEqualToString:@"0"])
        {
            //BID is closed
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Scout"
                                  message:@"This player has just been purchased. Look out for other players."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            alert.tag = 1;
            [alert show];
        }
        else
        {
            [self resizeViewControllerToFitScreen];
            
            if (!self.keyboardIsShowing)
            {
                rowData = (self.players)[0];
                bid_value = rowData[@"player_value"];
                NSInteger auto_input = [bid_value integerValue]+10000;
                NSString *minBid = [NSString stringWithFormat:@"%ld", (long)auto_input];
                self.messageText.text = minBid;
                self.minBidLabel.text = [NSString stringWithFormat:@"Min Bid:$%@", [[Globals i] numberFormat:minBid]];

            }
        }
    }
}

- (void)updateTimeLeft
{
    NSTimeInterval serverTimeInterval = [[Globals i] updateTime];

    NSTimeInterval firstBidTime;
    NSDate *firstBidDate;
    NSString *strDate;
    
    NSDictionary *rowData = (self.wsBidList)[0];
    strDate = rowData[@"bid_datetime"];
    strDate = [NSString stringWithFormat:@"%@ -0000", strDate];
    firstBidDate = [[[Globals i] getDateFormat] dateFromString:strDate];
    firstBidTime = [firstBidDate timeIntervalSince1970];
    self.b1s = (24*3600) - (serverTimeInterval - firstBidTime);
}

- (void)stopTimer
{
    [self.stopWatchTimer invalidate];
    self.stopWatchLabel.text = @" ";
}

- (void)startTimer
{
    if(!self.stopWatchTimer.isValid)
    {
        [self updateTimeLeft];
        
        self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(updateTimer)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}

- (void)updateTimer
{
    self.b1s = self.b1s-1;
    
    NSString *labelString = [[NSString alloc] initWithFormat:@" TimeLeft %@ ", [[Globals i] getCountdownString:self.b1s]];
    self.stopWatchLabel.text = labelString;
    
    if(((NSInteger)self.b1s % 60) == 0)
    {
        [self getNewMessages];
    }
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
            self.keyboardBounds = CGRectMake(0, 1024, 768, 264);
        }
        else
        {
            self.keyboardBounds = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, 216);
        }
        
        [self resizeViewControllerToFitScreen];
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
        self.messageList.frame = CGRectMake(0, BID_CEILING, self.view.frame.size.width, self.view.frame.size.height-BID_CEILING-31-self.keyboardBounds.size.height);
        self.messageText.frame = CGRectMake(0, self.view.frame.size.height-31-self.keyboardBounds.size.height, self.view.frame.size.width, 31);
        self.bidButton.frame = CGRectMake(SCREEN_WIDTH-BID_BUTTON_WIDTH, UIScreen.mainScreen.bounds.size.height-31-self.keyboardBounds.size.height, BID_BUTTON_WIDTH, 31.0f);
    }
    else
    {
        self.messageList.frame = CGRectMake(0, BID_CEILING, self.view.frame.size.width, self.view.frame.size.height-BID_CEILING-31);
        self.messageText.frame = CGRectMake(0, self.view.frame.size.height-31, self.view.frame.size.width, 31);
        self.bidButton.frame = CGRectMake(SCREEN_WIDTH-BID_BUTTON_WIDTH, UIScreen.mainScreen.bounds.size.height-31, BID_BUTTON_WIDTH, 31.0f);
    }
    
	[UIView commitAnimations];
    
    
    if([self.wsBidList count] > 0)
    {
        [self.messageList reloadData];
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.wsBidList count] - 1) inSection:0];
        [[self messageList] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)close
{
    [self stopTimer];
    
    [self keyboardWillHide];
    
	[UIManager.i closeTemplate];
}

- (IBAction)sendClicked
{
    if([self.wsBidList count] > 0) //Player has been bidded before
    {

    }
    else //This is the first bidder
    {
        self.b1s = (24*3600);
    }
    
	if((self.b1s > 1.0) && ([self.messageText.text length] > 0) && ([self.messageText.text integerValue] > 0))
    {
        NSDictionary *rowData;
        NSString *bid_value;
        NSString *player_value;
        
        rowData = (self.players)[0];
        player_value = rowData[@"player_value"];
        
        if([self.wsBidList count] > 0) //Player has been bidded before
        {
            rowData = (self.wsBidList)[[self.wsBidList count]-1];
            bid_value = [rowData[@"bid_value"]stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            if ([player_value integerValue] > [bid_value integerValue])
            {
                bid_value = player_value;
            }
        }
        else //This is the first bidder
        {
            bid_value = player_value;
        }
        
        if([self.messageText.text integerValue] > ([bid_value integerValue]+9999))
        {
            NSInteger bal = [[[Globals i] getClubData][@"balance"] integerValue];
            if([self.messageText.text integerValue] < bal)
            {
                if([[[Globals i] doBid:self.player_id:self.messageText.text] isEqualToString:@"1"])
                {
                    [self getNewMessages];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Accountant"
                                      message:@"We can't afford this bid. Get more club funds. Convert some Diamonds to Funds?"
                                      delegate:self
                                      cancelButtonTitle:@"CANCEL"
                                      otherButtonTitles:@"OK", nil];
                alert.tag = 3;
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Scout"
                                  message:[NSString stringWithFormat:@"The minimum bid is $%ld", (long)[bid_value integerValue]+10000]
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            alert.tag = 4;
            [alert show];
        }
    }
	
	self.messageText.text = @"";
    [self keyboardWillHide];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *row1 = (self.wsBidList)[[indexPath row]];
    
    if([row1[@"club_id"] isEqualToString:[[Globals i] wsClubDict][@"club_id"]])
    {
        return @{@"align_top": @"1", @"r1": row1[@"club_name"], @"r2": [[Globals i] numberFormat:row1[@"bid_value"]], @"c1": [[Globals i] getTimeAgo:row1[@"bid_datetime"]], @"c1_ratio": @"3"};
    }
    else
    {
        return @{@"select_able": @"1", @"align_top": @"1", @"r1": row1[@"club_name"], @"r2": [[Globals i] numberFormat:row1[@"bid_value"]], @"c1": [[Globals i] getTimeAgo:row1[@"bid_datetime"]], @"c1_ratio": @"3"};
    }
}

// Driving The Table View
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (tableView == self.playerList) 
    {
        return [[Globals i] playerCellHandler:tableView indexPath:indexPath playerArray:self.players checkPos:NO];
    }
    else
    {
        return [DynamicCell dynamicCell:self.messageList rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.playerList)
    {
        return 1;
    }
    else
    {
        return [self.wsBidList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.playerList) 
    {
        return 170*SCALE_IPAD;
    }
    else
    {
        return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.playerList) 
    {
        return nil;
    }
    else
    {
        NSDictionary *rowData = (self.wsBidList)[indexPath.row];
	
        if(![rowData[@"club_id"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
        {
            self.selected_clubid = [[NSString alloc] initWithString:rowData[@"club_id"]];
            [self keyboardWillHide];
            
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:self.selected_clubid forKey:@"club_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
    
        return nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (alertView.tag == 1) 
    {
        if(buttonIndex == 0)
        {
            [self close];
        }
    }
    
    if (alertView.tag == 3) 
    {
        if(buttonIndex == 1)
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"BuyFunds"
             object:self];
        }
    }
}

@end
