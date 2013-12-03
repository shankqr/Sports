//
//  PromotionView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//


@interface PromotionView : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	
	UITableView *table;
	UILabel *divisionLabel;
	UILabel *seriesLabel;
	UILabel *maxseriesLabel;
	NSString *filter;
	NSArray *leagues;
	NSString *selected_clubid;
	NSUInteger posOffset;
	NSUInteger totalRow;
}

@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UILabel *divisionLabel;
@property (nonatomic, strong) IBOutlet UILabel *seriesLabel;
@property (nonatomic, strong) IBOutlet UILabel *maxseriesLabel;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *leagues;
@property (nonatomic, strong) NSString *selected_clubid;
@property NSUInteger posOffset;
@property NSUInteger totalRow;
- (void)updateView;
- (IBAction)segmentTap:(id)sender;
@end

