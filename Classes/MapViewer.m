//
//  MapViewer.m
//  FFC
//
//  Created by Shankar on 7/17/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "MapViewer.h"
#import "ClubObject.h"
#import "Globals.h"
#import "CSMapAnnotation.h"
#import "MainView.h"

@implementation MapViewer
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
	NSDictionary *wsClubDict = [[Globals i] getClubInfoData];
	if(![selected_clubid isEqualToString:wsClubDict[@"club_id"]]) //Check for redundent page load for same id
	{
		managerLabel.text = wsClubDict[@"fb_name"];
		face_url = wsClubDict[@"face_pic"];
		
		if(![wsClubDict[@"fb_pic"] isEqualToString:@""])
		{
			NSURL *url = [NSURL URLWithString:wsClubDict[@"fb_pic"]];
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
		location.longitude = [wsClubDict[@"longitude"] floatValue];
		location.latitude = [wsClubDict[@"latitude"] floatValue];
		
        NSString *date = wsClubDict[@"date_found"];
        if ([date length] > 0)
        {
            date = [date substringToIndex:[date length] - 9];
        }
        
		clubAnnotation = [[CSMapAnnotation alloc] 
						initWithCoordinate:location
						title:wsClubDict[@"club_name"]
						subtitle:date
						imagepath:wsClubDict[@"logo_pic"]];
		
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
		
		selected_clubid = wsClubDict[@"club_id"];
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
	[[Globals i].mainView showChallenge:[Globals i].selectedClubId];
}

- (IBAction)mailButton_tap:(id)sender
{
    NSDictionary *wsClubDict = [[Globals i] getClubInfoData];

    NSString *isAlli = @"0";
    NSString *toID = [Globals i].selectedClubId;
    NSString *toName = wsClubDict[@"club_name"];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:isAlli forKey:@"is_alli"];
    [userInfo setObject:toID forKey:@"to_id"];
    [userInfo setObject:toName forKey:@"to_name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MailCompose"
                                                        object:self
                                                      userInfo:userInfo];
}

@end