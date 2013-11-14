//
//  AllianceObject.m
//  FFC
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
@synthesize leader_firstname;
@synthesize leader_secondname;
@synthesize score;
@synthesize logo_id;
@synthesize flag_id;
@synthesize fanpage_url;
@synthesize introduction_text;
@synthesize cup_name;
@synthesize cup_first_prize;
@synthesize cup_second_prize;
@synthesize cup_start;
@synthesize cup_round;
@synthesize cup_first_id;
@synthesize cup_first_name;
@synthesize cup_second_id;
@synthesize cup_second_name;

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
        if ([self.date_found length] > 0)
        {
            self.date_found = [self.date_found substringToIndex:[self.date_found length] - 9];
        }
		self.total_members = [aDictionary valueForKey:@"total_members"];
        self.alliance_level = [aDictionary valueForKey:@"alliance_level"];
        self.currency_first = [aDictionary valueForKey:@"currency_first"];
        self.currency_second = [aDictionary valueForKey:@"currency_second"];
        self.rank = [aDictionary valueForKey:@"rank"];
        self.leader_firstname = [aDictionary valueForKey:@"leader_firstname"];
        self.leader_secondname = [aDictionary valueForKey:@"leader_secondname"];
		self.score = [aDictionary valueForKey:@"score"];
        self.logo_id = [aDictionary valueForKey:@"logo_id"];
        self.flag_id = [aDictionary valueForKey:@"flag_id"];
        self.fanpage_url = [aDictionary valueForKey:@"fanpage_url"];
        self.introduction_text = [aDictionary valueForKey:@"introduction_text"];
        self.cup_name = [aDictionary valueForKey:@"cup_name"];
        self.cup_first_prize = [aDictionary valueForKey:@"cup_first_prize"];
        self.cup_second_prize = [aDictionary valueForKey:@"cup_second_prize"];
        self.cup_start = [aDictionary valueForKey:@"cup_start"];
        if ([self.cup_start length] > 0)
        {
            self.cup_start = [self.cup_start substringToIndex:[self.cup_start length] - 9];
        }
        self.cup_round = [aDictionary valueForKey:@"cup_round"];
        self.cup_first_id = [aDictionary valueForKey:@"cup_first_id"];
        self.cup_first_name = [aDictionary valueForKey:@"cup_first_name"];
        self.cup_second_id = [aDictionary valueForKey:@"cup_second_id"];
        self.cup_second_name = [aDictionary valueForKey:@"cup_second_name"];
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
    selfs.leader_firstname = [leader_firstname copy];
    selfs.leader_secondname = [leader_secondname copy];
    selfs.score = [score copy];
    selfs.logo_id = [logo_id copy];
    selfs.flag_id = [flag_id copy];
    selfs.fanpage_url = [fanpage_url copy];
    selfs.introduction_text = [introduction_text copy];
    selfs.cup_name = [cup_name copy];
    selfs.cup_first_prize = [cup_first_prize copy];
    selfs.cup_second_prize = [cup_second_prize copy];
    selfs.cup_start = [cup_start copy];
    selfs.cup_round = [cup_round copy];
    selfs.cup_first_id = [cup_first_id copy];
    selfs.cup_first_name = [cup_first_name copy];
    selfs.cup_second_id = [cup_second_id copy];
    selfs.cup_second_name = [cup_second_name copy];
    
	return selfs;
}

@end
