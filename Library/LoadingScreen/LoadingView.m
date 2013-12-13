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
@synthesize barImage;
@synthesize imgBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    UIImage *imgBkg;
    if (iPad)
    {
        imgBkg = [UIImage imageNamed:@"loading_ipad.png"];
    }
    else
    {
        imgBkg = [UIImage imageNamed:@"loading.png"];
    }
    [backgroundImage setImage:imgBkg];
    [self.view addSubview:backgroundImage];
    
    /*
    UIImage *imgLogo = [UIImage imageNamed:@"loading_logo.png"];
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:imgLogo];
    logoImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgLogo.size.width*SCALE_IPAD/4), SCREEN_OFFSET_MAINHEADER_Y, (imgLogo.size.width*SCALE_IPAD/2), (imgLogo.size.height*SCALE_IPAD/2));
    [self.view addSubview:logoImage];
    */
    
    UIImage *imgBarBkg = [UIImage imageNamed:@"loading_bar_bkg.png"];
    UIImageView *barbkgImage = [[UIImageView alloc] initWithImage:imgBarBkg];
    barbkgImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBarBkg.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(imgBarBkg.size.height*SCALE_IPAD/4), (imgBarBkg.size.width*SCALE_IPAD/2), (imgBarBkg.size.height*SCALE_IPAD/2));
    [self.view addSubview:barbkgImage];
    
    self.imgBar = [UIImage imageNamed:@"loading_bar.png"];
    self.barImage = [[UIImageView alloc] initWithImage:imgBar];
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(imgBar.size.height*SCALE_IPAD/4), 0, (imgBar.size.height*SCALE_IPAD/2));
    [self.barImage setClipsToBounds:YES];
    self.barImage.contentMode = UIViewContentModeLeft;
    [self.view addSubview:self.barImage];
}

- (void)updateView
{
    //start small again
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(imgBar.size.height*SCALE_IPAD/4), 0, (imgBar.size.height*SCALE_IPAD/2));
    
    [UIView animateWithDuration:15.0f
                     animations:^{
                         self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(imgBar.size.height*SCALE_IPAD/4), ((imgBar.size.width*SCALE_IPAD/2) * 1), (imgBar.size.height*SCALE_IPAD/2));
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)close
{
    [self.barImage removeFromSuperview];
    
    self.barImage = [[UIImageView alloc] initWithImage:imgBar];
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(imgBar.size.height*SCALE_IPAD/4), 0, (imgBar.size.height*SCALE_IPAD/2));
    [self.barImage setClipsToBounds:YES];
    self.barImage.contentMode = UIViewContentModeLeft;
    [self.view addSubview:self.barImage];
    
    [self.view removeFromSuperview];
}

@end
