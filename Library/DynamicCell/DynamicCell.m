//
//  DynamicCell.m
//  Kingdom
//
//  Created by Shankar on 10/30/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "DynamicCell.h"
#import "UIColor+Crayola.h"
#import "Globals.h"

#define CELL_CONTENT_MARGIN 10.0f * SCALE_IPAD
#define CELL_CONTENT_Y 3.0f * SCALE_IPAD
#define CELL_CONTENT_SPACING 5.0f * SCALE_IPAD
#define CELL_HEADER_HEIGHT 44.0f * SCALE_IPAD
#define CELL_HEADER_Y 15.0f * SCALE_IPAD
#define CELL_LABEL_HEIGHT 20.0f * SCALE_IPAD
#define CELL_DEFAULT_HEIGHT 22.0f * SCALE_IPAD
#define R1_FONT_SIZE 17.0f * SCALE_IPAD
#define R2_FONT_SIZE 16.0f * SCALE_IPAD
#define R3_FONT_SIZE 14.0f * SCALE_IPAD
#define C1_FONT_SIZE 15.0f * SCALE_IPAD
#define R1_FONT_SMALL_SIZE 13.0f * SCALE_IPAD

@implementation DynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initCode];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted && (self.cellRowData[@"h1"] == nil) && ((self.cellRowData[@"i2"] != nil && ![self.cellRowData[@"i2"] isEqualToString:@""]) || (self.cellRowData[@"select_able"] != nil)))
    {
        [self.selectedImage setHidden:NO];
    }
    else
    {
        [self.selectedImage setHidden:YES];
    }
}

- (void)createTextView
{
    UITextView *ttextv1 = [[UITextView alloc] initWithFrame:CGRectZero];
    [ttextv1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
    ttextv1.returnKeyType = UIReturnKeyDone;
    ttextv1.delegate = self;
    [ttextv1 setTag:7];
    
    [[ttextv1 layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[ttextv1 layer] setBorderWidth:2.0];
    //[[ttextv1 layer] setCornerRadius:15];
    
    [self addSubview:ttextv1];
}

- (void)initCode
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.backgroundImage.contentMode = UIViewContentModeScaleToFill;
    [self.backgroundImage setTag:10];
    [self addSubview:self.backgroundImage];
    
    self.footerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.footerImage.contentMode = UIViewContentModeScaleToFill;
    [self.footerImage setTag:8];
    [self addSubview:self.footerImage];
    
    self.num1_border = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.num1_border.contentMode = UIViewContentModeScaleToFill;
    [self.num1_border setTag:18];
    [self addSubview:self.num1_border];
    
    self.selectedImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.selectedImage.contentMode = UIViewContentModeScaleToFill;
    [self.selectedImage setImage:[UIImage imageNamed:@"skin_selected_cell"]];
    [self.selectedImage setTag:12];
    [self addSubview:self.selectedImage];
    
    self.textf1 = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.textf1 setMinimumFontSize:MINIMUM_FONT_SIZE];
    [self.textf1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
    self.textf1.returnKeyType = UIReturnKeyDone;
    self.textf1.delegate = self;
    [self.textf1 setTag:6];
    self.textf1.borderStyle = UITextBorderStyleBezel;
    self.textf1.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.textf1];
    
    self.row1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.row1 setNumberOfLines:0];
    [self.row1 setFont:[UIFont fontWithName:DEFAULT_FONT size:R1_FONT_SIZE]];
    [self.row1 setBackgroundColor:[UIColor clearColor]];
    self.row1.minimumScaleFactor = 1.0;
    [self.row1 setTag:1];
    [self addSubview:self.row1];
    
    self.row2 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.row2 setNumberOfLines:0];
    [self.row2 setFont:[UIFont fontWithName:DEFAULT_FONT size:R2_FONT_SIZE]];
    [self.row2 setBackgroundColor:[UIColor clearColor]];
    [self.row2 setTextColor:[UIColor crayolaBrownColor]];
    self.row2.minimumScaleFactor = 1.0;
    [self.row2 setTag:2];
    [self addSubview:self.row2];
    
    self.row3 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.row3 setNumberOfLines:0];
    [self.row3 setFont:[UIFont fontWithName:DEFAULT_FONT size:R3_FONT_SIZE]];
    [self.row3 setBackgroundColor:[UIColor clearColor]];
    [self.row3 setTextColor:[UIColor blackColor]];
    self.row3.minimumScaleFactor = 1.0;
    [self.row3 setTag:13];
    [self addSubview:self.row3];
    
    self.col1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.col1 setNumberOfLines:1];
    [self.col1 setFont:[UIFont fontWithName:DEFAULT_FONT size:C1_FONT_SIZE]];
    [self.col1 setBackgroundColor:[UIColor clearColor]];
    self.col1.adjustsFontSizeToFitWidth = YES;
    self.col1.minimumScaleFactor = 0.5;
    self.col1.textAlignment = NSTextAlignmentCenter;
    [self.col1 setTag:3];
    [self addSubview:self.col1];
    
    self.col2 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.col2 setNumberOfLines:1];
    [self.col2 setFont:[UIFont fontWithName:DEFAULT_FONT size:C1_FONT_SIZE]];
    [self.col2 setBackgroundColor:[UIColor clearColor]];
    self.col2.adjustsFontSizeToFitWidth = YES;
    self.col2.minimumScaleFactor = 0.5;
    self.col2.textAlignment = NSTextAlignmentCenter;
    [self.col2 setTag:15];
    [self addSubview:self.col2];
    
    self.num1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.num1 setNumberOfLines:1];
    [self.num1 setFont:[UIFont fontWithName:DEFAULT_FONT size:R1_FONT_SIZE]];
    [self.num1 setBackgroundColor:[UIColor clearColor]];
    self.num1.adjustsFontSizeToFitWidth = YES;
    self.num1.minimumScaleFactor = 0.5;
    self.num1.textAlignment = NSTextAlignmentCenter;
    [self.num1 setTag:11];
    [self addSubview:self.num1];
    
    self.img1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.img1.contentMode = UIViewContentModeScaleToFill;
    [self.img1 setTag:4];
    [self addSubview:self.img1];
    
    self.img1_over = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.img1_over.contentMode = UIViewContentModeScaleToFill;
    [self.img1_over setTag:14];
    [self addSubview:self.img1_over];
    
    self.img2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.img2.contentMode = UIViewContentModeScaleToFill;
    [self.img2 setTag:5];
    [self addSubview:self.img2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)drawCell:(NSDictionary *)rd cellWidth:(float)cell_width
{
    NSMutableDictionary *rowData = [rd mutableCopy];
    
    [self.row1 setNumberOfLines:0];
    [self.row2 setNumberOfLines:0];
    [self.row3 setNumberOfLines:0];
    [self.col1 setNumberOfLines:1];
    [self.col2 setNumberOfLines:1];
    [self.num1 setNumberOfLines:1];
    
    self.cellRowData = rowData;
    self.cellWidth = cell_width;
    
    CGFloat n1_width = 30.0f*SCALE_IPAD;
    CGFloat left_margin = CELL_CONTENT_MARGIN;
    CGFloat r1_length = cell_width - CELL_CONTENT_MARGIN*2;
    CGFloat top_y = CELL_CONTENT_Y;
    CGFloat top_image1_y = 10.0f*SCALE_IPAD;
    CGFloat center_y = CELL_CONTENT_Y;
    CGFloat r1_height = CELL_LABEL_HEIGHT;
    CGFloat r2_height = 0.0f;
    CGFloat r3_height = 0.0f;
    CGFloat i2_width = 0.0f;
    CGFloat i2_height = 0.0f;
    CGFloat r1_font_size = R1_FONT_SIZE;
    
    if (!self.backgroundImage)
    {
        self.backgroundImage = (UIImageView*)[self viewWithTag:10];
    }
    
    if (!self.footerImage)
    {
        self.footerImage = (UIImageView*)[self viewWithTag:8];
    }
    
    if (!self.num1_border)
    {
        self.num1_border = (UIImageView*)[self viewWithTag:18];
    }
    
    if (!self.selectedImage)
    {
        self.selectedImage = (UIImageView*)[self viewWithTag:12];
    }
    
    [self.backgroundImage setFrame:CGRectMake(0, 0, cell_width, CELL_HEADER_HEIGHT)];
    [self.footerImage setImage:nil];
    [self.num1_border setImage:nil];
    [self.selectedImage setFrame:CGRectMake(0, 0, cell_width, CELL_HEADER_HEIGHT)];
    
    CGFloat cell_height = [DynamicCell dynamicCellHeight:rowData cellWidth:cell_width];
    
    if (rowData[@"bkg_prefix"] != nil)
    {
        CGRect bkg_frame = CGRectMake(0, 0, cell_width, cell_height);
        UIImage *bkg_image = [[Globals i] dynamicImage:bkg_frame prefix:rowData[@"bkg_prefix"]];
        
        [self.backgroundImage setImage:bkg_image];
        [self.backgroundImage setFrame:bkg_frame];
    }
    else
    {
        if (rowData[@"bkg"] != nil && ![rowData[@"bkg"] isEqualToString:@""])
        {
            CGRect bkg_frame = CGRectMake(0, 0, cell_width, cell_height);
            UIImage *bkg_image = [UIImage imageNamed:rowData[@"bkg"]];
            
            [self.backgroundImage setImage:bkg_image];
            [self.backgroundImage setFrame:bkg_frame];
        }
        else
        {
            [self.backgroundImage setImage:nil];
            [self.backgroundImage setFrame:CGRectMake(0, 0, cell_width, cell_height)];
        }
    }
    
    if ([rowData[@"nofooter"] isEqualToString:@"1"])
    {
        [self.footerImage setImage:nil];
    }
    else
    {
        [self.footerImage setImage:[UIImage imageNamed:@"skin_footer_cell"]];
        [self.footerImage setFrame:CGRectMake(0, cell_height-1.0*SCALE_IPAD, cell_width, 1.0*SCALE_IPAD)];
    }
    
    [self.selectedImage setFrame:CGRectMake(0, 0, cell_width, cell_height)];
    
    [self.num1 setTextColor:[UIColor blackColor]];
    [self.row1 setTextColor:[UIColor blackColor]];
    [self.col1 setTextColor:[UIColor blackColor]];
    [self.col2 setTextColor:[UIColor blackColor]];
    
    if (rowData[@"h1"] != nil)
    {
        rowData[@"r1"] = rowData[@"h1"];
        
        [self.footerImage setImage:nil];
        
        [self.backgroundImage setImage:[UIImage imageNamed:@"skin_header_cell"]];
        
        top_y = CELL_HEADER_Y;
        center_y = CELL_HEADER_Y;
        
        [self.num1 setTextColor:[UIColor whiteColor]];
        [self.row1 setTextColor:[UIColor whiteColor]];
        [self.col1 setTextColor:[UIColor whiteColor]];
        [self.col2 setTextColor:[UIColor whiteColor]];
        
        [self.row1 setNumberOfLines:1];
        self.row1.adjustsFontSizeToFitWidth = YES;
        self.row1.minimumScaleFactor = 0.5;
    }
    
    if (!self.row1)
    {
        self.row1 = (UILabel*)[self viewWithTag:1];
    }
    if (!self.row1_button)
    {
        self.row1_button = (UIButton*)[self viewWithTag:17];
    }
    if (rowData[@"r1"] != nil)
    {
        [self.row1 setText:rowData[@"r1"]];
    }
    
    if (!self.row2)
    {
        self.row2 = (UILabel*)[self viewWithTag:2];
    }
    if (rowData[@"r2"] != nil)
    {
        [self.row2 setText:rowData[@"r2"]];
    }
    
    if (!self.row3)
    {
        self.row3 = (UILabel*)[self viewWithTag:13];
    }
    if (rowData[@"r3"] != nil)
    {
        [self.row3 setText:rowData[@"r3"]];
    }
    
    if (!self.num1)
    {
        self.num1 = (UILabel*)[self viewWithTag:11];
    }
    
    if (!self.img1)
    {
        self.img1 = (UIImageView*)[self viewWithTag:4];
    }
    
    if (!self.img1_over)
    {
        self.img1_over = (UIImageView*)[self viewWithTag:14];
    }
    
    if (rowData[@"n1_width"] != nil && ![rowData[@"n1_width"] isEqualToString:@""])
    {
        n1_width = [rowData[@"n1_width"] floatValue]*SCALE_IPAD;
        top_image1_y = CELL_CONTENT_Y;
    }
    
    if (rowData[@"i1"] != nil)
    {
        left_margin += n1_width + CELL_CONTENT_SPACING;
        r1_length -= n1_width + CELL_CONTENT_SPACING;
        
        if (![rowData[@"i1"] isEqualToString:@""])
        {
            [self.img1 setImage:[UIImage imageNamed:rowData[@"i1"]]];
        }
        
        if (rowData[@"i1_over"] != nil && ![rowData[@"i1_over"] isEqualToString:@""])
        {
            [self.img1_over setImage:[UIImage imageNamed:rowData[@"i1_over"]]];
        }
    }
    else if (rowData[@"n1"] != nil)
    {
        left_margin += n1_width + CELL_CONTENT_SPACING;
        r1_length -= n1_width + CELL_CONTENT_SPACING;
        
        [self.num1 setText:rowData[@"n1"]];
    }
    
    if (!self.img2)
    {
        self.img2 = (UIImageView*)[self viewWithTag:5];
    }
    if (rowData[@"i2"] != nil)
    {
        i2_width = 10 * SCALE_IPAD;
        i2_height = 20 * SCALE_IPAD;
        
        if (![rowData[@"i2"] isEqualToString:@""])
        {
            UIImage *i2_image = [UIImage imageNamed:rowData[@"i2"]];
            i2_width = i2_image.size.width/2 * SCALE_IPAD;
            i2_height = i2_image.size.height/2 * SCALE_IPAD;
            
            [self.img2 setImage:i2_image];
        }
        
        r1_length -= i2_width - CELL_CONTENT_SPACING;
    }
    
    CGFloat r2_length = r1_length;
    CGFloat col1_length = 0;
    CGFloat col2_length = 0;
    if (!self.col1)
    {
        self.col1 = (UILabel*)[self viewWithTag:3];
    }
    if (!self.col1_button)
    {
        self.col1_button = (UIButton*)[self viewWithTag:16];
    }
    if (!self.col2)
    {
        self.col2 = (UILabel*)[self viewWithTag:15];
    }
    if (rowData[@"c1"] != nil)
    {
        CGFloat c1_ratio = 4;
        
        if (rowData[@"c1_ratio"] != nil && ![rowData[@"c1_ratio"] isEqualToString:@""])
        {
            c1_ratio = [rowData[@"c1_ratio"] floatValue];
            if (c1_ratio < 2 || c1_ratio > 10)
            {
                c1_ratio = 4;
            }
        }
        
        col1_length = r1_length/c1_ratio;
        r1_length -= col1_length - CELL_CONTENT_SPACING;
        col1_length -= CELL_CONTENT_SPACING;
        
        [self.col1 setText:rowData[@"c1"]];
    }
    
    if (rowData[@"c2"] != nil)
    {
        col2_length = col1_length;
        r1_length -= col1_length - CELL_CONTENT_SPACING;
        
        [self.col2 setText:rowData[@"c2"]];
    }
    
    if (rowData[@"t1"] != nil)
    {
        CGFloat t1_height = 36.0f * SCALE_IPAD;
        NSInteger t1_keyboard = [rowData[@"t1_keyboard"] integerValue];
        
        if (rowData[@"t1_height"] != nil)
        {
            [self performSelectorOnMainThread:@selector(createTextView) withObject:nil waitUntilDone:YES];
            
            if (!self.textv1)
            {
                self.textv1 = (UITextView*)[self viewWithTag:7];
            }
            
            t1_height = [rowData[@"t1_height"] floatValue]*SCALE_IPAD;
            [self.textv1 setFrame:CGRectMake(left_margin, CELL_CONTENT_Y, r1_length, t1_height)];
            
            if (t1_keyboard == 4)
            {
                self.textv1.keyboardType = UIKeyboardTypeEmailAddress;
            }
            if (t1_keyboard == 5)
            {
                self.textv1.keyboardType = UIKeyboardTypeNumberPad;
            }
            if (t1_keyboard == 6)
            {
                self.textv1.keyboardType = UIKeyboardTypeNamePhonePad;
            }
        }
        else
        {
            if (!self.textf1)
            {
                self.textf1 = (UITextField*)[self viewWithTag:6];
            }
            
            [self.textf1 setPlaceholder:rowData[@"t1"]];
            [self.textf1 setFrame:CGRectMake(left_margin, CELL_CONTENT_Y, r1_length, t1_height)];
            
            if (t1_keyboard == 4)
            {
                self.textf1.keyboardType = UIKeyboardTypeEmailAddress;
            }
            if (t1_keyboard == 5)
            {
                self.textf1.keyboardType = UIKeyboardTypeNumberPad;
            }
            if (t1_keyboard == 6)
            {
                self.textf1.keyboardType = UIKeyboardTypeNamePhonePad;
            }
        }
    }
    
    r1_height = [DynamicCell textHeight:rowData[@"r1"] lblWidth:r1_length font:self.row1.font];
    
    if ((rowData[@"r1"] != nil) && ![rowData[@"r1"] isEqualToString:@""])
    {
        if (rowData[@"r1_button"] != nil) //r1 is a button instead of label
        {
            if (self.row1_button == nil)
            {
                CGFloat button_width = 150.0f*SCALE_IPAD;
                CGFloat button_height = 35.0f*SCALE_IPAD;
                CGFloat button_x = (cell_width - button_width)/2;
                CGFloat button_y = CELL_CONTENT_MARGIN;
                
                if (rowData[@"c1_button"] != nil) //c1 is a button instead of label
                {
                    button_width = 125.0f*SCALE_IPAD;
                    button_x = CELL_CONTENT_MARGIN;
                }
                
                self.row1_button = [[Globals i] dynamicButtonWithTitle:rowData[@"r1"]
                                                                target:nil
                                                              selector:nil
                                                                 frame:CGRectMake(button_x, button_y, button_width, button_height)
                                                                  type:rowData[@"r1_button"]];
            }
            
            [self.row1_button setTitle:rowData[@"r1"] forState:UIControlStateNormal];
            [self addSubview:self.row1_button];
            
            [self.row1 setFrame:CGRectZero];
        }
        else
        {
            if (self.row1_button != nil)
            {
                [self.row1_button removeFromSuperview];
            }
            
            if ((rowData[@"r1_font"] != nil) && ![rowData[@"r1_font"] isEqualToString:@""])
            {
                r1_font_size = [rowData[@"r1_font"] floatValue]*SCALE_IPAD;
            }
            
            if ((rowData[@"r1_bold"] != nil) && ![rowData[@"r1_bold"] isEqualToString:@""])
            {
                [self.row1 setFont:[UIFont fontWithName:DEFAULT_FONT_BOLD size:r1_font_size]];
            }
            else
            {
                [self.row1 setFont:[UIFont fontWithName:DEFAULT_FONT size:r1_font_size]];
            }
            
            r1_height = [DynamicCell textHeight:rowData[@"r1"] lblWidth:r1_length font:self.row1.font];
            
            if ((rowData[@"r2"] == nil) && (rowData[@"r3"] == nil)) //1 line cell
            {
                if (rowData[@"i1"] != nil) //1 line cell with image on left
                {
                    top_image1_y = CELL_CONTENT_Y;
                    top_y = top_image1_y + ((n1_width/2) - (r1_height/2)); //Center r1
                    center_y = top_y;  //Center n1, c1, c2, i1
                }
            }
            
            [self.row1 setFrame:CGRectMake(left_margin, top_y, r1_length, r1_height)];
            
            if ((rowData[@"r1_center"] != nil) && ![rowData[@"r1_center"] isEqualToString:@""])
            {
                self.row1.textAlignment = NSTextAlignmentCenter;
            }
            else
            {
                self.row1.textAlignment = NSTextAlignmentLeft;
            }
            
            if ((rowData[@"r1_color"] != nil) && ![rowData[@"r1_color"] isEqualToString:@""])
            {
                if ([rowData[@"r1_color"] isEqualToString:@"1"])
                {
                    [self.row1 setTextColor:[UIColor redColor]];
                }
                else if ([rowData[@"r1_color"] isEqualToString:@"2"])
                {
                    [self.row1 setTextColor:[UIColor whiteColor]];
                }
                else
                {
                    [self.row1 setTextColor:[UIColor grayColor]];
                }
            }
            else
            {
                if (rowData[@"h1"] != nil)
                {
                    [self.row1 setTextColor:[UIColor whiteColor]];
                }
                else
                {
                    [self.row1 setTextColor:[UIColor blackColor]];
                }
            }
        }
    }
    else
    {
        if (self.row1_button != nil)
        {
            [self.row1_button removeFromSuperview];
        }
        
        [self.row1 setFrame:CGRectZero];
    }
    
    if ((rowData[@"r2"] != nil) && ![rowData[@"r2"] isEqualToString:@""])
    {
        if (rowData[@"align_top"] == nil)
        {
            r2_length = r1_length;
        }
        
        r2_height = [DynamicCell textHeight:rowData[@"r2"] lblWidth:r2_length font:self.row2.font];
        [self.row2 setFrame:CGRectMake(left_margin, top_y+r1_height, r2_length, r2_height)];
        
        center_y = 14.0f*SCALE_IPAD;
    }
    else
    {
        [self.row2 setFrame:CGRectZero];
    }
    
    if ((rowData[@"r3"] != nil) && ![rowData[@"r3"] isEqualToString:@""])
    {
        r3_height = [DynamicCell textHeight:rowData[@"r3"] lblWidth:r2_length font:self.row3.font];
        [self.row3 setFrame:CGRectMake(left_margin, top_y+r1_height+r2_height, r2_length, r3_height)];
    }
    else
    {
        [self.row3 setFrame:CGRectZero];
    }
    
    if ((rowData[@"n1"] != nil) && ![rowData[@"n1"] isEqualToString:@""])
    {
        if (rowData[@"align_top"] != nil)
        {
            [self.num1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, top_y, n1_width, CELL_LABEL_HEIGHT)];
        }
        else
        {
            [self.num1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, center_y, n1_width, CELL_LABEL_HEIGHT)];
        }
        
        if (rowData[@"h1"] != nil)
        {
            [self.num1 setTextColor:[UIColor whiteColor]];
        }
        else
        {
            [self.num1 setTextColor:[UIColor blackColor]];
        }
        
        if ((rowData[@"r1_bold"] != nil) && ![rowData[@"r1_bold"] isEqualToString:@""])
        {
            [self.num1 setFont:[UIFont fontWithName:DEFAULT_FONT_BOLD size:r1_font_size]];
        }
        else
        {
            [self.num1 setFont:[UIFont fontWithName:DEFAULT_FONT size:r1_font_size]];
        }
        
        if ([rowData[@"border"] isEqualToString:@"1"])
        {
            [self.num1_border setImage:[UIImage imageNamed:@"skin_border_cell"]];
            [self.num1_border setFrame:CGRectMake(CELL_CONTENT_MARGIN+n1_width, 0, 1.0*SCALE_IPAD, cell_height)];
        }
        else
        {
            [self.num1_border setImage:nil];
            [self.num1_border setFrame:CGRectZero];
        }
    }
    else
    {
        [self.num1 setFrame:CGRectZero];
        
        [self.num1_border setImage:nil];
        [self.num1_border setFrame:CGRectZero];
    }
    
    if ((rowData[@"i1"] != nil) && ![rowData[@"i1"] isEqualToString:@""])
    {
        [self.img1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, top_image1_y, n1_width, n1_width)];
        
        if ((rowData[@"i1_over"] != nil) && ![rowData[@"i1_over"] isEqualToString:@""])
        {
            [self.img1_over setFrame:CGRectMake(CELL_CONTENT_MARGIN, top_image1_y, n1_width, n1_width)];
        }
        else
        {
            [self.img1_over setFrame:CGRectZero];
        }
        
        center_y = 14.0f*SCALE_IPAD;
    }
    else
    {
        [self.img1 setFrame:CGRectZero];
        [self.img1_over setFrame:CGRectZero];
    }
    
    if ((rowData[@"c1"] != nil) && ![rowData[@"c1"] isEqualToString:@""])
    {
        if (rowData[@"c1_button"] != nil) //c1 is a button instead of label
        {
            if (self.col1_button == nil)
            {
                CGFloat button_width = col1_length - CELL_CONTENT_SPACING;
                CGFloat button_height = r1_height + r2_height + r3_height;
                CGFloat button_x = left_margin+r1_length + CELL_CONTENT_SPACING;
                CGFloat button_y = top_y;
                
                if (rowData[@"r1_button"] != nil) //r1 is a button instead of label
                {
                    button_width = 125.0f*SCALE_IPAD;
                    button_height = 35.0f*SCALE_IPAD;
                    button_x = button_width + CELL_CONTENT_MARGIN*2;
                    button_y = CELL_CONTENT_MARGIN;
                }
                
                self.col1_button = [[Globals i] dynamicButtonWithTitle:rowData[@"c1"]
                                                                target:nil
                                                              selector:nil
                                                                 frame:CGRectMake(button_x, button_y, button_width, button_height)
                                                                  type:rowData[@"c1_button"]];
            }
            
            [self.col1_button setTitle:rowData[@"c1"] forState:UIControlStateNormal];
            [self addSubview:self.col1_button];
            
            [self.col1 setFrame:CGRectZero];
        }
        else
        {
            if (self.col1_button != nil)
            {
                [self.col1_button removeFromSuperview];
            }
            
            if (rowData[@"align_top"] != nil)
            {
                [self.col1 setFrame:CGRectMake(left_margin+r1_length+CELL_CONTENT_SPACING, top_y, col1_length-CELL_CONTENT_SPACING, CELL_LABEL_HEIGHT)];
            }
            else
            {
                [self.col1 setFrame:CGRectMake(left_margin+r1_length+CELL_CONTENT_SPACING, center_y, col1_length-CELL_CONTENT_SPACING, CELL_LABEL_HEIGHT)];
            }
            
            if (rowData[@"h1"] != nil)
            {
                [self.col1 setBackgroundColor:[UIColor clearColor]];
                [self.col1 setTextColor:[UIColor whiteColor]];
            }
            else
            {
                if ((rowData[@"c1_color"] != nil) && ![rowData[@"c1_color"] isEqualToString:@""])
                {
                    if ([rowData[@"c1_color"] isEqualToString:@"1"])
                    {
                        [self.col1 setTextColor:[UIColor redColor]];
                    }
                    else
                    {
                        [self.col1 setTextColor:[UIColor grayColor]];
                    }
                }
                else
                {
                    [self.col1 setTextColor:[UIColor blackColor]];
                }
            }
        }
    }
    else
    {
        if (self.col1_button != nil)
        {
            [self.col1_button removeFromSuperview];
        }
        
        [self.col1 setFrame:CGRectZero];
    }
    
    if ((rowData[@"c2"] != nil) && ![rowData[@"c2"] isEqualToString:@""])
    {
        if (rowData[@"align_top"] != nil)
        {
            [self.col2 setFrame:CGRectMake(left_margin+r1_length+CELL_CONTENT_SPACING+col1_length, top_y, col2_length-CELL_CONTENT_SPACING, CELL_LABEL_HEIGHT)];
        }
        else
        {
            [self.col2 setFrame:CGRectMake(left_margin+r1_length+CELL_CONTENT_SPACING+col1_length, center_y, col2_length-CELL_CONTENT_SPACING, CELL_LABEL_HEIGHT)];
        }
        
        if (rowData[@"h1"] != nil)
        {
            [self.col2 setBackgroundColor:[UIColor clearColor]];
            [self.col2 setTextColor:[UIColor whiteColor]];
        }
        else
        {
            if ((rowData[@"c1_color"] != nil) && ![rowData[@"c1_color"] isEqualToString:@""])
            {
                if ([rowData[@"c1_color"] isEqualToString:@"1"])
                {
                    [self.col2 setTextColor:[UIColor redColor]];
                }
                else
                {
                    [self.col2 setTextColor:[UIColor grayColor]];
                }
            }
            else
            {
                [self.col2 setTextColor:[UIColor blackColor]];
            }
        }
    }
    else
    {
        [self.col2 setFrame:CGRectZero];
    }
    
    if ((rowData[@"i2"] != nil) && ![rowData[@"i2"] isEqualToString:@""])
    {
        float img2_y = top_image1_y;
        
        if ((rowData[@"i1"] != nil) && (n1_width > (r1_height+r2_height+r3_height)))
        {
            img2_y = top_image1_y + (n1_width)/2 - i2_height/2;
        }
        else
        {
            img2_y = top_y + (r1_height+r2_height+r3_height)/2 - i2_height/2;
        }

        [self.img2 setFrame:CGRectMake(left_margin+r1_length+col1_length+col2_length, img2_y, i2_width, i2_height)];
    }
    else
    {
        [self.img2 setFrame:CGRectZero];
    }
}

#pragma mark - DynamicCell

+ (DynamicCell *)dynamicCell:(UITableView *)tableView rowData:(NSDictionary *)rd cellWidth:(float)cell_width
{
    DynamicCell *cell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
    
    if (cell == nil)
    {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DynamicCell"];
    }
    
    [cell drawCell:rd cellWidth:cell_width];
    
    return cell;
}

+ (CGFloat)textHeight:(NSString *)text lblWidth:(CGFloat)label_width fontSize:(CGFloat)font_size
{
    CGSize constraint = CGSizeMake(label_width, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:DEFAULT_FONT size:font_size] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height, CELL_CONTENT_MARGIN);
}

+ (CGFloat)textHeight:(NSString *)text lblWidth:(CGFloat)label_width font:(UIFont*)font
{
    CGSize constraint = CGSizeMake(label_width, 20000.0f);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height, CELL_CONTENT_MARGIN);
}

+ (CGFloat)dynamicCellHeight:(NSDictionary *)rd cellWidth:(float)cell_width
{
    NSMutableDictionary *rowData = [rd mutableCopy];
    
    CGFloat n1_width = 30.0f*SCALE_IPAD;
    CGFloat cell_height = CELL_CONTENT_MARGIN;
    CGFloat r1_length = cell_width - CELL_CONTENT_MARGIN*2;
    CGFloat r2_length = 0.0f;
    CGFloat col1_length = 0.0f;
    CGFloat i2_width = 0.0f;
    CGFloat r1_font_size = R1_FONT_SIZE;
    CGFloat t1_height = 36.0f*SCALE_IPAD;
    
    if (rowData[@"n1_width"] != nil && ![rowData[@"n1_width"] isEqualToString:@""])
    {
        n1_width = [rowData[@"n1_width"] floatValue]*SCALE_IPAD;
    }
    
    if (rowData[@"i1"] != nil)
    {
        r1_length -= n1_width + CELL_CONTENT_SPACING;
    }
    else if (rowData[@"n1"] != nil)
    {
        r1_length -= n1_width + CELL_CONTENT_SPACING;
    }
    
    if (rowData[@"i2"] != nil)
    {
        i2_width = 10 * SCALE_IPAD;
        
        if (![rowData[@"i2"] isEqualToString:@""])
        {
            UIImage *i2_image = [UIImage imageNamed:rowData[@"i2"]];
            i2_width = i2_image.size.width/2 * SCALE_IPAD;
        }
        
        r1_length -= i2_width - CELL_CONTENT_SPACING;
    }
    
    r2_length = r1_length;
    
    if (rowData[@"c1"] != nil)
    {
        CGFloat c1_ratio = 4;
        if (rowData[@"c1_ratio"] != nil)
        {
            c1_ratio = [rowData[@"c1_ratio"] floatValue];
            if (c1_ratio < 2 || c1_ratio > 10)
            {
                c1_ratio = 4;
            }
        }
        col1_length = r1_length/c1_ratio;
        r1_length -= col1_length - CELL_CONTENT_SPACING;
        col1_length -= CELL_CONTENT_SPACING;
    }
    
    if (rowData[@"c2"] != nil)
    {
        r1_length -= col1_length - CELL_CONTENT_SPACING;
    }
    
    if (rowData[@"align_top"] == nil)
    {
        r2_length = r1_length;
    }
    
    if (rowData[@"h1"] != nil)
    {
        cell_height = CELL_HEADER_HEIGHT;
    }
    else
    {
        if ((rowData[@"r1"] != nil) && ![rowData[@"r1"] isEqualToString:@""])
        {
            if (rowData[@"r1_button"] != nil) //r1 is a button instead of label
            {
                cell_height += 35.0f*SCALE_IPAD + CELL_CONTENT_MARGIN;
            }
            else
            {
                if ((rowData[@"r1_font"] != nil) && ![rowData[@"r1_font"] isEqualToString:@""])
                {
                    r1_font_size = [rowData[@"r1_font"] floatValue]*SCALE_IPAD;
                }
                
                UIFont *r1font = [UIFont fontWithName:DEFAULT_FONT size:r1_font_size];
                
                if ((rowData[@"r1_bold"] != nil) && ![rowData[@"r1_bold"] isEqualToString:@""])
                {
                    r1font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:r1_font_size];
                }
                
                cell_height += [self textHeight:rowData[@"r1"] lblWidth:r1_length font:r1font];
            }
        }
        
        if ((rowData[@"r2"] != nil) && ![rowData[@"r2"] isEqualToString:@""])
        {
            cell_height += [self textHeight:rowData[@"r2"] lblWidth:r2_length fontSize:R2_FONT_SIZE];
        }
        
        if ((rowData[@"r3"] != nil) && ![rowData[@"r3"] isEqualToString:@""])
        {
            cell_height += [self textHeight:rowData[@"r3"] lblWidth:r2_length fontSize:R3_FONT_SIZE];
        }
        
        if ((rowData[@"i1"] != nil) && ![rowData[@"i1"] isEqualToString:@""])
        {
            if (n1_width >= cell_height-CELL_CONTENT_MARGIN)
            {
                cell_height = n1_width;
                cell_height += CELL_CONTENT_SPACING;
            }
        }
        
        if (rowData[@"t1"] != nil)
        {
            if (rowData[@"t1_height"] != nil)
            {
                t1_height = [rowData[@"t1_height"] floatValue]*SCALE_IPAD;
                cell_height += t1_height;
            }
            else
            {
                cell_height += t1_height;
            }
        }
    }
    
    return cell_height;
}

@end
