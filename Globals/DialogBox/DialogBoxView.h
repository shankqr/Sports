//
//  DialogBoxView.h
//  Kingdom Game
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

typedef void (^DialogBlock)(NSInteger index, NSString *text);

@interface DialogBoxView : UITableViewController

@property (nonatomic, strong) DialogBlock dialogBlock;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSString *displayText;
@property (nonatomic, strong) UITableViewCell *inputCell;

@property (nonatomic, assign) NSInteger verticalOffset;
@property (nonatomic, assign) NSInteger keyboardType;
@property (nonatomic, assign) NSInteger dialogType;

- (void)updateView;

@end
