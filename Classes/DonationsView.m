#import "DonationsView.h"

@implementation DonationsView
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
    [[Globals i] updateDonationsData];
    self.messages = [[Globals i] getDonationsData];
    [messageList reloadData];
}

// Driving The Table View
- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"AllianceCell";
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.messages)[row];
    
	AllianceCell *cell = (AllianceCell *)[messageList dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllianceCell" owner:self options:nil];
		cell = (AllianceCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
    
    cell.num.text = [[NSString alloc] initWithFormat:@"%d", indexPath.row+1];
    cell.name.text = rowData[@"club_name"];
    cell.members.text = [[Globals i] numberFormat:rowData[@"currency_second"]];
    cell.score.text = [[Globals i] numberFormat:rowData[@"currency_first"]];
    cell.endLabel.text = @" ";
    
    if([rowData[@"club_id"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
    {
        [cell.name setTextColor:[UIColor redColor]];
    }
    else
    {
        [cell.name setTextColor:[UIColor blackColor]];
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
	return 25*SCALE_IPAD;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end
