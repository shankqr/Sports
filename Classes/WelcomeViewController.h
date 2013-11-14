//
//  WelcomeViewController.h
//  FFC
//
//  Created by Shankar on 6/10/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//
@class MainView;

@interface WelcomeViewController : UIViewController 
{
    MainView *mainView;
	UILabel *promptLabel;
	NSString *promptText;
    UIImageView *bonusImage;
    UILabel *bonusLabel;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UILabel *promptLabel;
@property (nonatomic, strong) IBOutlet UIImageView *bonusImage;
@property (nonatomic, strong) IBOutlet UILabel *bonusLabel;
@property (nonatomic, strong) NSString *promptText;
- (void)updateView;
- (IBAction)okButton_tap:(id)sender;
@end
