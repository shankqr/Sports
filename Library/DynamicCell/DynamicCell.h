//
//  DynamicCell.h
//  Kingdom
//
//  Created by Shankar on 10/30/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "CellView.h"

@interface DynamicCell : UITableViewCell

@property (nonatomic, strong) CellView *cellview;

+ (UITableViewCell *)dynamicCell:(UITableView *)tableView rowData:(NSDictionary *)rd cellWidth:(float)cell_width;
+ (CGFloat)dynamicCellHeight:(NSDictionary *)rd cellWidth:(float)cell_width;
+ (CGFloat)textHeight:(NSString *)text lblWidth:(CGFloat)label_width fontSize:(CGFloat)font_size;
+ (CGFloat)textHeight:(NSString *)text lblWidth:(CGFloat)label_width font:(UIFont*)font;
+ (CGFloat)textWidth:(NSString *)text font:(UIFont*)font;

@end
