//
//  TemplateView.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@protocol TemplateDelegate;

@interface TemplateView : UIViewController

@property (nonatomic, strong) UILabel *currencyLabel;
@property (nonatomic, strong) UIButton *buyButton;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIViewController *headerView;
@property (nonatomic, strong) UIView *tabButtonsContainerView;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) NSInteger frameType;
@property (nonatomic, weak) id <TemplateDelegate> delegate;
- (void)cleanView;
- (void)updateView;
- (void)setBadgeNumber:(NSUInteger)tabIndex number:(NSUInteger)number;
- (void)closeButton_tap:(id)sender;
@end

@protocol TemplateDelegate <NSObject>
@optional
- (BOOL)mh_tabBarController:(TemplateView *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)mh_tabBarController:(TemplateView *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
@end

