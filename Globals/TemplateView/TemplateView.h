//
//  TemplateView.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//
@protocol TemplateDelegate;

@interface TemplateView : UIViewController
{
    UIView *tabButtonsContainerView;
	UIView *contentContainerView;
	UIImageView *indicatorImageView;
    UIImageView *backgroundImage;
    UILabel *titleLabel;
    UILabel *currencyLabel;
    UIButton *buyButton;
    UIButton *closeButton;
    NSArray *subViewControllers;
    NSMutableArray *pushedViewController;
    NSInteger frameType;
    BOOL backActive;
}
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *currencyLabel;
@property (nonatomic, strong) IBOutlet UIButton *buyButton;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) UIView *tabButtonsContainerView;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, strong) NSMutableArray *pushedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) NSInteger frameType;
@property (nonatomic, weak) id <TemplateDelegate> delegate;
- (void)cleanView;
- (void)updateView;
- (void)back;
- (void)pushNav:(UIViewController *)view;
- (UIViewController *)peekFromStack;
- (IBAction)closeButton_tap:(id)sender;
- (IBAction)buy_tap:(id)sender;
@end

/*
 * The delegate protocol for TemplateView.
 */
@protocol TemplateDelegate <NSObject>
@optional
- (BOOL)mh_tabBarController:(TemplateView *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)mh_tabBarController:(TemplateView *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
@end

