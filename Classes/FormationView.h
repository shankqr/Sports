//
//  FormationView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "Globals.h"
#import "SquadSelectView.h"
#import "MainView.h"

@interface FormationView : UIViewController <SquadSelectDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
	MainView *mainView;
	UISegmentedControl *segment;
	NSString *fid;
	SquadSelectView *squadSelecter;
	NSString *selectedPlayer;
	NSString *nwPlayer;
	NSString *selectedPos;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) SquadSelectView *squadSelecter;
@property (nonatomic, strong) NSString *selectedPlayer;
@property (nonatomic, strong) NSString *nwPlayer;
@property (nonatomic, strong) NSString *selectedPos;
- (void)updateView;
- (void)removeAllPos;
- (void)createPos1;
- (void)launchSquadSelect;
- (void)swapPos:(NSString *)pos;
@end
