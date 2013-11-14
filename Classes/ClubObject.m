//
//  ClubObject.m
//  FFC
//
//  Created by Shankar on 7/18/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "ClubObject.h"

@implementation ClubObject
@synthesize club_id;
@synthesize club_name;
@synthesize fan;
@synthesize longitude;
@synthesize latitude;
@synthesize badge_path;


- (id)initWithDictionary:(NSDictionary *)aDictionary 
{
    self = [super init];
	if (self)
	{
		self.club_id = [aDictionary valueForKey:@"club_id"];
		self.club_name = [aDictionary valueForKey:@"club_name"];
		self.fan = [aDictionary valueForKey:@"fan_members"];
		self.longitude = [aDictionary valueForKey:@"longitude"];
		self.latitude = [aDictionary valueForKey:@"latitude"];
		self.badge_path = [aDictionary valueForKey:@"logo_pic"];
	}
	return self;
}

@end
