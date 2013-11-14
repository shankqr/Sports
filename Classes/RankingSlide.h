//
//  RankingSlide.h
//  FM
//
//  Created by Shankar Nathan on 3/24/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//
#import "MainCell.h"

@class MainCell;
@interface RankingSlide : UIViewController 
{
	MainCell *mainView;
	UILabel *divisionLabel;
	UILabel *seriesLabel;
	UILabel *positionLabel;
	UILabel *undefeatedLabel;
}
@property (nonatomic, strong) MainCell *mainView;
@property (nonatomic, strong) IBOutlet UILabel *divisionLabel;
@property (nonatomic, strong) IBOutlet UILabel *seriesLabel;
@property (nonatomic, strong) IBOutlet UILabel *positionLabel;
@property (nonatomic, strong) IBOutlet UILabel *undefeatedLabel;
- (void)updateView;
@end
