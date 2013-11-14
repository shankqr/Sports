//
//  FixtureCell.h
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface FixtureCell : UITableViewCell 
{
	UILabel *matchDay;
	UILabel *matchDate;
	UILabel *matchMonth;
	UILabel *matchScore;
	UILabel *matchClubName1;
	UILabel *matchClubName2;
	UIImageView *matchClubLogo1;
}
@property (nonatomic, strong) IBOutlet UILabel *matchDay;
@property (nonatomic, strong) IBOutlet UILabel *matchDate;
@property (nonatomic, strong) IBOutlet UILabel *matchMonth;
@property (nonatomic, strong) IBOutlet UILabel *matchScore;
@property (nonatomic, strong) IBOutlet UILabel *matchClubName1;
@property (nonatomic, strong) IBOutlet UILabel *matchClubName2;
@property (nonatomic, strong) IBOutlet UIImageView *matchClubLogo1;

@end
