//
//  LeagueCell.h
//  FFC
//
//  Created by Shankar on 7/9/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface LeagueCell : UITableViewCell
{
	UILabel *pos;
	UILabel *club;
	UILabel *played;
	UILabel *won;
	UILabel *draw;
	UILabel *lost;
	UILabel *goalfor;
	UILabel *goalagaints;
	UILabel *goaldif;
	UILabel *points;
}
@property (nonatomic, strong) IBOutlet UILabel *pos;
@property (nonatomic, strong) IBOutlet UILabel *club;
@property (nonatomic, strong) IBOutlet UILabel *played;
@property (nonatomic, strong) IBOutlet UILabel *won;
@property (nonatomic, strong) IBOutlet UILabel *draw;
@property (nonatomic, strong) IBOutlet UILabel *lost;
@property (nonatomic, strong) IBOutlet UILabel *goalfor;
@property (nonatomic, strong) IBOutlet UILabel *goalagaints;
@property (nonatomic, strong) IBOutlet UILabel *goaldif;
@property (nonatomic, strong) IBOutlet UILabel *points;
@end
