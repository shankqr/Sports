//
//  DynamicCell.m
//  Kingdom
//
//  Created by Shankar on 10/30/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "DynamicCell.h"
#import "UIColor+Crayola.h"

#define CELL_CONTENT_MARGIN 10.0f * SCALE_IPAD
#define CELL_CONTENT_Y 3.0f * SCALE_IPAD
#define CELL_CONTENT_SPACING 5.0f * SCALE_IPAD
#define CELL_HEADER_HEIGHT 44.0f * SCALE_IPAD
#define CELL_HEADER_Y 15.0f * SCALE_IPAD
#define CELL_IMAGE1_SIZE 30.0f * SCALE_IPAD
#define CELL_IMAGE2_HEIGHT 20.0f * SCALE_IPAD
#define CELL_IMAGE2_WIDTH 10.0f * SCALE_IPAD
#define CELL_LABEL_HEIGHT 20.0f * SCALE_IPAD
#define CELL_DEFAULT_HEIGHT 22.0f * SCALE_IPAD
#define CELL_EMPTY_HEIGHT 10.0f * SCALE_IPAD

#define R1_FONT_SIZE 17.0f * SCALE_IPAD
#define R2_FONT_SIZE 16.0f * SCALE_IPAD
#define R3_FONT_SIZE 14.0f * SCALE_IPAD
#define C1_FONT_SIZE 15.0f * SCALE_IPAD

#define DEFAULT_FONT @"MLS 2013"
#define DEFAULT_FONT_SIZE 22.0f * SCALE_IPAD
#define DEFAULT_FONT_SMALL_SIZE 18.0f * SCALE_IPAD
#define DEFAULT_FONT_BIG_SIZE 26.0f * SCALE_IPAD
#define MINIMUM_FONT_SIZE 1.0f * SCALE_IPAD

@implementation DynamicCell

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
    
    if (highlighted && (self.cellRowData[@"h1"] == nil) && ((self.cellRowData[@"i2"] != nil) || (self.cellRowData[@"select_able"] != nil)) )
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
    [[ttextv1 layer] setBorderWidth:2.3];
    [[ttextv1 layer] setCornerRadius:15];
    
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
    [self addSubview:self.textf1];
    
    self.header1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.header1 setNumberOfLines:1];
    [self.header1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
    [self.header1 setBackgroundColor:[UIColor clearColor]];
    [self.header1 setTextColor:[UIColor whiteColor]];
    self.header1.adjustsFontSizeToFitWidth = YES;
    self.header1.minimumScaleFactor = 0.5;
    [self.header1 setTag:9];
    [self addSubview:self.header1];
    
    self.row1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.row1 setNumberOfLines:0];
    [self.row1 setFont:[UIFont fontWithName:DEFAULT_FONT size:R1_FONT_SIZE]];
    [self.row1 setBackgroundColor:[UIColor clearColor]];
    [self.row1 setTag:1];
    [self addSubview:self.row1];
    
    self.row2 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.row2 setNumberOfLines:0];
    [self.row2 setFont:[UIFont fontWithName:DEFAULT_FONT size:R2_FONT_SIZE]];
    [self.row2 setBackgroundColor:[UIColor clearColor]];
    [self.row2 setTextColor:[UIColor crayolaBrownColor]];
    [self.row2 setTag:2];
    [self addSubview:self.row2];
    
    self.row3 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.row3 setNumberOfLines:0];
    [self.row3 setFont:[UIFont fontWithName:DEFAULT_FONT size:R3_FONT_SIZE]];
    [self.row3 setBackgroundColor:[UIColor clearColor]];
    [self.row3 setTextColor:[UIColor blackColor]];
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
    
    self.num1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.num1 setNumberOfLines:1];
    [self.num1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
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

- (void)drawCell:(NSDictionary *)rowData cellWidth:(float)cell_width
{
    self.cellRowData = rowData;
    self.cellWidth = cell_width;
    
    CGFloat left_margin = CELL_CONTENT_MARGIN;
    CGFloat r1_length = cell_width - CELL_CONTENT_MARGIN*2;
    CGFloat top_y = CELL_CONTENT_Y;
    CGFloat center_y = CELL_CONTENT_Y;
    CGFloat r1_height = CELL_LABEL_HEIGHT;
    CGFloat r2_height = CELL_LABEL_HEIGHT;
    
    if (!self.backgroundImage)
    {
        self.backgroundImage = (UIImageView*)[self viewWithTag:10];
    }
    
    if (!self.footerImage)
    {
        self.footerImage = (UIImageView*)[self viewWithTag:8];
    }
    
    if (!self.selectedImage)
    {
        self.selectedImage = (UIImageView*)[self viewWithTag:12];
    }
    
    if (!self.header1)
    {
        self.header1 = (UILabel*)[self viewWithTag:9];
    }
    
    [self.backgroundImage setFrame:CGRectMake(0, 0, cell_width, CELL_HEADER_HEIGHT)];
    [self.footerImage setImage:nil];
    [self.selectedImage setFrame:CGRectMake(0, 0, cell_width, CELL_HEADER_HEIGHT)];
    
    if (rowData[@"h1"] != nil && ![rowData[@"h1"] isEqualToString:@""])
    {
        [self.backgroundImage setImage:[UIImage imageNamed:@"skin_header_cell"]];
        
        [self.header1 setText:rowData[@"h1"]];
        [self.header1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_HEADER_Y, r1_length, CELL_LABEL_HEIGHT)];
    }
    else
    {
        if ([rowData[@"h1"] isEqualToString:@""])
        {
            [self.backgroundImage setImage:[UIImage imageNamed:@"skin_header_cell"]];
            
            top_y = CELL_HEADER_Y;
            center_y = CELL_HEADER_Y;
            
            [self.num1 setTextColor:[UIColor whiteColor]];
            [self.row1 setTextColor:[UIColor whiteColor]];
            [self.col1 setTextColor:[UIColor whiteColor]];
            
            [self.row1 setNumberOfLines:1];
            self.row1.adjustsFontSizeToFitWidth = YES;
            self.row1.minimumScaleFactor = 0.5;
        }
        else
        {
            CGFloat cell_height = [DynamicCell dynamicCellHeight:rowData cellWidth:cell_width];
            
            //[backgroundImage setImage:[UIImage imageNamed:@"skin_content_cell"]];
            [self.backgroundImage setImage:nil];
            [self.backgroundImage setFrame:CGRectMake(0, 0, cell_width, cell_height)];
            
            [self.footerImage setImage:[UIImage imageNamed:@"skin_footer_cell"]];
            [self.footerImage setFrame:CGRectMake(0, cell_height-1, cell_width, 1)];
            
            [self.selectedImage setFrame:CGRectMake(0, 0, cell_width, cell_height)];
            
            [self.num1 setTextColor:[UIColor blackColor]];
            [self.row1 setTextColor:[UIColor blackColor]];
            [self.col1 setTextColor:[UIColor blackColor]];
        }
        
        [self.header1 setFrame:CGRectZero];
    }
    
    if (!self.row1)
    {
        self.row1 = (UILabel*)[self viewWithTag:1];
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
    
    if (rowData[@"i1"] != nil)
    {
        left_margin += CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
        r1_length -= CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
        
        [self.img1 setImage:[UIImage imageNamed:rowData[@"i1"]]];
    }
    else if (rowData[@"n1"] != nil)
    {
        left_margin += CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
        r1_length -= CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
        
        [self.num1 setText:rowData[@"n1"]];
    }
    
    if (!self.img2)
    {
        self.img2 = (UIImageView*)[self viewWithTag:5];
    }
    if (rowData[@"i2"] != nil)
    {
        r1_length -= CELL_IMAGE2_WIDTH - CELL_CONTENT_SPACING;
        [self.img2 setImage:[UIImage imageNamed:rowData[@"i2"]]];
    }
    
    CGFloat r2_length = r1_length;
    CGFloat col1_length = 0;
    if (!self.col1)
    {
        self.col1 = (UILabel*)[self viewWithTag:3];
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
        [self.col1 setText:rowData[@"c1"]];
    }
    
    if (rowData[@"t1"] != nil)
    {
        CGFloat t1_height = 21.0f * SCALE_IPAD;
        
        if (rowData[@"t1_height"] != nil)
        {
            [self performSelectorOnMainThread:@selector(createTextView) withObject:nil waitUntilDone:YES];
            
            if (!self.textv1)
            {
                self.textv1 = (UITextView*)[self viewWithTag:7];
            }
            
            t1_height = [rowData[@"t1_height"] floatValue] * SCALE_IPAD;
            [self.textv1 setFrame:CGRectMake(left_margin, CELL_CONTENT_Y, r1_length, t1_height)];
        }
        else
        {
            if (!self.textf1)
            {
                self.textf1 = (UITextField*)[self viewWithTag:6];
            }
            
            [self.textf1 setPlaceholder:rowData[@"t1"]];
            [self.textf1 setFrame:CGRectMake(left_margin, CELL_CONTENT_Y, r1_length, t1_height)];
        }
    }
    
    r1_height = [DynamicCell textHeight:rowData[@"r1"] lblWidth:r1_length fontSize:R1_FONT_SIZE];
    
    if ((rowData[@"r1"] != nil) && ![rowData[@"r1"] isEqualToString:@""])
    {
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
    else
    {
        [self.row1 setFrame:CGRectZero];
    }
    
    if ((rowData[@"r2"] != nil) && ![rowData[@"r2"] isEqualToString:@""])
    {
        if (rowData[@"align_top"] == nil)
        {
            r2_length = r1_length;
        }
        
        r2_height = [DynamicCell textHeight:rowData[@"r2"] lblWidth:r2_length fontSize:R2_FONT_SIZE];
        [self.row2 setFrame:CGRectMake(left_margin, top_y+r1_height, r2_length, r2_height)];
        
        center_y = 14.0f * SCALE_IPAD;
    }
    else
    {
        [self.row2 setFrame:CGRectZero];
    }
    
    if ((rowData[@"r3"] != nil) && ![rowData[@"r3"] isEqualToString:@""])
    {
        CGFloat r3_height = [DynamicCell textHeight:rowData[@"r3"] lblWidth:r2_length fontSize:R3_FONT_SIZE];
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
            [self.num1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, top_y, CELL_IMAGE1_SIZE, CELL_LABEL_HEIGHT)];
        }
        else
        {
            [self.num1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, center_y, CELL_IMAGE1_SIZE, CELL_LABEL_HEIGHT)];
        }
        
        if (rowData[@"h1"] != nil)
        {
            [self.num1 setTextColor:[UIColor whiteColor]];
        }
        else
        {
            [self.num1 setTextColor:[UIColor blackColor]];
        }
    }
    else
    {
        [self.num1 setFrame:CGRectZero];
    }
    
    if ((rowData[@"i1"] != nil) && ![rowData[@"i1"] isEqualToString:@""])
    {
        [self.img1 setFrame:CGRectMake(CELL_CONTENT_MARGIN, 10.0f * SCALE_IPAD, CELL_IMAGE1_SIZE, CELL_IMAGE1_SIZE)];
        
        center_y = 14.0f * SCALE_IPAD;
    }
    else
    {
        [self.img1 setFrame:CGRectZero];
    }
    
    if ((rowData[@"c1"] != nil) && ![rowData[@"c1"] isEqualToString:@""])
    {
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
    else
    {
        [self.col1 setFrame:CGRectZero];
    }
    
    if ((rowData[@"i2"] != nil) && ![rowData[@"i2"] isEqualToString:@""])
    {
        [self.img2 setFrame:CGRectMake(left_margin+r1_length+col1_length, center_y, CELL_IMAGE2_WIDTH, CELL_IMAGE2_HEIGHT)];
    }
    else
    {
        [self.img2 setFrame:CGRectZero];
    }
}

#pragma mark - DynamicCell

+ (DynamicCell *)dynamicCell:(UITableView *)tableView rowData:(NSDictionary *)rowData cellWidth:(float)cell_width
{
    DynamicCell *cell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
    
    if (cell == nil)
    {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DynamicCell"];
    }
    
    [cell drawCell:rowData cellWidth:cell_width];
    
    return cell;
}

+ (CGFloat)textHeight:(NSString *)text lblWidth:(CGFloat)label_width fontSize:(CGFloat)font_size
{
    CGSize constraint = CGSizeMake(label_width, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:DEFAULT_FONT size:font_size] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height, CELL_LABEL_HEIGHT);
}

+ (CGFloat)dynamicCellHeight:(NSDictionary *)rowData cellWidth:(float)cell_width
{
    CGFloat cell_height = CELL_EMPTY_HEIGHT;
    CGFloat r1_length = cell_width - CELL_CONTENT_MARGIN*2;
    CGFloat r2_length = 0.0f;
    CGFloat col1_length = 0.0f;
    
    if (rowData[@"i1"] != nil)
    {
        r1_length -= CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
    }
    else if (rowData[@"n1"] != nil)
    {
        r1_length -= CELL_IMAGE1_SIZE + CELL_CONTENT_SPACING;
    }
    
    if (rowData[@"i2"] != nil)
    {
        r1_length -= CELL_IMAGE2_WIDTH - CELL_CONTENT_SPACING;
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
    
    if (rowData[@"align_top"] == nil)
    {
        r2_length = r1_length;
    }
    
    if (rowData[@"h1"] != nil && ![rowData[@"h1"] isEqualToString:@""])
    {
        cell_height = CELL_HEADER_HEIGHT;
    }
    else if ([rowData[@"h1"] isEqualToString:@""])
    {
        cell_height = CELL_HEADER_HEIGHT;
    }
    else
    {
        if ((rowData[@"r1"] != nil) && ![rowData[@"r1"] isEqualToString:@""])
        {
            cell_height += [self textHeight:rowData[@"r1"] lblWidth:r1_length fontSize:R1_FONT_SIZE];
        }
        
        if ((rowData[@"r2"] != nil) && ![rowData[@"r2"] isEqualToString:@""])
        {
            cell_height += [self textHeight:rowData[@"r2"] lblWidth:r2_length fontSize:R2_FONT_SIZE];
        }
        else if ((rowData[@"i1"] != nil) && ![rowData[@"i1"] isEqualToString:@""])
        {
            cell_height += CELL_LABEL_HEIGHT;
        }
        
        if ((rowData[@"r3"] != nil) && ![rowData[@"r3"] isEqualToString:@""])
        {
            cell_height += [self textHeight:rowData[@"r3"] lblWidth:r2_length fontSize:R3_FONT_SIZE];
        }
        
        if (rowData[@"t1"] != nil)
        {
            if (rowData[@"t1_height"] != nil)
            {
                cell_height += [rowData[@"t1_height"] floatValue];
            }
            else
            {
                cell_height += CELL_LABEL_HEIGHT;
            }
        }
    }
    
    return cell_height;
}

@end
