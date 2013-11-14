//
//  LeagueSlide.h
//  FM
//
//  Created by Shankar Nathan on 3/24/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//
#import "MainCell.h"

@class MainCell;
@interface LeagueSlide : UIViewController 
{
	MainCell *mainView;
	UILabel *leagueRound;
	UILabel *leagueStartMonth;
	UILabel *leagueStartDay;
	UILabel *leagueEndMonth;
	UILabel *leagueEndDay;
}
@property (nonatomic, strong) MainCell *mainView;
@property (nonatomic, strong) IBOutlet UILabel *leagueRound;
@property (nonatomic, strong) IBOutlet UILabel *leagueStartMonth;
@property (nonatomic, strong) IBOutlet UILabel *leagueStartDay;
@property (nonatomic, strong) IBOutlet UILabel *leagueEndMonth;
@property (nonatomic, strong) IBOutlet UILabel *leagueEndDay;
- (void)updateView;
@end
