//
//  MatchCell.m
//  FFC
//
//  Created by Shankar on 4/2/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MatchCell.h"

@implementation MatchCell
@synthesize matchDay;
@synthesize matchDate;
@synthesize matchMonth;
@synthesize matchScore;
@synthesize matchClubName1;
@synthesize matchClubLogo1;

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
