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
@synthesize loadingTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    UIImage *imgBkg = [UIImage imageNamed:@"skin_menu.png"];
    [backgroundImage setImage:imgBkg];
    [self.view addSubview:backgroundImage];
    
    UIImage *imgBarBkg = [UIImage imageNamed:@"loading_bar_bkg.png"];
    UIImageView *barbkgImage = [[UIImageView alloc] initWithImage:imgBarBkg];
    barbkgImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBarBkg.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height/2)-(imgBarBkg.size.height*SCALE_IPAD/4), (imgBarBkg.size.width*SCALE_IPAD/2), (imgBarBkg.size.height*SCALE_IPAD/2));
    [self.view addSubview:barbkgImage];
    
    UIImage *imgLogo = [UIImage imageNamed:@"loading_logo.png"];
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:imgLogo];
    logoImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgLogo.size.width*SCALE_IPAD/4), SCREEN_OFFSET_MAINHEADER_Y, (imgLogo.size.width*SCALE_IPAD/2), (imgLogo.size.height*SCALE_IPAD/2));
    [self.view addSubview:logoImage];
    
    self.imgBar = [UIImage imageNamed:@"loading_bar.png"];
    self.barImage = [[UIImageView alloc] initWithImage:imgBar];
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height/2)-(imgBar.size.height*SCALE_IPAD/4), 0, (imgBar.size.height*SCALE_IPAD/2));
    [self.barImage setClipsToBounds:YES];
    self.barImage.contentMode = UIViewContentModeLeft;
    [self.view addSubview:self.barImage];
    
    bar_x = 0;
}

- (void)updateView
{
    [self.view setUserInteractionEnabled:YES];
    
    //start small again
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height/2)-(imgBar.size.height*SCALE_IPAD/4), 0, (imgBar.size.height*SCALE_IPAD/2));
    
    if (!loadingTimer.isValid)
    {
        //loadingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(growLoadingBar) userInfo:nil repeats:YES];
    }
    
    [UIView animateWithDuration:15.0f
                     animations:^{
                         self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height/2)-(imgBar.size.height*SCALE_IPAD/4), ((imgBar.size.width*SCALE_IPAD/2) * 1), (imgBar.size.height*SCALE_IPAD/2));
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)growLoadingBar
{
    if (bar_x < 1)
    {
        bar_x += 0.1;
        self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height/2)-(imgBar.size.height*SCALE_IPAD/4), ((imgBar.size.width*SCALE_IPAD/2) * bar_x), (imgBar.size.height*SCALE_IPAD/2));
        [self.view setNeedsDisplay];
    }
    else
    {
        [self close];
    }
}

- (void)addBar
{
    if (bar_x < 1)
    {
        bar_x += 0.1;
        
        self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height/2)-(imgBar.size.height*SCALE_IPAD/4), ((imgBar.size.width*SCALE_IPAD/2) * bar_x), (imgBar.size.height*SCALE_IPAD/2));
        
        [self.view performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
    }
}

- (void)close
{
    if (loadingTimer != nil)
    {
        [loadingTimer invalidate];
    }
    
    bar_x = 0;
    
    [self.view removeFromSuperview];
}

@end
