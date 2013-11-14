#import "WallView.h"

@implementation WallView
@synthesize mainView;
@synthesize selected_clubid;
@synthesize messages;
@synthesize messageText;
@synthesize messageList;


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	messageList.dataSource = self;
	messageList.delegate = self;
	messageText.delegate = self;
	[self getNewMessages];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSValue *keyboardBoundsValue = userInfo[UIKeyboardFrameBeginUserInfoKey];
	[keyboardBoundsValue getValue:&keyboardBounds];
	keyboardIsShowing = YES;
	[self resizeViewControllerToFitScreen];
}

- (void)keyboardWillHide:(NSNotification *)note
{
	keyboardIsShowing = NO;
	keyboardBounds = CGRectMake(0, 0, 0, 0);
	[self resizeViewControllerToFitScreen];
}

- (void)resizeViewControllerToFitScreen 
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
	if (keyboardIsShowing)
    {
        self.messageList.frame = CGRectMake(0, 0, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height-31-keyboardBounds.size.height);
        self.messageText.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height-31-keyboardBounds.size.height, SCREEN_WIDTH, 31.0f);
    }
    else
    {
        self.messageList.frame = CGRectMake(0, 0, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height-31);
        self.messageText.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height-31, SCREEN_WIDTH, 31.0f);
    }
    
	[UIView commitAnimations];
    
    [self getNewMessages];
}

- (void)close
{
    keyboardIsShowing = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
	[self.view removeFromSuperview];
}

- (IBAction)cancelButton_tap:(id)sender
{
	[mainView backSound];
	[self close];
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

- (void)updateView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self resizeViewControllerToFitScreen];
}

- (IBAction)messageText_tap:(id)sender
{
    [mainView buttonSound];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// Sending the message to the server
- (IBAction)sendClicked:(id)sender
{
    [mainView buttonSound];
	if([messageText.text length] > 0)
    {
		if([[[Globals i] doPost:messageText.text] isEqualToString:@"1"])
		{
            [self getNewMessages];
        }
	}
	
	messageText.text = @"";
}

// Getting the message
- (void)getNewMessages
{
    [[Globals i] updateWallData];
    self.messages = [[Globals i] getWallData];
    if([self.messages count]>0)
    {
        [messageList reloadData];
        //NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([messages count] - 1) inSection:0];
        //[[self messageList] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

// Driving The Table View
- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"ChatCell";
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.messages)[row];
    
	ChatCell *cell = (ChatCell *)[messageList dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil];
		cell = (ChatCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
    
    NSString *date = rowData[@"date_posted"];
    if ([date length] > 0)
    {
        date = [date substringToIndex:[date length] - 15];
    }
    
    cell.messageLabel.text = [NSString stringWithFormat:@"[%@] %@:%@",
                              date,
                              rowData[@"club_name"],
                              rowData[@"message"]];
    
    if([rowData[@"club_id"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
    {
        [cell.messageLabel setTextColor:[UIColor redColor]];
    }
    else
    {
        [cell.messageLabel setTextColor:[UIColor blackColor]];
    }
    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
	return [self.messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40*SCALE_IPAD;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowData = [[Globals i] getWallData][indexPath.row];
	
    if(![rowData[@"club_id"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
    {
    selected_clubid = [[NSString alloc] initWithString: [rowData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
	
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:rowData[@"club_name"]
						  message:rowData[@"message"]
						  delegate:self
						  cancelButtonTitle:@"Close"
						  otherButtonTitles:@"Club Info", @"Challenge", nil];
	[alert show];
    }
    
	return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
        [messageText resignFirstResponder];
		[self.mainView jumpToClubViewer:selected_clubid];
    }
    if(buttonIndex == 2)
	{
        [messageText resignFirstResponder];
		[self.mainView jumpToChallenge:selected_clubid];
    }
}

@end
