//
//  MailReply.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface MailReply : UITableViewController
{
    NSDictionary *mailData;
	NSArray *rows;
    UITableViewCell *inputCell;
}
@property (nonatomic, strong) NSDictionary *mailData;
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) UITableViewCell *inputCell;
- (void)updateView;
@end
