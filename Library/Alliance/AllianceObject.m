//
//  AllianceObject.m
//  Kingdom Game
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

#import "AllianceObject.h"

@implementation AllianceObject

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
        self.currency_first = [aDictionary valueForKey:@"currency_first"];
        self.currency_second = [aDictionary valueForKey:@"currency_second"];
        self.rank = [aDictionary valueForKey:@"rank"];
		self.score = [aDictionary valueForKey:@"score"];
        self.logo_id = [aDictionary valueForKey:@"logo_id"];
        self.flag_id = [aDictionary valueForKey:@"flag_id"];
        self.description = [aDictionary valueForKey:@"introduction_text"];
        self.leader_firstname = [aDictionary valueForKey:@"leader_firstname"];
        self.leader_secondname = [aDictionary valueForKey:@"leader_secondname"];
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
    
    selfs.alliance_id = [self.alliance_id copy];
    selfs.leader_id = [self.leader_id copy];
    selfs.leader_name = [self.leader_name copy];
    selfs.name = [self.name copy];
    selfs.date_found = [self.date_found copy];
    selfs.total_members = [self.total_members copy];
    selfs.alliance_level = [self.alliance_level copy];
    selfs.currency_first = [self.currency_first copy];
    selfs.currency_second = [self.currency_second copy];
    selfs.rank = [self.rank copy];
    selfs.score = [self.score copy];
    selfs.logo_id = [self.logo_id copy];
    selfs.flag_id = [self.flag_id copy];
    selfs.description = [self.description copy];
    selfs.leader_firstname = [self.leader_firstname copy];
    selfs.leader_secondname = [self.leader_secondname copy];
    selfs.cup_name = [self.cup_name copy];
    selfs.cup_first_prize = [self.cup_first_prize copy];
    selfs.cup_second_prize = [self.cup_second_prize copy];
    selfs.cup_start = [self.cup_start copy];
    selfs.cup_round = [self.cup_round copy];
    selfs.cup_first_id = [self.cup_first_id copy];
    selfs.cup_first_name = [self.cup_first_name copy];
    selfs.cup_second_id = [self.cup_second_id copy];
    selfs.cup_second_name = [self.cup_second_name copy];
	return selfs;
}

@end
