//
//  AllianceObject.h
//  Kingdom Game
//
//  Created by Shankar on 1/13/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@interface AllianceObject : NSObject <NSCopying>

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
@property (nonatomic, strong) NSString *leader_firstname;
@property (nonatomic, strong) NSString *leader_secondname;
@property (nonatomic, strong) NSString *cup_name;
@property (nonatomic, strong) NSString *cup_first_prize;
@property (nonatomic, strong) NSString *cup_second_prize;
@property (nonatomic, strong) NSString *cup_start;
@property (nonatomic, strong) NSString *cup_round;
@property (nonatomic, strong) NSString *cup_first_id;
@property (nonatomic, strong) NSString *cup_first_name;
@property (nonatomic, strong) NSString *cup_second_id;
@property (nonatomic, strong) NSString *cup_second_name;

- (id)initWithDictionary:(NSDictionary *)aDictionary;

@end
