//
//  OverviewCell.h
//  FFC
//
//  Created by Shankar on 11/21/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

@interface OverviewCell : UITableViewCell
{
	UILabel *divisionLabel;
	UILabel *markerLabel;
}
@property (nonatomic, strong) IBOutlet UILabel *divisionLabel;
@property (nonatomic, strong) IBOutlet UILabel *markerLabel;
@end
