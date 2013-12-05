//
//  CSMapAnnotation.h
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CSMapAnnotation : MKAnnotationView <MKAnnotation>
{
	CLLocationCoordinate2D _coordinate;
	NSString *_title;
	NSString *_subtitle;
	NSString *_userData;
	NSString *_club_id;
	UIImageView *imageView;
}
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate
				   title:(NSString*)title
				subtitle:(NSString*)subtitle
			   imagepath:(NSString*)imagepath;
@property (nonatomic, strong) NSString *userData;
@property (nonatomic, strong) NSString *club_id;
@property (nonatomic, strong) UIImageView *imageView;
@end
