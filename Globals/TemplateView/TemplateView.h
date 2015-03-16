//
//  TemplateView.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@protocol TemplateDelegate;

@interface TemplateView : UIViewController

@property (nonatomic, strong) UIImageView *ivBkgHeader;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *tabButtonsContainerView;
@property (nonatomic, strong) UIView *contentContainerView;

@property (nonatomic, copy) NSArray *headerView;
@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) NSUInteger frameType;

@property (nonatomic, weak) UIViewController *selectedViewController;
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

