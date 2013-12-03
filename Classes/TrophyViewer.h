//
//  TrophyViewer.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//


@interface TrophyViewer : UITableViewController <UIAlertViewDelegate>
{
	
	NSMutableArray *trophies;
	NSString *selected_trophy;
}

@property (nonatomic, strong) NSMutableArray *trophies;
@property (nonatomic, strong) NSString *selected_trophy;
- (void)updateView;
@end
