//
//  LastMatchSlide.h
//  FM
//
//  Created by Shankar Nathan on 3/24/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//
#import "MainCell.h"

@class MainCell;
@interface LastMatchSlide : UIViewController 
{
	MainCell *mainView;
	UIImageView *matchtypeImage;
	UILabel *clubName;
	UILabel *rivalName;
	UILabel *matchMonth;
	UILabel *matchDay;
	UILabel *clubScore;
	UILabel *rivalScore;
}
@property (nonatomic, strong) MainCell *mainView;
@property (nonatomic, strong) IBOutlet UIImageView *matchtypeImage;
@property (nonatomic, strong) IBOutlet UILabel *clubName;
@property (nonatomic, strong) IBOutlet UILabel *rivalName;
@property (nonatomic, strong) IBOutlet UILabel *matchMonth;
@property (nonatomic, strong) IBOutlet UILabel *matchDay;
@property (nonatomic, strong) IBOutlet UILabel *clubScore;
@property (nonatomic, strong) IBOutlet UILabel *rivalScore;
- (void)updateView;
@end
