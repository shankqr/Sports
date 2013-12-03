//
//  ChallengeCreateView.h
//  FFC
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//


@interface ChallengeCreateView : UIViewController <UIActionSheetDelegate, UITextViewDelegate>
{
	
	UILabel *titleLabel;
	UITextView *managerNote;
	UIButton *winButton;
	UIButton *loseButton;
	NSString *selected_matchid;
	NSString *win;
	NSString *lose;
	NSString *draw;
	NSArray *matches;
}

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextView *managerNote;
@property (nonatomic, strong) IBOutlet UIButton *winButton;
@property (nonatomic, strong) IBOutlet UIButton *loseButton;
@property (nonatomic, strong) NSString *selected_matchid;
@property (nonatomic, strong) NSString *win;
@property (nonatomic, strong) NSString *lose;
@property (nonatomic, strong) NSString *draw;
@property (nonatomic, strong) NSArray *matches;
- (void)updateView;
- (IBAction)winButton_tap:(id)sender;
- (IBAction)loseButton_tap:(id)sender;
- (IBAction)okButton_tap:(id)sender;
- (IBAction)cancelButton_tap:(id)sender;
@end
