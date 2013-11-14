//
//  DynamicCell.m
//  Kingdom
//
//  Created by Shankar on 10/30/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "DynamicCell.h"
#import "Globals.h"

@implementation DynamicCell
@synthesize cellRowData;
@synthesize backgroundImage;
@synthesize footerImage;
@synthesize selectedImage;
@synthesize textf1;
@synthesize textv1;
@synthesize header1;
@synthesize row1;
@synthesize row2;
@synthesize row3;
@synthesize col1;
@synthesize num1;
@synthesize img1;
@synthesize img2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // Initialization code
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
    
    if (highlighted && (cellRowData[@"h1"] == nil) && ((cellRowData[@"i2"] != nil) || (cellRowData[@"select_able"] != nil)) )
    {
        [selectedImage setHidden:NO];
    }
    else
    {
        [selectedImage setHidden:YES];
    }
}

- (void)createTextView
{
    UITextView *ttextv1 = [[UITextView alloc] initWithFrame:CGRectZero];
    [ttextv1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
    ttextv1.returnKeyType = UIReturnKeyDone;
    ttextv1.delegate = self;
    [ttextv1 setTag:7];
    [self addSubview:ttextv1];
}

- (void)initCode
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    backgroundImage.contentMode = UIViewContentModeScaleToFill;
    [backgroundImage setTag:10];
    [self addSubview:backgroundImage];
    
    footerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    footerImage.contentMode = UIViewContentModeScaleToFill;
    [footerImage setTag:8];
    [self addSubview:footerImage];
    
    selectedImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    selectedImage.contentMode = UIViewContentModeScaleToFill;
    [selectedImage setImage:[UIImage imageNamed:@"skin_selected_cell"]];
    [selectedImage setTag:12];
    [self addSubview:selectedImage];
    
    textf1 = [[UITextField alloc] initWithFrame:CGRectZero];
    [textf1 setMinimumFontSize:MINIMUM_FONT_SIZE];
    [textf1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
    textf1.returnKeyType = UIReturnKeyDone;
    textf1.delegate = self;
    [textf1 setTag:6];
    [self addSubview:textf1];
    
    header1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [header1 setNumberOfLines:1];
    [header1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
    [header1 setBackgroundColor:[UIColor clearColor]];
    [header1 setTextColor:[UIColor whiteColor]];
    header1.adjustsFontSizeToFitWidth = YES;
    header1.minimumScaleFactor = 0.5;
    [header1 setTag:9];
    [self addSubview:header1];
    
    row1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [row1 setNumberOfLines:0];
    [row1 setFont:[UIFont fontWithName:DEFAULT_FONT size:R1_FONT_SIZE]];
    [row1 setBackgroundColor:[UIColor clearColor]];
    [row1 setTag:1];
    [self addSubview:row1];
    
    row2 = [[UILabel alloc] initWithFrame:CGRectZero];
    [row2 setNumberOfLines:0];
    [row2 setFont:[UIFont fontWithName:DEFAULT_FONT size:R2_FONT_SIZE]];
    [row2 setBackgroundColor:[UIColor clearColor]];
    [row2 setTextColor:[UIColor crayolaBrownColor]];
    [row2 setTag:2];
    [self addSubview:row2];
    
    row3 = [[UILabel alloc] initWithFrame:CGRectZero];
    [row3 setNumberOfLines:0];
    [row3 setFont:[UIFont fontWithName:DEFAULT_FONT size:R3_FONT_SIZE]];
    [row3 setBackgroundColor:[UIColor clearColor]];
    [row3 setTextColor:[UIColor blackColor]];
    [row3 setTag:13];
    [self addSubview:row3];
    
    col1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [col1 setNumberOfLines:1];
    [col1 setFont:[UIFont fontWithName:DEFAULT_FONT size:C1_FONT_SIZE]];
    [col1 setBackgroundColor:[UIColor clearColor]];
    col1.adjustsFontSizeToFitWidth = YES;
    col1.minimumScaleFactor = 0.5;
    col1.textAlignment = NSTextAlignmentCenter;
    [col1 setTag:3];
    [self addSubview:col1];
    
    num1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [num1 setNumberOfLines:1];
    [num1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
    [num1 setBackgroundColor:[UIColor clearColor]];
    num1.adjustsFontSizeToFitWidth = YES;
    num1.minimumScaleFactor = 0.5;
    num1.textAlignment = NSTextAlignmentCenter;
    [num1 setTag:11];
    [self addSubview:num1];
    
    img1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    img1.contentMode = UIViewContentModeScaleToFill;
    [img1 setTag:4];
    [self addSubview:img1];
    
    img2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    img2.contentMode = UIViewContentModeScaleToFill;
    [img2 setTag:5];
    [self addSubview:img2];
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

- (void)drawCell:(NSDictionary *)rowData cellWidth:(float)cell_width
{
    self.cellRowData = rowData;
    cellWidth = cell_width;
    
    CGFloat left_margin = CELL_CONTENT_MARGIN;
    CGFloat r1_length = cell_width - CELL_CONTENT_MARGIN*2;
    CGFloat top_y = CELL_CONTENT_Y;
    CGFloat center_y = CELL_CONTENT_Y;
    CGFloat r1_height = CELL_LABEL_HEIGHT;
    CGFloat r2_height = CELL_LABEL_HEIGHT;
    
    if (!backgroundImage)
    {
        backgroundImage = (UIImageView*)[self viewWithTag:10];
    }
    
    if (!footerImage)
    {
        footerImage = (UIImageView*)[self viewWithTag:8];
    }
    
    if (!selectedImage)
    {
        selectedImage = (UIImageView*)[self viewWithTag:12];
    }
    
    if (!header1)
    {
        header1 = (UILabel*)[self viewWithTag:9];
    }
    
    [backgroundImage setFrame:CGRectMake(0, 0, cell_width, CELL_HEADER_HEIGHT)];
    [footerImage setImage:nil];
    [selectedImage setFrame:CGRectMake(0, 0, cell_width, CELL_HEADER_HEIGHT)];
    
    if (rowData[@"h1"] != nil && ![rowData[@"h1"] isEqualToString:@""])
    {
        [backgroundImage setImage:[UIImage imageNamed:@"skin_header_cell"]];
        
        [header1 setText:rowData[@"h1"]];
        [header1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_HEADER_Y, r1_length, CELL_LABEL_HEIGHT)];
    }
    else
    {
        if ([rowData[@"h1"] isEqualToString:@""])
        {
            [backgroundImage setImage:[UIImage imageNamed:@"skin_header_cell"]];
            
            top_y = CELL_HEADER_Y;
            center_y = CELL_HEADER_Y;
            
            [num1 setTextColor:[UIColor whiteColor]];
            [row1 setTextColor:[UIColor whiteColor]];
            [col1 setTextColor:[UIColor whiteColor]];
            
            [row1 setNumberOfLines:1];
            row1.adjustsFontSizeToFitWidth = YES;
            row1.minimumScaleFactor = 0.5;
        }
        else
        {
            CGFloat cell_height = [[Globals i] dynamicCellHeight:rowData cellWidth:cell_width];
            
            //[backgroundImage setImage:[UIImage imageNamed:@"skin_content_cell"]];
            [backgroundImage setImage:nil];
            [backgroundImage setFrame:CGRectMake(0, 0, cell_width, cell_height)];
            
            [footerImage setImage:[UIImage imageNamed:@"skin_footer_cell"]];
            [footerImage setFrame:CGRectMake(0, cell_height-1, cell_width, 1)];
            
            [selectedImage setFrame:CGRectMake(0, 0, cell_width, cell_height)];
            
            [num1 setTextColor:[UIColor blackColor]];
            [row1 setTextColor:[UIColor blackColor]];
            [col1 setTextColor:[UIColor blackColor]];
        }
        
        [header1 setFrame:CGRectZero];
    }
    
    if (!row1)
    {
        row1 = (UILabel*)[self viewWithTag:1];
    }
    if (rowData[@"r1"] != nil)
    {
        [row1 setText:rowData[@"r1"]];
    }
    
    if (!row2)
    {
        row2 = (UILabel*)[self viewWithTag:2];
    }
    if (rowData[@"r2"] != nil)
    {
        [row2 setText:rowData[@"r2"]];
    }
    
    if (!row3)
    {
        row3 = (UILabel*)[self viewWithTag:13];
    }
    if (rowData[@"r3"] != nil)
    {
        [row3 setText:rowData[@"r3"]];
    }
    
    if (!num1)
    {
        num1 = (UILabel*)[self viewWithTag:11];
    }
    
    if (!img1)
    {
        img1 = (UIImageView*)[self viewWithTag:4];
    }
    
    if (rowData[@"i1"] != nil)
    {
        left_margin += CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
        r1_length -= CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
        
        [img1 setImage:[UIImage imageNamed:rowData[@"i1"]]];
    }
    else if (rowData[@"n1"] != nil)
    {
        left_margin += CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
        r1_length -= CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
        
        [num1 setText:rowData[@"n1"]];
    }
    
    if (!img2)
    {
        img2 = (UIImageView*)[self viewWithTag:5];
    }
    if (rowData[@"i2"] != nil)
    {
        r1_length -= CELL_IMAGE2_WIDTH - CELL_CONTENT_SPACING;
        [img2 setImage:[UIImage imageNamed:rowData[@"i2"]]];
    }
    
    CGFloat r2_length = r1_length;
    CGFloat col1_length = 0;
    if (!col1)
    {
        col1 = (UILabel*)[self viewWithTag:3];
    }
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
        [col1 setText:rowData[@"c1"]];
    }
    
    if (rowData[@"t1"] != nil)
    {
        CGFloat t1_height = 21.0f * SCALE_IPAD;
        
        if (rowData[@"t1_height"] != nil)
        {
            [self performSelectorOnMainThread:@selector(createTextView) withObject:nil waitUntilDone:YES];
            
            if (!textv1)
            {
                textv1 = (UITextView*)[self viewWithTag:7];
            }
            
            t1_height = [rowData[@"t1_height"] floatValue] * SCALE_IPAD;
            [textv1 setFrame:CGRectMake(left_margin, CELL_CONTENT_Y, r1_length, t1_height)];
        }
        else
        {
            if (!textf1)
            {
                textf1 = (UITextField*)[self viewWithTag:6];
            }
            
            [textf1 setPlaceholder:rowData[@"t1"]];
            [textf1 setFrame:CGRectMake(left_margin, CELL_CONTENT_Y, r1_length, t1_height)];
        }
    }
    
    r1_height = [[Globals i] textHeight:rowData[@"r1"] lblWidth:r1_length fontSize:R1_FONT_SIZE];
    
    if ((rowData[@"r1"] != nil) && ![rowData[@"r1"] isEqualToString:@""])
    {
        [row1 setFrame:CGRectMake(left_margin, top_y, r1_length, r1_height)];
        
        if ((rowData[@"r1_center"] != nil) && ![rowData[@"r1_center"] isEqualToString:@""])
        {
            row1.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            row1.textAlignment = NSTextAlignmentLeft;
        }
        
        if ((rowData[@"r1_color"] != nil) && ![rowData[@"r1_color"] isEqualToString:@""])
        {
            if ([rowData[@"r1_color"] isEqualToString:@"1"])
            {
                [row1 setTextColor:[UIColor redColor]];
            }
            else
            {
                [row1 setTextColor:[UIColor grayColor]];
            }
        }
        else
        {
            if (rowData[@"h1"] != nil)
            {
                [row1 setTextColor:[UIColor whiteColor]];
            }
            else
            {
                [row1 setTextColor:[UIColor blackColor]];
            }
        }
    }
    else
    {
        [row1 setFrame:CGRectZero];
    }
    
    if ((rowData[@"r2"] != nil) && ![rowData[@"r2"] isEqualToString:@""])
    {
        if (rowData[@"align_top"] == nil)
        {
            r2_length = r1_length;
        }
        
        r2_height = [[Globals i] textHeight:rowData[@"r2"] lblWidth:r2_length fontSize:R2_FONT_SIZE];
        [row2 setFrame:CGRectMake(left_margin, top_y+r1_height, r2_length, r2_height)];
        
        center_y = 14.0f * SCALE_IPAD;
    }
    else
    {
        [row2 setFrame:CGRectZero];
    }
    
    if ((rowData[@"r3"] != nil) && ![rowData[@"r3"] isEqualToString:@""])
    {
        CGFloat r3_height = [[Globals i] textHeight:rowData[@"r3"] lblWidth:r2_length fontSize:R3_FONT_SIZE];
        [row3 setFrame:CGRectMake(left_margin, top_y+r1_height+r2_height, r2_length, r3_height)];
    }
    else
    {
        [row3 setFrame:CGRectZero];
    }
    
    if ((rowData[@"n1"] != nil) && ![rowData[@"n1"] isEqualToString:@""])
    {
        if (rowData[@"align_top"] != nil)
        {
            [num1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, top_y, CELL_IMAGE1_SIZE, CELL_LABEL_HEIGHT)];
        }
        else
        {
            [num1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, center_y, CELL_IMAGE1_SIZE, CELL_LABEL_HEIGHT)];
        }
        
        if (rowData[@"h1"] != nil)
        {
            [num1 setTextColor:[UIColor whiteColor]];
        }
        else
        {
            [num1 setTextColor:[UIColor blackColor]];
        }
    }
    else
    {
        [num1 setFrame:CGRectZero];
    }
    
    if ((rowData[@"i1"] != nil) && ![rowData[@"i1"] isEqualToString:@""])
    {
        [img1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, 10.0f * SCALE_IPAD, CELL_IMAGE1_SIZE, CELL_IMAGE1_SIZE)];
        
        center_y = 14.0f * SCALE_IPAD;
    }
    else
    {
        [img1 setFrame:CGRectZero];
    }
    
    if ((rowData[@"c1"] != nil) && ![rowData[@"c1"] isEqualToString:@""])
    {
        if (rowData[@"align_top"] != nil)
        {
            [col1 setFrame:CGRectMake(left_margin+r1_length+CELL_CONTENT_SPACING, top_y, col1_length-CELL_CONTENT_SPACING, CELL_LABEL_HEIGHT)];
        }
        else
        {
            [col1 setFrame:CGRectMake(left_margin+r1_length+CELL_CONTENT_SPACING, center_y, col1_length-CELL_CONTENT_SPACING, CELL_LABEL_HEIGHT)];
        }
        
        if (rowData[@"h1"] != nil)
        {
            [col1 setBackgroundColor:[UIColor clearColor]];
            [col1 setTextColor:[UIColor whiteColor]];
        }
        else
        {
            if ((rowData[@"c1_color"] != nil) && ![rowData[@"c1_color"] isEqualToString:@""])
            {
                if ([rowData[@"c1_color"] isEqualToString:@"1"])
                {
                    [col1 setTextColor:[UIColor redColor]];
                }
                else
                {
                    [col1 setTextColor:[UIColor grayColor]];
                }
            }
            else
            {
                [col1 setTextColor:[UIColor blackColor]];
            }
        }
    }
    else
    {
        [col1 setFrame:CGRectZero];
    }
    
    if ((rowData[@"i2"] != nil) && ![rowData[@"i2"] isEqualToString:@""])
    {
        [img2 setFrame:CGRectMake(left_margin+r1_length+col1_length, center_y, CELL_IMAGE2_WIDTH, CELL_IMAGE2_HEIGHT)];
    }
    else
    {
        [img2 setFrame:CGRectZero];
    }
}

@end
