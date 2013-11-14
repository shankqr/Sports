//
//  JobsCell.m
//  FFC
//
//  Created by Shankar on 3/30/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "JobsCell.h"

@implementation JobsCell
@synthesize trainImage;
@synthesize descImage;
@synthesize energyLabel;
@synthesize friendlyLabel;
@synthesize rewardLabel;
@synthesize rankLabel;
@synthesize unlockLabel;
@synthesize jobButton;
@synthesize rankProgress;


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
