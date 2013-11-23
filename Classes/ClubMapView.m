//
//  ClubMapView.m
//  FFC
//
//  Created by Shankar on 7/17/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "ClubMapView.h"
#import <QuartzCore/QuartzCore.h>
#import "ClubObject.h"
#import "Globals.h"
#import "CSMapAnnotation.h"
#import "MainView.h"

@implementation ClubMapView
@synthesize mainView;
@synthesize clubs;
@synthesize selected_clubid;
@synthesize allListContent;
@synthesize filteredListContent;
@synthesize mapViewer;

- (void)dealloc
{
    mapViewer.delegate = nil;
}

- (void)viewDidLoad
{
    mapViewer = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, UIScreen.mainScreen.bounds.size.height)];
    mapViewer.mapType = MKMapTypeStandard;
    mapViewer.showsUserLocation = YES;
    mapViewer.scrollEnabled = YES;
    [self.view addSubview:mapViewer];
}

- (void)updateView
{
    mapViewer.delegate = self;
    
	if([[[Globals i] getMapClubsData] count] < 1)
	{
		if(allListContent.count > 0)
		{
			[mapViewer removeAnnotations:allListContent];
			allListContent = [[NSArray alloc] init];
		}
		
		UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Map"
						  message:@"Only active login clubs will show on map. Clicking OK will take some time to load the map."
						  delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
		[alert show];
	}
	else 
	{
		if(allListContent.count < 1)
		{
			[self setupMap];
		}
	}
    
    [self zoomCurrentLocation];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	[self getMapClubsData];
}

-(void)getMapClubsData
{
	[[Globals i] updateMapClubsData];
	self.clubs = [[NSMutableArray alloc] initWithArray:[[Globals i] getMapClubsData] copyItems:YES];
	[self setupMap];
}

- (void)setupMap
{
	NSMutableArray *annotationArray = [[NSMutableArray alloc] initWithCapacity:self.clubs.count];
	for (NSDictionary *eachElement in self.clubs)
	{
		CLLocationCoordinate2D location;
		location.longitude = [[eachElement valueForKey:@"longitude"] floatValue];
		location.latitude = [[eachElement valueForKey:@"latitude"] floatValue];
		NSString *fanmembers = [[eachElement valueForKey:@"fan_members"] stringByAppendingString:@" Fans"];
		
		CSMapAnnotation* clubAnnotation = [[CSMapAnnotation alloc] 
											initWithCoordinate:location
											title:[eachElement valueForKey:@"club_name"]
											subtitle:fanmembers
											imagepath:[eachElement valueForKey:@"logo_pic"]];
		[clubAnnotation setClub_id:[eachElement valueForKey:@"club_id"]];
		
		[annotationArray addObject:clubAnnotation];
	}
	allListContent = [[NSArray alloc] initWithArray:annotationArray];
	[mapViewer addAnnotations:allListContent];
}

- (void)zoomCurrentLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMake(mapViewer.centerCoordinate, MKCoordinateSpanMake(180, 360));
    [mapViewer setRegion:region animated:YES]; 
    
}

#pragma mark mapView delegate functions
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
	
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	CSMapAnnotation* annotation = (CSMapAnnotation*) view.annotation;
	if(annotation.club_id != nil)
	{
		NSString *my_club_id = [annotation.club_id stringByReplacingOccurrencesOfString:@"," withString:@""];
		[mainView showClubViewer:my_club_id];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{	
    CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapViewer dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if((pin == nil) && (![annotation.title isEqualToString:@"Current Location"]))
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:csAnnotation reuseIdentifier:@"Pin"];
        pin.rightCalloutAccessoryView = csAnnotation.rightCalloutAccessoryView;
        pin.leftCalloutAccessoryView = csAnnotation.leftCalloutAccessoryView;
    }
    else
    {
        pin.annotation = annotation;
    }
        
    //pin.animatesDrop = YES;
    //[pin setEnabled:YES];
    [pin setCanShowCallout:YES];
	
	return pin;
}

@end