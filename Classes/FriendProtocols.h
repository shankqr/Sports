//
//  FriendProtocols.h
//  FFC
//
//  Created by Shankar on 10/12/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol FBGraphUserExtraFields <FBGraphUser>

@property (nonatomic, retain) NSArray *devices;
@property (nonatomic) BOOL *installed;

@end
