//
//  SPURLConnection.h
//  Sparrow
//
//  Created by Daniel Sperl on 17.10.13.
//  Copyright (c) 2013 Gamua. All rights reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

#import <Foundation/Foundation.h>

typedef void (^SPURLConnectionCompleteBlock)(NSData *body, NSInteger httpStatus, NSError *error);

/// A wrapper over NSURLConnection that simplifies its usage by routing the result into
/// a simple block.
@interface SPURLConnection : NSObject <NSURLConnectionDelegate>

/// --------------------
/// @name Initialization
/// --------------------

/// Initializes a connection for a certain request. The request is NOT started automatically.
- (instancetype)initWithRequest:(NSURLRequest *)request;

/// -------------
/// @name Methods
/// -------------

/// Starts the request asynchronously. The callback block will be executed from the calling thread.
- (void)startWithBlock:(SPURLConnectionCompleteBlock)completeBlock;

/// Cancels an asynchronous load of a request.
- (void)cancel;

@end