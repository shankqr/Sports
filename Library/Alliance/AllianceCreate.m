//
//  AllianceCreate.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "AllianceCreate.h"
#import "Globals.h"

@implementation AllianceCreate

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateView:(BOOL)createMode
{
    if (createMode)
    {
        self.isCreate = YES;
    }
    else
    {
        self.isCreate = NO;
    }
    
    NSDictionary *rowHeader1 = @{@"h1": @"Alliance Name"};
    NSDictionary *row10 = @{@"t1": @"Enter name here..."};
    NSArray *rows1 = @[rowHeader1, row10];
    
    NSDictionary *rowHeader2 = @{@"h1": @"Description"};
    NSDictionary *row20 = @{@"t1": @"Enter text here...", @"t1_height": @"84"};
    NSArray *rows2 = @[rowHeader2, row20];
    
    NSDictionary *rowHeader3 = @{@"h1": @"Options"};
    NSDictionary *rowDone = @{@"r1": @"Save", @"r1_center": @"1"};
    if (self.isCreate)
    {
        rowDone = @{@"r1": @"Create Alliance", @"r1_center": @"1"};
    }
    NSDictionary *rowCancel = @{@"r1": @"Cancel", @"r1_center": @"1", @"r1_color": @"1"};
    NSArray *rows3 = @[rowHeader3, rowDone, rowCancel];
    
    self.rows = @[rows1, rows2, rows3];
    
	[self.tableView reloadData];
	[self.view setNeedsDisplay];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    return (self.rows)[indexPath.section][indexPath.row];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rows count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows[section] count];
}

#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.rows count]-1)
    {
        self.inputCell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITextField *tvName = (UITextField *)[self.inputCell1 viewWithTag:6];
        
        self.inputCell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        UITextView *tvDesc = (UITextView *)[self.inputCell2 viewWithTag:7];
        
        if(indexPath.row == 1) //Save or Create
        {
            if(([tvName.text length] > 2) && ([tvDesc.text length] > 0))
            {
                [tvName resignFirstResponder];
                [tvDesc resignFirstResponder];
                
                if (self.isCreate)
                {
                    [self postAllianceCreate:tvName.text withDesc:tvDesc.text];
                }
                else
                {
                    [self postAllianceEdit:tvName.text withDesc:tvDesc.text];
                }
            }
            else
            {
                [[Globals i] showDialog:@"Invalid Input! Name must be at least 3 characters long, and do not leave Description blank."];
            }
        }
        else if(indexPath.row == 2) //Cancel
        {
            [[Globals i] backTemplate];
            tvName.text = @"";
            tvDesc.text = @"";
        }
    }
    
	return nil;
}

- (void)postAllianceEdit:(NSString *)tvName withDesc:(NSString *)tvDesc
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [[Globals i] wsClubData][@"club_id"],
                          @"club_id",
                          [[Globals i] wsClubData][@"alliance_id"],
                          @"alliance_id",
                          tvName,
                          @"name",
                          tvDesc,
                          @"message",
                          nil];
    
    [Globals postServerLoading:dict :@"PostAllianceEdit" :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{ //Update UI on main thread
             if (success)
             {
                 [[Globals i] backTemplate];
                 [[Globals i] closeTemplate];
                 
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"GotoAlliance"
                  object:self];
                 
                 [[Globals i] showToast:@"Alliance Edited Successfully!"
                          optionalTitle:nil
                          optionalImage:@"tick_yes"];
             }
         });
     }];
}

- (void)postAllianceCreate:(NSString *)tvName withDesc:(NSString *)tvDesc
{
    NSDictionary *wspi = [[Globals i] getCurrentSeasonData];
    NSString *reqCurrency1 = wspi[@"alliance_require_currency2"];
    
    [[Globals i] showDialogBlock:[NSString stringWithFormat:@"Form a new Alliance for %@ Diamonds only.", [[Globals i] numberFormat:reqCurrency1]]
                                :2
                                :^(NSInteger index, NSString *text)
     {
         if(index == 1) //YES
         {
             NSDictionary *wspi = [[Globals i] getCurrentSeasonData];
             NSString *reqCurrency1 = wspi[@"alliance_require_currency2"];
             
             NSInteger balDiamonds = [[[Globals i] wsClubData][@"currency_second"] integerValue];
             
             if (balDiamonds >= reqCurrency1.integerValue)
             {
                 NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [[Globals i] wsClubData][@"club_id"],
                                       @"club_id",
                                       [[Globals i] wsClubData][@"club_name"],
                                       @"club_name",
                                       tvName,
                                       @"name",
                                       tvDesc,
                                       @"message",
                                       nil];
                 
                 [Globals postServerLoading:dict :@"PostAllianceCreate" :^(BOOL success, NSData *data)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{ //Update the UI on the main thread
                          
                          if (success)
                          {
                              [[Globals i] updateClubData]; //Balance Diamonds will be updated
                                        
                              [[Globals i] backTemplate];
                              [[Globals i] closeTemplate];
                                       
                              [[NSNotificationCenter defaultCenter]
                                        postNotificationName:@"GotoAlliance"
                                        object:self];
                              
                              [[Globals i] showDialog:@"Congratulations on creating an Alliance. Don't forget to set the winning prizes and invite as many club as posible. Good luck and have fun!"];
  
                              [[Globals i] showToast:@"Alliance Created Successfully!"
                                       optionalTitle:nil
                                       optionalImage:@"tick_yes"];
                          }
                      });
                  }];
             }
             else
             {
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"GotoBuy"
                  object:self];
             }
         }
     }];
}

@end
