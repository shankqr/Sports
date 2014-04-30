//
//  TemplateView.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "TemplateView.h"
#import "Globals.h"
#import "CustomBadge.h"

@implementation TemplateView

static const NSInteger TagOffset = 1000;

- (void)closeButton_tap:(id)sender
{
    [[Globals i] closeTemplate];
}

- (void)cleanView
{
    [self.contentContainerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self.tabButtonsContainerView removeFromSuperview];
    [self.contentContainerView removeFromSuperview];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"CloseAllTemplate"])
    {
        [[Globals i] closeTemplate];
    }
}

- (void)updateView
{
    CGRect full_frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);

    self.view = [[UIView alloc] initWithFrame:full_frame];
    self.view.backgroundColor = [[UIColor alloc] initWithRed:0./255 green:0./255 blue:0./255 alpha:0.6];
    
    CGRect rect = CGRectMake(SCREEN_OFFSET_X, SCREEN_OFFSET_MAINHEADER_Y, UIScreen.mainScreen.bounds.size.width, self.tabBarHeight);
    
    self.tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
    self.contentContainerView = [[UIView alloc] initWithFrame:rect];
    self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseAllTemplate"
                                               object:nil];
    
    if (self.backgroundImage == nil)
    {
        self.backgroundImage = [[UIImageView alloc] initWithFrame:full_frame];
        [self.view addSubview:self.backgroundImage];
    }
    
    if (UIScreen.mainScreen.bounds.size.height == 568)
    {
        [self.backgroundImage setImage:[UIImage imageNamed:@"skin_default_4.png"]];
    }
    else if (UIScreen.mainScreen.bounds.size.height == 1024)
    {
        [self.backgroundImage setImage:[UIImage imageNamed:@"skin_default_ipad.png"]];
    }
    else
    {
        [self.backgroundImage setImage:[UIImage imageNamed:@"skin_default.png"]];
    }
    
    CGFloat side_spacing = 56.0*SCALE_IPAD;
    CGRect title_frame = CGRectMake(side_spacing, 8.0f*SCALE_IPAD, UIScreen.mainScreen.bounds.size.width-side_spacing*2, 30*SCALE_IPAD);
    
    if (self.titleLabel == nil)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:title_frame];
        [self.titleLabel setNumberOfLines:1];
        [self.titleLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        self.titleLabel.minimumScaleFactor = 1.0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:self.titleLabel];
    }
    [self.titleLabel setText:self.title];
    
    if (self.closeButton == nil)
    {
        self.closeButton = [[UIButton alloc] init];
        UIImage *btn_image = [UIImage imageNamed:@"button_close1"];
        CGSize btnSize = CGSizeMake(btn_image.size.width * SCALE_IPAD, btn_image.size.height * SCALE_IPAD);
        [self.closeButton setFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-btnSize.width, 0.0f, btnSize.width, btnSize.height)];
        [self.closeButton setBackgroundImage:btn_image forState:UIControlStateNormal];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"button_close1_hvr"] forState:UIControlStateHighlighted];
        [self.closeButton addTarget:self action:@selector(closeButton_tap:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.closeButton];
    }

    if (self.frameType == 0) //No borders, fullscreen
    {
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = self.view.bounds.size.width;
        rect.size.height = UIScreen.mainScreen.bounds.size.height;
    }
    else if (self.frameType == 1) //1 border at top
    {
        rect.origin.x = SCREEN_OFFSET_X;
        rect.origin.y = SCREEN_OFFSET_MAINHEADER_Y;
        rect.size.width = self.view.bounds.size.width;
        rect.size.height = UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_MAINHEADER_Y;
    }
    else if (self.frameType == 2) //Fullscreen and no close button
    {
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = self.view.bounds.size.width;
        rect.size.height = UIScreen.mainScreen.bounds.size.height;
        
        self.closeButton.enabled = NO;
        self.closeButton.hidden = YES;
    }
    else if (self.frameType == 3) //Fullscreen chart dialog box
    {
        rect.origin.x = SCREEN_OFFSET_X + CHART_CONTENT_MARGIN;
        rect.origin.y = SCREEN_OFFSET_MAINHEADER_Y;
        rect.size.width = self.view.bounds.size.width - CHART_CONTENT_MARGIN*2;
        rect.size.height = UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_MAINHEADER_Y - CHART_CONTENT_MARGIN;
        
        [self.titleLabel setTextColor:[UIColor blackColor]];
        
        UIImage *bkg_image = [[Globals i] dynamicImage:full_frame prefix:@"bkg6"];
        [self.backgroundImage setImage:bkg_image];
        
        UIImage *btn_image = [UIImage imageNamed:@"button_close2"];
        CGSize btnSize = CGSizeMake(btn_image.size.width * SCALE_IPAD, btn_image.size.height * SCALE_IPAD);
        
        [self.closeButton setFrame:CGRectMake(self.closeButton.frame.origin.x-CHART_CONTENT_MARGIN, self.closeButton.frame.origin.y, btnSize.width, btnSize.height)];
        [self.closeButton setBackgroundImage:btn_image forState:UIControlStateNormal];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"button_close2_hvr"] forState:UIControlStateHighlighted];
    }
    else if (self.frameType == 4) //MainView as background (Plugin system)
    {
        [self.view setFrame:CGRectMake(SCREEN_OFFSET_X,
                                       SCREEN_OFFSET_MAINHEADER_Y,
                                       UIScreen.mainScreen.bounds.size.width,
                                       PLUGIN_HEIGHT)];
        
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = self.view.bounds.size.width;
        rect.size.height = self.view.bounds.size.height;
        
        self.titleLabel.hidden = YES;
        self.closeButton.enabled = NO;
        self.closeButton.hidden = YES;
        
        if (iPad)
        {
            [self.backgroundImage setImage:[UIImage imageNamed:@"skin_plugin_ipad.png"]];
        }
        else
        {
            [self.backgroundImage setImage:[UIImage imageNamed:@"skin_plugin_4.png"]];
        }
        [self.backgroundImage setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    else if (self.frameType == 5) //MainView as background (overlap header above)
    {
        [self.view setFrame:CGRectMake(SCREEN_OFFSET_X,
                                       0,
                                       UIScreen.mainScreen.bounds.size.width,
                                       UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_BOTTOM)];
        
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = self.view.bounds.size.width;
        rect.size.height = self.view.bounds.size.height;
        
        self.titleLabel.hidden = YES;
        self.closeButton.enabled = NO;
        self.closeButton.hidden = YES;
        
        if (iPad)
        {
            [self.backgroundImage setImage:[UIImage imageNamed:@"skin_plugin_ipad.png"]];
        }
        else
        {
            [self.backgroundImage setImage:[UIImage imageNamed:@"skin_plugin_4.png"]];
        }
        [self.backgroundImage setFrame:CGRectMake(0, SCREEN_OFFSET_MAINHEADER_Y, self.view.bounds.size.width, self.view.bounds.size.height-SCREEN_OFFSET_MAINHEADER_Y)];
    }
    else if (self.frameType == 6 || self.frameType == 7) //Table fit to screen dialog box style
    {
        CGFloat height = 0;
        CGFloat width = 0;
        if ([self.viewControllers[0] isKindOfClass:[UITableViewController class]])
        {
            UITableViewController *tvc = (UITableViewController *)self.viewControllers[0];
            CGRect rect = [tvc.tableView rectForSection:[tvc.tableView numberOfSections] - 1];
            width = UIScreen.mainScreen.bounds.size.width-DIALOG_CONTENT_MARGIN*2;
            height = CGRectGetMaxY(rect)+DIALOG_CONTENT_MARGIN;
            
            tvc.tableView.scrollEnabled = NO;
        }
        else
        {
            UIViewController *vc = (UIViewController *)self.viewControllers[0];
            width = vc.view.frame.size.width;
            height = vc.view.frame.size.height;
        }
        
        CGFloat rect_y = (UIScreen.mainScreen.bounds.size.height-height)/2.0f - DIALOG_CONTENT_MARGIN;
        if (rect_y < 0.0f)
        {
            rect_y = 0.0f;
        }
        
        rect.origin.x = (UIScreen.mainScreen.bounds.size.width-width)/2.0f;
        rect.origin.y = rect_y;
        rect.size.width = width;
        rect.size.height = height;
        
        CGFloat spacing = 10.0f*SCALE_IPAD;
        
        self.titleLabel.hidden = YES;
        
        if (self.frameType == 6)
        {
            [self.closeButton setFrame:CGRectMake(rect.origin.x+width+spacing-self.closeButton.bounds.size.width, rect.origin.y-spacing, self.closeButton.bounds.size.width, self.closeButton.bounds.size.height)];
            [self.closeButton setBackgroundImage:[UIImage imageNamed:@"button_close2"] forState:UIControlStateNormal];
            [self.closeButton setBackgroundImage:[UIImage imageNamed:@"button_close2_hvr"] forState:UIControlStateHighlighted];
        }
        else
        {
            self.closeButton.hidden = YES;
        }
        
        UIImage *bkg_image = [[Globals i] dynamicImage:rect prefix:@"bkg6"];
        [self.backgroundImage setImage:bkg_image];
        [self.backgroundImage setFrame:rect];
    }
    
    if (self.headerView != nil) //Has a header view
    {
        [self.view addSubview:self.headerView.view];
        
        rect.origin.y = rect.origin.y + self.headerView.view.frame.size.height;
        rect.size.height = rect.size.height - self.headerView.view.frame.size.height;
    }
    
    if([self.viewControllers count] > 1) //Tab buttons above
    {
        [self.tabButtonsContainerView setFrame:rect];
        self.tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.tabButtonsContainerView];
        
        rect.origin.y = rect.origin.y + self.tabBarHeight;
        rect.size.height = rect.size.height - self.tabBarHeight;
    }
    
    [self.contentContainerView setFrame:rect];
	[self.view addSubview:self.contentContainerView];
    
    //Resize all viewcontrollers to fit content frame
    for (UIViewController *viewController in self.viewControllers)
    {
        [[viewController view] setFrame:rect];
    }
    
    [self.view bringSubviewToFront:self.closeButton]; //Make sure close button is always infront

	[self reloadTabButtons];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
    
	[self layoutTabButtons];
}

- (void)reloadTabButtons
{
	[self removeTabButtons];
	[self addTabButtons];
    
	// Force redraw of the previously active tab.
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)addTabButtons
{
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TagOffset + index;
		button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
		button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        
		UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
		button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
		button.imageEdgeInsets = viewController.tabBarItem.imageInsets;
		[button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
        
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        CustomBadge *badge = [CustomBadge customBadgeWithString:@"0"
                                                withStringColor:[UIColor whiteColor]
                                                 withInsetColor:[UIColor redColor]
                                                 withBadgeFrame:NO
                                            withBadgeFrameColor:[UIColor whiteColor]
                                                      withScale:0.75*SCALE_IPAD
                                                    withShining:YES];
        
        [badge setFrame:CGRectMake(0, 0, badge.frame.size.width, badge.frame.size.height)];
        badge.hidden = YES;
        [button addSubview:badge];
        
		[self.tabButtonsContainerView addSubview:button];
        
		++index;
	}
}

- (void)setBadgeNumber:(NSUInteger)tabIndex number:(NSUInteger)number
{
    UIButton *tabButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + tabIndex];
    
    for(UIView *viewRef in tabButton.subviews)
    {
        if([viewRef isKindOfClass:[CustomBadge class]])
        {
            CustomBadge *tabBadge = (CustomBadge *)viewRef;
            [tabBadge autoBadgeSizeWithString:[@(number) stringValue]];
            [tabBadge setFrame:CGRectMake(tabButton.frame.size.width-tabBadge.frame.size.width, 0, tabBadge.frame.size.width, tabBadge.frame.size.height)];
            tabBadge.hidden = NO;
            
            if (number == 0)
            {
                tabBadge.hidden = YES;
            }
        }
    }
}

- (void)removeTabButtons
{
	while ([self.tabButtonsContainerView.subviews count] > 0)
	{
		[[self.tabButtonsContainerView.subviews lastObject] removeFromSuperview];
	}
}

- (void)layoutTabButtons
{
	NSUInteger index = 0;
	NSUInteger count = [self.viewControllers count];
    
	CGRect rect = CGRectMake(0.0f, 0.0f, floorf(UIScreen.mainScreen.bounds.size.width / count), self.tabBarHeight);
    
	NSArray *buttons = [self.tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
	{
		if (index == count - 1)
        {
			rect.size.width = UIScreen.mainScreen.bounds.size.width - rect.origin.x;
        }
        
		button.frame = rect;
		rect.origin.x += rect.size.width;
        
        [self deselectTabButton:button];
        
		if (index == self.selectedIndex)
        {
			[self selectTabButton:button];
        }
        
		++index;
	}
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
	UIViewController *oldSelectedViewController = self.selectedViewController;
    
	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}
    
	_viewControllers = [newViewControllers copy];
    
	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
    {
		_selectedIndex = newIndex;
    }
	else if (newIndex < [_viewControllers count])
    {
		_selectedIndex = newIndex;
    }
	else
    {
		_selectedIndex = 0;
    }
    
	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}
    
	if ([self isViewLoaded])
    {
		[self reloadTabButtons];
    }
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    
	if ([self.delegate respondsToSelector:@selector(mh_tabBarController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = (self.viewControllers)[newSelectedIndex];
		if (![self.delegate mh_tabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}
    
	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController;
		UIViewController *toViewController;
        
        [self.contentContainerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
		if (_selectedIndex != NSNotFound)
		{
			UIButton *fromButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
		}
        
		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;
        
		UIButton *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}
        
		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
		{
			toViewController.view.frame = self.contentContainerView.bounds;
			[self.contentContainerView addSubview:toViewController.view];
			//[self centerIndicatorOnButton:toButton];
            
			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else if (animated)
		{
			CGRect rect = self.contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;
            
			toViewController.view.frame = rect;
			self.tabButtonsContainerView.userInteractionEnabled = NO;
            
			[self transitionFromViewController:fromViewController
                              toViewController:toViewController
                                      duration:0.3f
                                       options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                                    animations:^
             {
                 CGRect rect = fromViewController.view.frame;
                 if (oldSelectedIndex < newSelectedIndex)
                     rect.origin.x = -rect.size.width;
                 else
                     rect.origin.x = rect.size.width;
                 
                 fromViewController.view.frame = rect;
                 toViewController.view.frame = self.contentContainerView.bounds;
                 //[self centerIndicatorOnButton:toButton];
             }
                                    completion:^(BOOL finished)
             {
                 self.tabButtonsContainerView.userInteractionEnabled = YES;
                 
                 if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
                     [self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
             }];
		}
		else  // not animated
		{
			[fromViewController.view removeFromSuperview];
            
			toViewController.view.frame = self.contentContainerView.bounds;
			[self.contentContainerView addSubview:toViewController.view];
			//[self centerIndicatorOnButton:toButton];
            
			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
}

- (UIViewController *)selectedViewController
{
	if (self.selectedIndex != NSNotFound)
    {
		return (self.viewControllers)[self.selectedIndex];
    }
	else
    {
		return nil;
    }
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
    {
		[self setSelectedIndex:index animated:animated];
    }
}

- (void)tabButtonPressed:(UIButton *)sender
{
	[self setSelectedIndex:sender.tag - TagOffset animated:NO];
}

#pragma mark - Change these methods to customize the look of the buttons

- (void)selectTabButton:(UIButton *)button
{
	[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
	UIImage *image_h = [[Globals i] dynamicImage:button.frame prefix:@"tab1_h"];
	[button setBackgroundImage:image_h forState:UIControlStateNormal];
	[button setBackgroundImage:image_h forState:UIControlStateHighlighted];
	
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)deselectTabButton:(UIButton *)button
{
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
	UIImage *image_h = [[Globals i] dynamicImage:button.frame prefix:@"tab1_h"];
    UIImage *image_n = [[Globals i] dynamicImage:button.frame prefix:@"tab1"];
	[button setBackgroundImage:image_n forState:UIControlStateNormal];
	[button setBackgroundImage:image_h forState:UIControlStateHighlighted];
    
	[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (CGFloat)tabBarHeight
{
	return 40.0f * SCALE_IPAD;
}

@end
