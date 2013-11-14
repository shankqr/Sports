//
//  PlayerCell.h
//  FFC
//
//  Created by Shankar on 3/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface PlayerCell : UITableViewCell 
{
	UIImageView *faceImage;
	UIImageView *injuredbruisedImage;
	UIImageView *star1;
	UIImageView *star2;
	UIImageView *star3;
	UIImageView *star4;
	UIImageView *star5;
	UILabel *card1;
	UILabel *card2;
	UILabel *playerName;
	UILabel *playerValue;
	UILabel *position;
	UILabel *stamina;
	UIImageView *pbstamina;
	UILabel *keeper;
	UIImageView *pbkeeper;
	UILabel *defending;
	UIImageView *pbdefending;
	UILabel *playmaking;
	UIImageView *pbplaymaking;
	UILabel *passing;
	UIImageView *pbpassing;
	UILabel *scoring;
	UIImageView *pbscoring;
    UILabel *condition;
}
@property (nonatomic, strong) IBOutlet UIImageView *faceImage;
@property (nonatomic, strong) IBOutlet UIImageView *injuredbruisedImage;
@property (nonatomic, strong) IBOutlet UIImageView *star1;
@property (nonatomic, strong) IBOutlet UIImageView *star2;
@property (nonatomic, strong) IBOutlet UIImageView *star3;
@property (nonatomic, strong) IBOutlet UIImageView *star4;
@property (nonatomic, strong) IBOutlet UIImageView *star5;
@property (nonatomic, strong) IBOutlet UILabel *card1;
@property (nonatomic, strong) IBOutlet UILabel *card2;
@property (nonatomic, strong) IBOutlet UILabel *playerName;
@property (nonatomic, strong) IBOutlet UILabel *playerValue;
@property (nonatomic, strong) IBOutlet UILabel *position;
@property (nonatomic, strong) IBOutlet UILabel *stamina;
@property (nonatomic, strong) IBOutlet UIImageView *pbstamina;
@property (nonatomic, strong) IBOutlet UILabel *keeper;
@property (nonatomic, strong) IBOutlet UIImageView *pbkeeper;
@property (nonatomic, strong) IBOutlet UILabel *defending;
@property (nonatomic, strong) IBOutlet UIImageView *pbdefending;
@property (nonatomic, strong) IBOutlet UILabel *playmaking;
@property (nonatomic, strong) IBOutlet UIImageView *pbplaymaking;
@property (nonatomic, strong) IBOutlet UILabel *passing;
@property (nonatomic, strong) IBOutlet UIImageView *pbpassing;
@property (nonatomic, strong) IBOutlet UILabel *scoring;
@property (nonatomic, strong) IBOutlet UIImageView *pbscoring;
@property (nonatomic, strong) IBOutlet UILabel *condition;
@end
