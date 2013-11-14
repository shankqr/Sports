//
//  AllianceCell.h
//  FFC
//
//  Created by Shankar on 3/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface AllianceCell : UITableViewCell
{
    UILabel *num;
	UILabel *name;
	UILabel *members;
    UILabel *score;
    UILabel *endLabel;
}
@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (nonatomic, strong) IBOutlet UILabel *num;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *members;
@property (nonatomic, strong) IBOutlet UILabel *score;
@end
