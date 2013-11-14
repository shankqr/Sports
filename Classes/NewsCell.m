//
//  NewsCell.m
//  FFC
//
//  Created by Shankar on 4/2/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell
@synthesize newsDay;
@synthesize newsDate;
@synthesize newsMonth;
@synthesize newsHeader;

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
