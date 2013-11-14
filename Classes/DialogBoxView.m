//
//  DialogBoxView.m
//  Tiny Kingdom
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


- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (IBAction)closeButton_tap:(id)sender
{
	[self.view removeFromSuperview];
}

- (IBAction)okButton_tap:(id)sender
{
    if ((dialogType == 4) || (dialogType == 5) || (dialogType == 6))
    {
        if([inputText.text isEqualToString:@""])
        {
            
        }
        else if ([[inputText.text substringWithRange:NSMakeRange(0,1)] isEqualToString:@" "])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:GAME_NAME
                                  message:@"Blank spaces at the begining is not allowed"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(returnText:)])
        {
            [delegate returnText:inputText.text];
        }
    }
    else
    {
        [delegate returnDialog:self.view.tag];
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
    
    if (dialogType == 3)
    {
        [self setup3];
    }
    
    if (dialogType == 4) 
    {
        keyboardType = 6;
        [self setupInput];
    }
    
    if (dialogType == 5)
    {
        keyboardType = 4;
        [self setupInput];
    }
    
    if (dialogType == 6)
    {
        keyboardType = 3;
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

- (void)setup1
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
        [noButton setImage:[UIImage imageNamed:@"button_ok1.png"] forState:UIControlStateNormal];
	}
    else
    {
        CGRect buttonRect = CGRectMake(115, 280, 90, 45);
        noButton.frame = buttonRect;
        [noButton setImage:[UIImage imageNamed:@"button_ok1.png"] forState:UIControlStateNormal];
    }
}

- (void)setup2
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

- (void)setup3
{
    [titleLabel setHidden:NO];
    [whiteLabel setHidden:NO];
    [promptLabel setHidden:NO];
    [inputText setHidden:YES];
    [yesButton setHidden:NO];
    [noButton setHidden:YES];
    [closeButton setHidden:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect buttonRect = CGRectMake(294, 768, 180, 90);
        yesButton.frame = buttonRect;
        [yesButton setImage:[UIImage imageNamed:@"button_ok1.png"] forState:UIControlStateNormal];
	}
    else
    {
        CGRect buttonRect = CGRectMake(115, 280, 90, 45);
        yesButton.frame = buttonRect;
        [yesButton setImage:[UIImage imageNamed:@"button_ok1.png"] forState:UIControlStateNormal];
    }
}

- (void)setupInput
{
    [promptLabel setHidden:YES];
    [noButton setHidden:YES];
    
    [titleLabel setHidden:NO];
    [whiteLabel setHidden:NO];
    [inputText setHidden:NO];
    [yesButton setHidden:NO];
    [closeButton setHidden:NO];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect buttonRect = CGRectMake(294, 650, 180, 90);
        yesButton.frame = buttonRect;
        [yesButton setImage:[UIImage imageNamed:@"button_ok1.png"] forState:UIControlStateNormal];
	}
    else
    {
        CGRect buttonRect = CGRectMake(115, 205, 90, 45);
        yesButton.frame = buttonRect;
        [yesButton setImage:[UIImage imageNamed:@"button_ok1.png"] forState:UIControlStateNormal];
    }
    
    inputText.delegate = self;
	
	if(keyboardType == 1)
	{
		inputText.keyboardType = UIKeyboardTypeASCIICapable;
	}
	if(keyboardType == 2)
	{
		inputText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	}
	if(keyboardType == 3)
	{
		inputText.keyboardType = UIKeyboardTypeURL;
	}
	if(keyboardType == 4)
	{
		inputText.keyboardType = UIKeyboardTypeNumberPad;
	}
	if(keyboardType == 5)
	{
		inputText.keyboardType = UIKeyboardTypePhonePad;
	}
	if(keyboardType == 6)
	{
		inputText.keyboardType = UIKeyboardTypeNamePhonePad;
	}
	if(keyboardType == 7)
	{
		inputText.keyboardType = UIKeyboardTypeEmailAddress;
	}
	
	[inputText becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	if([inputText.text isEqualToString:@""])
	{
		
	}
	else if ([[inputText.text substringWithRange:NSMakeRange(0,1)] isEqualToString:@" "])
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:GAME_NAME
							  message:@"Blank spaces at the begining is not allowed"
							  delegate:self
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(returnText:)])
	{
		[delegate returnText:inputText.text];
	}
	
	return YES;
}

@end
