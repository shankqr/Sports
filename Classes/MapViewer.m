//
//  MapViewer.m
//  FFC
//
//  Created by Shankar on 7/17/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MapViewer.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "ClubObject.h"
#import "Globals.h"
#import "CSMapAnnotation.h"
#import "MainView.h"

@implementation MapViewer
@synthesize mainView;
@synthesize selected_clubid;
@synthesize mapView;
@synthesize clubAnnotation;
@synthesize managerImage;
@synthesize managerLabel;
@synthesize face_url;

- (void)viewDidLoad
{
	selected_clubid = @"0";
}

- (void)loadManagerImage
{
	if([face_url length] > 5)
	{
		NSURL *url = [NSURL URLWithString:face_url];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [[UIImage alloc] initWithData:data];
		[managerImage setImage:img];
	}
	else 
	{
		NSString *fname = @"a1.png";
		[managerImage setImage:[UIImage imageNamed:fname]];
	}
}

- (void)updateView
{
	NSDictionary *wsClubData = [[Globals i] getClubInfoData];
	if(![selected_clubid isEqualToString:wsClubData[@"club_id"]]) //Check for redundent page load for same id
	{
		managerLabel.text = wsClubData[@"fb_name"];
		face_url = wsClubData[@"face_pic"];
		
		if(![wsClubData[@"fb_pic"] isEqualToString:@""])
		{
			NSURL *url = [NSURL URLWithString:wsClubData[@"fb_pic"]];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *img = [[UIImage alloc] initWithData:data];
			[managerImage setImage:img];
		}
		else 
		{
			[self loadManagerImage];
		}
		
		if(clubAnnotation != nil)
		{
			[mapView removeAnnotation:clubAnnotation];
		}
		
		CLLocationCoordinate2D location;
		location.longitude = [wsClubData[@"longitude"] floatValue];
		location.latitude = [wsClubData[@"latitude"] floatValue];
		
        NSString *date = wsClubData[@"date_found"];
        if ([date length] > 0)
        {
            date = [date substringToIndex:[date length] - 9];
        }
        
		clubAnnotation = [[CSMapAnnotation alloc] 
						initWithCoordinate:location
						title:wsClubData[@"club_name"]
						subtitle:date
						imagepath:wsClubData[@"logo_pic"]];
		
		[mapView addAnnotation:clubAnnotation];
		
		
		MKCoordinateSpan span;
		span.latitudeDelta = 20;
		span.longitudeDelta = 20;
		
		MKCoordinateRegion region;
		region.span = span;
		region.center = location;
		
		[mapView setRegion:region animated:YES];
		[mapView regionThatFits:region];
		
		[mapView selectAnnotation:clubAnnotation animated:YES];
		
		selected_clubid = wsClubData[@"club_id"];
	}
}

#pragma mark mapView delegate functions
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView* pin = nil;
	
	if(![annotation.title isEqualToString:@"Current Location"])
	{
		CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
		NSString* identifier = @"Pin";
		pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		if(pin == nil)
		{
			pin = [[MKPinAnnotationView alloc] initWithAnnotation:csAnnotation reuseIdentifier:identifier];
			pin.leftCalloutAccessoryView = csAnnotation.leftCalloutAccessoryView;
		}
		
		[pin setSelected:YES];
		[pin setHighlighted:YES];
		[pin setAnimatesDrop:YES];
		[pin setEnabled:YES];
		[pin setCanShowCallout:YES];
	}
	
	return pin;
}

- (IBAction)challengeButton_tap:(id)sender
{
	[mainView showChallenge:[Globals i].selectedClubId];
}

@end