#import "JCNotificationBanner.h"

@implementation JCNotificationBanner

@synthesize title;
@synthesize message;
@synthesize imagename;
@synthesize timeout;
@synthesize tapHandler;

- (JCNotificationBanner*) initWithTitle:(NSString*)_title
                                message:(NSString*)_message
                                  image:(NSString*)_imagename
                             tapHandler:(JCNotificationBannerTapHandlingBlock)_tapHandler
{
    return [self initWithTitle:_title message:_message image:_imagename timeout:1.0 tapHandler:_tapHandler];
}


- (JCNotificationBanner*) initWithTitle:(NSString*)_title
                                message:(NSString*)_message
                                  image:(NSString*)_imagename
                                timeout:(NSTimeInterval)_timeout
                             tapHandler:(JCNotificationBannerTapHandlingBlock)_tapHandler
{
  self = [super init];
  if (self)
  {
    self.title = _title;
    self.message = _message;
    self.imagename = _imagename;
    self.timeout = _timeout;
    self.tapHandler = _tapHandler;
  }
  return self;
}

@end
