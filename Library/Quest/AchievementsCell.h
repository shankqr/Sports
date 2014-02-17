//
//  AchievementsCell.h
//  FFC
//
//  Created by Shankar on 3/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface AchievementsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *taskImage;
@property (nonatomic, strong) IBOutlet UIImageView *doneImage;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *desc;
@property (nonatomic, strong) IBOutlet UILabel *reward;
@property (nonatomic, strong) IBOutlet UIButton *claimButton;

@end
