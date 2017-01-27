//
//  DynamicTVC.h
//  ShankarXyrality
//
//  Created by Shankar on 25/12/2016.
//  Copyright © 2016 Shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *ui_cells_array;

- (void)updateView;
- (NSDictionary *)getRowData:(NSIndexPath *)indexPath;

@end
