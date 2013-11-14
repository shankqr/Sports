//
//  LeagueslideCell.m
//  FFC
//
//  Created by Shankar on 11/26/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

#import "LeagueslideCell.h"

@implementation LeagueslideCell
@synthesize leagueRound;
@synthesize leagueStartMonth;
@synthesize leagueStartDay;
@synthesize leagueEndMonth;
@synthesize leagueEndDay;


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
