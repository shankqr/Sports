//
//  OverfirstCell.m
//  FFC
//
//  Created by Shankar on 11/21/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

#import "OverfirstCell.h"

@implementation OverfirstCell
@synthesize introLabel;


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
