//
//  StadiumView.h
//  FFC
//
//  Created by Shankar Nathan on 5/26/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface StadiumView : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *stadiumNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *capacityLabel;
@property (nonatomic, strong) IBOutlet UILabel *ticketLabel;
@property (nonatomic, strong) IBOutlet UILabel *levelLabel;
@property (nonatomic, strong) IBOutlet UILabel *rentLabel;

- (IBAction)upgradeButton_tap:(id)sender;
- (void)updateView;

@end
