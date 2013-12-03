//
//  ClubMapView.h
//  FFC
//
//  Created by Shankar on 7/17/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface ClubMapView : UIViewController <MKMapViewDelegate, UIAlertViewDelegate>
{
	
	MKMapView *mapViewer;
	NSString *selected_clubid;
	NSMutableArray *clubs;
	NSArray *allListContent;
	NSMutableArray *filteredListContent;
}

@property (nonatomic, strong) MKMapView* mapViewer;
@property (nonatomic, strong) NSString *selected_clubid;
@property (nonatomic, strong) NSMutableArray *clubs;
@property (nonatomic, strong) NSArray *allListContent;
@property (nonatomic, strong) NSMutableArray *filteredListContent;
- (void)updateView;
@end
