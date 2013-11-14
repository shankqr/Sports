//
//  MailView.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MailDetail;

@interface MailView : UITableViewController
{
	NSMutableArray *rows;
    MailDetail *mailDetail;
}
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) MailDetail *mailDetail;
- (void)updateView;
@end