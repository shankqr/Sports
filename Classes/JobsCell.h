//
//  JobsCell.h
//  FFC
//
//  Created by Shankar on 3/30/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface JobsCell : UITableViewCell
{
	UIImageView *trainImage;
	UIImageView *descImage;
	UILabel *energyLabel;
	UILabel *friendlyLabel;
	UILabel *rewardLabel;
	UILabel *rankLabel;
    UILabel *unlockLabel;
    UIButton *jobButton;
	UIProgressView *rankProgress;
}
@property (nonatomic, strong) IBOutlet UIImageView *trainImage;
@property (nonatomic, strong) IBOutlet UIImageView *descImage;
@property (nonatomic, strong) IBOutlet UILabel *energyLabel;
@property (nonatomic, strong) IBOutlet UILabel *friendlyLabel;
@property (nonatomic, strong) IBOutlet UILabel *rewardLabel;
@property (nonatomic, strong) IBOutlet UILabel *rankLabel;
@property (nonatomic, strong) IBOutlet UILabel *unlockLabel;
@property (nonatomic, strong) IBOutlet UIButton *jobButton;
@property (nonatomic, strong) IBOutlet UIProgressView *rankProgress;
@end
