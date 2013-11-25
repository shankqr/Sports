//
//  LoadingView.m
//  Sports
//
//  Created by Shankar on 11/25/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()

@end

@implementation LoadingView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    [backgroundImage setImage:[UIImage imageNamed:@"loading_bkg.png"]];

    [self.view addSubview:backgroundImage];
}

@end
