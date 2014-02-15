//
//  LoadingView.h
//  Sports
//
//  Created by Shankar on 11/25/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#define bar_y 0.9f

@interface LoadingView : UIViewController

@property (nonatomic, strong) UIImageView *barImage;
@property (nonatomic, strong) UIImage *imgBar;
@property (nonatomic, strong) UILabel *lblStatus;

- (void)updateView;
- (void)close;

@end
