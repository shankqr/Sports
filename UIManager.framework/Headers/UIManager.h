//
//  UIManager.h
//  Kingdom Game
//
//  Created by Shankar on 6/9/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIManager/DynamicTVC.h>
#import <UIManager/DynamicCell.h>
#import <UIManager/CellView.h>
#import <UIManager/RowView.h>
#import <UIManager/DCFineTuneSlider.h>
#import <UIManager/Colours.h>
#import <UIManager/TemplateView.h>
#import <UIManager/JCNotificationCenter.h>
#import <UIManager/JCNotificationBannerPresenter.h>
#import <UIManager/JCNotificationBannerPresenterSmokeStyle.h>
#import <UIManager/CustomBadge.h>
#import <UIManager/DialogBoxView.h>
#import <UIManager/MarqueeLabel.h>
#import <UIManager/ProgressView.h>

#define iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define SCALE_IPAD (iPad ? 2.0f : 1.0f)
#define CHART_CONTENT_MARGIN (10.0f*SCALE_IPAD)
#define DIALOG_CONTENT_MARGIN (20.0f*SCALE_IPAD)
#define DIALOG_CELL_WIDTH (CELL_CONTENT_WIDTH - DIALOG_CONTENT_MARGIN*3)
#define SCREEN_OFFSET_BOTTOM (83.0f*SCALE_IPAD)
#define SCREEN_OFFSET_X (0.0f*SCALE_IPAD)
#define SCREEN_OFFSET_MAINHEADER_Y (43.0f*SCALE_IPAD)
#define PLUGIN_HEIGHT (UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_MAINHEADER_Y - SCREEN_OFFSET_BOTTOM)
#define CELL_CONTENT_WIDTH UIScreen.mainScreen.bounds.size.width
#define DEFAULT_FONT @"TrebuchetMS"
#define DEFAULT_FONT_BOLD @"TrebuchetMS-Bold"
#define DEFAULT_FONT_SIZE (11.0f*SCALE_IPAD)

//Template Frame Types
#define FRAME_FullScreen 0
#define FRAME_BorderTop 1
#define FRAME_FullScreenNoCloseButton 2
#define FRAME_FullScreenChart 3
#define FRAME_Plugin 4
#define FRAME_PluginOverlapHeader 5
#define FRAME_TableFit 6
#define FRAME_TableFitNoCloseButton 7
#define FRAME_TableFitNotAlwaysOntop 8
#define FRAME_TableFitMapDialog 9
#define FRAME_BorderTopFullBackgroundImage 10

@interface UIManager : NSObject

@property (nonatomic, strong) NSString *tabViewTitle;

//UI Methods
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType :(NSInteger)selectedIndex :(NSArray *)headerView;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType :(NSInteger)selectedIndex;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title;
- (void)closeTemplate;
- (void)showDialog:(NSString *)l1 title:(NSString*)frameTitle;
- (void)showDialog:(NSString *)l1;
- (void)showDialogBlock:(NSString *)l1 title:(NSString*)frameTitle type:(NSInteger)frameType :(DialogBlock)block;
- (void)showDialogBlock:(NSString *)l1 :(NSInteger)frameType :(DialogBlock)block;
- (void)showDialogBlockRow:(NSMutableArray *)rows title:(NSString*)frameType type:(NSInteger)frameType :(DialogBlock)block;
- (void)flushViewControllerStack;
- (void)pushViewControllerStack:(UIViewController *)view;
- (UIViewController *)popViewControllerStack;
- (UIViewController *)peekViewControllerStack;
- (UIViewController *)firstViewControllerStack;
- (BOOL)isCurrentView:(UIViewController *)view;
- (NSString *)currentViewTitle;
- (void)closeAllTemplate;
- (void)setTemplateBadgeNumber:(NSUInteger)tabIndex number:(NSUInteger)number;
- (UIButton *)buttonWithTitle:(NSString *)title
                       target:(id)target
                     selector:(SEL)selector
                        frame:(CGRect)frame
                  imageNormal:(UIImage *)imageNormal
             imageHighlighted:(UIImage *)imageHighlighted
                imageCentered:(BOOL)imageCentered
                darkTextColor:(BOOL)darkTextColor;
- (UIImage *)dynamicImage:(CGRect)frame prefix:(NSString *)prefix;
- (UIImage *)colorImage:(NSString *)imageName :(UIColor *)color;
- (UIButton *)dynamicButtonWithTitle:(NSString *)title
                              target:(id)target
                            selector:(SEL)selector
                               frame:(CGRect)frame
                                type:(NSString *)type;

- (void)setTemplateFrameType:(NSInteger)frame_type;

+ (UIManager *)i;

- (UIImage *)imageNamedCustom:(NSString *)image_name;

@end
