//
//  ProductCell.m
//  FFC
//
//  Created by Shankar on 3/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell
@synthesize productImage;
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;
@synthesize productName;
@synthesize productValue;
@synthesize productDesc;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
