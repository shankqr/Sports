//
//  LoadingView.h
//  Sports
//
//  Created by Shankar on 11/25/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@interface LoadingView : UIViewController
{
    UIImageView *barImage;
    UIImage *imgBar;
    NSTimer *loadingTimer;
    CGFloat bar_x;
}
@property (nonatomic, strong) UIImageView *barImage;
@property (nonatomic, strong) UIImage *imgBar;
@property (nonatomic, strong) NSTimer *loadingTimer;
- (void)updateView;
- (void)addBar;
- (void)close;
@end
