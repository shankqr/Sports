//
//  ChallengeView.h
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface ChallengeView : UIViewController <UIActionSheetDelegate>
{
	UILabel *titleLabel;
	UITextView *managerNote;
	NSString *selected_matchid;
	NSArray *matches;
	NSInteger currMatchIndex;
    UILabel *winLabel;
	UILabel *loseLabel;
}

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextView *managerNote;
@property (nonatomic, strong) IBOutlet UILabel *winLabel;
@property (nonatomic, strong) IBOutlet UILabel *loseLabel;
@property (nonatomic, strong) NSString *selected_matchid;
@property (nonatomic, strong) NSArray *matches;
- (void)updateView;
- (void)viewChallenge:(NSInteger)selected_row;
- (void)confirmPurchase;
- (IBAction)okButton_tap:(id)sender;
- (IBAction)cancelButton_tap:(id)sender;
- (IBAction)challengeButton_tap:(id)sender;
@end
