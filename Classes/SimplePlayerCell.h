//
//  PlayerCell.h
//  FFC
//
//  Created by Shankar on 3/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface SimplePlayerCell : UITableViewCell
{
	UIImageView *faceImage;
	UILabel *playerName;
	UILabel *playerValue;
	UILabel *position;
}
@property (nonatomic, strong) IBOutlet UIImageView *faceImage;
@property (nonatomic, strong) IBOutlet UILabel *playerName;
@property (nonatomic, strong) IBOutlet UILabel *playerValue;
@property (nonatomic, strong) IBOutlet UILabel *position;
@end
