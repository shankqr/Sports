//
//  ClubObject.h
//  FFC
//
//  Created by Shankar on 7/18/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface ClubObject : NSObject 
{
	NSString *club_id;
	NSString *club_name;
	NSString *fan;
	NSString *longitude;
	NSString *latitude;
	NSString *badge_path;
}
- (id)initWithDictionary:(NSDictionary *)aDictionary;
@property (nonatomic, strong) NSString *club_id;
@property (nonatomic, strong) NSString *club_name;
@property (nonatomic, strong) NSString *fan;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *badge_path;

@end

