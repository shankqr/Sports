//
//  EventsView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface EventsView : UITableViewController

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSString *updateOnWillAppear;
- (void)updateView;
- (void)clearView;

@end
