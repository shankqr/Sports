//
//  ProductCell.h
//  FFC
//
//  Created by Shankar on 3/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface ProductCell : UITableViewCell
{
	UIImageView *productImage;
	UIImageView *star1;
	UIImageView *star2;
	UIImageView *star3;
	UIImageView *star4;
	UIImageView *star5;
	UILabel *productName;
	UILabel *productValue;
	UILabel *productDesc;
}
@property (nonatomic, strong) IBOutlet UIImageView *productImage;
@property (nonatomic, strong) IBOutlet UIImageView *star1;
@property (nonatomic, strong) IBOutlet UIImageView *star2;
@property (nonatomic, strong) IBOutlet UIImageView *star3;
@property (nonatomic, strong) IBOutlet UIImageView *star4;
@property (nonatomic, strong) IBOutlet UIImageView *star5;
@property (nonatomic, strong) IBOutlet UILabel *productName;
@property (nonatomic, strong) IBOutlet UILabel *productValue;
@property (nonatomic, strong) IBOutlet UILabel *productDesc;
@end
