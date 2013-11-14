//
//  FixtureCell.m
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "FixtureCell.h"

@implementation FixtureCell
@synthesize matchDay;
@synthesize matchDate;
@synthesize matchMonth;
@synthesize matchScore;
@synthesize matchClubName1;
@synthesize matchClubName2;
@synthesize matchClubLogo1;

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
