//
//  TacticsView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface TacticsView : UIViewController <UIActionSheetDelegate, UIScrollViewDelegate>
{
	NSString *tid;
	UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSMutableArray *viewControllers;
	UIImageView *unlockLogo;
    NSInteger total_tactics;
    BOOL pageControlUsed;
}
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (readwrite) NSInteger total_tactics;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
- (IBAction)changePage:(id)sender;
- (void)updateView;
@end
