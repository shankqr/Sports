//
//  TacticsView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@class MainView;
@interface TacticsView : UIViewController <UIActionSheetDelegate, UIScrollViewDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	NSString *tid;
	UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSMutableArray *viewControllers;
	UIImageView *unlockLogo;
    BOOL pageControlUsed;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) IBOutlet UIImageView *tacticsLogo;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
- (IBAction)changePage:(id)sender;
- (void)updateView;
- (void)showTactics;
- (void)loadScrollViewWithPage:(int)page;
@end
