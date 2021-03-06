//
//  CoachCell.h
//  FFC
//
//  Created by Shankar on 3/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface CoachCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *faceImage;
@property (nonatomic, strong) IBOutlet UIImageView *star1;
@property (nonatomic, strong) IBOutlet UIImageView *star2;
@property (nonatomic, strong) IBOutlet UIImageView *star3;
@property (nonatomic, strong) IBOutlet UIImageView *star4;
@property (nonatomic, strong) IBOutlet UIImageView *star5;
@property (nonatomic, strong) IBOutlet UILabel *coachName;
@property (nonatomic, strong) IBOutlet UILabel *coachValue;
@property (nonatomic, strong) IBOutlet UILabel *coachDesc;
@property (nonatomic, strong) IBOutlet UILabel *skill;
@property (nonatomic, strong) IBOutlet UIImageView *pbskill;
@property (nonatomic, strong) IBOutlet UILabel *leadership;
@property (nonatomic, strong) IBOutlet UIImageView *pbleadership;

@end
