//
//  ProgressView.h
//  Kingdom
//
//  Created by Shankar on 4/14/14.
//  Copyright (c) 2014 TAPFANTASY. All rights reserved.
//

@interface ProgressView : UIView

@property (nonatomic, strong) UIImageView *barBkgImageView1;
@property (nonatomic, strong) UIImageView *barImageView1;
@property (nonatomic, strong) UILabel *bkgLabel;
@property (nonatomic, strong) UILabel *barLabel1;
@property (nonatomic, strong) NSString *barText;

@property (nonatomic, assign) float bar1;

- (void)updateView;
- (void)hideAll;

@end
