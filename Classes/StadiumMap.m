//
//  StadiumMap.m
//  FFC
//
//  Created by Shankar on 7/26/11.
//  Copyright 2011 TAPFANTASY. All rights reserved.
//

#import "StadiumMap.h"
#import "Globals.h"
#import "MainView.h"
#import "StadiumView.h"
#import "UpgradeView.h"

@implementation StadiumMap
@synthesize mainView;
@synthesize stadiumView;
@synthesize upgradeView;
@synthesize s0;
@synthesize s1;
@synthesize s2;
@synthesize s3;
@synthesize s4;
@synthesize s5;
@synthesize s6;
@synthesize s7;
@synthesize progressBar1;
@synthesize stadiumMap;
@synthesize stadiumPitch;
@synthesize stadiumSection0;
@synthesize stadiumSection1;
@synthesize stadiumSection2;
@synthesize stadiumSection3;
@synthesize stadiumSection4;
@synthesize stadiumSection5;
@synthesize stadiumSection6;
@synthesize stadiumSection7;
@synthesize building1;
@synthesize building2;
@synthesize building3;
@synthesize carUp;
@synthesize carDown;
@synthesize gameTimer;
@synthesize dateFormat;
@synthesize serverFormat;
@synthesize building1TimerLabel;
@synthesize building2TimerLabel;
@synthesize building3TimerLabel;
@synthesize building1CashLabel;
@synthesize building2CashLabel;
@synthesize building3CashLabel;
@synthesize timer1;
@synthesize timer2;
@synthesize timer3;
@synthesize money1;
@synthesize money2;
@synthesize money3;
@synthesize b1s;
@synthesize b2s;
@synthesize b3s;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(1.57079633);
    landscapeTransform = CGAffineTransformTranslate (landscapeTransform, +80.0, +80.0);
    [self.view setTransform:landscapeTransform];
    
    anim1 = NO;
    anim2 = NO;
    
    randomCar = [[Globals i] Random_next:1 to:8];
    randomSpeed = [[Globals i] Random_next:4 to:10];
    
    self.carUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"car%ld01.png", (long)randomCar]]];
    carUp.frame = CGRectMake(-55*SCALE_IPAD, 180*SCALE_IPAD, 55*SCALE_IPAD, 40*SCALE_IPAD);
    carUp.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:carUp];
    [self moveImage:carUp animID:@"CarUp" duration:randomSpeed curve:UIViewAnimationCurveLinear x:405.0 y:-55.0];
    
    randomCar = [[Globals i] Random_next:1 to:8];
    randomSpeed = [[Globals i] Random_next:4 to:10];
    
    self.carDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"car%ld02.png", (long)randomCar]]];
    carDown.frame = CGRectMake(350*SCALE_IPAD, -55*SCALE_IPAD, 55*SCALE_IPAD, 40*SCALE_IPAD);
    carDown.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:carDown];
    [self moveImage:carDown animID:@"CarDown" duration:randomSpeed curve:UIViewAnimationCurveLinear x:-55.0 y:150.0];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    serverFormat = [[NSDateFormatter alloc] init];
    [serverFormat setLocale:locale];
    [serverFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss Z"];
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:locale];
    [dateFormat setDateFormat:@"EEEE, MMMM d, yyyy HH:mm:ss Z"];
    
    building1CashLabel.hidden = YES;
    building2CashLabel.hidden = YES;
    building3CashLabel.hidden = YES;
    
    progressBar1 = [[UILabel alloc] init];
    progressBar1.backgroundColor = [UIColor greenColor];
    building1.tag = 0;
    building2.tag = 0;
    building3.tag = 0;
    building1CashLabel.hidden = YES;
    building2CashLabel.hidden = YES;
    building3CashLabel.hidden = YES;
    b1s = 0.0;
    b2s = 0.0;
    b3s = 0.0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)showStadiumUpgrade
{
    if (stadiumView == nil)
    {
        stadiumView = [[StadiumView alloc] initWithNibName:@"StadiumView" bundle:nil];
    }
    [[Globals i] showTemplate:@[stadiumView] :@"" :0];
    [self.stadiumView updateView];
}

- (void)showBuildingUpgrade:(NSInteger)type;
{
    if (upgradeView == nil)
    {
        upgradeView = [[UpgradeView alloc] initWithNibName:@"UpgradeView" bundle:nil];
    }
    [[Globals i] showTemplate:@[upgradeView] :@"" :0];
    [self.upgradeView updateView:type];
}

- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (void)moveImage:(UIImageView *)image animID:(NSString *)animID
         duration:(NSTimeInterval)duration curve:(NSInteger)curve x:(CGFloat)x y:(CGFloat)y
{
    [UIView beginAnimations:animID context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(a1DidStop:finished:context:)];
    [UIView setAnimationCurve:curve];
    //[UIView setAnimationRepeatAutoreverses:YES];
    //[UIView setAnimationRepeatCount:1];
    
    image.frame = CGRectMake(x, y, 55*SCALE_IPAD, 40*SCALE_IPAD);
    
    [UIView commitAnimations];
}

- (void)a1DidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ( [animationID isEqualToString:@"CarUp"] ) 
    {
        randomCar = [[Globals i] Random_next:1 to:8];
        [self.carUp setImage:[UIImage imageNamed:[NSString stringWithFormat:@"car%ld01.png", (long)randomCar]]];
        carUp.frame = CGRectMake(-55*SCALE_IPAD, 180*SCALE_IPAD, 55*SCALE_IPAD, 40*SCALE_IPAD);
        [carUp setNeedsDisplay];
        [self.view setNeedsDisplay];
        
        anim1 = YES;
    }
    if ( [animationID isEqualToString:@"CarDown"] ) 
    {
        randomCar = [[Globals i] Random_next:1 to:8];
        [self.carDown setImage:[UIImage imageNamed:[NSString stringWithFormat:@"car%ld02.png", (long)randomCar]]];
        carDown.frame = CGRectMake(350*SCALE_IPAD, -55*SCALE_IPAD, 55*SCALE_IPAD, 40*SCALE_IPAD);
        [carDown setNeedsDisplay];
        [self.view setNeedsDisplay];
        
        anim2 = YES;
    }
}

- (void)onTimer
{
    if (anim1) 
    {
        randomSpeed = [[Globals i] Random_next:4 to:10];
        [self moveImage:carUp animID:@"CarUp" duration:randomSpeed curve:UIViewAnimationCurveLinear x:405.0*SCALE_IPAD y:-55.0*SCALE_IPAD];
        anim1 = NO;
    }
    if (anim2) 
    {
        randomSpeed = [[Globals i] Random_next:4 to:10];
        [self moveImage:carDown animID:@"CarDown" duration:randomSpeed curve:UIViewAnimationCurveLinear x:-55.0*SCALE_IPAD y:150.0*SCALE_IPAD];
        anim2 = NO;
    }
    
    [self updateBuildingTimer];
}

- (void)updateHarverstTimeLeft
{
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/CurrentTime", WS_URL];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    NSString *returnValue  = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    
    returnValue = [NSString stringWithFormat:@"%@ -0000", returnValue];
    NSDate *serverDateTime = [serverFormat dateFromString:returnValue];
    NSTimeInterval serverTimeInterval = [serverDateTime timeIntervalSince1970];
    
    [[Globals i] setOffsetTime:serverTimeInterval];
    
    NSTimeInterval lastHarvestedTime;
    NSDate *lastHarvestedDate;
    NSString *strDate;

    strDate = [[Globals i] getClubData][@"building1_dt"];
    strDate = [NSString stringWithFormat:@"%@ -0000", strDate];
    lastHarvestedDate = [dateFormat dateFromString:strDate];
    lastHarvestedTime = [lastHarvestedDate timeIntervalSince1970];
    b1s = (24*3600) - (serverTimeInterval - lastHarvestedTime);
    
    strDate = [[Globals i] getClubData][@"building2_dt"];
    strDate = [NSString stringWithFormat:@"%@ -0000", strDate];
    lastHarvestedDate = [dateFormat dateFromString:strDate];
    lastHarvestedTime = [lastHarvestedDate timeIntervalSince1970];
    b2s = (8*3600) - (serverTimeInterval - lastHarvestedTime);
    
    strDate = [[Globals i] getClubData][@"building3_dt"];
    strDate = [NSString stringWithFormat:@"%@ -0000", strDate];
    lastHarvestedDate = [dateFormat dateFromString:strDate];
    lastHarvestedTime = [lastHarvestedDate timeIntervalSince1970];
    b3s = (1*3600) - (serverTimeInterval - lastHarvestedTime);
}

- (void)updateBuildingTimer
{
    b1s = b1s-1;
    b2s = b2s-1;
    b3s = b3s-1;
    
    if (building1.tag == 0) 
    {
        NSInteger b1 = [[[Globals i] getClubData][@"building1"] integerValue];
        if (b1 > 0 && b1s > 1)
        {
            building1TimerLabel.text = [[Globals i] getCountdownString:b1s];
            timer1.hidden = NO;
            [timer1 setImage:[UIImage imageNamed:@"timer.png"]];
            money1.hidden = YES;
        }
        else
        {
            building1TimerLabel.text = @"";
            timer1.hidden = YES;
            if (b1 > 0)
            {
                money1.hidden = NO;
                [money1 setImage:[UIImage imageNamed:@"icon_money2.png"]];
            }
            else
            {
                money1.hidden = YES;
                [money1 setImage:[UIImage imageNamed:@""]];
            }
        }
    }
    
    if (building2.tag == 0) 
    {
        NSInteger b2 = [[[Globals i] getClubData][@"building2"] integerValue];
        if (b2 > 0 && b2s > 1)
        {
            building2TimerLabel.text = [[Globals i] getCountdownString:b2s];
            timer2.hidden = NO;
            [timer2 setImage:[UIImage imageNamed:@"timer.png"]];
            money2.hidden = YES;
        }
        else
        {
            building2TimerLabel.text = @"";
            timer2.hidden = YES;
            if (b2 > 0)
            {
                money2.hidden = NO;
                [money2 setImage:[UIImage imageNamed:@"icon_money2.png"]];
            }
            else
            {
                money2.hidden = YES;
                [money2 setImage:[UIImage imageNamed:@""]];
            }
        }
    }

    if (building3.tag == 0) 
    {
        NSInteger b3 = [[[Globals i] getClubData][@"building3"] integerValue];
        if (b3 > 0 && b3s > 1)
        {
            building3TimerLabel.text = [[Globals i] getCountdownString:b3s];
            timer3.hidden = NO;
            [timer3 setImage:[UIImage imageNamed:@"timer.png"]];
            money3.hidden = YES;
        }
        else
        {
            building3TimerLabel.text = @"";
            timer3.hidden = YES;
            if (b3 > 0)
            {
                money3.hidden = NO;
                [money3 setImage:[UIImage imageNamed:@"icon_money2.png"]];
            }
            else
            {
                money3.hidden = YES;
                [money3 setImage:[UIImage imageNamed:@""]];
            }
        }
    }

    
}

- (void)updateView
{
    [self updateHarverstTimeLeft];
    
    if (!gameTimer.isValid)
    {
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    
    [stadiumMap setImage:[UIImage imageNamed:@"map1.png"]];
    [stadiumPitch setImage:[UIImage imageNamed:@"m1.png"]];
    
    NSInteger s = [[[Globals i] getClubData][@"stadium"] integerValue];
    if (s > 329) 
    {
        s = 329;
    }
    
    //Buildings code
    NSInteger b1 = [[[Globals i] getClubData][@"building1"] integerValue];
    if (b1 == 0) 
    {
        [building1 setImage:[UIImage imageNamed:@"building_empty.png"] forState:UIControlStateNormal];
        building1CashLabel.text = @"";
    }
    else
    {
        if (b1 > 10) 
        {
            [building1 setImage:[UIImage imageNamed:@"building_hotel11.png"] forState:UIControlStateNormal];
        }
        else
        {
            [building1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"building_hotel%ld.png", (long)b1]] forState:UIControlStateNormal];
        }
        building1CashLabel.text = [NSString stringWithFormat:@"+$%ld", (long)b1*b1+s];
    }
    
    NSInteger b2 = [[[Globals i] getClubData][@"building2"] integerValue];
    if (b2 == 0) 
    {
        [building2 setImage:[UIImage imageNamed:@"building_empty.png"] forState:UIControlStateNormal];
        building2CashLabel.text = @"";
    }
    else
    {
        if (b2 > 10) 
        {
            [building2 setImage:[UIImage imageNamed:@"building_food11.png"] forState:UIControlStateNormal];
        }
        else
        {
            [building2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"building_food%ld.png", (long)b2]] forState:UIControlStateNormal];
        }
        building2CashLabel.text = [NSString stringWithFormat:@"+$%ld", (long)b2*s];
    }
    
    NSInteger b3 = [[[Globals i] getClubData][@"building3"] integerValue];
    if (b3 == 0) 
    {
        [building3 setImage:[UIImage imageNamed:@"building_empty.png"] forState:UIControlStateNormal];
        building3CashLabel.text = @"";
    }
    else
    {
        if (b3 > 10) 
        {
            [building3 setImage:[UIImage imageNamed:@"building_office11.png"] forState:UIControlStateNormal];
        }
        else
        {
            [building3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"building_office%ld.png", (long)b3]] forState:UIControlStateNormal];
        }
        building3CashLabel.text = [NSString stringWithFormat:@"+$%ld", (long)b3*b1+b2+s];
    }
    
    //Stadium code
    indexMap = s-1;
    
    NSInteger indexBack = 100 + (indexMap/8);
    NSInteger indexStage = (indexMap%8);
    
    switch (indexStage)
    {
        case 0:
            s0 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s1 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s2 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s3 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s4 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s5 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s6 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s7 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            break;
        case 1:
            s0 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s1 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s2 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s3 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s4 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s5 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s6 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s7 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            break;
        case 2:
            s0 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s1 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s2 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s3 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s4 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s5 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s6 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s7 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            break;
        case 3:
            s0 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s1 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s2 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s3 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s4 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s5 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s6 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s7 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            break;
        case 4:
            s0 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s1 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s2 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s3 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s4 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s5 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s6 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s7 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            break;
        case 5:
            s0 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s1 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s2 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s3 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s4 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s5 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s6 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s7 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            break;
        case 6:
            s0 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s1 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s2 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s3 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s4 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s5 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s6 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            s7 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            break;
        case 7:
            s0 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s1 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s2 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s3 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s4 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s5 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s6 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s7 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack];
            break;
        default:
            s0 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s1 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s2 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s3 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s4 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s5 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s6 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            s7 = [NSString stringWithFormat:@"m%ld.png", (long)indexBack+1];
            break;
    }
    
    CGRect clippedRect = CGRectMake(0, 0, 177, 188);
    [stadiumSection0 setImage:[self imageByCropping:[UIImage imageNamed:s0] toRect:clippedRect]];
    
    clippedRect = CGRectMake(177, 0, 148, 188);
    [stadiumSection1 setImage:[self imageByCropping:[UIImage imageNamed:s1] toRect:clippedRect]];
    
    clippedRect = CGRectMake(325, 0, 152, 188);
    [stadiumSection2 setImage:[self imageByCropping:[UIImage imageNamed:s2] toRect:clippedRect]];
    
    clippedRect = CGRectMake(477, 0, 141, 188);
    [stadiumSection3 setImage:[self imageByCropping:[UIImage imageNamed:s3] toRect:clippedRect]];
    
    clippedRect = CGRectMake(618, 0, 172, 188);
    [stadiumSection4 setImage:[self imageByCropping:[UIImage imageNamed:s4] toRect:clippedRect]];
    
    clippedRect = CGRectMake(790, 0, 137, 188);
    [stadiumSection5 setImage:[self imageByCropping:[UIImage imageNamed:s5] toRect:clippedRect]];
    
    clippedRect = CGRectMake(927, 0, 156, 188);
    [stadiumSection6 setImage:[self imageByCropping:[UIImage imageNamed:s6] toRect:clippedRect]];
    
    clippedRect = CGRectMake(1083, 0, 156, 188);
    [stadiumSection7 setImage:[self imageByCropping:[UIImage imageNamed:s7] toRect:clippedRect]];

    building1TimerLabel.text = @"";
    building2TimerLabel.text = @"";
    building3TimerLabel.text = @"";
}

- (void)harvestBuilding:(NSInteger)type
{
    building1TimerLabel.text = @".";
    building2TimerLabel.text = @".";
    building3TimerLabel.text = @".";
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/HarvestNew/%@/%ld/%.0f", 
                       WS_URL, [[Globals i] UID], (long)type, timeInterval];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    NSString *returnValue  = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    if([returnValue isEqualToString:@"1"])
    {
        if([[Globals i] updateClubData]) // Balance added
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:5.0];
            if (type == 1) 
            {
                building1CashLabel.hidden = NO;
                [UIView setAnimationDidStopSelector:@selector(b1DidStop:finished:context:)];
                building1CashLabel.center = CGPointMake(building1CashLabel.center.x, building1CashLabel.center.y-200);
                [building1CashLabel setAlpha:0];
                [[Globals i] scheduleNotification:[[NSDate date] dateByAddingTimeInterval:24*3600] :@"Hotel is Ready for Collection!"];
            }
            if (type == 2) 
            {
                building2CashLabel.hidden = NO;
                [UIView setAnimationDidStopSelector:@selector(b2DidStop:finished:context:)];
                building2CashLabel.center = CGPointMake(building2CashLabel.center.x, building2CashLabel.center.y-200);
                [building2CashLabel setAlpha:0];
                [[Globals i] scheduleNotification:[[NSDate date] dateByAddingTimeInterval:8*3600] :@"Food Business is Ready for Collection!"];
            }
            if (type == 3) 
            {
                building3CashLabel.hidden = NO;
                [UIView setAnimationDidStopSelector:@selector(b3DidStop:finished:context:)];
                building3CashLabel.center = CGPointMake(building3CashLabel.center.x, building3CashLabel.center.y-200);
                [building3CashLabel setAlpha:0];
                [[Globals i] scheduleNotification:[[NSDate date] dateByAddingTimeInterval:1*3600] :@"Manager Office is Ready for Collection!"];
            }
            [UIView commitAnimations];
            [[Globals i] moneySound];
            
            [self updateView];
        }
    }
}

- (void)upgradeBuilding:(NSInteger)type
{
    if (type == 1) 
    {
        building1TimerLabel.text = @".";
        timer1.hidden = YES;
        [building1 setAlpha:0.3];
        building1.tag = 1;
        
        progressBar1.frame = CGRectMake(PBAR1_X,PBAR1_Y,PBAR_SMALL,PBAR_SMALL);//starts small
        [self.view addSubview:progressBar1];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:20];
        [UIView setAnimationDidStopSelector:@selector(upgrade1DidStop:finished:context:)];
        progressBar1.frame = CGRectMake(PBAR1_X,PBAR1_Y,PBAR_BIG,PBAR_SMALL);//ends big
        
        [building1 setAlpha:1.0];
    }
    if (type == 2) 
    {
        building2TimerLabel.text = @".";
        timer2.hidden = YES;
        [building2 setAlpha:0.3];
        building2.tag = 1;
        
        progressBar1.frame = CGRectMake(PBAR2_X,PBAR2_Y,PBAR_SMALL,PBAR_SMALL);//starts small
        [self.view addSubview:progressBar1];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:20];
        [UIView setAnimationDidStopSelector:@selector(upgrade2DidStop:finished:context:)];
        progressBar1.frame = CGRectMake(PBAR2_X,PBAR2_Y,PBAR_BIG,PBAR_SMALL);//ends big
        
        [building2 setAlpha:1.0];
    }
    if (type == 3) 
    {
        building3TimerLabel.text = @".";
        timer3.hidden = YES;
        [building3 setAlpha:0.3];
        building3.tag = 1;
        
        progressBar1.frame = CGRectMake(PBAR3_X,PBAR3_Y,PBAR_SMALL,PBAR_SMALL);//starts small
        [self.view addSubview:progressBar1];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:20];
        [UIView setAnimationDidStopSelector:@selector(upgrade3DidStop:finished:context:)];
        progressBar1.frame = CGRectMake(PBAR3_X,PBAR3_Y,PBAR_BIG,PBAR_SMALL);//ends big
        
        [building3 setAlpha:1.0];
    }
    
    [UIView commitAnimations];
}

- (void)upgrade1DidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [building1 setAlpha:1.0];
    building1.tag = 0;
    [progressBar1 removeFromSuperview];
}

- (void)upgrade2DidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [building2 setAlpha:1.0];
    building2.tag = 0;
    [progressBar1 removeFromSuperview];
}

- (void)upgrade3DidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [building3 setAlpha:1.0];
    building3.tag = 0;
    [progressBar1 removeFromSuperview];
}

- (void)b1DidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    building1CashLabel.text = @"";
    [building1CashLabel setAlpha:1];
    building1CashLabel.center = CGPointMake(building1CashLabel.center.x, building1CashLabel.center.y+200);
    building1CashLabel.hidden = YES;
}

- (void)b2DidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    building2CashLabel.text = @"";
    [building2CashLabel setAlpha:1];
    building2CashLabel.center = CGPointMake(building2CashLabel.center.x, building2CashLabel.center.y+200);
    building2CashLabel.hidden = YES;
}

- (void)b3DidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    building3CashLabel.text = @"";
    [building3CashLabel setAlpha:1];
    building3CashLabel.center = CGPointMake(building3CashLabel.center.x, building3CashLabel.center.y+200);
    building3CashLabel.hidden = YES;
}

- (IBAction)changeButton_tap:(id)sender
{
    [self showStadiumUpgrade];
}

- (IBAction)building1_tap:(id)sender
{
    NSInteger b1 = [[[Globals i] getClubData][@"building1"] integerValue];

    if((b1 > 0) && ([building1TimerLabel.text isEqualToString:@""]))
    {
        [self harvestBuilding:1];
    }
    else
    {
        [self showBuildingUpgrade:1];
    }
}

- (IBAction)building2_tap:(id)sender
{
    NSInteger b2 = [[[Globals i] getClubData][@"building2"] integerValue];
    if((b2 > 0) && ([building2TimerLabel.text isEqualToString:@""]))
    {
        [self harvestBuilding:2];
    }
    else
    {
        [self showBuildingUpgrade:2];
    }
}

- (IBAction)building3_tap:(id)sender
{
    NSInteger b3 = [[[Globals i] getClubData][@"building3"] integerValue];
    if((b3 > 0) && ([building3TimerLabel.text isEqualToString:@""]))
    {
        [self harvestBuilding:3];
    }
    else
    {
        [self showBuildingUpgrade:3];
    }
}

@end
