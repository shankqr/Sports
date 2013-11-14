//
//  ImageHelper.m
//  FFC
//
//  Created by Shankar on 6/12/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+(NSString *)getImagePath:(NSString *)imageName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
	
	return imagePath;
}

+(void)saveImage:(UIImage *)imageUI :(NSString *)imageName
{
	NSString *imagePath = [ImageHelper getImagePath: imageName];
	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(imageUI)];
	[imageData writeToFile:imagePath atomically:YES];
}

+(UIImage *)getImage:(NSString *)imageName
{
	NSString *imagePath = [ImageHelper getImagePath: imageName];
	return [UIImage imageWithContentsOfFile:imagePath];
}

+(void)uploadImage 
{

}

@end
