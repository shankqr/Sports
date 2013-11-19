//
//  AllianceObject.h
//  Kingdom Game
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@interface AllianceObject : NSObject <NSCopying>
{
    NSString *alliance_id;
    NSString *leader_id;
    NSString *leader_name;
	NSString *name;
    NSString *date_found;
	NSString *total_members;
    NSString *alliance_level;
    NSString *currency_first;
    NSString *currency_second;
	NSString *rank;
    NSString *score;
    NSString *logo_id;
    NSString *flag_id;
	NSString *description;
}
- (id)initWithDictionary:(NSDictionary *)aDictionary;
@property (nonatomic, strong) NSString *alliance_id;
@property (nonatomic, strong) NSString *leader_id;
@property (nonatomic, strong) NSString *leader_name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *date_found;
@property (nonatomic, strong) NSString *total_members;
@property (nonatomic, strong) NSString *alliance_level;
@property (nonatomic, strong) NSString *currency_first;
@property (nonatomic, strong) NSString *currency_second;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *logo_id;
@property (nonatomic, strong) NSString *flag_id;
@property (nonatomic, strong) NSString *description;
@end
