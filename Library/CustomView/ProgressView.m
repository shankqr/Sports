//
//  ProgressView.m
//  Kingdom
//
//  Created by Shankar on 4/14/14.
//  Copyright (c) 2014 TAPFANTASY. All rights reserved.
//

#import "ProgressView.h"
#import "Globals.h"

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat progress_w = self.frame.size.width;
        CGFloat progress_h = self.frame.size.height;
        CGRect bar_frame = CGRectMake(0, 0, progress_w, progress_h);
        
        self.bkgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.bkgLabel setBackgroundColor:[UIColor blackColor]];
        [self.bkgLabel setFrame:bar_frame];
        [self addSubview:self.bkgLabel];
        
        UIImage *barImage1 = [UIImage imageNamed:@"progressbar_left"];
        self.barImageView1 = [[UIImageView alloc] initWithImage:barImage1];
        [self.barImageView1 setFrame:CGRectMake(0.0f, 0.0f, 0.0f, self.frame.size.height)];
        [self.barImageView1 setClipsToBounds:YES];
        self.barImageView1.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.barImageView1];
        
        UIImage *barBkgImage1 = [[Globals i] dynamicImage:bar_frame prefix:@"progressbar"];
        self.barBkgImageView1 = [[UIImageView alloc] initWithImage:barBkgImage1];
        [self.barBkgImageView1 setFrame:bar_frame];
        [self addSubview:self.barBkgImageView1];
        
        self.barLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.barLabel1 setNumberOfLines:1];
        [self.barLabel1 setFont:[UIFont fontWithName:DEFAULT_FONT_BOLD size:9*SCALE_IPAD]];
        [self.barLabel1 setBackgroundColor:[UIColor clearColor]];
        [self.barLabel1 setTextColor:[UIColor whiteColor]];
        self.barLabel1.adjustsFontSizeToFitWidth = YES;
        self.barLabel1.minimumScaleFactor = 0.5;
        self.barLabel1.textAlignment = NSTextAlignmentCenter;
        [self.barLabel1 setFrame:bar_frame];
        [self addSubview:self.barLabel1];
        
        self.bar1 = 0.0f;
    }
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL pointInside = NO;
    return pointInside;
}

- (void)updateView
{
    self.bkgLabel.hidden = NO;
    self.barImageView1.hidden = NO;
    self.barBkgImageView1.hidden = NO;
    self.barLabel1.hidden = NO;
    
    if (self.bar1 > 0.0f)
    {
        CGFloat bar = self.frame.size.width*self.bar1;
        [self.barImageView1 setFrame:CGRectMake(0.0f, 0.0f, bar, self.frame.size.height)];
    }
    else if (self.bar1 > 1.0f)
    {
        [self.barImageView1 setFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    }
    else
    {
        [self.barImageView1 setFrame:CGRectMake(0.0f, 0.0f, 0.0f, self.frame.size.height)];
    }
    
    [self.barLabel1 setText:self.barText];
}

- (void)hideAll
{
    self.bkgLabel.hidden = YES;
    self.barImageView1.hidden = YES;
    self.barBkgImageView1.hidden = YES;
    self.barLabel1.hidden = YES;
}

@end
