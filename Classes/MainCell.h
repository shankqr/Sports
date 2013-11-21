//
//  MainCell.h
//  FFC
//
//  Created by Shankar on 8/18/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

@class MainView;
@class LeagueSlide;
@class RankingSlide;
@class NextMatchSlide;
@class LastMatchSlide;
@class CustomBadge;

@interface MainCell : UITableViewCell
{
    MainView *mainView;
    UIView *activeSlide;
	LeagueSlide *leagueSlide;
	RankingSlide *rankingSlide;
	NextMatchSlide *nextmatchSlide;
	LastMatchSlide *lastmatchSlide;
    NSTimer *slidesTimer;
    NSInteger timerIndex;
    UIButton *fbLogoutButton;
    UIButton *fbShareButton;
    CustomBadge *achievementsBadge;
}
@property (strong, nonatomic) MainView *mainView;
@property (strong, nonatomic) UIView *activeSlide;
@property (strong, nonatomic) LeagueSlide *leagueSlide;
@property (strong, nonatomic) RankingSlide *rankingSlide;
@property (strong, nonatomic) NextMatchSlide *nextmatchSlide;
@property (strong, nonatomic) LastMatchSlide *lastmatchSlide;
@property (strong, nonatomic) NSTimer *slidesTimer;
@property (strong, nonatomic) CustomBadge *achievementsBadge;
@property (readwrite) NSInteger timerIndex;
@property (strong, nonatomic) IBOutlet UIButton *fbLogoutButton;
@property (strong, nonatomic) IBOutlet UIButton *fbShareButton;
@property (strong, nonatomic) IBOutlet UIButton *buttonTrain;
@property (strong, nonatomic) IBOutlet UIButton *buttonCity;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (strong, nonatomic) IBOutlet UIButton *button5;
@property (strong, nonatomic) IBOutlet UIButton *button6;
@property (strong, nonatomic) IBOutlet UIButton *button7;
@property (strong, nonatomic) IBOutlet UIButton *button8;
@property (strong, nonatomic) IBOutlet UIButton *button9;
@property (strong, nonatomic) IBOutlet UIButton *button10;
@property (strong, nonatomic) IBOutlet UIButton *button11;
@property (strong, nonatomic) IBOutlet UIButton *button12;
@property (strong, nonatomic) IBOutlet UIButton *button13;
@property (strong, nonatomic) IBOutlet UIButton *button14;
@property (strong, nonatomic) IBOutlet UIButton *button15;
@property (strong, nonatomic) IBOutlet UIButton *button16;
@property (strong, nonatomic) IBOutlet UIButton *button17;
@property (strong, nonatomic) IBOutlet UIButton *button19;
@property (strong, nonatomic) IBOutlet UIButton *button20;
@property (strong, nonatomic) IBOutlet UIButton *button21;
@property (strong, nonatomic) IBOutlet UIButton *button22;
@property (strong, nonatomic) IBOutlet UIButton *button23;
- (void)createSlides;
- (void)showSlide;
- (void)hideSlide;
- (void)changeSlide;
- (void)changeSlideNow;
- (void)createAchievementBadges;
- (void)removeAchievementBadges;
- (void)updateAchievementBadges;
- (void)createAssociationBadge;
@end
