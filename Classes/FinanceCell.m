//
//  FinanceCell.m
//  FFC
//
//  Created by Shankar on 6/16/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "FinanceCell.h"

@implementation FinanceCell
@synthesize item;
@synthesize cost1;
@synthesize cost2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
