//
//  DynamicCell.h
//  Kingdom
//
//  Created by Shankar on 10/30/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#define iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define SCALE_IPAD (iPad ? 2.0f : 1.0f)
#define CELL_CONTENT_WIDTH (iPad ? 768.0f : 320.0f)

@interface DynamicCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>

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

@property (nonatomic, assign) float cellWidth;

- (void)drawCell:(NSDictionary *)rowData cellWidth:(float)cell_width;

+ (UITableViewCell *)dynamicCell:(UITableView *)tableView rowData:(NSDictionary *)rowData cellWidth:(float)cell_width;
+ (CGFloat)dynamicCellHeight:(NSDictionary *)rowData cellWidth:(float)cell_width;
+ (CGFloat)textHeight:(NSString *)text lblWidth:(CGFloat)label_width fontSize:(CGFloat)font_size;

@end
