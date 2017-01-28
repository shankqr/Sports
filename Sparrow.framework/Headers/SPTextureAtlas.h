//
//  SPTextureAtlas.h
//  Sparrow
//
//  Created by Daniel Sperl on 27.06.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>

@class SPRectangle;
@class SPTexture;

/** ------------------------------------------------------------------------------------------------

 A texture atlas is a collection of many smaller textures in one big image. The class
 SPTextureAtlas is used to access textures from such an atlas.
 
 Using a texture atlas for your textures solves two problems:
 
 - Whenever you switch between textures, the batching of image objects is disrupted.
 - Some OpenGL textures need to have side lengths that are powers of two. Sparrow hides this
   limitation from you, but you will nevertheless use more memory if you do not follow that rule.
 
 By using a texture atlas, you avoid both texture switches and the power-of-two limitation. All 
 textures are within one big "super-texture", and Sparrow takes care that the correct part of this 
 texture is displayed.
 
 There are several ways to create a texture atlas. One is to use the atlas generator script that
 is provided with Sparrow. Here is a sample on how to use it:
 
	# creates "atlas.xml" and "atlas.png" from the	provided images 
	./generate_atlas.rb *.png output/atlas.xml
 
 The atlas generator can be found in the 'utils' directory in the Sparrow package. A README file
 shows you how to install and use it. If you want to have more control over your atlas, you will
 find great alternative tools on the Internet, like [Texture Packer](http://www.texturepacker.com).
 
 Whatever tool you use, Sparrow expects the following file format:

	<TextureAtlas imagePath='atlas.png'>
	  <SubTexture name='texture_1' x='0'  y='0' width='50' height='50'/>
	  <SubTexture name='texture_2' x='50' y='0' width='20' height='30'/> 
	</TextureAtlas>
 
 If your images have transparent areas at their edges, you can make use of the `frame` property
 of `SPTexture`. Trim the texture by removing the transparent edges and specify the original 
 texture size like this:

	<SubTexture name='trimmed' x='0' y='0' height='10' width='10'
	            frameX='-10' frameY='-10' frameWidth='30' frameHeight='30'/>
 
------------------------------------------------------------------------------------------------- */

@interface SPTextureAtlas : NSObject

/// --------------------
/// @name Initialization
/// --------------------

/// Initializes a texture atlas from an XML file and a custom texture. _Designated Initializer_.
- (instancetype)initWithContentsOfFile:(NSString *)path texture:(SPTexture *)texture;

/// Initializes a texture atlas from an XML file, loading the texture that is specified in the XML.
- (instancetype)initWithContentsOfFile:(NSString *)path;

/// Initializes a teture atlas from a texture. Add the regions manually with `addName:forRegion:`.
- (instancetype)initWithTexture:(SPTexture *)texture;

/// Factory Method.
+ (instancetype)atlasWithContentsOfFile:(NSString *)path;

/// -------------
/// @name Methods
/// -------------

/// Retrieve a subtexture by name. Returns `nil` if it is not found.
- (SPTexture *)textureByName:(NSString *)name;

/// The region rectangle associated with a specific name.
- (SPRectangle *)regionByName:(NSString *)name;

/// The frame rectangle of a specific region, or `nil` if that region has no frame.
- (SPRectangle *)frameByName:(NSString *)name;

/// Returns all textures that start with a certain string, sorted alphabetically
/// (especially useful for `SPMovieClip`).
- (NSArray *)texturesStartingWith:(NSString *)prefix;

/// Returns all texture names that start with a certain string, sorted alphabetically.
- (NSArray *)namesStartingWith:(NSString *)prefix;

/// Creates a region for a subtexture and gives it a name.
- (void)addRegion:(SPRectangle *)region withName:(NSString *)name;

/// Creates a region for a subtexture with a frame and gives it a name.
- (void)addRegion:(SPRectangle *)region withName:(NSString *)name frame:(SPRectangle *)frame;

/// Creates a region for a subtexture with a frame and gives it a name. If `rotated` is `YES`,
/// the subtexture will show the region rotated by 90 degrees (CCW).
- (void)addRegion:(SPRectangle *)region withName:(NSString *)name frame:(SPRectangle *)frame
          rotated:(BOOL)rotated;

/// Removes a region with a certain name.
- (void)removeRegion:(NSString *)name;

/// ----------------
/// @name Properties
/// ----------------

/// The number of available subtextures.
@property (nonatomic, readonly) int numTextures;

/// All texture names of the atlas, sorted alphabetically.
@property (nonatomic, readonly) NSArray *names;

/// All textures of the atlas, sorted alphabetically.
@property (nonatomic, readonly) NSArray *textures;

/// The base texture that makes up the atlas.
@property (nonatomic, readonly) SPTexture *texture;

@end
