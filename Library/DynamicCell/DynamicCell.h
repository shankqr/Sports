//
//  DynamicCell.h
//  Kingdom
//
//  Created by Shankar on 10/30/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@interface DynamicCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSDictionary *cellRowData;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *footerImage;
@property (nonatomic, strong) UIImageView *selectedImage;
@property (nonatomic, strong) UIImageView *num1_border;
@property (nonatomic, strong) UIImageView *row1_border;
@property (nonatomic, strong) UIImageView *col1_border;
@property (nonatomic, strong) UITextField *textf1;
@property (nonatomic, strong) UITextView *textv1;
@property (nonatomic, strong) UILabel *row1;
@property (nonatomic, strong) UIButton *row1_button;
@property (nonatomic, strong) UILabel *row2;
@property (nonatomic, strong) UILabel *row3;
@property (nonatomic, strong) UILabel *col1;
@property (nonatomic, strong) UIButton *col1_button;
@property (nonatomic, strong) UILabel *col2;
@property (nonatomic, strong) UILabel *num1;
@property (nonatomic, strong) UIImageView *img1;
@property (nonatomic, strong) UIImageView *img1_over;
@property (nonatomic, strong) UIImageView *img2;

@property (nonatomic, assign) float cellWidth;

- (void)drawCell:(NSDictionary *)rd cellWidth:(float)cell_width;

+ (UITableViewCell *)dynamicCell:(UITableView *)tableView rowData:(NSDictionary *)rd cellWidth:(float)cell_width;
+ (CGFloat)dynamicCellHeight:(NSDictionary *)rd cellWidth:(float)cell_width;
+ (CGFloat)textHeight:(NSString *)text lblWidth:(CGFloat)label_width fontSize:(CGFloat)font_size;

@end
