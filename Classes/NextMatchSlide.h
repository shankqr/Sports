//
//  NextMatchSlide.h
//  FM
//
//  Created by Shankar Nathan on 3/23/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainCell;
@interface NextMatchSlide : UIViewController 
{
	MainCell *mainCell;
	UIImageView *matchtypeImage;
	UILabel *clubName;
	UILabel *rivalName;
	UILabel *matchMonth;
	UILabel *matchDay;
}
@property (nonatomic, strong) MainCell *mainCell;
@property (nonatomic, strong) IBOutlet UIImageView *matchtypeImage;
@property (nonatomic, strong) IBOutlet UILabel *clubName;
@property (nonatomic, strong) IBOutlet UILabel *rivalName;
@property (nonatomic, strong) IBOutlet UILabel *matchMonth;
@property (nonatomic, strong) IBOutlet UILabel *matchDay;
- (void)updateView;
@end
