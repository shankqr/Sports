//
//  NewsCell.h
//  FFC
//
//  Created by Shankar on 4/2/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface NewsCell : UITableViewCell
{
	UILabel *newsDay;
	UILabel *newsDate;
	UILabel *newsMonth;
	UILabel *newsHeader;
}
@property (nonatomic, strong) IBOutlet UILabel *newsDay;
@property (nonatomic, strong) IBOutlet UILabel *newsDate;
@property (nonatomic, strong) IBOutlet UILabel *newsMonth;
@property (nonatomic, strong) IBOutlet UILabel *newsHeader;
@end
