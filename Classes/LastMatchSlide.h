//
//  LastMatchSlide.h
//  FM
//
//  Created by Shankar Nathan on 3/24/10.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainCell;

@interface LastMatchSlide : UIViewController 

@property (nonatomic, strong) MainCell *mainCell;
@property (nonatomic, strong) IBOutlet UIImageView *matchtypeImage;
@property (nonatomic, strong) IBOutlet UILabel *clubName;
@property (nonatomic, strong) IBOutlet UILabel *rivalName;
@property (nonatomic, strong) IBOutlet UILabel *matchMonth;
@property (nonatomic, strong) IBOutlet UILabel *matchDay;
@property (nonatomic, strong) IBOutlet UILabel *clubScore;
@property (nonatomic, strong) IBOutlet UILabel *rivalScore;

- (void)updateView;

@end
