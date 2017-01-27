
#import "PlayerView.h"
#import "SquadView.h"
#import "Globals.h"
#import "PlayerCell.h"

@implementation PlayerView
@synthesize squadView;
@synthesize playerList;
@synthesize players;
@synthesize player_id;
@synthesize flagImageView;
@synthesize nationLabel;
@synthesize moraleLabel;

- (void)updateView:(NSDictionary *)player
{
    self.players = [[NSMutableArray alloc] initWithObjects:player, nil];
    [playerList reloadData];
    self.player_id = player[@"player_id"];
    
    moraleLabel.text = [NSString stringWithFormat:@"%ld%%", (long)[player[@"happiness"] integerValue]/2];
    
    if ([player[@"happiness"] integerValue] < 80)
    {
        moraleLabel.textColor = [UIColor redColor];
    }
    else if ([player[@"happiness"] integerValue] < 150)
    {
        moraleLabel.textColor = [UIColor yellowColor];
    }
    else
    {
        moraleLabel.textColor = [UIColor greenColor];
    }
    
    NSInteger nation = [player[@"nationality"] integerValue];
    
    if (nation > 0 && nation < 263)
    {
        nationLabel.text = ARRAY_FLAGS[nation];
        [flagImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"flag_%ld.png", (long)nation]]];
    }
    else
    {
        nationLabel.text = @" ";
        flagImageView.image = nil;
    }
}

- (void)close
{
	[UIManager.i closeTemplate];
}

- (IBAction)sellButton_tap:(id)sender
{
    NSInteger minimum_player = 11;
    
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        minimum_player = 11;
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        minimum_player = 6;
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        minimum_player = 5;
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        minimum_player = 9;
    }
    
    if((squadView.players.count > minimum_player) && (![squadView.sold_player_id isEqualToString:squadView.sel_player_id]))
    {
        if([Globals i].energy > 9)
        {
            NSInteger half_value = [squadView.sel_player_value integerValue] / 2;
            NSNumber* number = @(half_value);
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
            [numberFormatter setGroupingSeparator:@","];
            squadView.sel_player_halfvalue = [numberFormatter stringForObjectValue:number];
            
            [UIManager.i showDialogBlock:[NSString stringWithFormat:@"+5 XP. Are you sure you want to sell %@ half the value for $%@?", squadView.sel_player_name, squadView.sel_player_halfvalue]
                                        :2
                                        :^(NSInteger index, NSString *text)
             {
                 if(index == 1) //YES
                 {
                     [Globals i].energy = [Globals i].energy-10;
                     [[Globals i] storeEnergy];
                     squadView.sold_player_id = squadView.sel_player_id;
                     [[Globals i] sellPlayer: squadView.sel_player_value: squadView.sel_player_id];
                     [squadView forceUpdate];
                     
                     //Update Header
                     [[Globals i] updateClubData]; //Balance added with player sold price
                     
                     NSString *message = [[NSString alloc] initWithFormat:@"I have just sold my player %@ for $%@", squadView.sel_player_name, squadView.sel_player_halfvalue];
                     NSString *extra_desc = @"Always check out the transfer list for new players, who knows you might buy the next super star.";
                     NSString *imagename = @"sold_player.png";
                     [[Globals i] fbPublishStory:message :extra_desc :imagename];
                     
                     [self close];
                     
                     [UIManager.i showDialog:[NSString stringWithFormat:@"+5 XP. Congratulations! you managed to sell %@ to a 3rd world country for $%@. You now have %ld players left on your team.",
                                              squadView.sel_player_name, squadView.sel_player_halfvalue, (unsigned long)squadView.players.count]];

                 }
             }];
        }
        else
        {
            [UIManager.i showDialogBlock:@"10 energy is required to sell any player. Refill to full Energy?"
                                        :2
                                        :^(NSInteger index, NSString *text)
             {
                 if(index == 1) //YES
                 {
                     [[Globals i] settPurchasedProduct:@"14"];
                     
                     NSString *pi = [[Globals i] getProductIdentifiers][@"refill"];
                     NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                     [userInfo setObject:pi forKey:@"pi"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchase"
                                                                         object:self
                                                                       userInfo:userInfo];
                 }
             }];
        }
    }
    else
    {
        [UIManager.i showDialog:[NSString stringWithFormat:@"You must have at least %ld players left on your team.", (long)minimum_player]];
    }
}

- (IBAction)energizeButton_tap:(id)sender
{
    if([Globals i].energy > 9)
    {
        NSString *dt = [NSString stringWithFormat:@"Energize %@ for 10 Energy? %@'s Condition will increase by 5.",
                                squadView.sel_player_name, squadView.sel_player_name];
        
        [UIManager.i showDialogBlock:dt
                                    :2
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 [Globals i].energy = [Globals i].energy-10;
                 [[Globals i] storeEnergy];
                 [[Globals i] energizePlayer:squadView.sel_player_id];
                 
                 [squadView normalUpdate];
                 
                 //Update Header
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"UpdateHeader"
                  object:self];
                 
                 //[[Globals i] updateClubData]; //Club energy deducted.
                 
                 [self updateView:(squadView.players)[squadView.selectedRow]];
             }
         }];
    }
    else
    {
        [UIManager.i showDialogBlock:@"10 energy is required to Energize any player. Refill to full Energy?"
                                    :2
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 [[Globals i] settPurchasedProduct:@"14"];
                 
                 NSString *pi = [[Globals i] getProductIdentifiers][@"refill"];
                 NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                 [userInfo setObject:pi forKey:@"pi"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchase"
                                                                     object:self
                                                                   userInfo:userInfo];
             }
         }];
    }
}

- (IBAction)healButton_tap:(id)sender
{
    if([Globals i].energy > 9)
    {
        NSString *dt = [NSString stringWithFormat:@"Heal %@ for 10 Energy? %@'s injury days will decrease by 1.",
                                squadView.sel_player_name, squadView.sel_player_name];
        
        [UIManager.i showDialogBlock:dt
                                    :2
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 [Globals i].energy = [Globals i].energy-10;
                 [[Globals i] storeEnergy];
                 [[Globals i] healPlayer: squadView.sel_player_id];
                 
                 [squadView normalUpdate];
                 
                 //Update Header
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"UpdateHeader"
                  object:self];
                 
                 [self updateView:(squadView.players)[squadView.selectedRow]];
             }
         }];
    }
    else
    {
        [UIManager.i showDialogBlock:@"10 energy is required to Heal any player. Refill to full Energy?"
                                    :2
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 [[Globals i] settPurchasedProduct:@"14"];
                 
                 NSString *pi = [[Globals i] getProductIdentifiers][@"refill"];
                 NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                 [userInfo setObject:pi forKey:@"pi"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchase"
                                                                     object:self
                                                                   userInfo:userInfo];
             }
         }];
    }
}

- (IBAction)renameButton_tap:(id)sender
{
    NSInteger totalDiamonds = [[[Globals i] getClubData][@"currency_second"] integerValue];
    
    if(totalDiamonds > 9)
    {
        [UIManager.i showDialogBlock:@"+5 XP. Rename Player for 10 Diamonds? Enter a new name for this player."
                                    :4
                                    :^(NSInteger index, NSString *text)
         {
             if (index == 1) //OK button is clicked
             {
                 NSString *returnValue = @"0";
                 if([text isEqualToString:@""])
                 {
                     //returnValue = @"0";
                 }
                 else
                 {
                     NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/RenamePlayer/%@/%@/%@",
                                        WS_URL, [[Globals i] UID], squadView.sel_player_id, text];
                     NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                     NSURL *url = [[NSURL alloc] initWithString:wsurl2];
                     returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
                     
                 }
                 
                 if([returnValue isEqualToString:@"1"])
                 {
                     [squadView forceUpdate];
                     
                     //Update Header
                     [[Globals i] updateClubData]; //Diamonds deducted for player rename
                     
                     NSString *message = [[NSString alloc] initWithFormat:@"I have just renamed my player %@ to %@", squadView.sel_player_name, text];
                     NSString *extra_desc = @"Always check out the transfer list for new players, who knows you might sign up the next super star.";
                     NSString *imagename = @"rename_player.png";
                     [[Globals i] fbPublishStory:message :extra_desc :imagename];
                     
                     [self close];
                     
                     [UIManager.i showDialog:[NSString stringWithFormat:@"+5 XP. Congratulations! player %@ is now called %@.",
                                              squadView.sel_player_name, text]];
                 }
                 else
                 {
                     [UIManager.i showDialog:@"NAME NOT VALID. Try again and enter another name."];
                 }
             }
         }];
    }
    else
    {
        [UIManager.i showDialogBlock:@"10 Diamonds is required to rename a player. Would you like to buy some diamonds"
                                    :2
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"GotoBuy"
                  object:self];

                 [self close];
             }
         }];
    }
}

- (IBAction)improveButton_tap:(id)sender
{
    NSInteger totalDiamonds = [[[Globals i] getClubData][@"currency_second"] integerValue];
    
    if(totalDiamonds > 4)
    {
        NSString *dt = [NSString stringWithFormat:@"+5 XP. Send %@ to Special Training for 5 Diamonds? One of %@'s skill will level up after special training.",
                                squadView.sel_player_name, squadView.sel_player_name];
        
        [UIManager.i showDialogBlock:dt
                                    :2
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 NSString *returnValue = @"0";
                 NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/UpgradePlayer/%@/%@",
                                    WS_URL, [[Globals i] UID], squadView.sel_player_id];
                 NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 NSURL *url = [[NSURL alloc] initWithString:wsurl2];
                 returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
                 
                 
                 if([returnValue isEqualToString:@"0"])
                 {
                     [UIManager.i showDialog:@"Player NOT VALID. Please select another player."];
                 }
                 else
                 {
                     [squadView normalUpdate];
                     
                     //Update Header
                     [[Globals i] updateClubData]; //Deduct diamonds and +5 XP.
                     
                     NSString *message = [[NSString alloc] initWithFormat:@"I have just sent my player %@ to special training.", squadView.sel_player_name];
                     NSString *extra_desc = @"One of your player skill will level up after special training.";
                     NSString *imagename = @"special_training.png";
                     [[Globals i] fbPublishStory:message :extra_desc :imagename];
                     
                     [self updateView:(squadView.players)[squadView.selectedRow]];
                     
                     NSString *promptText = @"0";
                     
                     if([returnValue isEqualToString:@"1"])
                     {
                         promptText = [NSString stringWithFormat:@"+5 XP. Congratulations! player %@ has level up his %@ skills.", squadView.sel_player_name, [[Globals i] PlayerSkill2]];
                     }
                     else if([returnValue isEqualToString:@"2"])
                     {
                         promptText = [NSString stringWithFormat:@"+5 XP. Congratulations! player %@ has level up his %@ skills.", squadView.sel_player_name, [[Globals i] PlayerSkill3]];
                     }
                     else if([returnValue isEqualToString:@"3"])
                     {
                         promptText = [NSString stringWithFormat:@"+5 XP. Congratulations! player %@ has level up his %@ skills.", squadView.sel_player_name, [[Globals i] PlayerSkill4]];
                     }
                     else if([returnValue isEqualToString:@"4"])
                     {
                         promptText = [NSString stringWithFormat:@"+5 XP. Congratulations! player %@ has level up his %@ skills.", squadView.sel_player_name, [[Globals i] PlayerSkill5]];
                     }
                     else if([returnValue isEqualToString:@"5"])
                     {
                         promptText = [NSString stringWithFormat:@"+5 XP. Congratulations! player %@ has level up his %@ skills.", squadView.sel_player_name, [[Globals i] PlayerSkill1]];
                     }
                     
                     [UIManager.i showDialog:promptText];
                 }
             }
         }];
    }
    else
    {
        [UIManager.i showDialogBlock:@"5 Diamonds is required for Special Training. Would you like to buy some diamonds?"
                                    :2
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"GotoBuy"
                  object:self];
                 
                 [self close];
             }
         }];
    }
}

- (IBAction)moraleButton_tap:(id)sender
{
    NSInteger totalDiamonds = [[[Globals i] getClubData][@"currency_second"] integerValue];
    
    if(totalDiamonds > 2)
    {
        NSString *dt = [NSString stringWithFormat:@"+5 XP. Give %@ a Morale Boost for 3 Diamonds? %@'s Morale will increase by 5.",
                                squadView.sel_player_name, squadView.sel_player_name];
        
        [UIManager.i showDialogBlock:dt
                                    :2
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 NSString *returnValue = @"0";
                 NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/MoralePlayer/%@/%@",
                                    WS_URL, [[Globals i] UID], squadView.sel_player_id];
                 NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 NSURL *url = [[NSURL alloc] initWithString:wsurl2];
                 returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
                 
                 
                 if([returnValue isEqualToString:@"0"])
                 {
                     [UIManager.i showDialog:@"Player NOT VALID. Please select another player."];
                 }
                 else
                 {
                     [squadView normalUpdate];
                     
                     //Update Header
                     [[Globals i] updateClubData]; //Diamonds deducted and +5 XP.
                     
                     NSString *message = [[NSString alloc] initWithFormat:@"I have just gave my player %@ a Morale Boost.", squadView.sel_player_name];
                     NSString *extra_desc = @"Your player's morale will increase by 5 after giving a Morale Boost.";
                     NSString *imagename = @"morale_boost.png";
                     [[Globals i] fbPublishStory:message :extra_desc :imagename];
                     
                     [self updateView:(squadView.players)[squadView.selectedRow]];
                     
                     NSString *promptText = @"0";
                     
                     promptText = [NSString stringWithFormat:@"+5 XP. Congratulations! player %@ morale has increased by 5.", squadView.sel_player_name];
                     
                     [UIManager.i showDialog:promptText];
                 }
             }
         }];
    }
    else
    {
        [UIManager.i showDialogBlock:@"3 Diamonds is required for a Morale Boost. Would you like to buy some diamonds?"
                                    :2
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"GotoBuy"
                  object:self];
                 
                 [self close];
             }
         }];
    }
}

// Driving The Table View
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [[Globals i] playerCellHandler:tableView indexPath:indexPath playerArray:self.players checkPos:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170*SCALE_IPAD;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
