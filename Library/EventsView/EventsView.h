//
//  EventsView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface EventsView : UITableViewController

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSString *serviceNameDetail;
@property (nonatomic, strong) NSString *serviceNameList;
@property (nonatomic, strong) NSString *serviceNameResult;
@property (nonatomic, strong) NSString *isAlliance;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, assign) NSTimeInterval b1s;

- (void)updateView;
- (void)clearView;

@end
