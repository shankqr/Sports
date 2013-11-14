//
//  LeagueslideCell.h
//  FFC
//
//  Created by Shankar on 11/26/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

@interface LeagueslideCell : UITableViewCell
{
	UILabel *leagueRound;
	UILabel *leagueStartMonth;
	UILabel *leagueStartDay;
	UILabel *leagueEndMonth;
	UILabel *leagueEndDay;
}
@property (nonatomic, strong) IBOutlet UILabel *leagueRound;
@property (nonatomic, strong) IBOutlet UILabel *leagueStartMonth;
@property (nonatomic, strong) IBOutlet UILabel *leagueStartDay;
@property (nonatomic, strong) IBOutlet UILabel *leagueEndMonth;
@property (nonatomic, strong) IBOutlet UILabel *leagueEndDay;
@end
