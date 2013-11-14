//
//  DynamicCell.h
//  Kingdom
//
//  Created by Shankar on 10/30/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@interface DynamicCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>
{
    NSDictionary *cellRowData;
    float cellWidth;
    
    UIImageView *backgroundImage;
    UIImageView *footerImage;
    UIImageView *selectedImage;
    UITextField *textf1;
    UITextView *textv1;
    UILabel *header1;
    UILabel *row1;
    UILabel *row2;
    UILabel *row3;
    UILabel *col1;
    UILabel *num1;
    UIImageView *img1;
    UIImageView *img2;
}
@property (nonatomic, strong) NSDictionary *cellRowData;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *footerImage;
@property (nonatomic, strong) UIImageView *selectedImage;
@property (nonatomic, strong) UITextField *textf1;
@property (nonatomic, strong) UITextView *textv1;
@property (nonatomic, strong) UILabel *header1;
@property (nonatomic, strong) UILabel *row1;
@property (nonatomic, strong) UILabel *row2;
@property (nonatomic, strong) UILabel *row3;
@property (nonatomic, strong) UILabel *col1;
@property (nonatomic, strong) UILabel *num1;
@property (nonatomic, strong) UIImageView *img1;
@property (nonatomic, strong) UIImageView *img2;
- (void)drawCell:(NSDictionary *)rowData cellWidth:(float)cell_width;
@end
