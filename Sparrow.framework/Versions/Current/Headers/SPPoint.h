//
//  SPPoint.h
//  Sparrow
//
//  Created by Daniel Sperl on 23.03.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKMath.h>
#import <Sparrow/SPPoolObject.h>

/** The SPPoint class describes a two dimensional point or vector. */

@interface SPPoint : SPPoolObject <NSCopying>
{
  @protected
    float _x;
    float _y;
}

/// --------------------
/// @name Initialization
/// --------------------

/// Initializes a point with its x and y components. _Designated Initializer_.
- (instancetype)initWithX:(float)x y:(float)y;

/// Initializes a point with the distance and angle in respect to the origin.
- (instancetype)initWithPolarLength:(float)length angle:(float)angle;

/// Factory method.
+ (instancetype)pointWithPolarLength:(float)length angle:(float)angle;

/// Factory method.
+ (instancetype)pointWithX:(float)x y:(float)y;

/// Factory method.
+ (instancetype)point;

/// -------------
/// @name Methods
// --------------

/// Adds a point to the current point and returns the resulting point.
- (SPPoint *)addPoint:(SPPoint *)point;

/// Substracts a point from the current point and returns the resulting point.
- (SPPoint *)subtractPoint:(SPPoint *)point;

/// Scales the point by a certain factor and returns the resulting point.
- (SPPoint *)scaleBy:(float)scalar;

/// Rotates the point by the given angle (in radians, CCW) and returns the resulting point.
- (SPPoint *)rotateBy:(float)angle;

/// Returns a point that has the same direction but a length of one.
- (SPPoint *)normalize;

/// Returns a point that is the inverse (negation) of this point.
- (SPPoint *)invert;

/// Returns a perpendicular vector.
- (SPPoint *)perpendicular;

/// Returns a point truncated to length.
- (SPPoint *)truncateLength:(float)maxLength;

/// Returns the dot-product of self and the given point.
- (float)dot:(SPPoint *)other;

/// Compares two points.
- (BOOL)isEqualToPoint:(SPPoint *)other;

/// Copies the values from another point into the current point.
- (void)copyFromPoint:(SPPoint *)point;

/// Sets the members of the point to the specified values.
- (void)setX:(float)x y:(float)y;

/// Creates a GLKit vector that is equivalent to this instance.
- (GLKVector2)convertToGLKVector;

/// Calculates the distance between two points.
+ (float)distanceFromPoint:(SPPoint *)p1 toPoint:(SPPoint *)p2;

/// Calculates the angle between two points.
+ (float)angleBetweenPoint:(SPPoint *)p1 andPoint:(SPPoint *)p2;

/// Determines a point between two specified points. `ratio = 0 -> p1, ratio = 1 -> p2`
+ (SPPoint *)interpolateFromPoint:(SPPoint *)p1 toPoint:(SPPoint *)p2 ratio:(float)ratio;

/// ----------------
/// @name Properties
/// ----------------

/// The x-Coordinate of the point.
@property (nonatomic, assign) float x;

/// The y-Coordinate of the point.
@property (nonatomic, assign) float y;

/// The distance to the origin (or the length of the vector).
@property (readonly) float length;

/// The squared distance to the origin (or the squared length of the vector)
@property (readonly) float lengthSquared;

/// The angle between the positive x-axis and the point (in radians, CCW).
@property (readonly) float angle;

/// Returns true if this point is in the origin (x and y equal zero).
@property (readonly) BOOL isOrigin;

@end
