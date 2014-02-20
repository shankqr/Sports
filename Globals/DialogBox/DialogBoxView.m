//
//  DialogBoxView.m
//  Kingdom Game
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "DialogBoxView.h"

@implementation DialogBoxView

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
    if ((self.dialogType == 4) || (self.dialogType == 5) || (self.dialogType == 6))
    {
        if([self.inputText.text isEqualToString:@""])
        {
            
        }
        else if ([[self.inputText.text substringWithRange:NSMakeRange(0,1)] isEqualToString:@" "])
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
            self.titleLabel.text = @"";
            self.whiteLabel.text = @"";
            self.promptLabel.text = @"";
            
            [self.view removeFromSuperview];
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(returnText:)])
            {
                [self.delegate returnText:self.inputText.text];
            }
            
            if (self.dialogBlock != nil)
            {
                self.dialogBlock(1, self.inputText.text);
            }
        }
    }
    else
    {
        [self.view removeFromSuperview];
        
        [self.delegate returnDialog:self.view.tag];
        
        if (self.dialogBlock != nil)
        {
            self.dialogBlock(1, @"");
        }
    }
}

- (void)updateView
{
	self.titleLabel.text = self.titleText;
    self.whiteLabel.text = self.whiteText;
	self.promptLabel.text = self.promptText;
    
    if (self.dialogType == 0)
    {
        [self setup0];
    }
    
    if (self.dialogType == 1)
    {
        [self setup1];
    }
    
    if (self.dialogType == 2)
    {
        [self setup2];
    }
    
    if (self.dialogType == 4)
    {
        self.inputText.keyboardType = UIKeyboardTypeEmailAddress;
        [self setupInput];
    }
    
    if (self.dialogType == 5)
    {
        self.inputText.keyboardType = UIKeyboardTypeNumberPad;
        [self setupInput];
    }
    
    if (self.dialogType == 6)
    {
        self.inputText.keyboardType = UIKeyboardTypeNamePhonePad;
        [self setupInput];
    }
	
	[self.view setNeedsDisplay];
}

- (void)setup0
{
    [self.promptLabel setHidden:YES];
    [self.noButton setHidden:YES];
    [self.titleLabel setHidden:NO];
    [self.whiteLabel setHidden:NO];
    [self.inputText setHidden:YES];
    [self.yesButton setHidden:YES];
    [self.closeButton setHidden:YES];
}

- (void)setup1 //OK
{
    [self.titleLabel setHidden:NO];
    [self.whiteLabel setHidden:NO];
    [self.promptLabel setHidden:NO];
    [self.inputText setHidden:YES];
    [self.yesButton setHidden:YES];
    [self.noButton setHidden:NO];
    [self.closeButton setHidden:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect buttonRect = CGRectMake(294, 570, 180, 90);
        self.noButton.frame = buttonRect;
        [self.noButton setImage:[UIImage imageNamed:@"button_ok.png"] forState:UIControlStateNormal];
	}
    else
    {
        CGRect buttonRect = CGRectMake(115, 256, 90, 45);
        self.noButton.frame = buttonRect;
        [self.noButton setImage:[UIImage imageNamed:@"button_ok.png"] forState:UIControlStateNormal];
    }
}

- (void)setup2 //YES NO
{
    [self.titleLabel setHidden:NO];
    [self.whiteLabel setHidden:NO];
    [self.promptLabel setHidden:NO];
    [self.inputText setHidden:YES];
    [self.yesButton setHidden:NO];
    [self.noButton setHidden:NO];
    [self.closeButton setHidden:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect buttonRect = CGRectMake(166, 570, 180, 90);
        self.yesButton.frame = buttonRect;
        [self.yesButton setImage:[UIImage imageNamed:@"button_yes.png"] forState:UIControlStateNormal];
        
        buttonRect = CGRectMake(422, 570, 180, 90);
        self.noButton.frame = buttonRect;
        [self.noButton setImage:[UIImage imageNamed:@"button_no.png"] forState:UIControlStateNormal];
    }
    else
    {
        CGRect buttonRect = CGRectMake(50, 256, 90, 45);
        self.yesButton.frame = buttonRect;
        [self.yesButton setImage:[UIImage imageNamed:@"button_yes.png"] forState:UIControlStateNormal];
        
        buttonRect = CGRectMake(180, 256, 90, 45);
        self.noButton.frame = buttonRect;
        [self.noButton setImage:[UIImage imageNamed:@"button_no.png"] forState:UIControlStateNormal];
    }
}

- (void)setupInput
{
    [self.promptLabel setHidden:YES];
    [self.noButton setHidden:YES];
    
    [self.titleLabel setHidden:YES];
    [self.whiteLabel setHidden:NO];
    [self.inputText setHidden:NO];
    [self.yesButton setHidden:NO];
    [self.closeButton setHidden:NO];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect buttonRect = CGRectMake(294, 570, 180, 90);
        self.yesButton.frame = buttonRect;
        [self.yesButton setImage:[UIImage imageNamed:@"button_ok.png"] forState:UIControlStateNormal];
	}
    else
    {
        CGRect buttonRect = CGRectMake(115, 240, 90, 45);
        self.yesButton.frame = buttonRect;
        [self.yesButton setImage:[UIImage imageNamed:@"button_ok.png"] forState:UIControlStateNormal];
    }
    
    self.inputText.delegate = self;
	[self.inputText becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	[self.inputText resignFirstResponder];
	
	return YES;
}

@end
