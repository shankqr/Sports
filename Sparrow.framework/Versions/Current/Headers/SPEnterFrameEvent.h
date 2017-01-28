//
//  SPEnterFrameEvent.h
//  Sparrow
//
//  Created by Daniel Sperl on 30.04.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>
#import <Sparrow/SPEvent.h>

SP_EXTERN NSString *const SPEventTypeEnterFrame;

/** ------------------------------------------------------------------------------------------------

 An SPEnterFrameEvent is triggered once per frame and is dispatched to all objects in the
 display tree.
 
 It contains information about the time that has passed since the last frame. That way, you 
 can easily make animations that are independent of the frame rate, but take the passed time
 into account.
 
------------------------------------------------------------------------------------------------- */

@interface SPEnterFrameEvent : SPEvent

/// --------------------
/// @name Initialization
/// --------------------

/// Initializes an enter frame event with the passed time. _Designated Initializer_.
- (instancetype)initWithType:(NSString *)type bubbles:(BOOL)bubbles passedTime:(double)seconds;

/// Initializes an enter frame event that does not bubble (recommended).
- (instancetype)initWithType:(NSString *)type passedTime:(double)seconds;

/// Factory method.
+ (instancetype)eventWithType:(NSString *)type passedTime:(double)seconds;

/// ----------------
/// @name Properties
/// ----------------

/// The time that has passed since the last frame (in seconds).
@property (nonatomic, readonly) double passedTime;

@end
