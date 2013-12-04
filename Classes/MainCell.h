//
//  MainCell.h
//  FFC
//
//  Created by Shankar on 8/18/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

@class LeagueSlide;
@class RankingSlide;
@class NextMatchSlide;
@class LastMatchSlide;
@class CustomBadge;
@interface MainCell : UITableViewCell
{
    UIView *activeSlide;
	LeagueSlide *leagueSlide;
	RankingSlide *rankingSlide;
	NextMatchSlide *nextmatchSlide;
	LastMatchSlide *lastmatchSlide;
    NSTimer *slidesTimer;
    NSInteger timerIndex;
    CustomBadge *achievementsBadge;
    CustomBadge *mailBadge;
}
@property (strong, nonatomic) UIView *activeSlide;
@property (strong, nonatomic) LeagueSlide *leagueSlide;
@property (strong, nonatomic) RankingSlide *rankingSlide;
@property (strong, nonatomic) NextMatchSlide *nextmatchSlide;
@property (strong, nonatomic) LastMatchSlide *lastmatchSlide;
@property (strong, nonatomic) NSTimer *slidesTimer;
@property (strong, nonatomic) CustomBadge *achievementsBadge;
@property (strong, nonatomic) CustomBadge *mailBadge;
@property (readwrite) NSInteger timerIndex;
- (void)changeSlideNow;
- (void)updateAchievementBadges;
- (void)updateMailBadges;
@end
