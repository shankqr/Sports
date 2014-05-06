//
//  StadiumMap.h
//  FFC
//
//  Created by Shankar on 7/26/11.
//  Copyright 2011 TAPFANTASY. All rights reserved.
//

@class StadiumView;
@class UpgradeView;

@interface StadiumMap : UIViewController 

@property (nonatomic, strong) StadiumView *stadiumView;
@property (nonatomic, strong) UpgradeView *upgradeView;
@property (nonatomic, strong) IBOutlet NSString *s0;
@property (nonatomic, strong) IBOutlet NSString *s1;
@property (nonatomic, strong) IBOutlet NSString *s2;
@property (nonatomic, strong) IBOutlet NSString *s3;
@property (nonatomic, strong) IBOutlet NSString *s4;
@property (nonatomic, strong) IBOutlet NSString *s5;
@property (nonatomic, strong) IBOutlet NSString *s6;
@property (nonatomic, strong) IBOutlet NSString *s7;
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

@property (nonatomic, assign) NSTimeInterval b1s;
@property (nonatomic, assign) NSTimeInterval b2s;
@property (nonatomic, assign) NSTimeInterval b3s;
@property (nonatomic, assign) NSInteger indexMap;
@property (nonatomic, assign) NSInteger randomCar;
@property (nonatomic, assign) double randomSpeed;
@property (nonatomic, assign) BOOL anim1;
@property (nonatomic, assign) BOOL anim2;

- (IBAction)changeButton_tap:(id)sender;
- (IBAction)building1_tap:(id)sender;
- (IBAction)building2_tap:(id)sender;
- (IBAction)building3_tap:(id)sender;
- (void)updateView;
- (void)updateBuildingTimer;
- (void)harvestBuilding:(NSInteger)type;
- (void)updateHarverstTimeLeft;

@end
