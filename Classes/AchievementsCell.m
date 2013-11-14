//
//  AchievementsCell.m
//  FFC
//
//  Created by Shankar on 3/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "AchievementsCell.h"


@implementation AchievementsCell
@synthesize taskImage;
@synthesize doneImage;
@synthesize name;
@synthesize desc;
@synthesize reward;
@synthesize claimButton;
@synthesize claimLabel;


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
