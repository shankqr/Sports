//
//  StadiumMap.h
//  FFC
//
//  Created by Shankar on 7/26/11.
//  Copyright 2011 TAPFANTASY. All rights reserved.
//
#import "Globals.h"
#import "MainView.h"

@interface StadiumMap : UIViewController 
{
    MainView *mainView;
    NSString *s0;
    NSString *s1;
    NSString *s2;
    NSString *s3;
    NSString *s4;
    NSString *s5;
    NSString *s6;
    NSString *s7;
    UILabel *progressBar1;
    UIImageView *stadiumMap;
    UIImageView *stadiumPitch;
    UIImageView *stadiumSection0;
    UIImageView *stadiumSection1;
    UIImageView *stadiumSection2;
    UIImageView *stadiumSection3;
    UIImageView *stadiumSection4;
    UIImageView *stadiumSection5;
    UIImageView *stadiumSection6;
    UIImageView *stadiumSection7;
    UIImageView *timer1;
    UIImageView *timer2;
    UIImageView *timer3;
    UIImageView *money1;
    UIImageView *money2;
    UIImageView *money3;
    UIButton *building1;
    UIButton *building2;
    UIButton *building3;
    UILabel *building1TimerLabel;
    UILabel *building2TimerLabel;
    UILabel *building3TimerLabel;
    UILabel *building1CashLabel;
    UILabel *building2CashLabel;
    UILabel *building3CashLabel;
    UIImageView *carUp;
    UIImageView *carDown;
    NSTimer *gameTimer;
    NSDateFormatter *serverFormat;
    NSDateFormatter *dateFormat;
    NSTimeInterval b1s;
    NSTimeInterval b2s;
    NSTimeInterval b3s;
    int indexMap;
    int randomCar;
    double randomSpeed;
    BOOL anim1;
    BOOL anim2;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet NSString *s0;
@property (nonatomic, strong) IBOutlet NSString *s1;
@property (nonatomic, strong) IBOutlet NSString *s2;
@property (nonatomic, strong) IBOutlet NSString *s3;
@property (nonatomic, strong) IBOutlet NSString *s4;
@property (nonatomic, strong) IBOutlet NSString *s5;
@property (nonatomic, strong) IBOutlet NSString *s6;
@property (nonatomic, strong) IBOutlet NSString *s7;
@property (nonatomic, strong) IBOutlet UILabel *progressBar1;
@property (nonatomic, strong) IBOutlet UIImageView *stadiumMap;
@property (nonatomic, strong) IBOutlet UIImageView *stadiumPitch;
@property (nonatomic, strong) IBOutlet UIImageView *stadiumSection0;
@property (nonatomic, strong) IBOutlet UIImageView *stadiumSection1;
@property (nonatomic, strong) IBOutlet UIImageView *stadiumSection2;
@property (nonatomic, strong) IBOutlet UIImageView *stadiumSection3;
@property (nonatomic, strong) IBOutlet UIImageView *stadiumSection4;
@property (nonatomic, strong) IBOutlet UIImageView *stadiumSection5;
@property (nonatomic, strong) IBOutlet UIImageView *stadiumSection6;
@property (nonatomic, strong) IBOutlet UIImageView *stadiumSection7;
@property (nonatomic, strong) IBOutlet UIImageView *timer1;
@property (nonatomic, strong) IBOutlet UIImageView *timer2;
@property (nonatomic, strong) IBOutlet UIImageView *timer3;
@property (nonatomic, strong) IBOutlet UIImageView *money1;
@property (nonatomic, strong) IBOutlet UIImageView *money2;
@property (nonatomic, strong) IBOutlet UIImageView *money3;
@property (nonatomic, strong) IBOutlet UIButton *building1;
@property (nonatomic, strong) IBOutlet UIButton *building2;
@property (nonatomic, strong) IBOutlet UIButton *building3;
@property (nonatomic, strong) IBOutlet UILabel *building1TimerLabel;
@property (nonatomic, strong) IBOutlet UILabel *building2TimerLabel;
@property (nonatomic, strong) IBOutlet UILabel *building3TimerLabel;
@property (nonatomic, strong) IBOutlet UILabel *building1CashLabel;
@property (nonatomic, strong) IBOutlet UILabel *building2CashLabel;
@property (nonatomic, strong) IBOutlet UILabel *building3CashLabel;
@property (nonatomic, strong) UIImageView *carUp;
@property (nonatomic, strong) UIImageView *carDown;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) NSDateFormatter *serverFormat;
@property (nonatomic, strong) NSDateFormatter *dateFormat;
@property (readwrite) NSTimeInterval b1s;
@property (readwrite) NSTimeInterval b2s;
@property (readwrite) NSTimeInterval b3s;
- (IBAction)changeButton_tap:(id)sender;
- (IBAction)cancelButton_tap:(id)sender;
- (IBAction)building1_tap:(id)sender;
- (IBAction)building2_tap:(id)sender;
- (IBAction)building3_tap:(id)sender;
- (void)updateView;
- (void)upgradeBuilding:(int)type;
- (void)updateBuildingTimer;
- (void)harvestBuilding:(int)type;
- (void)updateHarverstTimeLeft;
- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
- (void)moveImage:(UIImageView *)image animID:(NSString *)animID
         duration:(NSTimeInterval)duration curve:(int)curve x:(CGFloat)x y:(CGFloat)y;
@end
