#import "EventsView.h"

@implementation EventsView
@synthesize mainView;
@synthesize messages;
@synthesize messageList;


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (UIScreen.mainScreen.bounds.size.height != 568 && !iPad)
    {
        [messageList setFrame:CGRectMake(0, messageList.frame.origin.y, 320, UIScreen.mainScreen.bounds.size.height-messageList.frame.origin.y)];
    }
    
	messageList.dataSource = self;
	messageList.delegate = self;
	[self getNewMessages];
}

- (void)close
{
	[self.view removeFromSuperview];
}

- (IBAction)cancelButton_tap:(id)sender
{
	[mainView backSound];
	[self close];
}

- (void)updateView
{
    [self getNewMessages];
}

// Getting the events message
- (void)getNewMessages
{
    [[Globals i] updateEventsData];
    self.messages = [[Globals i] getEventsData];
    if([self.messages count]>0)
    {
        [messageList reloadData];
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
    
    cell.messageLabel.text = [NSString stringWithFormat:@"[%@]%@",
                              date,
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
	return nil;
}

@end
