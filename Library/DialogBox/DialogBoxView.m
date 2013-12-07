//
//  DialogBoxView.m
//  Kingdom Game
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "DialogBoxView.h"

@implementation DialogBoxView
@synthesize delegate;
@synthesize inputText;
@synthesize titleLabel;
@synthesize promptLabel;
@synthesize whiteLabel;
@synthesize titleText;
@synthesize whiteText;
@synthesize promptText;
@synthesize keyboardType;
@synthesize dialogType;
@synthesize closeButton;
@synthesize yesButton;
@synthesize noButton;

- (IBAction)closeButton_tap:(id)sender
{
    if (self.dialogBlock != nil)
    {
        self.dialogBlock(0, @"");
    }
    
	[self.view removeFromSuperview];
}

- (IBAction)okButton_tap:(id)sender
{
    [self done];
}

- (void)done
{
    if ((dialogType == 4) || (dialogType == 5) || (dialogType == 6))
    {
        if([inputText.text isEqualToString:@""])
        {
            
        }
        else if ([[inputText.text substringWithRange:NSMakeRange(0,1)] isEqualToString:@" "])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Input"
                                  message:@"Blank spaces at the begining is not allowed"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            titleLabel.text = @"";
            whiteLabel.text = @"";
            promptLabel.text = @"";
            
            [self.view removeFromSuperview];
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(returnText:)])
            {
                [delegate returnText:inputText.text];
            }
            
            if (self.dialogBlock != nil)
            {
                self.dialogBlock(1, inputText.text);
            }
        }
    }
    else
    {
        [self.view removeFromSuperview];
        
        [delegate returnDialog:self.view.tag];
        
        if (self.dialogBlock != nil)
        {
            self.dialogBlock(1, @"");
        }
    }
}

- (void)updateView
{
	titleLabel.text = titleText;
    whiteLabel.text = whiteText;
	promptLabel.text = promptText;
    
    if (dialogType == 0)
    {
        [self setup0];
    }
    
    if (dialogType == 1) 
    {
        [self setup1];
    }
    
    if (dialogType == 2) 
    {
        [self setup2];
    }
    
    if (dialogType == 4)
    {
        inputText.keyboardType = UIKeyboardTypeEmailAddress;
        [self setupInput];
    }
    
    if (dialogType == 5)
    {
        inputText.keyboardType = UIKeyboardTypeNumberPad;
        [self setupInput];
    }
    
    if (dialogType == 6)
    {
        inputText.keyboardType = UIKeyboardTypeNamePhonePad;
        [self setupInput];
    }
	
	[self.view setNeedsDisplay];
}

- (void)setup0
{
    [promptLabel setHidden:YES];
    [noButton setHidden:YES];
    [titleLabel setHidden:NO];
    [whiteLabel setHidden:NO];
    [inputText setHidden:YES];
    [yesButton setHidden:YES];
    [closeButton setHidden:YES];
}

- (void)setup1 //OK
{
    [titleLabel setHidden:NO];
    [whiteLabel setHidden:NO];
    [promptLabel setHidden:NO];
    [inputText setHidden:YES];
    [yesButton setHidden:YES];
    [noButton setHidden:NO];
    [closeButton setHidden:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect buttonRect = CGRectMake(294, 768, 180, 90);
        noButton.frame = buttonRect;
        [noButton setImage:[UIImage imageNamed:@"button_ok.png"] forState:UIControlStateNormal];
	}
    else
    {
        CGRect buttonRect = CGRectMake(115, 280, 90, 45);
        noButton.frame = buttonRect;
        [noButton setImage:[UIImage imageNamed:@"button_ok.png"] forState:UIControlStateNormal];
    }
}

- (void)setup2 //YES NO
{
    [titleLabel setHidden:NO];
    [whiteLabel setHidden:NO];
    [promptLabel setHidden:NO];
    [inputText setHidden:YES];
    [yesButton setHidden:NO];
    [noButton setHidden:NO];
    [closeButton setHidden:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect buttonRect = CGRectMake(166, 768, 180, 90);
        yesButton.frame = buttonRect;
        [yesButton setImage:[UIImage imageNamed:@"button_yes.png"] forState:UIControlStateNormal];
        
        buttonRect = CGRectMake(422, 768, 180, 90);
        noButton.frame = buttonRect;
        [noButton setImage:[UIImage imageNamed:@"button_no.png"] forState:UIControlStateNormal];
    }
    else
    {
        CGRect buttonRect = CGRectMake(50, 280, 90, 45);
        yesButton.frame = buttonRect;
        [yesButton setImage:[UIImage imageNamed:@"button_yes.png"] forState:UIControlStateNormal];
        
        buttonRect = CGRectMake(180, 280, 90, 45);
        noButton.frame = buttonRect;
        [noButton setImage:[UIImage imageNamed:@"button_no.png"] forState:UIControlStateNormal];
    }
}

- (void)setupInput
{
    [promptLabel setHidden:YES];
    [noButton setHidden:YES];
    
    [titleLabel setHidden:YES];
    [whiteLabel setHidden:NO];
    [inputText setHidden:NO];
    [yesButton setHidden:NO];
    [closeButton setHidden:NO];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect buttonRect = CGRectMake(294, 768, 180, 90);
        yesButton.frame = buttonRect;
        [yesButton setImage:[UIImage imageNamed:@"button_ok.png"] forState:UIControlStateNormal];
	}
    else
    {
        CGRect buttonRect = CGRectMake(115, 260, 90, 45);
        yesButton.frame = buttonRect;
        [yesButton setImage:[UIImage imageNamed:@"button_ok.png"] forState:UIControlStateNormal];
    }
    
    inputText.delegate = self;
	[inputText becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	[self.inputText resignFirstResponder];
	
	return YES;
}

@end
