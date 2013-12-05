//
//  AllianceCup.h
//  Sports
//
//  Created by Shankar on 12/6/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@interface AllianceCup : UITableViewController
{
	NSString *filter;
	NSArray *matches;
	NSString *selected_clubid;
	NSInteger curRound;
	NSInteger totalRound;
}
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *matches;
@property (nonatomic, strong) NSString *selected_clubid;
@property (readwrite) NSInteger curRound;
@property (readwrite) NSInteger totalRound;
- (void)updateView;
@end