//
//  Menu0Cell.m
//  Mafia Tower
//
//  Created by Shankar on 1/16/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

#import "Menu0Cell.h"

@implementation Menu0Cell
@synthesize productIcon;
@synthesize productTitle;
@synthesize productInfo;
@synthesize productBonus;
@synthesize productTag;
@synthesize productPrice;
@synthesize buyLabel;
@synthesize buyButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
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
