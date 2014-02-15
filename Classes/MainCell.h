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

@property (nonatomic, strong) UIView *activeSlide;
@property (nonatomic, strong) LeagueSlide *leagueSlide;
@property (nonatomic, strong) RankingSlide *rankingSlide;
@property (nonatomic, strong) NextMatchSlide *nextmatchSlide;
@property (nonatomic, strong) LastMatchSlide *lastmatchSlide;
@property (nonatomic, strong) NSTimer *slidesTimer;
@property (nonatomic, strong) CustomBadge *achievementsBadge;
@property (nonatomic, strong) CustomBadge *mailBadge;
@property (nonatomic, strong) UIButton *buttonSale;
@property (nonatomic, strong) UILabel *labelSale;

@property (nonatomic, assign) NSInteger timerIndex;
@property (nonatomic, assign) NSInteger s1;
@property (nonatomic, assign) NSInteger b1s;
@property (nonatomic, assign) Boolean timerIsShowing;

- (void)changeSlideNow;
- (void)updateAchievementBadges;
- (void)updateMailBadges;
- (void)updateSalesButton;

@end
