//
//  BidCell.m
//  FFC
//
//  Created by Shankar on 3/19/11.
//  Copyright 2011 TAPFANTASY. All rights reserved.
//

#import "BidCell.h"

@implementation BidCell
@synthesize userLabel;
@synthesize messageLabel;

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
