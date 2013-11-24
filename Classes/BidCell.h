//
//  BidCell.h
//  FFC
//
//  Created by Shankar on 3/19/11.
//  Copyright 2011 TAPFANTASY. All rights reserved.
//

@interface BidCell : UITableViewCell 
{
    UILabel *userLabel;
    UILabel *messageLabel;
}
@property (nonatomic, strong) IBOutlet UILabel *userLabel;
@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@end
