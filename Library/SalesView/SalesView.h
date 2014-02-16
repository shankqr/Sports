//
//  SalesView.h
//  Sports
//
//  Created by Shankar on 2/9/14.
//  Copyright (c) 2014 TAPFANTASY. All rights reserved.
//

@interface SalesView : UIViewController

@property (nonatomic, strong) IBOutlet UILabel* lblRow3;
@property (nonatomic, strong) IBOutlet UILabel* lblRow4;
@property (nonatomic, strong) IBOutlet UILabel* lblEnding;
@property (nonatomic, strong) IBOutlet UILabel* lblPrice;
@property (nonatomic, strong) IBOutlet UILabel* lblBundle1;
@property (nonatomic, strong) IBOutlet UILabel* lblBundle2;
@property (nonatomic, strong) IBOutlet UILabel* lblBundle3;
@property (nonatomic, strong) IBOutlet UILabel* lblBundle4;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, assign) NSTimeInterval b1s;

- (void)updateView;
- (IBAction)buy_tap:(id)sender;

@end
