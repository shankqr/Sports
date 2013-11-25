//
//  LoadingView.m
//  Sports
//
//  Created by Shankar on 11/25/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "LoadingView.h"
#import "Globals.h"

@interface LoadingView ()

@end

@implementation LoadingView
@synthesize loadingTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    [backgroundImage setImage:[UIImage imageNamed:@"loading_bkg.png"]];
    
    [self.view addSubview:backgroundImage];
}

- (void)updateView
{
    loadingTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(close) userInfo:nil repeats:NO];
}

- (void)close
{
    [self.view removeFromSuperview];
}

@end
