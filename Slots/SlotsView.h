//
//  SlotsView.h
//  Liberty Bell
//
//  Created by TapFantasy on 5/24/13.
//  Copyright (c) 2013 TapFantasy. All rights reserved.
//

#import "General.h"
#import "GameMechanics.h"
#import "Audio.h"

@interface SlotsView : UIViewController <GameMechanicsDelegate, AudioDelegate>
{
    GameMechanics *gameMechanics;
    NSDictionary *config;
    NSDictionary *texts;
    NSArray *combinations;
    NSArray *reels;
    NSArray *reelViews;
    NSArray *bulbs;
    NSMutableArray *currentSpinCounts;
    NSMutableArray *currentSpinResults;
    NSDictionary *animations;
    NSMutableArray *cards;
    NSMutableArray *currentCards;
    int itemWidth;
    int itemHeight;
    int rowCount;
    int currentlyRotating;
    int currentWins;
    int noOfSpins;
    int winResult;
    int rand1;
    int rand2;
    int rand3;
    Audio *audio;
    
    BOOL keepSpinning;
    
    IBOutlet UIView* reel1;
    IBOutlet UIView* reel2;
    IBOutlet UIView* reel3;
    IBOutlet UIButton *armButton;
    IBOutlet UILabel *winsLabel;
    IBOutlet UILabel *coinsLabel;
    IBOutlet UILabel *creditsLabel;
    IBOutlet UILabel *winsTitleLabel;
    IBOutlet UILabel *winsTitleLabel2;
    IBOutlet UILabel *coinsTitleLabel;
    IBOutlet UIView *machineView;
    IBOutlet UIView *winsContainer;
    IBOutlet UIView *coinsContainer;
    IBOutlet UIView *armButtonContainer;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIButton *addCoinButton;
    IBOutlet UIButton *addMaxCoinButton;
    IBOutlet UIButton *productsButton;
    IBOutlet UIView *betContainer;
    IBOutlet UIView *maxBetContainer;
    IBOutlet UILabel *creditsTitleLabel;
    IBOutlet UIView *payoutsContainer;
    IBOutlet UIButton *payoutsButton;
    IBOutlet UIButton *payoutsCloseButton;
    IBOutlet UILabel *payoutsLabel;
    IBOutlet UIImageView *vegasLights;
    IBOutlet UIImageView *bulbImage1;
    IBOutlet UIImageView *bulbImage2;
    IBOutlet UIImageView *bulbImage3;
    IBOutlet UIImageView *bulbImage4;
    IBOutlet UIImageView *bulbImage5;
    IBOutlet UIImageView *bulbImage6;
    IBOutlet UIImageView *bulbImage7;
    IBOutlet UIImageView *bulbImage8;
}
- (IBAction) armButtonTapped:(id)sender;
- (IBAction) addCoinButtonTapped:(id)sender;
- (IBAction) addMaxCoinButtonTapped:(id)sender;
- (IBAction) productsButtonTapped:(id)sender;
- (IBAction) payoutsCloseButtonTapped:(id)sender;
- (IBAction) payoutsButtonTapped:(id)sender;
@end
