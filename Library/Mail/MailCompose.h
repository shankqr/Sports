//
//  MailCompose.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface MailCompose : UITableViewController

@property (nonatomic, strong) NSString *isAlliance;
@property (nonatomic, strong) NSString *toID;
@property (nonatomic, strong) NSString *toName;
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) UITableViewCell *inputCell1;
@property (nonatomic, strong) UITableViewCell *inputCell2;

- (void)updateView;
- (void)updateInputs;

@end
