//
//  RowView.h
//  Kingdom
//
//  Created by Shankar on 4/14/14.
//  Copyright (c) 2014 TAPFANTASY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCFineTuneSlider;

@interface RowView : UIView

@property (nonatomic, strong) NSMutableDictionary *rowData;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) DCFineTuneSlider *slider;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) CGRect frame_view;

- (CGFloat)updateView;
- (void)hideAll;

@end
