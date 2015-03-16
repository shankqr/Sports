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

- (void)updateView;

@end
