//
//  SPImage.h
//  Sparrow
//
//  Created by Daniel Sperl on 19.06.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>
#import <Sparrow/SPQuad.h>

/** ------------------------------------------------------------------------------------------------

 An SPImage displays a quad with a texture mapped onto it.
 
 Sparrow uses the SPTexture class to represent textures. To display a texture, you have to map
 it on a quad - and that's what SPImage is for.
 
 As SPImage inherits from SPQuad, you can give it a color. For each pixel, the resulting color will
 be the result of the multiplication of the color of the texture with the color of the quad. That 
 way, you can easily tint textures with a certain color. 
 
 Furthermore, SPImage allows the manipulation of texture coordinates. That way, you can move a 
 texture inside an image without changing any vertex coordinates of the quad. You can also use 
 this feature as a very efficient way to create a rectangular mask.
 
------------------------------------------------------------------------------------------------- */

@interface SPImage : SPQuad 
{
    SPTexture *_texture;
}

/// --------------------
/// @name Initialization
/// --------------------

/// Initialize a quad with a texture mapped onto it. _Designated Initializer_.
- (instancetype)initWithTexture:(SPTexture *)texture;

/// Initialize a quad with a texture loaded from a file. No mipmaps will be created.
- (instancetype)initWithContentsOfFile:(NSString *)path;

/// Initialize a quad with a texture loaded from a file.
- (instancetype)initWithContentsOfFile:(NSString *)path generateMipmaps:(BOOL)mipmaps;

/// Factory method.
+ (instancetype)imageWithTexture:(SPTexture *)texture;

/// Factory method.
+ (instancetype)imageWithContentsOfFile:(NSString *)path;

/// -------------
/// @name Methods
/// -------------

/// Sets the texture coordinates of a vertex. Coordinates are in the range [0, 1].
- (void)setTexCoords:(SPPoint *)coords ofVertex:(int)vertexID;

/// Sets the texture coordinates of a vertex. Coordinates are in the range [0, 1].
- (void)setTexCoordsWithX:(float)x y:(float)y ofVertex:(int)vertexID;

/// Gets the texture coordinates of a vertex.
- (SPPoint *)texCoordsOfVertex:(int)vertexID;

/// Readjusts the dimensions of the image according to its current texture. Call this method 
/// to synchronize image and texture size after assigning a texture with a different size.
- (void)readjustSize;

/// ----------------
/// @name Properties
/// ----------------

/// The texture that is displayed on the quad.
@property (nonatomic, strong) SPTexture *texture;

@end
