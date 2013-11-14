//
//  StaffCell.h
//  FFC
//
//  Created by Shankar on 3/30/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface StaffCell : UITableViewCell
{
	UIImageView *faceImage;
	UILabel *staffPos;
	UILabel *staffEmployed;
	UILabel *staffCost;
}
@property (nonatomic, strong) IBOutlet UIImageView *faceImage;
@property (nonatomic, strong) IBOutlet UILabel *staffPos;
@property (nonatomic, strong) IBOutlet UILabel *staffEmployed;
@property (nonatomic, strong) IBOutlet UILabel *staffCost;
@end
