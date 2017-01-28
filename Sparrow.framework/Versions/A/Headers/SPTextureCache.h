//
//  SPTextureCache.h
//  Sparrow
//
//  Created by Daniel Sperl on 25.03.14.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>

@class SPTexture;

/** ------------------------------------------------------------------------------------------------

 The texture cache keeps weak references to all loaded textures.

 When you try to instantiate a texture that is already in memory, it is taken from the cache
 instead of loading it again.

 _This is an internal class. You do not have to use it manually._

------------------------------------------------------------------------------------------------- */

@interface SPTextureCache : NSObject

/// Returns the texture stored with the given key, or `nil` if that texture is not available.
- (SPTexture *)textureForKey:(NSString *)key;

/// Stores a weak reference to the given texture. The texture is not retained;
/// when it is deallocated, it is automatically removed from the cache.
- (void)setTexture:(SPTexture *)obj forKey:(NSString *)key;

/// Removes all references.
- (void)purge;

@end