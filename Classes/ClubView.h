//
//  ClubView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//


@interface ClubView : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
	
	UIImagePickerController *picker;
	UIActionSheet *sourceActionSheet;
	UIButton *ownerImage;
	UIButton *logoImage;
	UIButton *homeImage;
	UIButton *awayImage;
	UIImage *iFace;
	UIImage *iLogo;
	UIImage *iHome;
	UIImage *iAway;
	UILabel *foundedLabel;
	UILabel *loginLabel;
	NSInteger pickerTag;
	NSString *face_url;
	NSString *logo_url;
	NSString *home_url;
	NSString *away_url;
}

@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIActionSheet *sourceActionSheet;
@property (nonatomic, strong) IBOutlet UIButton *ownerImage;
@property (nonatomic, strong) IBOutlet UIButton *logoImage;
@property (nonatomic, strong) IBOutlet UIButton *homeImage;
@property (nonatomic, strong) IBOutlet UIButton *awayImage;
@property (nonatomic, strong) IBOutlet UILabel *foundedLabel;
@property (nonatomic, strong) IBOutlet UILabel *loginLabel;
@property (nonatomic, strong) UIImage *iFace;
@property (nonatomic, strong) UIImage *iLogo;
@property (nonatomic, strong) UIImage *iHome;
@property (nonatomic, strong) UIImage *iAway;
@property (nonatomic, strong) NSString *face_url;
@property (nonatomic, strong) NSString *logo_url;
@property (nonatomic, strong) NSString *home_url;
@property (nonatomic, strong) NSString *away_url;
@property (readwrite) NSInteger pickerTag;
- (void)updateView;
- (void)resetImages;
- (IBAction)resetButton_tap:(id)sender;
- (IBAction)clubnameButton_tap:(id)sender;
- (IBAction)logoButton_tap:(id)sender;
- (IBAction)homeButton_tap:(id)sender;
- (IBAction)awayButton_tap:(id)sender;
- (IBAction)managerImageButton_tap:(id)sender;
@end
