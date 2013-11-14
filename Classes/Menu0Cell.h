//
//  Menu0Cell.h
//  Mafia Tower
//
//  Created by Shankar on 1/16/12.
//  Copyright (c) 2012 TAPFANTASY. All rights reserved.
//

@interface Menu0Cell : UITableViewCell
{
    UIImageView *productIcon;
    UILabel *productTitle;
    UILabel *productInfo;
    UILabel *productBonus;
    UILabel *productTag;
    UILabel *productPrice;
    UILabel *buyLabel;
    UIButton *buyButton;
}
@property (nonatomic, strong) IBOutlet UIImageView *productIcon;
@property (nonatomic, strong) IBOutlet UILabel *productTitle;
@property (nonatomic, strong) IBOutlet UILabel *productInfo;
@property (nonatomic, strong) IBOutlet UILabel *productBonus;
@property (nonatomic, strong) IBOutlet UILabel *productTag;
@property (nonatomic, strong) IBOutlet UILabel *productPrice;
@property (nonatomic, strong) IBOutlet UILabel *buyLabel;
@property (nonatomic, strong) IBOutlet UIButton *buyButton;

@end
