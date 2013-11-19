//
//  AllianceCreate.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface AllianceCreate : UITableViewController
{
	NSArray *rows;
    UITableViewCell *inputCell1;
    UITableViewCell *inputCell2;
    NSString *nameText;
    NSString *descriptionText;
    BOOL isCreate;
}
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) UITableViewCell *inputCell1;
@property (nonatomic, strong) UITableViewCell *inputCell2;
@property (nonatomic, strong) NSString *nameText;
@property (nonatomic, strong) NSString *descriptionText;
- (void)updateView:(BOOL)createMode;
@end
