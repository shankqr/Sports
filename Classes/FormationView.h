//
//  FormationView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "SquadSelectView.h"

@interface FormationView : UIViewController <SquadSelectDelegate, UIActionSheetDelegate>
{
	UISegmentedControl *segment;
    UIImageView *ivBackground;
	NSString *fid;
	SquadSelectView *squadSelecter;
	NSString *selectedPlayer;
	NSString *nwPlayer;
	NSString *selectedPos;
}
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) IBOutlet UIImageView *ivBackground;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) SquadSelectView *squadSelecter;
@property (nonatomic, strong) NSString *selectedPlayer;
@property (nonatomic, strong) NSString *nwPlayer;
@property (nonatomic, strong) NSString *selectedPos;
- (void)updateView;
@end
