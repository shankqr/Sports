#import <Foundation/Foundation.h>

#define iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define SCALE_IPAD (iPad ? 2.0f : 1.0f)

typedef void (^JCNotificationBannerTapHandlingBlock)();

@interface JCNotificationBanner : NSObject

@property (nonatomic) NSString* title;
@property (nonatomic) NSString* message;
@property (nonatomic) NSString* imagename;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, copy) JCNotificationBannerTapHandlingBlock tapHandler;

- (JCNotificationBanner*) initWithTitle:(NSString*)title
                                message:(NSString*)message
                                  image:(NSString*)imagename
                             tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

- (JCNotificationBanner*) initWithTitle:(NSString*)title
                                message:(NSString*)message
                                  image:(NSString*)imagename
                                timeout:(NSTimeInterval)timeout
                             tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;
@end
