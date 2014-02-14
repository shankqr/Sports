//
//  UpgradeView.h
//  FFC
//
//  Created by Shankar Nathan on 5/26/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface UpgradeView : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *buildingImage;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *cashLabel;
@property (nonatomic, strong) IBOutlet UILabel *formulaLabel;

@property (nonatomic, assign) NSInteger buildingType;

- (IBAction)upgradeButton_tap:(id)sender;
- (void)updateView:(NSInteger)type;

@end
