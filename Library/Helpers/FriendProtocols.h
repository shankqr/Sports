//
//  FriendProtocols.h
//  Kingdom Game
//
//  Created by Shankar on 10/12/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

@protocol FBGraphUserExtraFields <FBGraphUser>

@property (nonatomic, retain) NSArray *devices;
@property (nonatomic) BOOL *installed;

@end
