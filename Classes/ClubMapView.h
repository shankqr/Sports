//
//  ClubMapView.h
//  FFC
//
//  Created by Shankar on 7/17/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "ClubObject.h"
#import "Globals.h"
#import "CSMapAnnotation.h"
#import "MainView.h"

@interface ClubMapView : UIViewController <MKMapViewDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	MKMapView *mapViewer;
	NSString *selected_clubid;
	NSMutableArray *clubs;
	NSArray *allListContent;
	NSMutableArray *filteredListContent;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) MKMapView* mapViewer;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) NSMutableArray *clubs;
@property (nonatomic, strong) NSArray *allListContent;
@property (nonatomic, strong) NSMutableArray *filteredListContent;
- (void)updateView;
- (void)setupMap;
- (void)zoomCurrentLocation;
- (void)getMapClubsData;
@end
