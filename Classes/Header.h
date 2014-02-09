//
//  Header.h
//  FFC
//
//  Created by Shankar on 8/12/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface Header : UIViewController

@property (nonatomic, strong) IBOutlet UILabel* lblDiamond;
@property (nonatomic, strong) IBOutlet UILabel* lblName;
@property (nonatomic, strong) IBOutlet UILabel* lblGold;
@property (nonatomic, strong) IBOutlet UILabel* lblLevel;
@property (nonatomic, strong) IBOutlet UILabel* lblExpCounter;
@property (nonatomic, strong) IBOutlet UILabel* lblEnergyCounter;
@property (nonatomic, strong) IBOutlet UILabel* lblEnergyTimer;
@property (nonatomic, strong) IBOutlet UIImageView* iLogo;
@property (nonatomic, strong) IBOutlet UIProgressView* pvExp;
@property (nonatomic, strong) IBOutlet UIButton *btnGold;
@property (nonatomic, strong) IBOutlet UIButton *btnDiamond;
@property (nonatomic, strong) IBOutlet UIButton *btnEnergy;
@property (nonatomic, strong) NSTimer *energyTimer;

@property (nonatomic, assign) NSInteger energy_seconds;
@property (nonatomic, assign) NSInteger diamond;
@property (nonatomic, assign) NSInteger gold;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger energy_max;
@property (nonatomic, assign) NSInteger xp_max;
@property (nonatomic, assign) NSInteger xp;

- (void)updateView;
- (void)refillEnergy;
- (IBAction)club_tap:(id)sender;
- (IBAction)gold_tap:(id)sender;
- (IBAction)diamond_tap:(id)sender;
- (IBAction)energy_tap:(id)sender;

@end
