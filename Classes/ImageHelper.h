//
//  ImageHelper.h
//  FFC
//
//  Created by Shankar on 6/12/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface ImageHelper : NSObject {

}

+(NSString *)getImagePath:(NSString *)imageName;
+(void)saveImage:(UIImage *)imageUI :(NSString *)imageName;
+(UIImage *)getImage:(NSString *)imageName;

@end
