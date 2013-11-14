//
//  FinanceCell.h
//  FFC
//
//  Created by Shankar on 6/16/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface FinanceCell : UITableViewCell 
{
	UILabel *item;
	UILabel *cost1;
	UILabel *cost2;
}
@property (nonatomic, strong) IBOutlet UILabel *item;
@property (nonatomic, strong) IBOutlet UILabel *cost1;
@property (nonatomic, strong) IBOutlet UILabel *cost2;
@end
