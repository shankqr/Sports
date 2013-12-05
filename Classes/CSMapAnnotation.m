//
//  CSMapAnnotation.m
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import "CSMapAnnotation.h"
#define kHeight 40
#define kWidth  40
#define kBorder 0

@implementation CSMapAnnotation
@synthesize coordinate = _coordinate;
@synthesize userData = _userData;
@synthesize club_id = _club_id;
@synthesize imageView;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate 
				   title:(NSString*)title
				   subtitle:(NSString*)subtitle
					imagepath:(NSString*)imagepath
{
	self = [super init];
	
	//self.frame = CGRectMake(0, 0, kWidth, kHeight);
	//self.backgroundColor = [UIColor whiteColor];
	
	if(imagepath.length > 5)
	{
		NSURL *url = [NSURL URLWithString:imagepath];
		NSData *data = [NSData dataWithContentsOfURL:url];
		imageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:data]];
	}
	else 
	{
		NSString *fname = [NSString stringWithFormat:@"c%@.png", imagepath];
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fname]];
	}
	imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2 * kBorder, kWidth - 2 * kBorder);
	
	_coordinate = coordinate;
	_title      = title;
	_subtitle   = subtitle;
	
	self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	self.leftCalloutAccessoryView = imageView;
	
	return self;
}

- (NSString *)title
{
	return _title;
}

- (NSString *)subtitle
{
	return _subtitle;
}

@end
