//
//  FormationView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#define Pos_y1 (iPad ? 310.0f : 95.0f)
#define Pos_y2 (iPad ? 460.0f : 170.0f)
#define Pos_y3 (iPad ? 610.0f : 245.0f)
#define Pos_y4 (iPad ? 760.0f : 320.0f)
#define Pos_x1 (iPad ? 164.0f : 50.0f)
#define Pos_x2 (iPad ? 484.0f : 210.0f)
#define Pos_x3 (iPad ? 10.0f : 2.0f)
#define Pos_x4 (iPad ? 164.0f : 66.0f)
#define Pos_x5 (iPad ? 484.0f : 194.0f)
#define Pos_x6 (iPad ? 640.0f : 258.0f)
#define Subs_x1 (iPad ? 324.0f : 130.0f)
#define Subs_x2 (iPad ? 70.0f : 10.0f)
#define Subs_x3 (iPad ? 230.0f : 90.0f)
#define Subs_x4 (iPad ? 400.0f : 170.0f)
#define Subs_x5 (iPad ? 560.0f : 250.0f)
#define Subs_y1 (iPad ? 630.0f : 265.0f)
#define Subs_y2 (iPad ? 780.0f : 340.0f)
#define Subs_y3 (iPad ? 380.0f : 150.0f)

#define Pos_y1_hockey (iPad ? 310.0f : 95.0f)
#define Pos_y2_hockey (iPad ? 460.0f : 170.0f)
#define Pos_y3_hockey (iPad ? 610.0f : 245.0f)
#define Pos_y4_hockey (iPad ? 760.0f : 320.0f)
#define Pos_x1_hockey (iPad ? 164.0f : 50.0f)
#define Pos_x2_hockey (iPad ? 484.0f : 210.0f)
#define Pos_x3_hockey (iPad ? 10.0f : 2.0f)
#define Pos_x4_hockey (iPad ? 164.0f : 66.0f)
#define Pos_x5_hockey (iPad ? 484.0f : 194.0f)
#define Pos_x6_hockey (iPad ? 640.0f : 258.0f)
#define Subs_x1_hockey (iPad ? 324.0f : 130.0f)
#define Subs_x2_hockey (iPad ? 70.0f : 10.0f)
#define Subs_x3_hockey (iPad ? 230.0f : 90.0f)
#define Subs_x4_hockey (iPad ? 400.0f : 170.0f)
#define Subs_x5_hockey (iPad ? 560.0f : 250.0f)
#define Subs_y1_hockey (iPad ? 630.0f : 265.0f)
#define Subs_y2_hockey (iPad ? 780.0f : 340.0f)
#define Subs_y3_hockey (iPad ? 380.0f : 150.0f)

#define Pos_y1_baseball (iPad ? 760.0f : 330.0f)
#define Pos_y2_baseball (iPad ? 625.0f : 270.0f)
#define Pos_y3_baseball (iPad ? 495.0f : 210.0f)
#define Pos_y4_baseball (iPad ? 365.0f : 160.0f)
#define Pos_y5_baseball (iPad ? 292.0f : 130.0f)
#define Pos_x1_baseball (iPad ? 324.0f : 130.0f)
#define Pos_x2_baseball (iPad ? 190.0f : 70.0f)
#define Pos_x3_baseball (iPad ? 460.0f : 190.0f)
#define Pos_x4_baseball (iPad ? 230.0f : 90.0f)
#define Pos_x5_baseball (iPad ? 415.0f : 170.0f)
#define Pos_x6_baseball (iPad ? 75.0f : 26.0f)
#define Pos_x7_baseball (iPad ? 572.0f : 234.0f)

#import "SquadSelectView.h"

@class MainView;
@class SquadSelectView;
@interface FormationView : UIViewController <SquadSelectDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	UISegmentedControl *segment;
    UIImageView *ivBackground;
	NSString *fid;
	SquadSelectView *squadSelecter;
	NSString *selectedPlayer;
	NSString *nwPlayer;
	NSString *selectedPos;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) IBOutlet UIImageView *ivBackground;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) SquadSelectView *squadSelecter;
@property (nonatomic, strong) NSString *selectedPlayer;
@property (nonatomic, strong) NSString *nwPlayer;
@property (nonatomic, strong) NSString *selectedPos;
- (void)updateView;
@end
