//
//  ClubView.m
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//
#import "ClubView.h"
#import "Globals.h"
#import "ImageHelper.h"
#import "MainView.h"

@implementation ClubView
@synthesize mainView;
@synthesize picker;
@synthesize sourceActionSheet;
@synthesize logoImage;
@synthesize homeImage;
@synthesize awayImage;
@synthesize iLogo;
@synthesize iHome;
@synthesize iAway;
@synthesize iFace;
@synthesize ownerImage;
@synthesize foundedLabel;
@synthesize loginLabel;
@synthesize pickerTag;
@synthesize face_url;
@synthesize logo_url;
@synthesize home_url;
@synthesize away_url;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
	self.picker = imagePickerController;
}

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
    NSString *date = wsClubData[@"date_found"];
    if ([date length] > 0)
    {
        date = [date substringToIndex:[date length] - 9];
    }
	foundedLabel.text = date;
	loginLabel.text = wsClubData[@"last_login"];
	face_url = wsClubData[@"face_pic"];
	logo_url = wsClubData[@"logo_pic"];
	home_url = wsClubData[@"home_pic"];
	away_url = wsClubData[@"away_pic"];
	
	[self setImages];
	[self.view setNeedsDisplay];
}


- (void)setImages
{
	[self loadLogo];
	
	[self loadHome];
	
	[self loadAway];
	
	iFace = [ImageHelper getImage: @"/owner.png"];
	if(iFace.size.width > 1)
	{
		[ownerImage setImage:iFace forState:UIControlStateNormal];
	}
	else
	{
		[self loadOwner];
	}
}

- (void)resetImages
{
	NSDictionary *wsClubData = [[Globals i] getClubData];
	logo_url = wsClubData[@"logo_pic"];
	home_url = wsClubData[@"home_pic"];
	away_url = wsClubData[@"away_pic"];
	//face_url = [wsClubData objectForKey:@"face_pic"];
	[self loadLogo];
	[self loadHome];
	[self loadAway];
	//self.loadOwner;
}

- (void)loadLogo
{
	if([logo_url length] > 5)
	{
		NSURL *url = [NSURL URLWithString:logo_url];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [[UIImage alloc] initWithData:data];
		[logoImage setImage:img forState:UIControlStateNormal];
	}
	else
	{
		NSString *fname = [NSString stringWithFormat:@"c%@.png", logo_url];
		[logoImage setImage:[UIImage imageNamed:fname] forState:UIControlStateNormal];
	}
}

- (void)loadHome
{
	if([home_url length] > 5)
	{
		NSURL *url = [NSURL URLWithString:home_url];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [[UIImage alloc] initWithData:data];
		[homeImage setImage:img forState:UIControlStateNormal];
        
	}
	else 
	{
		NSString *fname = [NSString stringWithFormat:@"j%@.png", home_url];
		[homeImage setImage:[UIImage imageNamed:fname] forState:UIControlStateNormal];
	}
}

- (void)loadAway
{
	if([away_url length] > 5)
	{
		NSURL *url = [NSURL URLWithString:away_url];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [[UIImage alloc] initWithData:data];
		[awayImage setImage:img forState:UIControlStateNormal];

	}
	else 
	{
		NSString *fname = [NSString stringWithFormat:@"j%@.png", away_url];
		[awayImage setImage:[UIImage imageNamed:fname] forState:UIControlStateNormal];
	}
}

- (void)loadOwner
{
	if([face_url length] > 5)
	{
		NSURL *url = [NSURL URLWithString:face_url];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [[UIImage alloc] initWithData:data];
		[ownerImage setImage:img forState:UIControlStateNormal];

	}
	else 
	{
		NSString *fname = [NSString stringWithFormat:@"a%@.png", face_url];
		[ownerImage setImage:[UIImage imageNamed:fname] forState:UIControlStateNormal];
	}
}

-(IBAction)logoButton_tap:(id)sender
{
    sourceActionSheet = [[UIActionSheet alloc]
                         initWithTitle:@""
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"Change Logo", nil];
	sourceActionSheet.tag = 1;
	[sourceActionSheet showInView:self.view];
}

-(IBAction)homeButton_tap:(id)sender
{
    sourceActionSheet = [[UIActionSheet alloc]
                         initWithTitle:@""
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"Change Home Jersey", nil];
	sourceActionSheet.tag = 2;
	[sourceActionSheet showInView:self.view];
}

-(IBAction)awayButton_tap:(id)sender
{
    sourceActionSheet = [[UIActionSheet alloc]
                         initWithTitle:@""
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"Change Away Jersey", nil];
	sourceActionSheet.tag = 3;
	[sourceActionSheet showInView:self.view];
}

-(IBAction)managerImageButton_tap:(id)sender
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		sourceActionSheet = [[UIActionSheet alloc]
					   initWithTitle:@"Picture Source Options"
					   delegate:self
					   cancelButtonTitle:@"Cancel"
					   destructiveButtonTitle:@"Reset"
					   otherButtonTitles:@"Facebook", @"Camera", nil];
	}
	else
	{
		sourceActionSheet = [[UIActionSheet alloc]
					   initWithTitle:@"Picture Source Options"
					   delegate:self
					   cancelButtonTitle:@"Cancel"
					   destructiveButtonTitle:@"Reset"
					   otherButtonTitles:@"Facebook", nil];
	}
	sourceActionSheet.tag = 4;
	[sourceActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	pickerTag = [actionSheet tag];
	if(pickerTag > 0 && pickerTag < 5)
	{
		if(buttonIndex == 0) //RESET
		{
			if(pickerTag == 4)
			{
				[self loadOwner];
			}
            else // Online Store
			{
				[mainView showOthersStore];
			}
		}
		if(buttonIndex == 1) //Go to store or load facebook pic
		{
			if(pickerTag == 4) //Owner Picture Facebook
			{
				if(![[[Globals i] getClubData][@"fb_pic"] isEqualToString:@""])
				{
					NSURL *url = [NSURL URLWithString:[[Globals i] getClubData][@"fb_pic"]];
					NSData *data = [NSData dataWithContentsOfURL:url];
					UIImage *img = [[UIImage alloc] initWithData:data];
					[ownerImage setImage:img forState:UIControlStateNormal];
					[ImageHelper saveImage: img: @"/owner.png"];
				}
			}
		}
		if(buttonIndex == 2) //Camera
        {
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
			{
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
				[self presentViewController:picker animated:YES completion:nil];
			}
		}
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self dismissViewControllerAnimated:YES completion:nil];
	
	
	
	[mainView updateHeader];
	
	UIImage *image = info[@"UIImagePickerControllerEditedImage"];
	if(pickerTag == 1)
	{
		[logoImage setImage:image forState:UIControlStateNormal];
		[ImageHelper saveImage: image: @"/logo.png"];
	}
	if(pickerTag == 2)
	{
		[homeImage setImage:image forState:UIControlStateNormal];
		[ImageHelper saveImage: image: @"/home.png"];
	}
	if(pickerTag == 3)
	{
		[awayImage setImage:image forState:UIControlStateNormal];
		[ImageHelper saveImage: image: @"/away.png"];
	}
	if(pickerTag == 4)
	{
		[ownerImage setImage:image forState:UIControlStateNormal];
		[ImageHelper saveImage: image: @"/owner.png"];
	}
	
	[self updateView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:nil];
	
	[mainView updateHeader];
	[self updateView];
}

-(IBAction)clubnameButton_tap:(id)sender
{
	[self confirmPurchase];
}

- (void)confirmPurchase
{
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Payment Option"
						  message:@"How would you like to cover the fees for this club rename?"
						  delegate:self
						  cancelButtonTitle:@"Cancel"
						  otherButtonTitles:@"USD$0.99", @"$10,000 + 10 Energy", @"10 Diamonds", nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 1)
	{
        [[Globals i] settPurchasedProduct:@"10"];
		[mainView buyProduct:[[Globals i] getProductIdentifiers][@"rename"]];
	}
	
	if(buttonIndex == 2)
	{
		NSInteger pval = 10000;
		NSInteger bal = [[[Globals i] getClubData][@"balance"] integerValue];
		
		if((bal > pval) && ([Globals i].energy > 9))
		{
			[Globals i].energy -= 10;
			[[Globals i] storeEnergy];
			[mainView renameClubPurchaseSuccess:@"1":@"0"];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Accountant"
								  message:@"Insufficient club funds or Energy. Use real funds USD$0.99?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  otherButtonTitles:@"OK", nil];
			[alert show];
		}
	}
    
    if(buttonIndex == 3)
	{
		NSInteger pval = 9;
		NSInteger bal = [[[Globals i] getClubData][@"currency_second"] integerValue];
		
		if(bal > pval)
		{
			[mainView renameClubPurchaseSuccess:@"2":@"0"];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Accountant"
								  message:@"Insufficient Diamonds. Use real funds USD$0.99?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  otherButtonTitles:@"OK", nil];
			[alert show];
		}
	}
}

-(IBAction)resetButton_tap:(id)sender
{
	
    [[Globals i] settPurchasedProduct:@"13"];
	[mainView buyProduct:[[Globals i] getProductIdentifiers][@"reset"]];
}

@end
