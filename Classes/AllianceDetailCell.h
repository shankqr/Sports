//
//  AllianceDetailCell.h
//  FFC
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@interface AllianceDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *buttonEvents;
@property (strong, nonatomic) IBOutlet UIButton *buttonDonations;
@property (strong, nonatomic) IBOutlet UIButton *buttonDonate;
@property (strong, nonatomic) IBOutlet UIButton *buttonMembers;
@property (strong, nonatomic) IBOutlet UIButton *buttonWall;
@property (strong, nonatomic) IBOutlet UIButton *buttonApplied;
@property (strong, nonatomic) IBOutlet UIButton *buttonUpgrade;
@property (strong, nonatomic) IBOutlet UIButton *buttonResign;
@property (strong, nonatomic) IBOutlet UIButton *buttonCup;
@property (strong, nonatomic) IBOutlet UIButton *buttonEdit;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *leader;
@property (strong, nonatomic) IBOutlet UILabel *leader_name;
@property (strong, nonatomic) IBOutlet UILabel *date_found;
@property (strong, nonatomic) IBOutlet UILabel *total_members;
@property (strong, nonatomic) IBOutlet UILabel *alliance_level;
@property (strong, nonatomic) IBOutlet UILabel *currency_first;
@property (strong, nonatomic) IBOutlet UILabel *currency_second;
@property (strong, nonatomic) IBOutlet UILabel *rank;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *fanpage_url;
@property (strong, nonatomic) IBOutlet UILabel *cup_name;
@property (strong, nonatomic) IBOutlet UILabel *cup_first_prize;
@property (strong, nonatomic) IBOutlet UILabel *cup_second_prize;
@property (strong, nonatomic) IBOutlet UILabel *cup_start;
@property (strong, nonatomic) IBOutlet UILabel *cup_round;
@property (strong, nonatomic) IBOutlet UILabel *cup_first_name;
@property (strong, nonatomic) IBOutlet UILabel *cup_second_name;
@property (strong, nonatomic) IBOutlet UITextView *introduction_text;
@end
