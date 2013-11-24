//
//  SubsView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#define Subs_x1 (iPad ? 324.0f : 130.0f)
#define Subs_x2 (iPad ? 70.0f : 10.0f)
#define Subs_x3 (iPad ? 230.0f : 90.0f)
#define Subs_x4 (iPad ? 400.0f : 170.0f)
#define Subs_x5 (iPad ? 560.0f : 250.0f)
#define Subs_y1 (iPad ? 630.0f : 265.0f)
#define Subs_y2 (iPad ? 780.0f : 340.0f)
#define Subs_y3 (iPad ? 380.0f : 150.0f)

#define Subs_x1_hockey (iPad ? 324.0f : 130.0f)
#define Subs_x2_hockey (iPad ? 70.0f : 10.0f)
#define Subs_x3_hockey (iPad ? 230.0f : 90.0f)
#define Subs_x4_hockey (iPad ? 400.0f : 170.0f)
#define Subs_x5_hockey (iPad ? 560.0f : 250.0f)
#define Subs_y1_hockey (iPad ? 630.0f : 265.0f)
#define Subs_y2_hockey (iPad ? 780.0f : 340.0f)
#define Subs_y3_hockey (iPad ? 380.0f : 150.0f)

#define Subs_x1_baseball (iPad ? 324.0f : 130.0f)
#define Subs_x2_baseball (iPad ? 70.0f : 10.0f)
#define Subs_x3_baseball (iPad ? 230.0f : 90.0f)
#define Subs_x4_baseball (iPad ? 400.0f : 170.0f)
#define Subs_x5_baseball (iPad ? 560.0f : 250.0f)
#define Subs_y1_baseball (iPad ? 630.0f : 265.0f)
#define Subs_y2_baseball (iPad ? 780.0f : 340.0f)
#define Subs_y3_baseball (iPad ? 380.0f : 150.0f)

#import "SquadSelectView.h"

@class MainView;
@interface SubsView : UIViewController <SquadSelectDelegate, UIActionSheetDelegate>
{
	MainView *mainView;
    UIImageView *ivBackground;
    SquadSelectView *squadSelecter;
	NSString *fid;
	NSString *selectedPlayer;
	NSString *nwPlayer;
	NSString *selectedPos;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UIImageView *ivBackground;
@property (nonatomic, strong) SquadSelectView *squadSelecter;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *selectedPlayer;
@property (nonatomic, strong) NSString *nwPlayer;
@property (nonatomic, strong) NSString *selectedPos;
- (void)updateView;
@end
