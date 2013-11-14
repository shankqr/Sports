//
//  PlayerCell.m
//  FFC
//
//  Created by Shankar on 3/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "PlayerCell.h"

@implementation PlayerCell
@synthesize faceImage;
@synthesize injuredbruisedImage;
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;
@synthesize card1;
@synthesize card2;
@synthesize playerName;
@synthesize playerValue;
@synthesize position;
@synthesize stamina;
@synthesize pbstamina;
@synthesize keeper;
@synthesize pbkeeper;
@synthesize defending;
@synthesize pbdefending;
@synthesize playmaking;
@synthesize pbplaymaking;
@synthesize passing;
@synthesize pbpassing;
@synthesize scoring;
@synthesize pbscoring;
@synthesize condition;


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
