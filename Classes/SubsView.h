//
//  SubsView.h
//  FFC
//
//  Created by Shankar Nathan on 5/28/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "SquadSelectView.h"

@class MainView;
@class SquadSelectView;
@interface SubsView : UIViewController <SquadSelectDelegate, UIActionSheetDelegate>
{
	MainView *mainView;
    SquadSelectView *squadSelecter;
	NSString *fid;
	NSString *selectedPlayer;
	NSString *nwPlayer;
	NSString *selectedPos;
}
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) SquadSelectView *squadSelecter;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *selectedPlayer;
@property (nonatomic, strong) NSString *nwPlayer;
@property (nonatomic, strong) NSString *selectedPos;
- (void)updateView;
- (void)removeAllPos;
- (void)createSub;
- (void)addPosButton:(NSString *)pos
			   label:(NSString *)label
				 tag:(int)tag
				posx:(int)posx
				posy:(int)posy;
- (void)launchSquadSelect;
- (void)swapPos:(NSString *)pos;
@end
