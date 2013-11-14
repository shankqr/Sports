//
//  DialogBoxView.h
//  Kingdom Game
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@protocol DialogBoxDelegate2 <NSObject>
@optional
- (void)returnText:(NSString *)text;
- (void)returnDialog:(NSInteger)tag;
@end

typedef void (^DialogBlock)(NSInteger index, NSString *text);

@interface DialogBoxView2 : UIViewController <UITextFieldDelegate>
{
	id<DialogBoxDelegate2> __weak delegate;
	UITextField *inputText;
	UILabel *titleLabel;
    UILabel *whiteLabel;
	UILabel *promptLabel;
    UIButton *closeButton;
    UIButton *yesButton;
    UIButton *noButton;
	NSString *titleText;
    NSString *whiteText;
	NSString *promptText;
	NSInteger verticalOffset;
	NSInteger keyboardType;
    NSInteger dialogType;
}
@property (weak) id<DialogBoxDelegate2> delegate;
@property (nonatomic, strong) DialogBlock dialogBlock;
@property (nonatomic, strong) IBOutlet UITextField *inputText;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *whiteLabel;
@property (nonatomic, strong) IBOutlet UILabel *promptLabel;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) IBOutlet UIButton *yesButton;
@property (nonatomic, strong) IBOutlet UIButton *noButton;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *whiteText;
@property (nonatomic, strong) NSString *promptText;
@property (readwrite) NSInteger keyboardType;
@property (readwrite) NSInteger dialogType;
- (void)updateView;
- (void)setup0;
- (void)setup1;
- (void)setup2;
- (void)setup3;
- (void)setupInput;
- (IBAction)closeButton_tap:(id)sender;
- (IBAction)okButton_tap:(id)sender;
@end
