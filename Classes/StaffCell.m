//
//  StaffCell.m
//  FFC
//
//  Created by Shankar on 3/30/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "StaffCell.h"

@implementation StaffCell
@synthesize faceImage;
@synthesize staffPos;
@synthesize staffEmployed;
@synthesize staffCost;

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
