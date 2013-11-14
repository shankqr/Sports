//
//  LeagueCell.m
//  FFC
//
//  Created by Shankar on 7/9/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "LeagueCell.h"

@implementation LeagueCell
@synthesize pos;
@synthesize club;
@synthesize played;
@synthesize won;
@synthesize draw;
@synthesize lost;
@synthesize goalfor;
@synthesize goalagaints;
@synthesize goaldif;
@synthesize points;


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
