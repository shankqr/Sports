//
//  OverView.h
//  FFC
//
//  Created by Shankar on 7/11/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface OverView : UITableViewController
{
    NSUInteger maxDivision;
	NSUInteger curDivision;
	NSUInteger curSeries;
}
@property NSUInteger maxDivision;
@property NSUInteger curDivision;
@property NSUInteger curSeries;
- (void)updateView;
@end
