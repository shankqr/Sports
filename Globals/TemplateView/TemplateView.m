//
//  TemplateView.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "TemplateView.h"
#import "Globals.h"

@implementation TemplateView
@synthesize tabButtonsContainerView;
@synthesize contentContainerView;
@synthesize indicatorImageView;
@synthesize backgroundImage;
@synthesize titleLabel;
@synthesize currencyLabel;
@synthesize buyButton;
@synthesize closeButton;
@synthesize pushedViewController;
@synthesize frameType;

static const NSInteger TagOffset = 1000;

- (IBAction)closeButton_tap:(id)sender
{
    if (self.backActive)
    {
        [self backorclose];
    }
    else
    {
        [[Globals i] closeTemplate];
    }
}

- (IBAction)buy_tap:(id)sender
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GotoBuy"
     object:self];
}

- (void)cleanView
{
    [self.contentContainerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self.tabButtonsContainerView removeFromSuperview];
    [self.indicatorImageView removeFromSuperview];
    [self.contentContainerView removeFromSuperview];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.backActive = NO;
    
    CGRect rect = CGRectMake(SCREEN_OFFSET_X, SCREEN_OFFSET_MAINHEADER_Y, SCREEN_WIDTH, self.tabBarHeight);
    
    tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
    indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TemplateIndicator"]];
    contentContainerView = [[UIView alloc] initWithFrame:rect];
    contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHeader"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"UpdateHeader"])
    {
        [currencyLabel setText:[[Globals i] numberFormat:[[Globals i] wsClubData][@"currency_second"]]];
    }
}

- (void)updateView
{
    if (UIScreen.mainScreen.bounds.size.height == 568)
    {
        [backgroundImage setImage:[UIImage imageNamed:@"skin_default_4.png"]];
        [backgroundImage setFrame:CGRectMake(0, 0, 320, UIScreen.mainScreen.bounds.size.height)];
    }
    
    [titleLabel setText:self.title];
    [currencyLabel setText:[[Globals i] numberFormat:[[Globals i] wsClubData][@"currency_second"]]];
    
    pushedViewController = [[NSMutableArray alloc] initWithCapacity:[self.viewControllers count]];
    for (NSUInteger i=0; i < [self.viewControllers count]; i++)
    {
        pushedViewController[i] = [[NSMutableArray alloc] init];
    }
    
    CGRect rect = CGRectMake(SCREEN_OFFSET_X, SCREEN_OFFSET_MAINHEADER_Y, SCREEN_WIDTH, self.tabBarHeight);

    if([self.viewControllers count] > 1) //Tab buttons above
    {
        [tabButtonsContainerView setFrame:rect];
        tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:tabButtonsContainerView];
        
        rect.origin.y = self.tabBarHeight + SCREEN_OFFSET_MAINHEADER_Y;
        rect.size.height = UIScreen.mainScreen.bounds.size.height - rect.origin.y - SCREEN_OFFSET_BOTTOM;
        
        [self.view addSubview:indicatorImageView];
    }
    else
    {
        if (frameType == 0) //No borders, fullscreen
        {
            rect.origin.x = 0;
            rect.origin.y = 0;
            rect.size.width = self.view.bounds.size.width;
            rect.size.height = UIScreen.mainScreen.bounds.size.height;
        }
        if (frameType == 1) //1 border at top
        {
            rect.origin.x = SCREEN_OFFSET_X;
            rect.origin.y = SCREEN_OFFSET_MAINHEADER_Y;
            rect.size.width = self.view.bounds.size.width;
            rect.size.height = UIScreen.mainScreen.bounds.size.height - rect.origin.y - SCREEN_OFFSET_BOTTOM;
        }
        if (frameType == 2) //Fullscreen and no close button
        {
            rect.origin.x = 0;
            rect.origin.y = 0;
            rect.size.width = self.view.bounds.size.width;
            rect.size.height = UIScreen.mainScreen.bounds.size.height;
            
            closeButton.enabled = NO;
            closeButton.hidden = YES;
        }
        if (frameType == 3) //Dialog box style
        {
            rect.origin.x = 25.0f + DIALOG_CONTENT_MARGIN;
            rect.origin.y = 75.0f + SCREEN_OFFSET_DIALOGHEADER_Y;
            rect.size.width = 260.0f*SCALE_IPAD - DIALOG_CONTENT_MARGIN*2;
            rect.size.height = 270.0f*SCALE_IPAD - SCREEN_OFFSET_DIALOGHEADER_Y*2;
            
            buyButton.hidden = YES;
            titleLabel.hidden = YES;
            currencyLabel.hidden = YES;
            
            [closeButton setFrame:CGRectMake(285.0f, 75.0f, closeButton.bounds.size.width, closeButton.bounds.size.height)];
            
            [backgroundImage setImage:[UIImage imageNamed:@"skin_dialog.png"]];
            [backgroundImage setFrame:CGRectMake(25.0f, 75.0f, 260.0f*SCALE_IPAD, 270.0f*SCALE_IPAD)];
        }
    }
    
    [contentContainerView setFrame:rect];
	[self.view addSubview:contentContainerView];
    
    //Resize all viewcontrollers to fit content frame
    for (UIViewController *viewController in self.viewControllers)
    {
        [[viewController view] setFrame:rect];
    }
    
    [self.view bringSubviewToFront:self.closeButton]; //Make sure close button is always infront

    
	[self reloadTabButtons];
    
    //[self layoutTabButtons];
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
		button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SMALL_SIZE];
		button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        
		UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
		button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
		button.imageEdgeInsets = viewController.tabBarItem.imageInsets;
		[button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
		[button setImage:viewController.tabBarItem.image forState:UIControlStateNormal];
        
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
		[self deselectTabButton:button];
		[tabButtonsContainerView addSubview:button];
        
		++index;
	}
}

- (void)removeTabButtons
{
	while ([tabButtonsContainerView.subviews count] > 0)
	{
		[[tabButtonsContainerView.subviews lastObject] removeFromSuperview];
	}
}

- (void)layoutTabButtons
{
	NSUInteger index = 0;
	NSUInteger count = [self.viewControllers count];
    
	CGRect rect = CGRectMake(0.0f, 0.0f, floorf(SCREEN_WIDTH / count), self.tabBarHeight);
    
	indicatorImageView.hidden = YES;
    
	NSArray *buttons = [tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
	{
		if (index == count - 1)
        {
			rect.size.width = SCREEN_WIDTH - rect.origin.x;
        }
        
		button.frame = rect;
		rect.origin.x += rect.size.width;
        
		if (index == self.selectedIndex)
        {
			[self centerIndicatorOnButton:button];
        }
        
		++index;
	}
}

- (void)centerIndicatorOnButton:(UIButton *)button
{
	CGRect rect = indicatorImageView.frame;
	rect.origin.x = SCREEN_OFFSET_X + button.center.x - floorf(indicatorImageView.frame.size.width/2.0f);
	rect.origin.y = SCREEN_OFFSET_MAINHEADER_Y + self.tabBarHeight - indicatorImageView.frame.size.height;
	indicatorImageView.frame = rect;
	indicatorImageView.hidden = NO;
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
        
        [contentContainerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
		if (_selectedIndex != NSNotFound)
		{
			UIButton *fromButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
		}
        
		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;
        
		UIButton *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}
        
		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
		{
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];
            
			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else if (animated)
		{
			CGRect rect = contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;
            
			toViewController.view.frame = rect;
			tabButtonsContainerView.userInteractionEnabled = NO;
            
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
                 toViewController.view.frame = contentContainerView.bounds;
                 [self centerIndicatorOnButton:toButton];
             }
                                    completion:^(BOOL finished)
             {
                 tabButtonsContainerView.userInteractionEnabled = YES;
                 
                 if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
                     [self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
             }];
		}
		else  // not animated
		{
			[fromViewController.view removeFromSuperview];
            
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];
            
			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
}

- (void)pushToStack:(UIViewController *)view
{
    if(pushedViewController[self.selectedIndex] == nil)
    {
        pushedViewController[self.selectedIndex] = [[NSMutableArray alloc] init];
    }
    
    [pushedViewController[self.selectedIndex] addObject:view];
}

- (UIViewController *)popFromStack
{
    UIViewController *view = nil;
    
    if ([pushedViewController[self.selectedIndex] count] != 0)
    {
        view = [pushedViewController[self.selectedIndex] lastObject];
        [pushedViewController[self.selectedIndex] removeLastObject];
    }
    else
    {
        view = self.selectedViewController;
    }
    
    return view;
}

- (UIViewController *)peekFromStack
{
    UIViewController *view = nil;
    
    if ([pushedViewController[self.selectedIndex] count] != 0)
    {
        view = [pushedViewController[self.selectedIndex] lastObject];
    }
    else
    {
        view = self.selectedViewController;
    }
    
    return view;
}

- (void)pushNav:(UIViewController *)view
{
    CGRect rect = contentContainerView.bounds;
    rect.origin.x = rect.size.width;
    view.view.frame = rect;
    
    [self addChildViewController:view];
    
    UIViewController *curVC = [self peekFromStack];
    
    [self transitionFromViewController:curVC
                      toViewController:view
                              duration:0.3f
                               options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                            animations:^
     {
         CGRect rect = curVC.view.frame;
         rect.origin.x = -rect.size.width;
         
         curVC.view.frame = rect;
         view.view.frame = contentContainerView.bounds;
     }
                            completion:^(BOOL finished)
     {
         [view didMoveToParentViewController:self];
     }];
    
    [self pushToStack:view];
    
    [self updateCloseButtonStatus];
}

- (void)backorclose
{
    UIViewController *prevVC = [self popFromStack];
    UIViewController *curVC = [self peekFromStack];
    
    CGRect rect = contentContainerView.bounds;
    rect.origin.x = -rect.size.width;
    curVC.view.frame = rect;
    
    [prevVC willMoveToParentViewController:nil];
    [self addChildViewController:curVC];
    
    [self transitionFromViewController:prevVC
                      toViewController:curVC
                              duration:0.3f
                               options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                            animations:^
     {
         CGRect rect = prevVC.view.frame;
         rect.origin.x = rect.size.width;
         
         prevVC.view.frame = rect;
         curVC.view.frame = contentContainerView.bounds;
     }
                            completion:^(BOOL finished)
     {
         [prevVC removeFromParentViewController];
         [curVC didMoveToParentViewController:self];
     }];
    
    [self updateCloseButtonStatus];
}

- (void)updateCloseButtonStatus
{
    if ([pushedViewController[self.selectedIndex] count] == 0)
    {
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
        self.backActive = NO;
    }
    else
    {
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
        self.backActive = YES;
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
    //Clear stack for this index
    pushedViewController[self.selectedIndex] = [[NSMutableArray alloc] init];
    
	[self setSelectedIndex:sender.tag - TagOffset animated:NO];
    
    [self updateCloseButtonStatus];
}

#pragma mark - Change these methods to customize the look of the buttons

- (void)selectTabButton:(UIButton *)button
{
	[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
	UIImage *image = [[UIImage imageNamed:@"TemplateActiveTab"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateHighlighted];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
}

- (void)deselectTabButton:(UIButton *)button
{
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
	UIImage *image = [[UIImage imageNamed:@"TemplateInactiveTab"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateHighlighted];
    
	[button setTitleColor:[UIColor colorWithRed:175/255.0f green:85/255.0f blue:58/255.0f alpha:1.0f] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (CGFloat)tabBarHeight
{
	return 30.0f * SCALE_IPAD;
}

@end
