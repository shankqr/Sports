//
//  SPSprite.h
//  Sparrow
//
//  Created by Daniel Sperl on 21.03.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>
#import <Sparrow/SPDisplayObjectContainer.h>

/** ------------------------------------------------------------------------------------------------

 An SPSprite is the most lightweight, non-abstract container class. 

 Use it as a simple means of grouping objects together in one coordinate system.
 
	SPSprite *sprite = [SPSprite sprite];
	
	// create children
	SPImage *venus = [SPImage imageWithContentsOfFile:@"venus.png"];
	SPImage *mars = [SPImage imageWithContentsOfFile:@"mars.png"];
	
	// move children to some relative positions
	venus.x = 50;
	mars.x = -20;
	
	// add children to the sprite
	[sprite addChild:venus];
	[sprite addChild:mars];
	
	// calculate total width of all children
	float totalWidth = sprite.width;
	
	// rotate the whole group
	sprite.rotation = PI;

 **Flattened Sprites**
 
 The `flatten`-method allows you to optimize the rendering of static parts of your display list.

 It analyzes the tree of children attached to the sprite and optimizes the rendering calls
 in a way that makes rendering extremely fast. The speed-up comes at a price, though: you will
 no longer see any changes in the properties of the children (position, rotation, alpha, etc).
 To update the object after changes have happened, simply call `flatten` again, or `unflatten`
 the object.
 
------------------------------------------------------------------------------------------------- */

@interface SPSprite : SPDisplayObjectContainer

/// --------------------
/// @name Initialization
/// --------------------

/// Create a new, empty sprite.
+ (instancetype)sprite;

/// -------------
/// @name Methods
/// -------------

/// Optimizes the sprite for optimal rendering performance. Changes in the children of a flattened
/// sprite will not be displayed any longer. For this to happen, either call `flatten` again, or
/// `unflatten` the sprite. Beware that the actual flattening will not happen right away, but right
/// before the next rendering.
- (void)flatten;

/// Removes the rendering optimizations that were created when flattening the sprite.
/// Changes to the sprite's children will immediately become visible again.
- (void)unflatten;

/// Returns the bounds of the container's clipRect in the given coordinate space, or
/// null if the sprite doens't have a clipRect.
- (SPRectangle *)clipRectInSpace:(SPDisplayObject *)targetSpace;

/// ----------------
/// @name Properties
/// ----------------

/// Returns YES if this sprite has been flattened.
@property (nonatomic, readonly) BOOL isFlattened;

/// The sprite's clipping rectangle in its local coordinate system. Only pixels within this
/// rectangle will be drawn. The clipping rectangle is axis aligned with the screen, so it will
/// not be rotated or skewed if the sprite is.
@property (nonatomic, copy) SPRectangle* clipRect;

@end
