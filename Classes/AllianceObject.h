//
//  AllianceObject.h
//  FFC
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
    NSString *leader_firstname;
	NSString *leader_secondname;
    NSString *score;
    NSString *logo_id;
    NSString *flag_id;
    NSString *fanpage_url;
	NSString *introduction_text;
    NSString *cup_name;
	NSString *cup_first_prize;
    NSString *cup_second_prize;
    NSString *cup_start;
    NSString *cup_round;
    NSString *cup_first_id;
	NSString *cup_first_name;
    NSString *cup_second_id;
	NSString *cup_second_name;
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
@property (nonatomic, strong) NSString *leader_firstname;
@property (nonatomic, strong) NSString *leader_secondname;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *logo_id;
@property (nonatomic, strong) NSString *flag_id;
@property (nonatomic, strong) NSString *fanpage_url;
@property (nonatomic, strong) NSString *introduction_text;
@property (nonatomic, strong) NSString *cup_name;
@property (nonatomic, strong) NSString *cup_first_prize;
@property (nonatomic, strong) NSString *cup_second_prize;
@property (nonatomic, strong) NSString *cup_start;
@property (nonatomic, strong) NSString *cup_round;
@property (nonatomic, strong) NSString *cup_first_id;
@property (nonatomic, strong) NSString *cup_first_name;
@property (nonatomic, strong) NSString *cup_second_id;
@property (nonatomic, strong) NSString *cup_second_name;
@end
