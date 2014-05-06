//
//  DialogBoxView.m
//  Kingdom Game
//
//  Created by Shankar on 11/19/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "DialogBoxView.h"
#import "Globals.h"

@implementation DialogBoxView

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = (self.rows)[indexPath.section][indexPath.row];
    
    return rowData;
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH-DIALOG_CONTENT_MARGIN*2];
    
    [dcell.row1_button addTarget:self action:@selector(button1Pressed:) forControlEvents:UIControlEventTouchUpInside];
    dcell.row1_button.tag = indexPath.row;
    
    [dcell.col1_button addTarget:self action:@selector(button2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    dcell.col1_button.tag = indexPath.row;
    
    return dcell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rows count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH-DIALOG_CONTENT_MARGIN*2];
}

- (void)button1Pressed:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 0)
    {
        [self done];
    }
}

- (void)button2Pressed:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 0)
    {
        [[Globals i] closeTemplate];
        
        if (self.dialogBlock != nil)
        {
            self.dialogBlock(2, @"");
        }
    }
}

- (void)done
{
    if ((self.dialogType == 4) || (self.dialogType == 5) || (self.dialogType == 6))
    {
        self.inputCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UITextView *inputText = (UITextView *)[self.inputCell viewWithTag:7];
        
        if([inputText.text length] > 0)
        {
            [inputText resignFirstResponder];
            
            [[Globals i] closeTemplate];
            
            if (self.dialogBlock != nil)
            {
                self.dialogBlock(1, inputText.text);
            }
        }
    }
    else
    {
        [[Globals i] closeTemplate];
        
        if (self.dialogBlock != nil)
        {
            self.dialogBlock(1, @"");
        }
    }
}

- (void)updateView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.dialogType == 1)
    {
        [self setup1];
    }
    
    if (self.dialogType == 2)
    {
        [self setup2];
    }
    
    if ((self.dialogType == 4) || (self.dialogType == 5) || (self.dialogType == 6))
    {
        [self setupInput];
    }
    
    [self.tableView reloadData];
}

- (void)setup1 //OK
{
    NSDictionary *row10 = @{@"nofooter": @"1", @"r1": @" ", @"r1_center": @"1"};
    NSDictionary *row11 = @{@"nofooter": @"1", @"r1": self.displayText, @"r1_center": @"1"};
    NSArray *rows1 = @[row10, row11];
    self.rows = [@[rows1] mutableCopy];
    
    NSDictionary *row21 = @{@"nofooter": @"1", @"r1": @"OK", @"r1_button": @"3"};
    NSArray *rows2 = @[row21];
    [self.rows addObject:rows2];
}

- (void)setup2 //YES NO
{
    NSDictionary *row10 = @{@"nofooter": @"1", @"r1": @" ", @"r1_center": @"1"};
    NSDictionary *row11 = @{@"nofooter": @"1", @"r1": self.displayText, @"r1_center": @"1"};
    NSArray *rows1 = @[row10, row11];
    self.rows = [@[rows1] mutableCopy];
    
    NSDictionary *row21 = @{@"nofooter": @"1", @"r1": @"YES", @"r1_button": @"3", @"c1": @"NO", @"c1_button": @"3",};
    NSArray *rows2 = @[row21];
    [self.rows addObject:rows2];
}

- (void)setupInput
{
    NSDictionary *row10 = @{@"nofooter": @"1", @"r1": @" ", @"r1_center": @"1"};
    NSDictionary *row11 = @{@"nofooter": @"1", @"r1": self.displayText};
    NSDictionary *row12 = @{@"nofooter": @"1", @"t1": @"Enter text here...", @"t1_height": @"36", @"t1_keyboard": [@(self.dialogType) stringValue]};
    NSArray *rows1 = @[row10, row11, row12];
    
    NSDictionary *row21 = @{@"nofooter": @"1", @"r1": @"OK", @"r1_button": @"3", @"c1": @"CANCEL", @"c1_button": @"3",};
    NSArray *rows2 = @[row21];
    
    self.rows = [@[rows1, rows2] mutableCopy];
}

@end
