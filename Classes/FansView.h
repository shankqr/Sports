//
//  FansView.h
//  FFC
//
//  Created by Shankar Nathan on 5/27/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface FansView : UIViewController
{
	UILabel *membersLabel;
	UILabel *moodLabel;
	UILabel *expectationLabel;
	UILabel *sponsorLabel;
}
@property (nonatomic, strong) IBOutlet UILabel *membersLabel;
@property (nonatomic, strong) IBOutlet UILabel *moodLabel;
@property (nonatomic, strong) IBOutlet UILabel *expectationLabel;
@property (nonatomic, strong) IBOutlet UILabel *sponsorLabel;
- (void)updateView;
@end
