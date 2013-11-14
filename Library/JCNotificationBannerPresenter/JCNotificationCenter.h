#import <Foundation/Foundation.h>
#import "JCNotificationBanner.h"

@class JCNotificationBannerPresenter;

@interface JCNotificationCenter : NSObject

@property (nonatomic) JCNotificationBannerPresenter* presenter;

+ (JCNotificationCenter*) sharedCenter;

/** Adds notification to queue with given parameters. */
+ (void) enqueueNotificationWithMessage:(NSString*)message
                                  title:(NSString*)title
                                  image:(NSString*)imagename
                             tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

- (void) enqueueNotificationWithMessage:(NSString*)message
                                  title:(NSString*)title
                                  image:(NSString*)imagename
                             tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

- (void) enqueueNotification:(JCNotificationBanner*)notification;

@end
