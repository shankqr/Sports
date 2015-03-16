//
//  MailDetail.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface MailDetail : UITableViewController

@property (nonatomic, strong) NSDictionary *mailData;
@property (nonatomic, strong) NSDictionary *mailRow;
@property (nonatomic, strong) NSString *updateReplies;

- (void)updateView;
- (void)scrollUp;

@end
