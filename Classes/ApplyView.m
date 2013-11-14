#import "ApplyView.h"

@implementation ApplyView
@synthesize mainView;
@synthesize messages;
@synthesize messageList;
@synthesize selected_clubid;
@synthesize selected_aid;
@synthesize selected_clubname;
@synthesize alliance_leader_id;
@synthesize dialogBox;

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
    [[Globals i] updateAppliedData];
    self.messages = [[Globals i] getAppliedData];
    if([self.messages count]>0)
    {
        [messageList reloadData];
    }
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
	NSDictionary *rowData = [[Globals i] getAppliedData][indexPath.row];
	
    if(![rowData[@"club_id"] isEqualToString:[[Globals i] getClubData][@"club_id"]])
    {
        selected_clubid = [[NSString alloc] initWithString: [rowData[@"club_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
        
        if([alliance_leader_id isEqualToString:[[Globals i] getClubData][@"club_id"]]) //You are the leader
        {
            selected_aid = [[NSString alloc] initWithString: [rowData[@"alliance_id"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
            selected_clubname = rowData[@"club_name"];
        
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:rowData[@"club_name"]
                                  message:rowData[@"message"]
                                  delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:@"Club Info", @"Approve", @"Reject", nil];
            [alert show];
        }
        else
        {
            [self.mainView jumpToClubViewer:selected_clubid];
        }
    }
    
	return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		[self.mainView jumpToClubViewer:selected_clubid];
    }
    if(buttonIndex == 2)
	{
        NSString *returnValue = @"0";
        NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceApprove/%@/%@/%@",
                           WS_URL, selected_aid, selected_clubid, selected_clubname];
        NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc] initWithString:wsurl2];
        returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        
        if([returnValue isEqualToString:@"0"])
        {
            [self createDialogBox];
            dialogBox.titleText = @"Unable to Approve!";
            dialogBox.whiteText = @"Maximum Members Reached.";
            dialogBox.promptText = @"Upgrade/Level UP this Association to increase the total members allowed.";
            dialogBox.dialogType = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
        else
        {
            [self updateView];
            
            [self createDialogBox];
            dialogBox.titleText = @"Assistant Manager";
            dialogBox.whiteText = @"Club Approved!";
            dialogBox.promptText = @"The Club will be informed in the News that they are accepted.";
            dialogBox.dialogType = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
    if(buttonIndex == 3)
	{
        NSString *returnValue = @"0";
        NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/AllianceReject/%@/%@/%@",
                           WS_URL, selected_aid, selected_clubid, selected_clubname];
        NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc] initWithString:wsurl2];
        returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        
        if([returnValue isEqualToString:@"0"])
        {
            [self createDialogBox];
            dialogBox.titleText = @"Unable to Reject!";
            dialogBox.whiteText = @"Please try again.";
            dialogBox.promptText = @"";
            dialogBox.dialogType = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
        else
        {
            [self updateView];
            
            [self createDialogBox];
            dialogBox.titleText = @"Assistant Manager";
            dialogBox.whiteText = @"Club Rejected!";
            dialogBox.promptText = @"The Club will be informed in the News that they have been rejected.";
            dialogBox.dialogType = 1;
            [self.view insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
}

- (void)createDialogBox
{
    if (dialogBox == nil)
    {
        dialogBox = [[DialogBoxView alloc] initWithNibName:@"DialogBoxView" bundle:nil];
        //dialogBox.delegate = self;
    }
}

- (void)removeDialogBox
{
	if(dialogBox != nil)
	{
		[dialogBox.view removeFromSuperview];
	}
}

@end
