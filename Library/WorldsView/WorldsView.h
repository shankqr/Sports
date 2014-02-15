//
//  WorldsView.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"

@interface WorldsView : UITableViewController

@property (nonatomic, strong) NSMutableArray *rows;
- (void)updateView;
@end
