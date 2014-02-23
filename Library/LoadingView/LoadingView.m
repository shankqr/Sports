//
//  LoadingView.m
//  Sports
//
//  Created by Shankar on 11/25/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "LoadingView.h"
#import "Globals.h"

@implementation LoadingView

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
    
    UIImage *imgBarBkg = [UIImage imageNamed:@"loading_bar_bkg.png"];
    UIImageView *barbkgImage = [[UIImageView alloc] initWithImage:imgBarBkg];
    barbkgImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBarBkg.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(imgBarBkg.size.height*SCALE_IPAD/4), (imgBarBkg.size.width*SCALE_IPAD/2), (imgBarBkg.size.height*SCALE_IPAD/2));
    [self.view addSubview:barbkgImage];
    
    self.imgBar = [UIImage imageNamed:@"loading_bar.png"];
    self.barImage = [[UIImageView alloc] initWithImage:self.imgBar];
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(self.imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(self.imgBar.size.height*SCALE_IPAD/4), 0, (self.imgBar.size.height*SCALE_IPAD/2));
    [self.barImage setClipsToBounds:YES];
    self.barImage.contentMode = UIViewContentModeLeft;
    [self.view addSubview:self.barImage];
    
    self.lblStatus = [[UILabel alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBarBkg.size.width*SCALE_IPAD/4)-(60*SCALE_IPAD), (UIScreen.mainScreen.bounds.size.height*bar_y)-(imgBarBkg.size.height*SCALE_IPAD/4)-(30*SCALE_IPAD), (imgBarBkg.size.width*SCALE_IPAD/2)+(120*SCALE_IPAD), (imgBarBkg.size.height*SCALE_IPAD/2))];
    self.lblStatus.text = @"Loading...";
    self.lblStatus.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SMALL_SIZE];
	self.lblStatus.backgroundColor = [UIColor clearColor];
	self.lblStatus.textColor = [UIColor blackColor];
	self.lblStatus.textAlignment = NSTextAlignmentCenter;
	self.lblStatus.numberOfLines = 1;
	self.lblStatus.adjustsFontSizeToFitWidth = YES;
	self.lblStatus.minimumScaleFactor = 0.5f;
	[self.view addSubview:self.lblStatus];
    
    self.lblVersion = [[UILabel alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBarBkg.size.width*SCALE_IPAD/4)-(60*SCALE_IPAD), (40*SCALE_IPAD), (imgBarBkg.size.width*SCALE_IPAD/2)+(120*SCALE_IPAD), (imgBarBkg.size.height*SCALE_IPAD/2))];
    self.lblVersion.text = [NSString stringWithFormat:@"Version %@", GAME_VERSION];
    self.lblVersion.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SMALL_SIZE];
	self.lblVersion.backgroundColor = [UIColor clearColor];
	self.lblVersion.textColor = [UIColor blackColor];
	self.lblVersion.textAlignment = NSTextAlignmentCenter;
	self.lblVersion.numberOfLines = 1;
	self.lblVersion.adjustsFontSizeToFitWidth = YES;
	self.lblVersion.minimumScaleFactor = 0.5f;
	[self.view addSubview:self.lblVersion];
}

- (void)updateView
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"LoadingStatus"
                                               object:nil];
    
    //start small again
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(self.imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(self.imgBar.size.height*SCALE_IPAD/4), 0, (self.imgBar.size.height*SCALE_IPAD/2));
    
    [UIView animateWithDuration:30.0f
                     animations:^{
                         self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(self.imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(self.imgBar.size.height*SCALE_IPAD/4), ((self.imgBar.size.width*SCALE_IPAD/2) * 1), (self.imgBar.size.height*SCALE_IPAD/2));
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"LoadingStatus"])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSString *status = [userInfo objectForKey:@"status"];
        
        //Update label
        self.lblStatus.text = status;

        [self.view setNeedsDisplay];
        [CATransaction flush];
    }
}

- (void)close
{
    [self.barImage removeFromSuperview];
    
    self.barImage = [[UIImageView alloc] initWithImage:self.imgBar];
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(self.imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(self.imgBar.size.height*SCALE_IPAD/4), 0, (self.imgBar.size.height*SCALE_IPAD/2));
    [self.barImage setClipsToBounds:YES];
    self.barImage.contentMode = UIViewContentModeLeft;
    [self.view addSubview:self.barImage];
    
    [self.view removeFromSuperview];
}

@end
