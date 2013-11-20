//
//  WelcomeViewController.h
//  FFC
//
//  Created by Shankar on 6/10/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface WelcomeViewController : UIViewController 
{
	UILabel *promptLabel;
	NSString *promptText;
    UIImageView *bonusImage;
    UILabel *bonusLabel;
}
@property (nonatomic, strong) IBOutlet UILabel *promptLabel;
@property (nonatomic, strong) IBOutlet UIImageView *bonusImage;
@property (nonatomic, strong) IBOutlet UILabel *bonusLabel;
@property (nonatomic, strong) NSString *promptText;
- (void)updateView;
@end
