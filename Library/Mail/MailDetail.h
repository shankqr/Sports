//
//  MailDetail.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MailReply;

@interface MailDetail : UITableViewController
{
    NSDictionary *mailData;
	NSArray *rows;
    MailReply *mailReply;
}
@property (nonatomic, strong) NSDictionary *mailData;
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) MailReply *mailReply;
- (void)updateView;
- (void)scrollUp;
- (void)getReplies;
@end
