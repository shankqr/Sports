//
//  AllianceCup.h
//  Sports
//
//  Created by Shankar on 12/6/13.
//  Copyright (c) 2013 TAPFANTASY. All rights reserved.
//

@interface AllianceCup : UITableViewController

@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *matches;
@property (nonatomic, strong) NSString *alliance_id;

@property (nonatomic, assign) NSInteger curRound;
@property (nonatomic, assign) NSInteger totalRound;

- (void)updateView;

@end
