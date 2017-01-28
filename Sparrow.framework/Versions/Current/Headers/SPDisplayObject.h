//
//  SPDisplayObject.h
//  Sparrow
//
//  Created by Daniel Sperl on 15.03.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>
#import <Sparrow/SPEventDispatcher.h>

#ifdef SP_PHYSICS_CLASS
@class SP_PHYSICS_CLASS;
#endif

@class SPDisplayObjectContainer;
@class SPFragmentFilter;
@class SPMatrix;
@class SPPoint;
@class SPRectangle;
@class SPRenderSupport;
@class SPStage;

/** ------------------------------------------------------------------------------------------------

 The SPDisplayObject class is the base class for all objects that are rendered on the screen.
 
 In Sparrow, all displayable objects are organized in a display tree. Only objects that are part of
 the display tree will be displayed (rendered). 
 
 The display tree consists of leaf nodes (SPImage, SPQuad) that will be rendered directly to
 the screen, and of container nodes (subclasses of SPDisplayObjectContainer, like SPSprite).
 A container is simply a display object that has child nodes - which can, again, be either leaf
 nodes or other containers. 
 
 A display object has properties that define its position in relation to its parent
 (`x`, `y`), as well as its rotation, skewing and scaling factors (`scaleX`, `scaleY`). Use the 
 `alpha` and `visible` properties to make an object translucent or invisible.
 
 Every display object may be the target of touch events. If you don't want an object to be
 touchable, you can disable the `touchable` property. When it's disabled, neither the object
 nor its children will receive any more touch events.
 
 **Points vs. Pixels**
 
 All sizes and distances are measured in points. What this means in pixels depends on the 
 contentScaleFactor of the device. On a low resolution device (iPhone 3GS / iPad 1+2), one point
 corresponds to one pixel. On devices with a retina display, one point may be 2 pixels.
 
 **Transforming coordinates**
 
 Within the display tree, each object has its own local coordinate system. If you rotate a container,
 you rotate that coordinate system - and thus all the children of the container.
 
 Sometimes you need to know where a certain point lies relative to another coordinate system. 
 That's the purpose of the method `transformationMatrixToSpace:`. It will create a matrix that
 represents the transformation of a point in one coordinate system to another. 
 
 **Subclassing SPDisplayObject**
 
 As SPDisplayObject is an abstract class, you can't instantiate it directly, but have to use one of 
 its subclasses instead. There are already a lot of them available, and most of the time they will
 suffice. 
 
 However, you can create custom display objects as well. That's especially useful when you want to
 create an object with a custom render function.
 
 You will need to implement the following methods when you subclass SPDisplayObject:
 
	- (void)render:(SPRenderSupport *)support;
	- (SPRectangle *)boundsInSpace:(SPDisplayObject *)targetSpace;
 
 Have a look at SPQuad for a sample implementation of those methods. 
 
------------------------------------------------------------------------------------------------- */

@interface SPDisplayObject : SPEventDispatcher

/// -------------
/// @name Methods
/// -------------

/// Renders the display object with the help of a support object. 
- (void)render:(SPRenderSupport *)support;

/// Removes the object from its parent, if it has one.
- (void)removeFromParent;

/// Moves the pivot point to the center of the object.
- (void)alignPivotToCenter;

/// Moves the pivot point to a certain position within the local coordinate system of the object.
- (void)alignPivotX:(SPHAlign)hAlign pivotY:(SPVAlign)vAlign;

/// Creates a matrix that represents the transformation from the local coordinate system to another.
- (SPMatrix *)transformationMatrixToSpace:(SPDisplayObject *)targetSpace;

/// Returns a rectangle that completely encloses the object as it appears in another coordinate system.
- (SPRectangle *)boundsInSpace:(SPDisplayObject *)targetSpace;

/// Transforms a point from the local coordinate system to global (stage) coordinates.
- (SPPoint *)localToGlobal:(SPPoint *)localPoint;

/// Transforms a point from global (stage) coordinates to the local coordinate system.
- (SPPoint *)globalToLocal:(SPPoint *)globalPoint;

/// Returns the object that is found topmost on a point in local coordinates, or nil if the test fails.
- (SPDisplayObject *)hitTestPoint:(SPPoint *)localPoint;

/// Dispatches an event on all children (recursively). The event must not bubble. */
- (void)broadcastEvent:(SPEvent *)event;

/// Creates an event and dispatches it on all children (recursively). */
- (void)broadcastEventWithType:(NSString *)type;

/// ----------------
/// @name Properties
/// ----------------

/// The x coordinate of the object relative to the local coordinates of the parent.
@property (nonatomic, assign) float x;

/// The y coordinate of the object relative to the local coordinates of the parent.
@property (nonatomic, assign) float y;

/// The x coordinate of the object's origin in its own coordinate space (default: 0).
@property (nonatomic, assign) float pivotX;

/// The y coordinate of the object's origin in its own coordinate space (default: 0).
@property (nonatomic, assign) float pivotY;

/// The scale factor. "1" means no scale, a negative value inverts the object.
/// Note: Accessing this property will always return scaleX, even if scaleX and scaleY are not equal.
@property (nonatomic, assign) float scale;

/// The horizontal scale factor. "1" means no scale, negative values flip the object.
@property (nonatomic, assign) float scaleX;

/// The vertical scale factor. "1" means no scale, negative values flip the object.
@property (nonatomic, assign) float scaleY;

/// The horizontal skew angle in radians.
@property (nonatomic, assign) float skewX;

/// The vertical skew angle in radians.
@property (nonatomic, assign) float skewY;

/// The width of the object in points.
@property (nonatomic, assign) float width;

/// The height of the object in points.
@property (nonatomic, assign) float height;

/// The rotation of the object in radians. (In Sparrow, all angles are measured in radians.)
@property (nonatomic, assign) float rotation;

/// The opacity of the object. 0 = transparent, 1 = opaque.
@property (nonatomic, assign) float alpha;

/// The visibility of the object. An invisible object will be untouchable.
@property (nonatomic, assign) BOOL visible;

/// Indicates if this object (and its children) will receive touch events.
@property (nonatomic, assign) BOOL touchable;

/// The bounds of the object relative to the local coordinates of the parent.
@property (weak, nonatomic, readonly) SPRectangle *bounds;

/// The display object container that contains this display object.
@property (weak, nonatomic, readonly) SPDisplayObjectContainer *parent;

/// The root object the display object is connected to (i.e. an instance of the class
/// that was passed to `[SPViewController startWithRoot:]`), or nil if the object is not connected
/// to it.
@property (weak, nonatomic, readonly) SPDisplayObject *root;

/// The stage the display object is connected to, or nil if it is not connected to a stage.
@property (weak, nonatomic, readonly) SPStage *stage;

/// The topmost object in the display tree the object is part of.
@property (weak, nonatomic, readonly) SPDisplayObject *base;

/// The transformation matrix of the object relative to its parent.
/// @returns CAUTION: not a copy, but the actual object!
@property (nonatomic, copy) SPMatrix *transformationMatrix;

/// The name of the display object (default: nil). Used by `childByName:` of display object containers.
@property (nonatomic, copy) NSString *name;

/// The filter that is attached to the display object. Beware that you should NOT use the same
/// filter on more than one object (for performance reasons).
@property (nonatomic, strong) SPFragmentFilter *filter;

/// The blend mode determines how the object is blended with the objects underneath. Default: AUTO
@property (nonatomic, assign) uint blendMode;

/// Indicates if an object occupies any visible area. (Which is the case when its `alpha`,
/// `scaleX` and `scaleY` values are not zero, and its `visible` property is enabled.)
@property (nonatomic, readonly) BOOL hasVisibleArea;

/// The physics body associated with the display object. Sparrow does not provide physics on its
/// own, but this property may be used by any physics library to link an object to its physical
/// body.
#ifdef SP_PHYSICS_CLASS
@property (nonatomic, strong) SP_PHYSICS_CLASS *physicsBody;
#else
@property (nonatomic, strong) id physicsBody;
#endif

@end
