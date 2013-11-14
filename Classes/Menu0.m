//
//  Menu0.m
//  Mafia Tower
//
//  Created by Shankar on 1/15/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

#import "Menu0.h"

@implementation Menu0
@synthesize mainView;
@synthesize table;
@synthesize titleLabel;
@synthesize firstCurrency;
@synthesize secondCurrency;
@synthesize productTypes;
@synthesize currencyType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateView
{
    [mainView hideHeader];
    [mainView hideMarquee];
    [mainView hideFooter];
    
    NSDictionary *r1 = @{@"1": @"fund1", @"2": @"com.tapf", @"3": @"2417361", @"Title": @"Pouch of Cash", @"Info": @"Provides 10,000 Cash", @"Bonus": @"", @"Tag": @"10,000", @"Price": @"$0.99"};
    NSDictionary *r2 = @{@"1": @"fund6", @"2": @"com.tapf", @"3": @"9027491", @"Title": @"Pile of Cash", @"Info": @"Provides 22,000 Cash", @"Bonus": @"10% Extra for FREE!", @"Tag": @"22,000", @"Price": @"$1.99"};
    NSDictionary *r3 = @{@"1": @"fund2", @"2": @"com.tapf", @"3": @"7811556", @"Title": @"Bag of Cash", @"Info": @"Provides 60,000 Cash", @"Bonus": @"20% Extra for FREE!", @"Tag": @"60,000", @"Price": @"$4.99"};
    NSDictionary *r4 = @{@"1": @"fund3", @"2": @"com.tapf", @"3": @"3720643", @"Title": @"Sack of Cash", @"Info": @"Provides 150,000 Cash", @"Bonus": @"30% Extra for FREE!", @"Tag": @"150,000", @"Price": @"$9.99"};
    NSDictionary *r5 = @{@"1": @"fund7", @"2": @"com.tapf", @"3": @"5135513", @"Title": @"Chest of Cash", @"Info": @"Provides 275,000 Cash", @"Bonus": @"38% Extra for FREE!", @"Tag": @"275,000", @"Price": @"$19.99"};
    NSDictionary *r6 = @{@"1": @"fund4", @"2": @"com.tapf", @"3": @"8759869", @"Title": @"Case of Cash", @"Info": @"Provides 800,000 Cash", @"Bonus": @"45% Extra for FREE!", @"Tag": @"800,000", @"Price": @"$49.99"};
    NSDictionary *r7 = @{@"1": @"fund5", @"2": @"com.tapf", @"3": @"0847690", @"Title": @"Trunk of Cash", @"Info": @"Provides 1,700,000 Cash", @"Bonus": @"58% Extra for FREE!", @"Tag": @"1,700,000", @"Price": @"$99.99"};
    self.firstCurrency = [[NSMutableArray alloc] initWithObjects:r1, r2, r3, r4, r5, r6, r7, nil];
    
    NSDictionary *row1 = @{@"1": @"sc1", @"2": @"com.tapf", @"3": @"5192348", @"Title": @"Pile of Diamonds", @"Info": @"Provides 10 Diamonds", @"Bonus": @"", @"Tag": @"10", @"Price": @"$0.99"};
    NSDictionary *row2 = @{@"1": @"sc2", @"2": @"com.tapf", @"3": @"4069157", @"Title": @"Pouch of Diamonds", @"Info": @"Provides 22 Diamonds", @"Bonus": @"10% Extra for FREE!", @"Tag": @"22", @"Price": @"$1.99"};
    NSDictionary *row3 = @{@"1": @"sc3", @"2": @"com.tapf", @"3": @"6145148", @"Title": @"Bag of Diamonds", @"Info": @"Provides 60 Diamonds", @"Bonus": @"20% Extra for FREE!", @"Tag": @"60", @"Price": @"$4.99"};
    NSDictionary *row4 = @{@"1": @"sc4", @"2": @"com.tapf", @"3": @"9425144", @"Title": @"Sack of Diamonds", @"Info": @"Provides 150 Diamonds", @"Bonus": @"30% Extra for FREE!", @"Tag": @"150", @"Price": @"$9.99"};
    NSDictionary *row5 = @{@"1": @"sc5", @"2": @"com.tapf", @"3": @"1736703", @"Title": @"Chest of Diamonds", @"Info": @"Provides 275 Diamonds", @"Bonus": @"38% Extra for FREE!", @"Tag": @"275", @"Price": @"$19.99"};
    NSDictionary *row6 = @{@"1": @"sc6", @"2": @"com.tapf", @"3": @"6597164", @"Title": @"Case of Diamonds", @"Info": @"Provides 800 Diamonds", @"Bonus": @"45% Extra for FREE!", @"Tag": @"800", @"Price": @"$49.99"};
    NSDictionary *row7 = @{@"1": @"sc7", @"2": @"com.tapf", @"3": @"2792559", @"Title": @"Trunk of Diamonds", @"Info": @"Provides 1,700 Diamonds", @"Bonus": @"58% Extra for FREE!", @"Tag": @"1,700", @"Price": @"$99.99"};
    self.secondCurrency = [[NSMutableArray alloc] initWithObjects:row1, row2, row3, row4, row5, row6, row7, nil];
	
    if (currencyType)
    {
        productTypes = firstCurrency;
    }
    else
    {
        productTypes = secondCurrency;
    }
    
    [table setFrame:CGRectMake(0, HeaderBuy_height, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height-HeaderBuy_height)];
	
    [table reloadData];
	[self.view setNeedsDisplay];
}

- (IBAction)closeButton_tap:(id)sender
{
    [mainView backSound];
    [mainView showHeader];
    [mainView showMarquee];
    [mainView showFooter];
    
	[self.view removeFromSuperview];
}

- (void)buttonPressed:(id)sender
{
    [mainView buttonSound];
    
    int i = [sender tag];
    NSDictionary *rowData = (self.productTypes)[i];

    [[Globals i] settPurchasedProduct:rowData[@"3"]];
    NSString *pi = [[Globals i] getProductIdentifiers][rowData[@"1"]];

    [mainView buyProduct:pi];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"Menu0Cell";
	
	Menu0Cell *cell = (Menu0Cell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Menu0Cell" owner:self options:nil];
		cell = (Menu0Cell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.productTypes)[row];
    
    cell.productTitle.text = rowData[@"Title"];
    cell.productInfo.text = rowData[@"Info"];
    cell.productBonus.text = rowData[@"Bonus"];
    cell.productTag.text = rowData[@"Tag"];
    cell.productPrice.text = rowData[@"Price"];
    
    [cell.buyButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.buyButton.tag = row;
    
    if (currencyType)
    {
        [cell.productIcon setImage:[UIImage imageNamed:@"icon_money2"]];
    }
    else
    {
        [cell.productIcon setImage:[UIImage imageNamed:@"icon_diamond2"]];
    }
    
	return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int i = [indexPath row];
    NSDictionary *rowData = (self.productTypes)[i];
    
    [[Globals i] settPurchasedProduct:rowData[@"3"]];
    NSString *pi = [[Globals i] getProductIdentifiers][rowData[@"1"]];

    [mainView buyProduct:pi];
    
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80*SCALE_IPAD;
}

@end
