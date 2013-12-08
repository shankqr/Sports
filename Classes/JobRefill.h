//
//  JobRefill.h
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface JobRefill : UIViewController
{
	UILabel *titleLabel;
	UILabel *promptLabel;
	NSString *titleText;
	NSString *promptText;
}
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *promptLabel;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *promptText;
- (void)updateView;
- (IBAction)ok_tap:(id)sender;
@end
