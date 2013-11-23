//
//  StoreOthersView.m
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "StoreOthersView.h"
#import "ProductCell.h"
#import "Globals.h"
#import "MainView.h"

@implementation StoreOthersView
@synthesize mainView;
@synthesize products;
@synthesize filter;
@synthesize sold_product_id;
@synthesize sel_product_id;
@synthesize sel_product_value;
@synthesize sel_product_real;
@synthesize sel_product_star;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
	[super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
	[super didMoveToParentViewController:parent];
}

- (void)updateView
{
	if([[[Globals i] getProducts] count] < 1)
	{
		[[Globals i] showLoadingAlert];
		[NSThread detachNewThreadSelector: @selector(getProducts) toTarget:self withObject:nil];
	}
}

- (void)getProducts
{
	@autoreleasepool {
	
		[[Globals i] updateProducts];
		self.products = [[Globals i] getProducts];
        [self.tableView reloadData];
		[[Globals i] removeLoadingAlert];
	}
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"ProductCell";
	ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil)  
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:self options:nil];
		cell = (ProductCell *)nib[0];
		[[cell subviews][0] setTag:111];
	}
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.products)[row];

	NSString *price = [[Globals i] numberFormat:rowData[@"price_virtual"]];
    NSString *priceReal = [[Globals i] numberFormat:rowData[@"price_real"]];
    
    if ((price == nil) || ([price isEqualToString:@"0"]) || ([price isEqualToString:@""]))
    {
        if ((priceReal == nil) || ([priceReal isEqualToString:@"0"]) || ([priceReal isEqualToString:@""]))
        {
            cell.productValue.text = @" ";
        }
        else
        {
            cell.productValue.text = [NSString stringWithFormat:@"%@ Diamonds", priceReal];
        }
    }
    else
    {
        if ((priceReal == nil) || ([priceReal isEqualToString:@"0"]) || ([priceReal isEqualToString:@""]))
        {
            cell.productValue.text = [NSString stringWithFormat:@"$%@", price];
        }
        else
        {
            cell.productValue.text = [NSString stringWithFormat:@"$%@ or %@ Diamonds", price, priceReal];
        }
    }

	cell.productName.text = rowData[@"name"];
	
	cell.productDesc.text = rowData[@"description"];
	
    if(![rowData[@"content_url"] isEqualToString:@""])
	{
		[cell.productImage setImage:[UIImage imageNamed:rowData[@"content_url"]]];
	}
	else if(![rowData[@"image_url"] isEqualToString:@""])
	{
		NSURL *url = [NSURL URLWithString:rowData[@"image_url"]];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [[UIImage alloc] initWithData:data];
		[cell.productImage setImage:img];
	}
	
	int g = [rowData[@"product_star"] intValue];
	switch(g)
	{
		case 0:
			cell.star5.image = nil;
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 1:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 2:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 3:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 4:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 5:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 6:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
		case 7:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star1.image = nil;
			break;
		case 8:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			cell.star1.image = nil;
			break;
		case 9:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star1 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		case 10:
			[cell.star5 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star4 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star3 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star2 setImage:[UIImage imageNamed:STAR_FULL]];
			[cell.star1 setImage:[UIImage imageNamed:STAR_FULL]];
			break;
		default:
			[cell.star5 setImage:[UIImage imageNamed:STAR_HALF]];
			cell.star4.image = nil;
			cell.star3.image = nil;
			cell.star2.image = nil;
			cell.star1.image = nil;
			break;
	}
	
	return cell;
}

#pragma mark Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.products count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 77*SCALE_IPAD;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = (self.products)[row];
	NSString *name = rowData[@"name"];
	self.sel_product_id = [rowData[@"product_id"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    self.sel_product_star = rowData[@"product_star"];
    
	self.sel_product_value = [[Globals i] numberFormat:rowData[@"price_virtual"]];
    self.sel_product_real = [[Globals i] numberFormat:rowData[@"price_real"]];
    
    UIAlertView *alert;
    
    if ((sel_product_value == nil) || ([sel_product_value isEqualToString:@"0"]) || ([sel_product_value isEqualToString:@""]))
    {
        if ((sel_product_real == nil) || ([sel_product_real isEqualToString:@"0"]) || ([sel_product_real isEqualToString:@""]))
        {
            //Do nothing
        }
        else
        {
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Confirm Purchase"
                     message:[NSString stringWithFormat:@"Do you want to purchase %@ for %@ Diamonds", name, [[Globals i] numberFormat:rowData[@"price_real"]]]
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:[NSString stringWithFormat:@"%@ Diamonds", [[Globals i] numberFormat:rowData[@"price_real"]]], nil];
        }
    }
    else
    {
        if ((sel_product_real == nil) || ([sel_product_real isEqualToString:@"0"]) || ([sel_product_real isEqualToString:@""]))
        {
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Confirm Purchase"
                     message:[NSString stringWithFormat:@"Do you want to purchase %@ for $%@", name, [[Globals i] numberFormat:rowData[@"price_virtual"]]]
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:[NSString stringWithFormat:@"$%@", [[Globals i] numberFormat:rowData[@"price_virtual"]]], nil];
        }
        else
        {
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Confirm Purchase"
                     message:[NSString stringWithFormat:@"Do you want to purchase %@ for:", name]
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:[NSString stringWithFormat:@"$%@", [[Globals i] numberFormat:rowData[@"price_virtual"]]], [NSString stringWithFormat:@"%@ Diamonds", [[Globals i] numberFormat:rowData[@"price_real"]]], nil];
        }
    }
    
	[alert show];
	return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
        if ((sel_product_value == nil) || ([sel_product_value isEqualToString:@"0"]) || ([sel_product_value isEqualToString:@""]))
        {
            if ((sel_product_real == nil) || ([sel_product_real isEqualToString:@"0"]) || ([sel_product_real isEqualToString:@""]))
            {
                //Do nothing
            }
            else
            {
                [self purchaseWithDiamonds];
            }
        }
        else
        {
            [self purchaseWithFunds];
        }
	}
	
	if(buttonIndex == 2)
	{
        if ((sel_product_value == nil) || ([sel_product_value isEqualToString:@"0"]) || ([sel_product_value isEqualToString:@""]))
        {

        }
        else
        {
            if ((sel_product_real == nil) || ([sel_product_real isEqualToString:@"0"]) || ([sel_product_real isEqualToString:@""]))
            {

            }
            else
            {
                [self purchaseWithDiamonds];
            }
        }
	}
}

- (void)purchaseWithFunds
{
    int pval = [self.sel_product_value intValue];
    int bal = [[[[Globals i] getClubData][@"balance"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
    
    if(pval > bal)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Accountant"
                              message:@"Insufficient club funds. Buy more funds?"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        [[Globals i] showBuy];
    }
    else
    {
        [[Globals i] settPurchasedProduct:self.sel_product_id];
        [mainView buyOthersSuccess];
    }
}

- (void)purchaseWithDiamonds
{
    int pval = [self.sel_product_real intValue];
    int bal = [[[[Globals i] getClubData][@"currency_second"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
    
    if(pval > bal)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Accountant"
                              message:@"Insufficient Diamonds. Buy more?"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        [[Globals i] showBuy];
    }
    else
    {
        [[Globals i] settPurchasedProduct:self.sel_product_id];
        [mainView buyOthersSuccessWithDiamonds];
    }
}


@end
