//
//  LoadingView.h
//  Sports
//
//  Created by Shankar on 11/25/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@interface LoadingView : UIViewController
{
    NSTimer *loadingTimer;
}
@property (nonatomic, strong) NSTimer *loadingTimer;
- (void)updateView;
@end
