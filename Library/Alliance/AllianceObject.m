//
//  AllianceObject.m
//  Kingdom Game
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "AllianceObject.h"

@implementation AllianceObject
@synthesize alliance_id;
@synthesize leader_id;
@synthesize leader_name;
@synthesize name;
@synthesize date_found;
@synthesize total_members;
@synthesize alliance_level;
@synthesize currency_first;
@synthesize currency_second;
@synthesize rank;
@synthesize score;
@synthesize logo_id;
@synthesize flag_id;
@synthesize description;

- (id)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
	if (self)
	{
        self.alliance_id = [aDictionary valueForKey:@"alliance_id"];
        self.leader_id = [aDictionary valueForKey:@"leader_id"];
        self.leader_name = [aDictionary valueForKey:@"leader_name"];
		self.name = [aDictionary valueForKey:@"name"];
        self.date_found = [aDictionary valueForKey:@"date_found"];
		self.total_members = [aDictionary valueForKey:@"total_members"];
        self.alliance_level = [aDictionary valueForKey:@"alliance_level"];
        self.currency_first = [aDictionary valueForKey:@"currency_second"];
        //self.currency_second = [aDictionary valueForKey:@"currency_second"];
        self.rank = [aDictionary valueForKey:@"rank"];
		self.score = [aDictionary valueForKey:@"score"];
        self.logo_id = [aDictionary valueForKey:@"logo_id"];
        self.flag_id = [aDictionary valueForKey:@"flag_id"];
        self.description = [aDictionary valueForKey:@"description"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	AllianceObject *selfs = [[AllianceObject allocWithZone: zone] init];
    
    selfs.alliance_id = [alliance_id copy];
    selfs.leader_id = [leader_id copy];
    selfs.leader_name = [leader_name copy];
    selfs.name = [name copy];
    selfs.date_found = [date_found copy];
    selfs.total_members = [total_members copy];
    selfs.alliance_level = [alliance_level copy];
    selfs.currency_first = [currency_first copy];
    selfs.currency_second = [currency_second copy];
    selfs.rank = [rank copy];
    selfs.score = [score copy];
    selfs.logo_id = [logo_id copy];
    selfs.flag_id = [flag_id copy];
    selfs.description = [description copy];
    
	return selfs;
}

@end
