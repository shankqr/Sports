//
//  MapViewer.h
//  FFC
//
//  Created by Shankar on 7/17/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//
#import <MapKit/MapKit.h>

@class CSMapAnnotation;
@interface MapViewer : UIViewController <MKMapViewDelegate>
{
	
	MKMapView *mapView;
	NSString *selected_clubid;
	UILabel *managerLabel;
	UIImageView *managerImage;
	NSString *face_url;
	CSMapAnnotation* clubAnnotation;
}
@property (nonatomic, strong) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) IBOutlet UILabel *managerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *managerImage;
@property (nonatomic, strong) CSMapAnnotation* clubAnnotation;
@property (nonatomic, strong) NSString *face_url;
- (IBAction)challengeButton_tap:(id)sender;
- (IBAction)mailButton_tap:(id)sender;
- (void)updateView;
@end
